"""
Service de statistiques
Calcul des temps de guérison et statistiques globales
"""
from typing import Dict, Any, List
from datetime import datetime, timedelta


class StatsService:
    """Service de calcul des statistiques et temps de guérison"""
    
    def __init__(self, db_manager):
        self.db = db_manager
    
    def get_pathology_healing_stats(self) -> List[Dict[str, Any]]:
        """
        Récupère les statistiques de temps de guérison par pathologie
        
        Returns:
            Liste des statistiques par pathologie avec:
            - pathology_name: Nom de la pathologie
            - total_cases: Nombre total de cas
            - avg_healing_days: Temps moyen de guérison en jours
            - min_healing_days: Temps minimum observé
            - max_healing_days: Temps maximum observé
        """
        stats = self.db.get_pathology_stats()
        
        # Formate les résultats pour affichage convivial
        formatted_stats = []
        for stat in stats:
            formatted_stats.append({
                'pathology': stat['pathology_name'],
                'totalCases': stat['total_cases'],
                'averageHealingTime': {
                    'days': round(stat['avg_healing_days'], 1) if stat['avg_healing_days'] else None,
                    'weeks': round(stat['avg_healing_days'] / 7, 1) if stat['avg_healing_days'] else None
                },
                'minHealingTime': round(stat['min_healing_days'], 1) if stat['min_healing_days'] else None,
                'maxHealingTime': round(stat['max_healing_days'], 1) if stat['max_healing_days'] else None
            })
        
        return formatted_stats
    
    def calculate_improvement_rate(self, patient_id: str, days: int = 30) -> Dict[str, Any]:
        """
        Calcule le taux d'amélioration d'un patient sur une période
        
        Args:
            patient_id: ID du patient
            days: Nombre de jours à analyser (défaut: 30)
            
        Returns:
            Dict avec taux d'amélioration et statistiques
        """
        end_date = datetime.utcnow()
        start_date = end_date - timedelta(days=days)
        
        # Récupère l'historique
        history = self.db.get_pain_history(
            patient_id,
            start_date.isoformat(),
            end_date.isoformat()
        )
        
        if len(history) < 2:
            return {
                'sufficient_data': False,
                'message': 'Pas assez de données pour calculer l\'amélioration'
            }
        
        # Calcule les statistiques
        intensities = [point['average_intensity'] for point in history]
        initial_intensity = intensities[0]
        final_intensity = intensities[-1]
        
        # Taux d'amélioration (négatif = amélioration, positif = détérioration)
        absolute_change = final_intensity - initial_intensity
        percentage_change = (absolute_change / initial_intensity * 100) if initial_intensity > 0 else 0
        
        # Points par semaine
        days_elapsed = (datetime.fromisoformat(history[-1]['timestamp']) - datetime.fromisoformat(history[0]['timestamp'])).days
        weeks_elapsed = max(days_elapsed / 7, 1)
        points_per_week = absolute_change / weeks_elapsed
        
        # Détermine le statut
        if percentage_change < -10:
            status = 'improving'
            status_fr = 'En amélioration'
        elif percentage_change > 10:
            status = 'worsening'
            status_fr = 'En détérioration'
        else:
            status = 'stable'
            status_fr = 'Stable'
        
        return {
            'sufficient_data': True,
            'period_days': days,
            'data_points': len(history),
            'initial_intensity': round(initial_intensity, 1),
            'final_intensity': round(final_intensity, 1),
            'absolute_change': round(absolute_change, 1),
            'percentage_change': round(percentage_change, 1),
            'points_per_week': round(points_per_week, 2),
            'status': status,
            'status_fr': status_fr,
            'interpretation': self._interpret_improvement(percentage_change)
        }
    
    def _interpret_improvement(self, percentage_change: float) -> str:
        """Interprète le taux d'amélioration en message convivial"""
        if percentage_change < -30:
            return "Amélioration excellente"
        elif percentage_change < -15:
            return "Amélioration significative"
        elif percentage_change < -5:
            return "Amélioration légère"
        elif percentage_change <= 5:
            return "Situation stable"
        elif percentage_change <= 15:
            return "Légère détérioration"
        elif percentage_change <= 30:
            return "Détérioration significative"
        else:
            return "Détérioration importante"
    
    def get_cabinet_overview(self) -> Dict[str, Any]:
        """
        Génère une vue d'ensemble des statistiques du cabinet
        
        Returns:
            Dict avec statistiques globales
        """
        # Compte total de patients
        query_patients = "SELECT COUNT(DISTINCT id) as total FROM patients"
        total_patients = self.db.execute_query(query_patients)[0]['total']
        
        # Compte total de séances
        query_sessions = "SELECT COUNT(*) as total FROM pain_sessions"
        total_sessions = self.db.execute_query(query_sessions)[0]['total']
        
        # Moyenne d'intensité actuelle
        query_avg_intensity = """
        SELECT AVG(intensity) as avg_intensity 
        FROM pain_points 
        WHERE created_at >= datetime('now', '-7 days')
        """
        result = self.db.execute_query(query_avg_intensity)
        avg_intensity = result[0]['avg_intensity'] if result[0]['avg_intensity'] else 0
        
        # Pathologies actives
        query_active_pathologies = """
        SELECT COUNT(*) as total 
        FROM pathologies 
        WHERE status IN ('active', 'in_treatment')
        """
        active_pathologies = self.db.execute_query(query_active_pathologies)[0]['total']
        
        # Top 5 zones de douleur
        query_top_zones = """
        SELECT zone, COUNT(*) as count
        FROM pain_points
        WHERE created_at >= datetime('now', '-30 days')
        GROUP BY zone
        ORDER BY count DESC
        LIMIT 5
        """
        top_zones = self.db.execute_query(query_top_zones)
        
        # Statistiques pathologies depuis cache
        pathology_stats = self.db.get_cached_pathology_stats()
        
        return {
            'total_patients': total_patients,
            'total_sessions': total_sessions,
            'average_pain_intensity': round(avg_intensity, 1),
            'active_pathologies': active_pathologies,
            'top_pain_zones': [
                {'zone': z['zone'], 'count': z['count']}
                for z in top_zones
            ],
            'pathology_stats': pathology_stats[:5],  # Top 5 pathologies
            'last_updated': datetime.utcnow().isoformat()
        }
    
    def get_patient_summary(self, patient_id: str) -> Dict[str, Any]:
        """
        Génère un résumé complet pour un patient
        
        Args:
            patient_id: ID du patient
            
        Returns:
            Dict avec résumé du patient
        """
        # Informations patient
        query_patient = "SELECT * FROM patients WHERE id = ?"
        patient = self.db.execute_query(query_patient, (patient_id,))
        
        if not patient:
            return {'error': 'Patient non trouvé'}
        
        patient = patient[0]
        
        # Points de douleur actuels
        current_pain = self.db.get_patient_pain_points(patient_id)
        
        # Historique (30 derniers jours)
        end_date = datetime.utcnow()
        start_date = end_date - timedelta(days=30)
        history = self.db.get_pain_history(patient_id, start_date.isoformat(), end_date.isoformat())
        
        # Calcule intensité moyenne
        if history:
            avg_intensity = sum(p['average_intensity'] for p in history) / len(history)
        else:
            avg_intensity = 0
        
        # Taux d'amélioration
        improvement = self.calculate_improvement_rate(patient_id, 30)
        
        # Pathologies actives
        query_pathologies = """
        SELECT * FROM pathologies 
        WHERE patient_id = ? AND status IN ('active', 'in_treatment')
        """
        pathologies = self.db.execute_query(query_pathologies, (patient_id,))
        
        return {
            'patient_id': patient_id,
            'current_pain_points': len(current_pain),
            'average_intensity_30d': round(avg_intensity, 1),
            'improvement_rate': improvement,
            'active_pathologies': len(pathologies),
            'pathologies': pathologies,
            'total_history_points': len(history),
            'last_update': patient['updated_at']
        }
    
    def export_anonymized_stats(self, min_k_anonymity: int = 5) -> Dict[str, Any]:
        """
        Exporte des statistiques anonymisées pour partage inter-cabinets
        Applique k-anonymat (minimum 5 cas par pathologie)
        
        Args:
            min_k_anonymity: Nombre minimum de cas pour inclure une pathologie
            
        Returns:
            Dict avec statistiques anonymisées
        """
        # Récupère toutes les statistiques
        all_stats = self.db.get_pathology_stats()
        
        # Filtre selon k-anonymat
        anonymized_stats = [
            stat for stat in all_stats
            if stat['total_cases'] >= min_k_anonymity
        ]
        
        # Supprime les informations potentiellement identifiantes
        export_stats = []
        for stat in anonymized_stats:
            export_stats.append({
                'pathology': stat['pathology_name'],
                'case_range': self._anonymize_count(stat['total_cases']),  # Ex: "5-10" au lieu de "7"
                'avg_healing_days': round(stat['avg_healing_days'], 0) if stat['avg_healing_days'] else None,
                'healing_range': self._healing_range_category(stat['avg_healing_days'])
            })
        
        return {
            'stats': export_stats,
            'total_pathologies': len(export_stats),
            'k_anonymity': min_k_anonymity,
            'export_date': datetime.utcnow().isoformat(),
            'note': 'Statistiques anonymisées (k-anonymat ≥ 5)'
        }
    
    def _anonymize_count(self, count: int) -> str:
        """Convertit un compte exact en intervalle pour anonymisation"""
        if count < 5:
            return "< 5"
        elif count < 10:
            return "5-10"
        elif count < 20:
            return "10-20"
        elif count < 50:
            return "20-50"
        else:
            return "50+"
    
    def _healing_range_category(self, days: float) -> str:
        """Catégorise le temps de guérison en intervalle"""
        if days is None:
            return "Non disponible"
        elif days < 14:
            return "< 2 semaines"
        elif days < 30:
            return "2-4 semaines"
        elif days < 60:
            return "1-2 mois"
        elif days < 90:
            return "2-3 mois"
        else:
            return "> 3 mois"
