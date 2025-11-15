-- Schéma SQLite pour KinéCare
-- Données 100% locales, jamais sur Internet

-- ============================================
-- Table des utilisateurs (professionnels)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    role TEXT NOT NULL CHECK(role IN ('patient', 'kine', 'coach', 'admin')),
    phone TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Table des patients
-- ============================================
CREATE TABLE IF NOT EXISTS patients (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    birth_year INTEGER,
    gender TEXT CHECK(gender IN ('M', 'F', 'other')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- Table des points de douleur
-- ============================================
CREATE TABLE IF NOT EXISTS pain_points (
    id TEXT PRIMARY KEY,
    patient_id TEXT NOT NULL,
    zone TEXT NOT NULL CHECK(zone IN (
        'head', 'neck', 'left_shoulder', 'right_shoulder',
        'left_arm', 'right_arm', 'left_hand', 'right_hand',
        'chest', 'upper_back', 'lower_back',
        'left_hip', 'right_hip', 'left_thigh', 'right_thigh',
        'left_knee', 'right_knee', 'left_leg', 'right_leg',
        'left_foot', 'right_foot'
    )),
    intensity INTEGER NOT NULL CHECK(intensity BETWEEN 0 AND 10),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- ============================================
-- Table des séances
-- ============================================
CREATE TABLE IF NOT EXISTS pain_sessions (
    id TEXT PRIMARY KEY,
    patient_id TEXT NOT NULL,
    professional_id TEXT NOT NULL,
    session_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    session_type TEXT CHECK(session_type IN ('kine', 'apa', 'evaluation')),
    notes TEXT,
    duration_minutes INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (professional_id) REFERENCES users(id)
);

-- ============================================
-- Table historique des douleurs (pour graphiques)
-- ============================================
CREATE TABLE IF NOT EXISTS pain_history (
    id TEXT PRIMARY KEY,
    patient_id TEXT NOT NULL,
    session_id TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    average_intensity REAL NOT NULL,
    zone_intensities TEXT NOT NULL, -- JSON: {"lower_back": 7, "neck": 5}
    is_before_session BOOLEAN DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (session_id) REFERENCES pain_sessions(id) ON DELETE SET NULL
);

-- ============================================
-- Table des logs d'audit (traçabilité RGPD)
-- ============================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    action_type TEXT NOT NULL CHECK(action_type IN (
        'create_pain_point', 'update_pain_point', 'delete_pain_point',
        'create_session', 'update_session', 'delete_session',
        'view_patient', 'export_data', 'login', 'logout'
    )),
    target_type TEXT NOT NULL CHECK(target_type IN ('user', 'patient', 'pain_point', 'session', 'system')),
    target_id TEXT,
    old_values TEXT, -- JSON avant modification
    new_values TEXT, -- JSON après modification
    ip_address TEXT,
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ============================================
-- Table des pathologies (pour statistiques)
-- ============================================
CREATE TABLE IF NOT EXISTS pathologies (
    id TEXT PRIMARY KEY,
    patient_id TEXT NOT NULL,
    pathology_name TEXT NOT NULL, -- Ex: "Lombalgie chronique", "Cervicalgie"
    diagnosis_date DATE,
    primary_zone TEXT NOT NULL, -- Zone principale affectée
    severity TEXT CHECK(severity IN ('mild', 'moderate', 'severe')),
    status TEXT CHECK(status IN ('active', 'in_treatment', 'resolved')) DEFAULT 'active',
    resolution_date DATE, -- Date de guérison si resolved
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

-- ============================================
-- Table des statistiques anonymisées (cache)
-- ============================================
CREATE TABLE IF NOT EXISTS pathology_stats (
    id TEXT PRIMARY KEY,
    pathology_name TEXT NOT NULL UNIQUE,
    total_cases INTEGER DEFAULT 0,
    active_cases INTEGER DEFAULT 0,
    resolved_cases INTEGER DEFAULT 0,
    average_healing_days REAL, -- Temps moyen de guérison en jours
    average_improvement_rate REAL, -- Taux amélioration moyen (points/semaine)
    median_initial_intensity REAL,
    median_final_intensity REAL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Index pour optimisation des requêtes
-- ============================================
CREATE INDEX IF NOT EXISTS idx_pain_points_patient ON pain_points(patient_id);
CREATE INDEX IF NOT EXISTS idx_pain_points_created ON pain_points(created_at);
CREATE INDEX IF NOT EXISTS idx_sessions_patient ON pain_sessions(patient_id);
CREATE INDEX IF NOT EXISTS idx_sessions_date ON pain_sessions(session_date);
CREATE INDEX IF NOT EXISTS idx_history_patient ON pain_history(patient_id);
CREATE INDEX IF NOT EXISTS idx_history_timestamp ON pain_history(timestamp);
CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON audit_logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_pathologies_patient ON pathologies(patient_id);
CREATE INDEX IF NOT EXISTS idx_pathologies_status ON pathologies(status);

-- ============================================
-- Trigger pour mise à jour automatique updated_at
-- ============================================
CREATE TRIGGER IF NOT EXISTS update_users_timestamp 
AFTER UPDATE ON users
BEGIN
    UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_patients_timestamp 
AFTER UPDATE ON patients
BEGIN
    UPDATE patients SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_pain_points_timestamp 
AFTER UPDATE ON pain_points
BEGIN
    UPDATE pain_points SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_pathologies_timestamp 
AFTER UPDATE ON pathologies
BEGIN
    UPDATE pathologies SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- ============================================
-- Trigger pour créer historique automatiquement
-- ============================================
CREATE TRIGGER IF NOT EXISTS create_pain_history_on_insert
AFTER INSERT ON pain_points
BEGIN
    INSERT INTO pain_history (
        id,
        patient_id,
        timestamp,
        average_intensity,
        zone_intensities,
        is_before_session
    )
    SELECT
        'hist_' || NEW.id,
        NEW.patient_id,
        NEW.created_at,
        NEW.intensity,
        json_object('zone', NEW.zone, 'intensity', NEW.intensity),
        0
    WHERE NOT EXISTS (
        SELECT 1 FROM pain_history 
        WHERE patient_id = NEW.patient_id 
        AND timestamp = NEW.created_at
    );
END;

-- ============================================
-- Vue pour statistiques temps réel
-- ============================================
CREATE VIEW IF NOT EXISTS v_pathology_healing_times AS
SELECT 
    p.pathology_name,
    COUNT(*) as total_cases,
    AVG(JULIANDAY(p.resolution_date) - JULIANDAY(p.diagnosis_date)) as avg_healing_days,
    MIN(JULIANDAY(p.resolution_date) - JULIANDAY(p.diagnosis_date)) as min_healing_days,
    MAX(JULIANDAY(p.resolution_date) - JULIANDAY(p.diagnosis_date)) as max_healing_days
FROM pathologies p
WHERE p.status = 'resolved'
  AND p.diagnosis_date IS NOT NULL
  AND p.resolution_date IS NOT NULL
GROUP BY p.pathology_name;

-- ============================================
-- Vue pour évolution des douleurs
-- ============================================
CREATE VIEW IF NOT EXISTS v_pain_evolution AS
SELECT 
    ph.patient_id,
    ph.timestamp,
    ph.average_intensity,
    p.pathology_name,
    LAG(ph.average_intensity) OVER (
        PARTITION BY ph.patient_id 
        ORDER BY ph.timestamp
    ) as previous_intensity,
    ph.average_intensity - LAG(ph.average_intensity) OVER (
        PARTITION BY ph.patient_id 
        ORDER BY ph.timestamp
    ) as intensity_change
FROM pain_history ph
LEFT JOIN pathologies p ON ph.patient_id = p.patient_id
ORDER BY ph.patient_id, ph.timestamp;
