-- MediDesk Local Database Schema
-- SQLite database for health data (NEVER goes to cloud)

-- ============================================
-- TABLE: users
-- Comptes professionnels (kiné, coach, patients) + admins
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    role TEXT NOT NULL CHECK(role IN ('patient', 'kine', 'coach_apa', 'manager', 'sadmin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active INTEGER DEFAULT 1,
    phone TEXT,
    birth_date DATE,
    
    -- Permissions management
    can_manage_permissions INTEGER DEFAULT 0, -- 1 si peut gérer permissions (manager/délégué)
    delegated_by TEXT, -- ID de l'utilisateur qui a délégué les permissions
    delegation_expires_at TIMESTAMP, -- Expiration délégation (NULL = permanent)
    
    -- Metadata
    firebase_uid TEXT UNIQUE, -- Sync with Firebase Auth (optional)
    last_login TIMESTAMP,
    preferences TEXT -- JSON string for user settings
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_firebase_uid ON users(firebase_uid);

-- ============================================
-- TABLE: pain_points
-- Historique des points de douleur
-- ============================================
CREATE TABLE IF NOT EXISTS pain_points (
    id TEXT PRIMARY KEY,
    patient_id TEXT NOT NULL,
    professional_id TEXT NOT NULL, -- Who recorded this
    zone TEXT NOT NULL, -- 'head', 'neck', 'shoulder_left', etc.
    intensity INTEGER NOT NULL CHECK(intensity BETWEEN 0 AND 10),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_id TEXT, -- Link to pain_sessions if part of session
    is_before_session INTEGER DEFAULT 0, -- 0=after, 1=before
    notes TEXT,
    
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (professional_id) REFERENCES users(id),
    FOREIGN KEY (session_id) REFERENCES pain_sessions(id) ON DELETE SET NULL
);

CREATE INDEX idx_pain_points_patient ON pain_points(patient_id);
CREATE INDEX idx_pain_points_timestamp ON pain_points(timestamp);
CREATE INDEX idx_pain_points_session ON pain_points(session_id);
CREATE INDEX idx_pain_points_zone ON pain_points(zone);

-- ============================================
-- TABLE: pain_sessions
-- Séances de traitement
-- ============================================
CREATE TABLE IF NOT EXISTS pain_sessions (
    id TEXT PRIMARY KEY,
    patient_id TEXT NOT NULL,
    professional_id TEXT NOT NULL,
    session_type TEXT NOT NULL CHECK(session_type IN ('initial', 'followup', 'discharge')),
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    duration_minutes INTEGER,
    
    -- Pain metrics
    pain_before_avg REAL, -- Average intensity before session
    pain_after_avg REAL, -- Average intensity after session
    improvement REAL, -- Calculated: pain_before_avg - pain_after_avg
    
    -- Session details
    treatment_notes TEXT,
    exercises_prescribed TEXT, -- JSON array of exercises
    next_session_date TIMESTAMP,
    
    -- Status
    status TEXT DEFAULT 'completed' CHECK(status IN ('scheduled', 'completed', 'cancelled', 'no_show')),
    
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (professional_id) REFERENCES users(id)
);

CREATE INDEX idx_sessions_patient ON pain_sessions(patient_id);
CREATE INDEX idx_sessions_professional ON pain_sessions(professional_id);
CREATE INDEX idx_sessions_date ON pain_sessions(date);
CREATE INDEX idx_sessions_type ON pain_sessions(session_type);

-- ============================================
-- TABLE: audit_logs
-- Traçabilité RGPD : qui a modifié quoi et quand
-- ============================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    action_type TEXT NOT NULL CHECK(action_type IN (
        'create_patient',
        'update_patient', 
        'delete_patient',
        'create_pain_point',
        'update_pain_point',
        'delete_pain_point',
        'create_session',
        'update_session',
        'delete_session',
        'view_patient_data',
        'export_data',
        'login',
        'logout'
    )),
    entity_type TEXT, -- 'user', 'pain_point', 'session', etc.
    entity_id TEXT, -- ID of affected entity
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_address TEXT,
    user_agent TEXT,
    
    -- Changes tracking
    old_values TEXT, -- JSON before modification
    new_values TEXT, -- JSON after modification
    
    -- Context
    reason TEXT, -- Why this action was performed
    
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_timestamp ON audit_logs(timestamp);
CREATE INDEX idx_audit_action ON audit_logs(action_type);
CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id);

-- ============================================
-- TABLE: pathology_stats
-- Statistiques anonymisées par pathologie
-- Pour calcul temps de guérison/amélioration
-- ============================================
CREATE TABLE IF NOT EXISTS pathology_stats (
    id TEXT PRIMARY KEY,
    pathology_code TEXT NOT NULL, -- 'lombalgie', 'cervicalgie', 'tendinite_epaule', etc.
    pathology_name TEXT NOT NULL,
    
    -- Aggregated metrics (k-anonymat >= 5 patients minimum)
    total_patients INTEGER DEFAULT 0,
    avg_initial_intensity REAL, -- Average pain at first session
    avg_final_intensity REAL, -- Average pain at last session
    avg_total_improvement REAL, -- Average total improvement
    avg_sessions_count REAL, -- Average number of sessions
    avg_days_to_improvement REAL, -- Average days to 30% improvement
    avg_days_to_recovery REAL, -- Average days to < 2/10 pain
    
    -- Success rates
    success_rate_30pct REAL, -- % patients with 30%+ improvement
    success_rate_50pct REAL, -- % patients with 50%+ improvement
    success_rate_recovery REAL, -- % patients reaching < 2/10
    
    -- Zone distribution (JSON)
    affected_zones TEXT, -- {"shoulder_left": 45, "neck": 30, ...}
    
    -- Last updated
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_period_start DATE,
    data_period_end DATE
);

CREATE INDEX idx_pathology_code ON pathology_stats(pathology_code);
CREATE INDEX idx_pathology_calculated ON pathology_stats(calculated_at);

-- ============================================
-- TABLE: cabinet_config
-- Configuration du cabinet (singleton)
-- ============================================
CREATE TABLE IF NOT EXISTS cabinet_config (
    id INTEGER PRIMARY KEY CHECK(id = 1), -- Singleton: only one row
    cabinet_name TEXT NOT NULL,
    cabinet_address TEXT,
    cabinet_phone TEXT,
    cabinet_email TEXT,
    
    -- Network settings
    server_port INTEGER DEFAULT 8080,
    allow_external_access INTEGER DEFAULT 0, -- 0=localhost only, 1=LAN access
    
    -- Firebase sync (optional)
    firebase_enabled INTEGER DEFAULT 0,
    firebase_project_id TEXT,
    last_firebase_sync TIMESTAMP,
    
    -- Stats sharing
    share_anonymous_stats INTEGER DEFAULT 0, -- Share to Firebase for inter-cabinet
    
    -- Backups
    auto_backup_enabled INTEGER DEFAULT 1,
    backup_frequency_days INTEGER DEFAULT 7,
    last_backup_date TIMESTAMP,
    
    -- Updates
    app_version TEXT DEFAULT '1.0.0',
    last_update_check TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default config
INSERT OR IGNORE INTO cabinet_config (id, cabinet_name) VALUES (1, 'Cabinet de Kinésithérapie');

-- ============================================
-- TABLE: appointments (Firebase sync)
-- Rendez-vous (peut être synchronisé avec Firebase)
-- ============================================
CREATE TABLE IF NOT EXISTS appointments (
    id TEXT PRIMARY KEY,
    patient_pseudonym TEXT NOT NULL, -- "Patient A", "Patient B" (for Firebase sync)
    patient_id TEXT, -- Real ID (local only)
    professional_id TEXT NOT NULL,
    appointment_date TIMESTAMP NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    status TEXT DEFAULT 'scheduled' CHECK(status IN ('scheduled', 'confirmed', 'completed', 'cancelled', 'no_show')),
    appointment_type TEXT, -- 'initial', 'followup', 'assessment'
    notes TEXT,
    
    -- Sync
    firebase_synced INTEGER DEFAULT 0,
    firebase_id TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (patient_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (professional_id) REFERENCES users(id)
);

CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_professional ON appointments(professional_id);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_firebase ON appointments(firebase_id);

-- ============================================
-- VIEWS
-- ============================================

-- Vue: Patients avec dernière douleur moyenne
CREATE VIEW IF NOT EXISTS v_patients_latest_pain AS
SELECT 
    u.id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone,
    u.birth_date,
    MAX(pp.timestamp) as last_pain_date,
    AVG(pp.intensity) as last_avg_intensity,
    COUNT(DISTINCT ps.id) as total_sessions
FROM users u
LEFT JOIN pain_points pp ON u.id = pp.patient_id 
    AND pp.timestamp = (SELECT MAX(timestamp) FROM pain_points WHERE patient_id = u.id)
LEFT JOIN pain_sessions ps ON u.id = ps.patient_id
WHERE u.role = 'patient' AND u.is_active = 1
GROUP BY u.id;

-- Vue: Sessions avec amélioration
CREATE VIEW IF NOT EXISTS v_sessions_with_improvement AS
SELECT 
    ps.*,
    u.first_name || ' ' || u.last_name as patient_name,
    prof.first_name || ' ' || prof.last_name as professional_name,
    ROUND(ps.improvement, 1) as improvement_rounded,
    CASE 
        WHEN ps.improvement >= 3 THEN 'excellent'
        WHEN ps.improvement >= 2 THEN 'good'
        WHEN ps.improvement >= 1 THEN 'moderate'
        ELSE 'poor'
    END as improvement_category
FROM pain_sessions ps
JOIN users u ON ps.patient_id = u.id
JOIN users prof ON ps.professional_id = prof.id
WHERE ps.status = 'completed';

-- Vue: Statistiques temps réel
CREATE VIEW IF NOT EXISTS v_realtime_stats AS
SELECT 
    COUNT(DISTINCT CASE WHEN role = 'patient' THEN id END) as total_patients,
    COUNT(DISTINCT CASE WHEN role = 'kine' THEN id END) as total_kines,
    COUNT(DISTINCT CASE WHEN role = 'coach_apa' THEN id END) as total_coaches,
    (SELECT COUNT(*) FROM pain_points WHERE DATE(timestamp) = DATE('now')) as pain_points_today,
    (SELECT COUNT(*) FROM pain_sessions WHERE DATE(date) = DATE('now')) as sessions_today,
    (SELECT AVG(intensity) FROM pain_points WHERE DATE(timestamp) >= DATE('now', '-7 days')) as avg_pain_7days,
    (SELECT AVG(improvement) FROM pain_sessions WHERE DATE(date) >= DATE('now', '-30 days') AND status = 'completed') as avg_improvement_30days
FROM users;

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger: Auto-update timestamp on users
CREATE TRIGGER IF NOT EXISTS trg_users_updated_at
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

-- Trigger: Auto-update timestamp on appointments
CREATE TRIGGER IF NOT EXISTS trg_appointments_updated_at
AFTER UPDATE ON appointments
FOR EACH ROW
BEGIN
    UPDATE appointments SET updated_at = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;

-- Trigger: Calculate session improvement automatically
CREATE TRIGGER IF NOT EXISTS trg_calculate_session_improvement
AFTER INSERT ON pain_points
FOR EACH ROW
WHEN NEW.session_id IS NOT NULL
BEGIN
    UPDATE pain_sessions
    SET 
        pain_before_avg = (
            SELECT AVG(intensity) 
            FROM pain_points 
            WHERE session_id = NEW.session_id AND is_before_session = 1
        ),
        pain_after_avg = (
            SELECT AVG(intensity) 
            FROM pain_points 
            WHERE session_id = NEW.session_id AND is_before_session = 0
        )
    WHERE id = NEW.session_id;
    
    -- Calculate improvement
    UPDATE pain_sessions
    SET improvement = pain_before_avg - pain_after_avg
    WHERE id = NEW.session_id 
        AND pain_before_avg IS NOT NULL 
        AND pain_after_avg IS NOT NULL;
END;

-- ============================================
-- INITIAL DATA
-- ============================================

-- Super Admin account (password: sadmin123)
-- Hash generated with werkzeug.security.generate_password_hash('sadmin123')
INSERT OR IGNORE INTO users (id, email, password_hash, first_name, last_name, role, is_active, can_manage_permissions)
VALUES (
    'sadmin_001',
    'sadmin@medidesk.local',
    'scrypt:32768:8:1$EfD26oF2NvEMhXbw$a0db7799323dae5085023305f90705a2194fed4caf9c5460fdeab2955302ae006ba11b97309a5129a0d1af7b79a020057a2dbaa56d89f525ccde45368c187f74',
    'Super',
    'Admin',
    'sadmin',
    1,
    1
);

-- Manager account (password: manager123) - Patron cabinet
INSERT OR IGNORE INTO users (id, email, password_hash, first_name, last_name, role, is_active, can_manage_permissions)
VALUES (
    'manager_001',
    'patron@medidesk.local',
    'scrypt:32768:8:1$25mILREsmDHS6TMR$349df676532c4a9b3adea0e16cede5e5659ff8403718f5f9d9dddc93722c7e1a0b91ce0330b3d838d6904de08bdc60eb92a60b9309c6a7c793e83365018d0f0f',
    'Patron',
    'Cabinet',
    'manager',
    1,
    1
);

-- Demo accounts (same as current demo mode)
INSERT OR IGNORE INTO users (id, email, password_hash, first_name, last_name, role, phone, is_active, can_manage_permissions)
VALUES 
    ('patient_demo_001', 'patient@demo.com', 'scrypt:32768:8:1$QBZsCcan8NK7y3TS$a95c6c182b39ca84e5d90518f018d41ca5ad6f647925c862bedf821b16e1f817ecd1420a0cee2538c7e43987529492dfc5460497d7977d80d734230d979a6ae0', 'Jean', 'Patient', 'patient', '0612345678', 1, 0),
    ('kine_demo_001', 'kine@demo.com', 'scrypt:32768:8:1$kDGIPLRIlMgLwOij$d7157fe5b3050e58e8dc9c22ecd909af20b9786807beeb62b1e25c0b99d73862b5f58aff576e56288a90c62dacc2e4581d867bf2d3be941f8d35dc9b7628ae52', 'Marie', 'Kinésithérapeute', 'kine', '0623456789', 1, 0),
    ('coach_demo_001', 'coach@demo.com', 'scrypt:32768:8:1$7ITv216JdrZX4iV4$51d16f2ac6ae7ed678b0455f66b53cdf97a7a03f56f948f17d0b34d52d3f4c8cf9da14afa7400c828b968282aeb648ae52a27b0bd591dc0da3a9c08fa67d7f84', 'Pierre', 'Coach', 'coach_apa', '0634567890', 1, 0);

-- ============================================
-- MAINTENANCE QUERIES
-- ============================================

-- Clean old audit logs (keep 3 years as per RGPD)
-- DELETE FROM audit_logs WHERE timestamp < DATE('now', '-3 years');

-- Recalculate pathology stats
-- (Run periodically via scheduled task)

-- Vacuum database (optimize)
-- VACUUM;

-- ============================================
-- DATABASE VERSION
-- ============================================
PRAGMA user_version = 1;
