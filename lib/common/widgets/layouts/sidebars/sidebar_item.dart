import 'package:flutter/material.dart';


class SidebarItem extends StatelessWidget {

  const SidebarItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String route;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? Colors.blue.shade200 : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black,),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        selected: selected,
        onTap: onTap,
      ),
    );
  }
}

