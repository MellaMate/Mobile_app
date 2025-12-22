import 'package:flutter/material.dart';

class BottomNavigationCustom extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const BottomNavigationCustom({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    final background = Colors.white;
    final accent = const Color(0xFF00A86B);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.green.shade200, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.green,
                blurRadius: 5,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(
                index: 0,
                active: currentIndex == 0,
                icon: Icons.dashboard_outlined,
                label: 'Dashboard',
                accent: accent,
                onTap: onTap,
              ),
              _NavItem(
                index: 1,
                active: currentIndex == 1,
                icon: Icons.send_outlined,
                label: 'Send',
                accent: accent,
                onTap: onTap,
              ),
              _NavItem(
                index: 2,
                active: currentIndex == 2,
                icon: Icons.download_outlined,
                label: 'Receive',
                accent: accent,
                onTap: onTap,
              ),
              _NavItem(
                index: 3,
                active: currentIndex == 3,
                icon: Icons.history_outlined,
                label: 'History',
                accent: accent,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final bool active;
  final IconData icon;
  final String label;
  final Color accent;
  final ValueChanged<int>? onTap;

  const _NavItem({
    super.key,
    required this.index,
    required this.active,
    required this.icon,
    required this.label,
    required this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? accent : Colors.grey.shade500;

    return Expanded(
      child: InkWell(
        onTap: () => onTap?.call(index),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: color),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
