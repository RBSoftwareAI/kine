import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/audit_log.dart';
import '../../../utils/app_theme.dart';

/// Widget pour afficher un élément de la timeline d'audit
class AuditTimelineItem extends StatelessWidget {
  final AuditLog log;
  final bool isFirst;
  final bool isLast;

  const AuditTimelineItem({
    super.key,
    required this.log,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ligne de timeline avec icône
          SizedBox(
            width: 60,
            child: Column(
              children: [
                // Ligne supérieure
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: _getTimelineColor().withValues(alpha: 0.3),
                    ),
                  ),
                
                // Icône centrale
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTimelineColor().withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getTimelineColor(),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: _getActionIcon(),
                  ),
                ),
                
                // Ligne inférieure
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: _getTimelineColor().withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Contenu du log
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête avec action et timestamp
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTimelineColor().withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  log.actionType.emoji,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  log.actionType.displayName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _getTimelineColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatTimestamp(log.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.grey,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Utilisateur
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: _getRoleColor().withValues(alpha: 0.2),
                            child: Text(
                              log.userName[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _getRoleColor(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _getRoleDisplayName(log.userRole),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (log.isModifiedByProfessional)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'PRO',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryOrange,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Description
                      Text(
                        log.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                      
                      // Changements détaillés
                      if (log.oldValues != null && log.newValues != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.lightGrey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Détails des modifications :',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...log.newValues!.entries.map((entry) {
                                final oldValue = log.oldValues![entry.key];
                                final newValue = entry.value;
                                
                                if (oldValue == newValue) return const SizedBox.shrink();
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 14,
                                        color: AppTheme.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.darkBackground,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${entry.key}: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '$oldValue',
                                                style: TextStyle(
                                                  decoration: TextDecoration.lineThrough,
                                                  color: AppTheme.grey,
                                                ),
                                              ),
                                              const TextSpan(text: ' → '),
                                              TextSpan(
                                                text: '$newValue',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.primaryOrange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTimelineColor() {
    switch (log.actionType) {
      case ActionType.created:
        return AppTheme.success;
      case ActionType.updated:
        return AppTheme.primaryOrange;
      case ActionType.deleted:
        return AppTheme.error;
      case ActionType.viewed:
        return AppTheme.info;
      case ActionType.commented:
        return Colors.purple;
      case ActionType.approved:
        return AppTheme.success;
      case ActionType.rejected:
        return AppTheme.error;
      default:
        return AppTheme.grey;
    }
  }

  Widget _getActionIcon() {
    IconData iconData;
    
    switch (log.actionType) {
      case ActionType.created:
        iconData = Icons.add;
        break;
      case ActionType.updated:
        iconData = Icons.edit;
        break;
      case ActionType.deleted:
        iconData = Icons.delete;
        break;
      case ActionType.viewed:
        iconData = Icons.visibility;
        break;
      case ActionType.commented:
        iconData = Icons.comment;
        break;
      case ActionType.approved:
        iconData = Icons.check;
        break;
      case ActionType.rejected:
        iconData = Icons.close;
        break;
      default:
        iconData = Icons.more_horiz;
    }
    
    return Icon(
      iconData,
      size: 18,
      color: _getTimelineColor(),
    );
  }

  Color _getRoleColor() {
    switch (log.userRole) {
      case 'kine':
        return AppTheme.primaryOrange;
      case 'coach':
        return Colors.purple;
      case 'patient':
        return AppTheme.info;
      default:
        return AppTheme.grey;
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'kine':
        return 'Kinésithérapeute';
      case 'coach':
        return 'Coach APA';
      case 'patient':
        return 'Patient';
      default:
        return role;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
    }
  }
}
