import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../utils/app_theme.dart';

/// Card affichant les permissions d'un utilisateur
class UserPermissionsCard extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;
  final Function(UserModel, bool) onToggleStatus;
  final Function(UserModel) onDelegate;
  final Function(UserModel) onRevoke;

  const UserPermissionsCard({
    super.key,
    required this.user,
    required this.currentUser,
    required this.onToggleStatus,
    required this.onDelegate,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final bool canModify = currentUser.role.hierarchyLevel > user.role.hierarchyLevel;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _getRoleColor(user.role),
                  child: Text(
                    user.firstName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Infos utilisateur
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getRoleColor(user.role).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              user.role.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: _getRoleColor(user.role),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          
                          if (user.canManagePermissions && user.role != UserRole.manager && user.role != UserRole.sadmin) ...[
                            const SizedBox(width: 8),
                            Icon(Icons.supervised_user_circle, size: 16, color: AppTheme.warning),
                            const SizedBox(width: 4),
                            Text('Délégué', style: TextStyle(fontSize: 12, color: AppTheme.warning)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Switch actif/inactif
                if (canModify) ...[
                  Switch(
                    value: user.isActive,
                    onChanged: (value) => onToggleStatus(user, value),
                  ),
                ],
              ],
            ),
            
            // Actions
            if (canModify && user.role != UserRole.sadmin) ...[
              const Divider(height: 24),
              Row(
                children: [
                  // Bouton Déléguer/Révoquer
                  if (currentUser.isSadmin || currentUser.isManager) ...[
                    Expanded(
                      child: user.canManagePermissions && user.role != UserRole.manager
                          ? OutlinedButton.icon(
                              onPressed: () => onRevoke(user),
                              icon: const Icon(Icons.cancel, size: 18),
                              label: const Text('Révoquer délégation'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.warning,
                                side: const BorderSide(color: AppTheme.warning),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () => onDelegate(user),
                              icon: const Icon(Icons.add_moderator, size: 18),
                              label: const Text('Déléguer permissions'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.success,
                              ),
                            ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.sadmin:
        return AppTheme.error;
      case UserRole.manager:
        return AppTheme.warning;
      case UserRole.kine:
        return AppTheme.primaryOrange;
      case UserRole.coach:
        return Colors.blue;
      case UserRole.patient:
        return AppTheme.success;
    }
  }
}
