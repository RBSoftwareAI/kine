"""
Service de gestion des douleurs
CRUD et logique métier pour le suivi des douleurs
"""
import uuid
import json
from datetime import datetime, timedelta
from typing import Dict, Any, List, Optional


class PainService:
    """Service de gestion des points de douleur et historique"""
    
    def __init__(self, db_manager):
        self.db = db_manager
    
    def get_patient_pain_points(self, patient_id: str) -> List[Dict[str, Any]]:
        """
        Récupère tous les points de douleur actuels d'un patient
        
        Args:
            patient_id: ID du patient
            
        Returns:
            Liste des points de douleur
        """
        return self.db.get_patient_pain_points(patient_id)
    
    def create_pain_point(self, pain_data: Dict[str, Any], user_id: str, ip_address: str = None, user_agent: str = None) -> Dict[str, Any]:
        """
        Crée un nouveau point de douleur
        
        Args:
            pain_data: Données du point de douleur
            user_id: ID de l'utilisateur qui crée (pour audit)
            ip_address: IP de l'utilisateur (pour audit)
            user_agent: User agent (pour audit)
            
        Returns:
            Dict avec 'success', 'pain_id' ou 'error'
        """
        patient_id = pain_data.get('patientId')
        zone = pain_data.get('zone')
        intensity = pain_data.get('intensity')
        description = pain_data.get('description')
        
        # Validation
        if not patient_id or not zone:
            return {'success': False, 'error': 'Patient ID et zone requis'}
        
        if intensity is None or not (0 <= intensity <= 10):
            return {'success': False, 'error': 'Intensité doit être entre 0 et 10'}
        
        # Crée le point de douleur
        pain_id = f'pain_{uuid.uuid4().hex}'
        
        try:
            self.db.create_pain_point({
                'id': pain_id,
                'patient_id': patient_id,
                'zone': zone,
                'intensity': intensity,
                'description': description
            })
            
            # Crée un log d'audit
            self.db.create_audit_log({
                'id': f'log_{uuid.uuid4().hex}',
                'user_id': user_id,
                'action_type': 'create_pain_point',
                'target_type': 'pain_point',
                'target_id': pain_id,
                'old_values': None,
                'new_values': {
                    'patient_id': patient_id,
                    'zone': zone,
                    'intensity': intensity,
                    'description': description
                },
                'ip_address': ip_address,
                'user_agent': user_agent
            })
            
            return {'success': True, 'pain_id': pain_id}
        
        except Exception as e:
            return {'success': False, 'error': f'Erreur création: {str(e)}'}
    
    def update_pain_point(self, pain_id: str, updates: Dict[str, Any], user_id: str, ip_address: str = None, user_agent: str = None) -> Dict[str, Any]:
        """
        Met à jour un point de douleur existant
        
        Args:
            pain_id: ID du point de douleur
            updates: Champs à mettre à jour
            user_id: ID de l'utilisateur qui modifie
            ip_address: IP de l'utilisateur
            user_agent: User agent
            
        Returns:
            Dict avec 'success' ou 'error'
        """
        # Récupère les anciennes valeurs pour l'audit
        query = "SELECT * FROM pain_points WHERE id = ?"
        old_values = self.db.execute_query(query, (pain_id,))
        
        if not old_values:
            return {'success': False, 'error': 'Point de douleur non trouvé'}
        
        old_values = old_values[0]
        
        # Construit la requête de mise à jour
        fields = []
        params = []
        
        if 'intensity' in updates:
            if not (0 <= updates['intensity'] <= 10):
                return {'success': False, 'error': 'Intensité doit être entre 0 et 10'}
            fields.append('intensity = ?')
            params.append(updates['intensity'])
        
        if 'description' in updates:
            fields.append('description = ?')
            params.append(updates['description'])
        
        if not fields:
            return {'success': False, 'error': 'Aucune modification fournie'}
        
        # Ajoute l'ID pour le WHERE
        params.append(pain_id)
        
        query = f"UPDATE pain_points SET {', '.join(fields)} WHERE id = ?"
        
        try:
            self.db.execute_update(query, tuple(params))
            
            # Crée un log d'audit
            self.db.create_audit_log({
                'id': f'log_{uuid.uuid4().hex}',
                'user_id': user_id,
                'action_type': 'update_pain_point',
                'target_type': 'pain_point',
                'target_id': pain_id,
                'old_values': {
                    'intensity': old_values['intensity'],
                    'description': old_values['description']
                },
                'new_values': updates,
                'ip_address': ip_address,
                'user_agent': user_agent
            })
            
            return {'success': True}
        
        except Exception as e:
            return {'success': False, 'error': f'Erreur mise à jour: {str(e)}'}
    
    def delete_pain_point(self, pain_id: str, user_id: str, ip_address: str = None, user_agent: str = None) -> Dict[str, Any]:
        """
        Supprime un point de douleur
        
        Args:
            pain_id: ID du point de douleur
            user_id: ID de l'utilisateur qui supprime
            ip_address: IP de l'utilisateur
            user_agent: User agent
            
        Returns:
            Dict avec 'success' ou 'error'
        """
        # Récupère les valeurs pour l'audit
        query = "SELECT * FROM pain_points WHERE id = ?"
        old_values = self.db.execute_query(query, (pain_id,))
        
        if not old_values:
            return {'success': False, 'error': 'Point de douleur non trouvé'}
        
        old_values = old_values[0]
        
        try:
            query = "DELETE FROM pain_points WHERE id = ?"
            self.db.execute_update(query, (pain_id,))
            
            # Crée un log d'audit
            self.db.create_audit_log({
                'id': f'log_{uuid.uuid4().hex}',
                'user_id': user_id,
                'action_type': 'delete_pain_point',
                'target_type': 'pain_point',
                'target_id': pain_id,
                'old_values': {
                    'patient_id': old_values['patient_id'],
                    'zone': old_values['zone'],
                    'intensity': old_values['intensity'],
                    'description': old_values['description']
                },
                'new_values': None,
                'ip_address': ip_address,
                'user_agent': user_agent
            })
            
            return {'success': True}
        
        except Exception as e:
            return {'success': False, 'error': f'Erreur suppression: {str(e)}'}
    
    def get_pain_history(self, patient_id: str, start_date: str = None, end_date: str = None) -> List[Dict[str, Any]]:
        """
        Récupère l'historique des douleurs d'un patient
        
        Args:
            patient_id: ID du patient
            start_date: Date de début (ISO format)
            end_date: Date de fin (ISO format)
            
        Returns:
            Liste des points d'historique
        """
        return self.db.get_pain_history(patient_id, start_date, end_date)
    
    def get_evolution_data(self, patient_id: str, start_date: str = None, end_date: str = None, period: str = '30d') -> Dict[str, Any]:
        """
        Génère les données d'évolution pour les graphiques
        
        Args:
            patient_id: ID du patient
            start_date: Date de début
            end_date: Date de fin
            period: Période (7d, 30d, 3m, 6m, 1y)
            
        Returns:
            Dict avec données formatées pour fl_chart
        """
        # Calcule les dates si non fournies
        if not end_date:
            end_date = datetime.utcnow()
        else:
            end_date = datetime.fromisoformat(end_date)
        
        if not start_date:
            # Calcule start_date basé sur period
            period_days = {
                '7d': 7,
                '30d': 30,
                '3m': 90,
                '6m': 180,
                '1y': 365
            }
            days = period_days.get(period, 30)
            start_date = end_date - timedelta(days=days)
        else:
            start_date = datetime.fromisoformat(start_date)
        
        # Récupère l'historique
        history = self.get_pain_history(
            patient_id,
            start_date.isoformat(),
            end_date.isoformat()
        )
        
        if not history:
            return {
                'history_points': [],
                'average_intensity': 0,
                'trend': 'stable',
                'total_sessions': 0,
                'improvement_rate': 0
            }
        
        # Calcule les statistiques
        intensities = [point['average_intensity'] for point in history]
        average_intensity = sum(intensities) / len(intensities)
        
        # Calcule la tendance (régression linéaire simple)
        if len(history) >= 2:
            first_half = intensities[:len(intensities)//2]
            second_half = intensities[len(intensities)//2:]
            avg_first = sum(first_half) / len(first_half)
            avg_second = sum(second_half) / len(second_half)
            
            diff = avg_second - avg_first
            if diff < -0.5:
                trend = 'improving'
            elif diff > 0.5:
                trend = 'worsening'
            else:
                trend = 'stable'
        else:
            trend = 'stable'
        
        # Compte les séances
        sessions = [p for p in history if p.get('session_id')]
        total_sessions = len(sessions)
        
        # Calcule le taux d'amélioration
        if len(intensities) >= 2:
            initial_intensity = intensities[0]
            final_intensity = intensities[-1]
            improvement_rate = ((initial_intensity - final_intensity) / initial_intensity * 100) if initial_intensity > 0 else 0
        else:
            improvement_rate = 0
        
        return {
            'history_points': history,
            'average_intensity': round(average_intensity, 1),
            'trend': trend,
            'total_sessions': total_sessions,
            'improvement_rate': round(improvement_rate, 1)
        }
