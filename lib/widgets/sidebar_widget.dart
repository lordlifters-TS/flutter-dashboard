import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';

class SidebarWidget extends StatelessWidget {
  final String currentRoute;
  const SidebarWidget({super.key, required this.currentRoute});

  static const _items = [
    _SidebarItem('/dashboard',      Icons.dashboard_outlined,          'Dashboard'),
    _SidebarItem('/patients',       Icons.people_outlined,             'Patients'),
    _SidebarItem('/health-records', Icons.medical_information_outlined, 'Health Records'),
    _SidebarItem('/referrals',      Icons.swap_horiz_outlined,         'Referrals'),
    _SidebarItem('/facilities',     Icons.local_hospital_outlined,     'Facilities'),
    _SidebarItem('/notifications',  Icons.notifications_outlined,      'Notifications'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF00695C),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            color: const Color(0xFF004D40),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_hospital, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AFYALINK',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
                    Text('Health Records', style: TextStyle(color: Colors.white60, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              children: _items.map((item) => _buildNavItem(context, item)).toList(),
            ),
          ),

          // User Profile & Logout
          const Divider(color: Colors.white24, height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Consumer<AuthProvider>(
              builder: (_, auth, __) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Text(auth.userName.isNotEmpty ? auth.userName[0] : 'U',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                title: Text(auth.userName,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis),
                subtitle: Text(auth.userRole.replaceAll('_', ' ').toUpperCase(),
                    style: const TextStyle(color: Colors.white60, fontSize: 10)),
                trailing: IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white70, size: 20),
                  onPressed: () async {
                    await auth.logout();
                    if (context.mounted) context.go('/login');
                  },
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _SidebarItem item) {
    final isActive = currentRoute == item.route;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(item.icon, color: isActive ? Colors.white : Colors.white70, size: 22),
        title: Text(
          item.title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () => context.go(item.route),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        dense: true,
      ),
    );
  }
}

class _SidebarItem {
  final String route;
  final IconData icon;
  final String title;
  const _SidebarItem(this.route, this.icon, this.title);
}
