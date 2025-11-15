"""
KinéCare Statistics Service
Calcule les statistiques avec temps de guérison par pathologie
"""
from typing import Dict, List, Optional, Any
from datetime import datetime, timedelta
from collections import defaultdict
import json


class StatisticsService:
    """Service for calculating pathology statistics with healing times"""
    
    def __init__(self, db_manager):
        """
        Initialize statistics service
        
        Args:
            db_manager: DatabaseManager instance
        """
        self.db = db_manager
    
    def calculate_pathology_stats(
        self, 
        pathology_code: str,
        pathology_name: str,
        min_patients: int = 5  # k-anonymat minimum
    ) -> Optional[Dict[str, Any]]:
        """
        Calculate comprehensive statistics for a pathology
        
        Args:
            pathology_code: Code identifier (e.g., 'lombalgie')
            pathology_name: Display name (e.g., 'Lombalgie chronique')
            min_patients: Minimum patients required for k-anonymat
            
        Returns:
            Statistics dict or None if not enough patients
        """
        
        # Get all patients with this pathology (based on zone patterns)
        zone_mapping = self._get_pathology_zone_mapping()
        target_zones = zone_mapping.get(pathology_code, [])
        
        if not target_zones:
            return None
        
        # Query patients with pain in target zones
        zone_placeholders = ','.join(['?' for _ in target_zones])
        query = f"""
        SELECT DISTINCT patient_id
        FROM pain_points
        WHERE zone IN ({zone_placeholders})
        GROUP BY patient_id
        HAVING COUNT(*) >= 3  -- At least 3 pain points recorded
        """
        
        patient_rows = self.db.fetch_all(query, tuple(target_zones))
        patient_ids = [row['patient_id'] for row in patient_rows]
        
        # Check k-anonymat
        if len(patient_ids) < min_patients:
            print(f"⚠️  Not enough patients for {pathology_code}: {len(patient_ids)} < {min_patients}")
            return None
        
        # Calculate metrics for each patient
        patient_metrics = []
        for patient_id in patient_ids:
            metrics = self._calculate_patient_metrics(patient_id, target_zones)
            if metrics:
                patient_metrics.append(metrics)
        
        if not patient_metrics:
            return None
        
        # Aggregate statistics
        stats = self._aggregate_metrics(patient_metrics, pathology_code, pathology_name)
        
        return stats
    
    def _calculate_patient_metrics(
        self, 
        patient_id: str, 
        zones: List[str]
    ) -> Optional[Dict[str, Any]]:
        """
        Calculate metrics for a single patient
        
        Returns:
            Dict with patient metrics or None
        """
        
        # Get all pain points for this patient in target zones
        zone_placeholders = ','.join(['?' for _ in zones])
        query = f"""
        SELECT 
            id,
            zone,
            intensity,
            timestamp,
            session_id
        FROM pain_points
        WHERE patient_id = ? AND zone IN ({zone_placeholders})
        ORDER BY timestamp ASC
        """
        
        params = (patient_id,) + tuple(zones)
        pain_points = self.db.fetch_all(query, params)
        
        if len(pain_points) < 2:
            return None  # Need at least 2 points for comparison
        
        # Extract metrics
        first_point = pain_points[0]
        last_point = pain_points[-1]
        
        initial_intensity = first_point['intensity']
        final_intensity = last_point['intensity']
        total_improvement = initial_intensity - final_intensity
        
        # Calculate dates
        start_date = datetime.fromisoformat(first_point['timestamp'])
        end_date = datetime.fromisoformat(last_point['timestamp'])
        total_days = (end_date - start_date).days
        
        # Get session count
        sessions = self.db.fetch_all(
            "SELECT id, date FROM pain_sessions WHERE patient_id = ? ORDER BY date",
            (patient_id,)
        )
        session_count = len(sessions)
        
        # Calculate days to 30% improvement
        days_to_30pct = self._calculate_days_to_improvement(
            pain_points, 
            initial_intensity,
            threshold_pct=0.30
        )
        
        # Calculate days to recovery (< 2/10)
        days_to_recovery = self._calculate_days_to_recovery(
            pain_points,
            threshold=2
        )
        
        # Zone distribution
        zone_counts = defaultdict(int)
        for point in pain_points:
            zone_counts[point['zone']] += 1
        
        return {
            'patient_id': patient_id,
            'initial_intensity': initial_intensity,
            'final_intensity': final_intensity,
            'total_improvement': total_improvement,
            'total_days': total_days,
            'session_count': session_count,
            'days_to_30pct_improvement': days_to_30pct,
            'days_to_recovery': days_to_recovery,
            'achieved_30pct': total_improvement >= (initial_intensity * 0.30),
            'achieved_50pct': total_improvement >= (initial_intensity * 0.50),
            'achieved_recovery': final_intensity <= 2,
            'zone_distribution': dict(zone_counts)
        }
    
    def _calculate_days_to_improvement(
        self,
        pain_points: List[Dict],
        initial_intensity: float,
        threshold_pct: float
    ) -> Optional[int]:
        """
        Calculate days until threshold improvement is reached
        
        Args:
            pain_points: List of pain points (sorted by date)
            initial_intensity: Initial pain intensity
            threshold_pct: Improvement threshold (0.30 = 30%)
            
        Returns:
            Number of days or None if not achieved
        """
        target_intensity = initial_intensity * (1 - threshold_pct)
        start_date = datetime.fromisoformat(pain_points[0]['timestamp'])
        
        for point in pain_points:
            if point['intensity'] <= target_intensity:
                achievement_date = datetime.fromisoformat(point['timestamp'])
                return (achievement_date - start_date).days
        
        return None  # Not achieved yet
    
    def _calculate_days_to_recovery(
        self,
        pain_points: List[Dict],
        threshold: int = 2
    ) -> Optional[int]:
        """
        Calculate days until pain drops below threshold (recovery)
        
        Args:
            pain_points: List of pain points (sorted by date)
            threshold: Pain threshold for recovery (default 2/10)
            
        Returns:
            Number of days or None if not achieved
        """
        start_date = datetime.fromisoformat(pain_points[0]['timestamp'])
        
        for point in pain_points:
            if point['intensity'] <= threshold:
                recovery_date = datetime.fromisoformat(point['timestamp'])
                return (recovery_date - start_date).days
        
        return None  # Not recovered yet
    
    def _aggregate_metrics(
        self,
        patient_metrics: List[Dict],
        pathology_code: str,
        pathology_name: str
    ) -> Dict[str, Any]:
        """
        Aggregate patient metrics into pathology statistics
        
        Args:
            patient_metrics: List of patient metric dicts
            pathology_code: Pathology code
            pathology_name: Pathology name
            
        Returns:
            Aggregated statistics dict
        """
        total_patients = len(patient_metrics)
        
        # Calculate averages
        avg_initial = sum(m['initial_intensity'] for m in patient_metrics) / total_patients
        avg_final = sum(m['final_intensity'] for m in patient_metrics) / total_patients
        avg_improvement = sum(m['total_improvement'] for m in patient_metrics) / total_patients
        avg_sessions = sum(m['session_count'] for m in patient_metrics) / total_patients
        
        # Days to improvement (exclude None values)
        days_30pct_list = [m['days_to_30pct_improvement'] for m in patient_metrics if m['days_to_30pct_improvement'] is not None]
        avg_days_30pct = sum(days_30pct_list) / len(days_30pct_list) if days_30pct_list else None
        
        # Days to recovery (exclude None values)
        days_recovery_list = [m['days_to_recovery'] for m in patient_metrics if m['days_to_recovery'] is not None]
        avg_days_recovery = sum(days_recovery_list) / len(days_recovery_list) if days_recovery_list else None
        
        # Success rates
        success_30pct = sum(1 for m in patient_metrics if m['achieved_30pct']) / total_patients
        success_50pct = sum(1 for m in patient_metrics if m['achieved_50pct']) / total_patients
        success_recovery = sum(1 for m in patient_metrics if m['achieved_recovery']) / total_patients
        
        # Aggregate zone distribution
        all_zones = defaultdict(int)
        for m in patient_metrics:
            for zone, count in m['zone_distribution'].items():
                all_zones[zone] += count
        
        # Calculate percentages
        total_zone_points = sum(all_zones.values())
        zone_percentages = {
            zone: round((count / total_zone_points) * 100, 1)
            for zone, count in all_zones.items()
        }
        
        return {
            'pathology_code': pathology_code,
            'pathology_name': pathology_name,
            'total_patients': total_patients,
            
            # Intensity metrics
            'avg_initial_intensity': round(avg_initial, 1),
            'avg_final_intensity': round(avg_final, 1),
            'avg_total_improvement': round(avg_improvement, 1),
            
            # Session metrics
            'avg_sessions_count': round(avg_sessions, 1),
            
            # Time metrics (NEW - as requested)
            'avg_days_to_30pct_improvement': round(avg_days_30pct, 1) if avg_days_30pct else None,
            'avg_days_to_recovery': round(avg_days_recovery, 1) if avg_days_recovery else None,
            'patients_achieving_30pct': len(days_30pct_list),
            'patients_achieving_recovery': len(days_recovery_list),
            
            # Success rates
            'success_rate_30pct': round(success_30pct * 100, 1),
            'success_rate_50pct': round(success_50pct * 100, 1),
            'success_rate_recovery': round(success_recovery * 100, 1),
            
            # Zone distribution
            'affected_zones': zone_percentages,
            
            # Metadata
            'calculated_at': datetime.utcnow().isoformat(),
            'data_period_start': min(m['patient_id'] for m in patient_metrics),  # Placeholder
            'data_period_end': datetime.utcnow().date().isoformat()
        }
    
    def save_pathology_stats(self, stats: Dict[str, Any]) -> str:
        """
        Save calculated statistics to database
        
        Args:
            stats: Statistics dictionary
            
        Returns:
            Record ID
        """
        import uuid
        
        record_id = f"pstat_{uuid.uuid4().hex[:12]}"
        
        data = {
            'id': record_id,
            'pathology_code': stats['pathology_code'],
            'pathology_name': stats['pathology_name'],
            'total_patients': stats['total_patients'],
            'avg_initial_intensity': stats['avg_initial_intensity'],
            'avg_final_intensity': stats['avg_final_intensity'],
            'avg_total_improvement': stats['avg_total_improvement'],
            'avg_sessions_count': stats['avg_sessions_count'],
            'avg_days_to_improvement': stats['avg_days_to_30pct_improvement'],
            'avg_days_to_recovery': stats['avg_days_to_recovery'],
            'success_rate_30pct': stats['success_rate_30pct'],
            'success_rate_50pct': stats['success_rate_50pct'],
            'success_rate_recovery': stats['success_rate_recovery'],
            'affected_zones': json.dumps(stats['affected_zones']),
            'calculated_at': stats['calculated_at'],
            'data_period_start': stats['data_period_start'],
            'data_period_end': stats['data_period_end']
        }
        
        self.db.insert('pathology_stats', data)
        print(f"✅ Saved stats for {stats['pathology_name']}: {stats['total_patients']} patients")
        
        return record_id
    
    def calculate_all_pathologies(self) -> List[Dict[str, Any]]:
        """
        Calculate statistics for all known pathologies
        
        Returns:
            List of statistics dicts
        """
        pathologies = [
            ('lombalgie', 'Lombalgie chronique'),
            ('cervicalgie', 'Cervicalgie / Douleurs cervicales'),
            ('tendinite_epaule', 'Tendinite de l\'épaule'),
            ('gonalgie', 'Gonalgie / Douleurs du genou'),
            ('entorse_cheville', 'Entorse de la cheville'),
            ('syndrome_canal_carpien', 'Syndrome du canal carpien'),
            ('sciatique', 'Sciatique / Sciatalgie'),
            ('periarthrite', 'Périarthrite scapulo-humérale'),
        ]
        
        all_stats = []
        for code, name in pathologies:
            stats = self.calculate_pathology_stats(code, name)
            if stats:
                self.save_pathology_stats(stats)
                all_stats.append(stats)
        
        return all_stats
    
    def get_latest_pathology_stats(self, pathology_code: Optional[str] = None) -> List[Dict[str, Any]]:
        """
        Get latest statistics from database
        
        Args:
            pathology_code: Specific pathology or None for all
            
        Returns:
            List of statistics dicts
        """
        if pathology_code:
            query = """
            SELECT * FROM pathology_stats 
            WHERE pathology_code = ?
            ORDER BY calculated_at DESC
            LIMIT 1
            """
            result = self.db.fetch_one(query, (pathology_code,))
            return [result] if result else []
        else:
            # Get latest for each pathology
            query = """
            SELECT * FROM pathology_stats ps1
            WHERE calculated_at = (
                SELECT MAX(calculated_at)
                FROM pathology_stats ps2
                WHERE ps2.pathology_code = ps1.pathology_code
            )
            ORDER BY pathology_name
            """
            return self.db.fetch_all(query)
    
    def _get_pathology_zone_mapping(self) -> Dict[str, List[str]]:
        """
        Map pathology codes to affected body zones
        
        Returns:
            Dict of pathology_code -> [zones]
        """
        return {
            'lombalgie': ['lower_back', 'pelvis'],
            'cervicalgie': ['neck', 'upper_back'],
            'tendinite_epaule': ['shoulder_left', 'shoulder_right', 'upper_arm_left', 'upper_arm_right'],
            'gonalgie': ['knee_left', 'knee_right', 'lower_leg_left', 'lower_leg_right'],
            'entorse_cheville': ['ankle_left', 'ankle_right', 'foot_left', 'foot_right'],
            'syndrome_canal_carpien': ['wrist_left', 'wrist_right', 'hand_left', 'hand_right'],
            'sciatique': ['lower_back', 'pelvis', 'upper_leg_left', 'upper_leg_right'],
            'periarthrite': ['shoulder_left', 'shoulder_right', 'upper_arm_left', 'upper_arm_right'],
        }
    
    def get_patient_pathology(self, patient_id: str) -> Optional[str]:
        """
        Determine primary pathology for a patient based on pain zones
        
        Args:
            patient_id: Patient ID
            
        Returns:
            Pathology code or None
        """
        # Get most frequent zones
        query = """
        SELECT zone, COUNT(*) as count
        FROM pain_points
        WHERE patient_id = ?
        GROUP BY zone
        ORDER BY count DESC
        LIMIT 3
        """
        
        top_zones = self.db.fetch_all(query, (patient_id,))
        if not top_zones:
            return None
        
        zone_set = set(row['zone'] for row in top_zones)
        
        # Match against pathology mappings
        mapping = self._get_pathology_zone_mapping()
        best_match = None
        best_score = 0
        
        for pathology_code, pathology_zones in mapping.items():
            overlap = len(zone_set.intersection(pathology_zones))
            if overlap > best_score:
                best_score = overlap
                best_match = pathology_code
        
        return best_match if best_score > 0 else None


# Standalone testing
if __name__ == "__main__":
    from database.db_manager import get_db
    
    print("🧪 Testing StatisticsService...")
    
    db = get_db()
    stats_service = StatisticsService(db)
    
    # Calculate stats for all pathologies
    print("\n📊 Calculating pathology statistics...")
    all_stats = stats_service.calculate_all_pathologies()
    
    print(f"\n✅ Calculated stats for {len(all_stats)} pathologies")
    
    for stats in all_stats:
        print(f"\n📈 {stats['pathology_name']}:")
        print(f"   Patients: {stats['total_patients']}")
        print(f"   Avg improvement: {stats['avg_total_improvement']:.1f} points")
        print(f"   Avg sessions: {stats['avg_sessions_count']:.1f}")
        
        if stats['avg_days_to_30pct_improvement']:
            print(f"   Days to 30% improvement: {stats['avg_days_to_30pct_improvement']:.1f}")
        
        if stats['avg_days_to_recovery']:
            print(f"   Days to recovery: {stats['avg_days_to_recovery']:.1f}")
        
        print(f"   Success rate (30%): {stats['success_rate_30pct']:.1f}%")
        print(f"   Recovery rate: {stats['success_rate_recovery']:.1f}%")
