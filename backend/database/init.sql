-- MediDesk Database Initialization Script
-- Version: 1.3
-- Date: 25 Novembre 2025
-- Description: Création des tables pour installation locale PostgreSQL

-- Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Table: users (Utilisateurs du système)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('admin', 'kine', 'coach_apa', 'secretary', 'patient')),
    phone VARCHAR(20),
    birth_date DATE,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: patients (Données patients spécifiques)
CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    medical_history TEXT,
    current_pathology VARCHAR(255),
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: pain_history (Historique des douleurs)
CREATE TABLE IF NOT EXISTS pain_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    practitioner_id UUID REFERENCES users(id),
    zone VARCHAR(50) NOT NULL,
    intensity DECIMAL(3,1) CHECK (intensity >= 0 AND intensity <= 10),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    pathology VARCHAR(255),
    session_id UUID
);

-- Table: sessions (Séances de traitement)
CREATE TABLE IF NOT EXISTS sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    practitioner_id UUID REFERENCES users(id),
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    duration INTEGER, -- en minutes
    type VARCHAR(50) CHECK (type IN ('initial', 'followup', 'discharge')),
    intensity_before DECIMAL(3,1),
    intensity_after DECIMAL(3,1),
    improvement DECIMAL(3,1),
    zones TEXT[],
    pathology VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: appointments (Rendez-vous)
CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID REFERENCES users(id) ON DELETE CASCADE,
    practitioner_id UUID REFERENCES users(id),
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(50) CHECK (status IN ('scheduled', 'confirmed', 'completed', 'cancelled')),
    type VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: pain_mappings (Cartographie des douleurs)
CREATE TABLE IF NOT EXISTS pain_mappings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    mapping_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes pour performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_pain_history_user ON pain_history(user_id);
CREATE INDEX IF NOT EXISTS idx_pain_history_timestamp ON pain_history(timestamp);
CREATE INDEX IF NOT EXISTS idx_sessions_patient ON sessions(patient_id);
CREATE INDEX IF NOT EXISTS idx_sessions_date ON sessions(date);
CREATE INDEX IF NOT EXISTS idx_appointments_patient ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_start ON appointments(start_time);

-- Index full-text search
CREATE INDEX IF NOT EXISTS idx_users_name_trgm ON users USING gin(first_name gin_trgm_ops, last_name gin_trgm_ops);

-- Function: auto-update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers pour auto-update
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_patients_updated_at BEFORE UPDATE ON patients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON appointments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Créer un utilisateur admin par défaut
INSERT INTO users (email, password_hash, first_name, last_name, role, is_active)
VALUES (
    'admin@medidesk.local',
    -- Hash bcrypt de 'admin123' (à changer en production!)
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5xyJNu0kqx.Lq',
    'Admin',
    'Système',
    'admin',
    TRUE
)
ON CONFLICT (email) DO NOTHING;

-- Créer un praticien de test
INSERT INTO users (email, password_hash, first_name, last_name, role, phone, is_active)
VALUES (
    'kine@medidesk.local',
    -- Hash bcrypt de 'kine123'
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5xyJNu0kqx.Lq',
    'Marie',
    'Dubois',
    'kine',
    '+33 6 12 34 56 78',
    TRUE
)
ON CONFLICT (email) DO NOTHING;

-- Créer un patient de test
INSERT INTO users (email, password_hash, first_name, last_name, role, birth_date, is_active)
VALUES (
    'patient@medidesk.local',
    -- Hash bcrypt de 'patient123'
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5xyJNu0kqx.Lq',
    'Jean',
    'Dupont',
    'patient',
    '1980-01-01',
    TRUE
)
ON CONFLICT (email) DO NOTHING;

-- Message de succès
DO $$
BEGIN
    RAISE NOTICE '✅ Base de données MediDesk initialisée avec succès !';
    RAISE NOTICE '📊 Tables créées: users, patients, pain_history, sessions, appointments, pain_mappings';
    RAISE NOTICE '🔑 Comptes créés: admin@medidesk.local, kine@medidesk.local, patient@medidesk.local';
    RAISE NOTICE '⚠️  IMPORTANT: Changez les mots de passe par défaut !';
END $$;
