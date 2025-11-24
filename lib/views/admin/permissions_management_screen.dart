import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';
import '../../utils/app_theme.dart';
import 'widgets/user_permissions_card.dart';
import 'widgets/create_user_dialog.dart';
import 'widgets/delegation_dialog.dart';

/// Écran de gestion des permissions (sadmin et manager uniquement)
class PermissionsManagementScreen extends StatefulWidget {
  const PermissionsManagementScreen({super.key});

  @override
  State<PermissionsManagementScreen> createState() => _PermissionsManagementScreenState();
}

class _PermissionsManagementScreenState extends State<PermissionsManagementScreen> {
  final AdminService _adminService = AdminService();
  
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  UserRole? _selectedRoleFilter;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await _adminService.getProfessionals();
      
      setState(() {
        _allUsers = users;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    var filtered = List<UserModel>.from(_allUsers);

    // Filtre par rôle
    if (_selectedRoleFilter != null) {
      filtered = filtered.where((u) => u.role == _selectedRoleFilter).toList();
    }

    // Trier par hiérarchie descendante puis nom
    filtered.sort((a, b) {
      final roleComparison = b.role.hierarchyLevel.compareTo(a.role.hierarchyLevel);
      if (roleComparison != 0) return roleComparison;
      return a.fullName.compareTo(b.fullName);
    });

    setState(() {
      _filteredUsers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final currentUser = authProvider.currentUser;

    // Vérification accès
    if (currentUser == null || !currentUser.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Accès Refusé')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: AppTheme.error),
              SizedBox(height: 16),
              Text('Accès réservé aux administrateurs'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Permissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateUserDialog(_userToUserModel(currentUser)),
        icon: const Icon(Icons.person_add),
        label: const Text('Nouveau professionnel'),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  /// Convertir User en UserModel pour compatibilité avec ce screen
  UserModel _userToUserModel(dynamic user) {
    if (user is UserModel) return user;
    
    // Mapper le role String vers UserRole enum
    UserRole userRole;
    switch (user.role?.toLowerCase()) {
      case 'sadmin':
        userRole = UserRole.sadmin;
        break;
      case 'manager':
      case 'admin':
        userRole = UserRole.manager;
        break;
      case 'kine':
      case 'kinésithérapeute':
        userRole = UserRole.kine;
        break;
      case 'coach':
        userRole = UserRole.coach;
        break;
      default:
        userRole = UserRole.patient;
    }
    
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.prenom ?? user.firstName ?? '',
      lastName: user.nom ?? user.lastName ?? '',
      role: userRole,
      phoneNumber: user.telephone ?? user.phoneNumber,
      createdAt: user.dateCreation ?? user.createdAt ?? DateTime.now(),
      lastLoginAt: user.derniereConnexion ?? user.lastLoginAt,
      isActive: user.actif ?? user.isActive ?? true,
      canManagePermissions: false, // Par défaut
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppTheme.error),
            const SizedBox(height: 16),
            Text('Erreur', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadUsers,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Statistiques rapides
        _buildStatsBar(),

        // Filtres de rôle
        _buildRoleFilters(),

        const SizedBox(height: 8),

        // Liste des utilisateurs
        Expanded(
          child: _filteredUsers.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    return UserPermissionsCard(
                      user: _filteredUsers[index],
                      currentUser: _userToUserModel(context.read<AuthProvider>().currentUser!),
                      onToggleStatus: (user, status) => _toggleUserStatus(user, status),
                      onDelegate: _showDelegationDialog,
                      onRevoke: _revokeDelegation,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatsBar() {
    final managers = _allUsers.where((u) => u.role == UserRole.manager).length;
    final kines = _allUsers.where((u) => u.role == UserRole.kine).length;
    final coaches = _allUsers.where((u) => u.role == UserRole.coach).length;
    final delegated = _allUsers.where((u) => u.canManagePermissions && u.role != UserRole.manager && u.role != UserRole.sadmin).length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryOrange.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Managers', managers, Icons.admin_panel_settings),
          _buildStatItem('Kinés', kines, Icons.health_and_safety),
          _buildStatItem('Coaches', coaches, Icons.fitness_center),
          _buildStatItem('Délégués', delegated, Icons.supervised_user_circle),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryOrange, size: 28),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.grey),
        ),
      ],
    );
  }

  Widget _buildRoleFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Tous'),
            selected: _selectedRoleFilter == null,
            onSelected: (selected) {
              setState(() {
                _selectedRoleFilter = null;
                _applyFilters();
              });
            },
          ),
          const SizedBox(width: 8),
          ...UserRole.values.where((role) => role != UserRole.patient).map((role) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(role.displayName),
                  selected: _selectedRoleFilter == role,
                  onSelected: (selected) {
                    setState(() {
                      _selectedRoleFilter = selected ? role : null;
                      _applyFilters();
                    });
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppTheme.grey),
          const SizedBox(height: 16),
          const Text(
            'Aucun utilisateur',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Ajoutez des professionnels pour commencer',
            style: TextStyle(color: AppTheme.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateUserDialog(UserModel currentUser) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CreateUserDialog(
        adminService: _adminService,
        currentUser: currentUser,
      ),
    );

    if (result == true) {
      _loadUsers();
    }
  }

  Future<void> _toggleUserStatus(UserModel user, bool isActive) async {
    try {
      await _adminService.toggleUserStatus(user.id, isActive);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isActive 
              ? '✅ ${user.fullName} activé' 
              : '❌ ${user.fullName} désactivé'),
            backgroundColor: isActive ? AppTheme.success : AppTheme.warning,
          ),
        );
      }
      
      _loadUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showDelegationDialog(UserModel user) async {
    final result = await showDialog<DateTime?>(
      context: context,
      builder: (context) => DelegationDialog(user: user),
    );

    if (result != null) {
      try {
        await _adminService.delegatePermissions(
          userId: user.id,
          expiresAt: result,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Permissions déléguées à ${user.fullName}'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
        
        _loadUsers();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur délégation: $e'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _revokeDelegation(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Révoquer délégation'),
        content: Text('Retirer les permissions de gestion à ${user.fullName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
            child: const Text('Révoquer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _adminService.revokeDelegation(user.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Délégation révoquée pour ${user.fullName}'),
              backgroundColor: AppTheme.warning,
            ),
          );
        }
        
        _loadUsers();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur révocation: $e'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }
}
