import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/auth/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminHeader extends StatelessWidget {
  const AdminHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AdminAuthController>();
    final UserProfile? user = auth.user.value;
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          const Spacer(),
          _HeaderItem(title: 'Empresa', value: "Superuser"),
          const VerticalDivider(width: 32, thickness: 0.5, color: Colors.grey),
          _HeaderItem(title: 'Conectado como', value: user?.name ?? ""),
          const VerticalDivider(width: 32, thickness: 0.5, color: Colors.grey),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              auth.logout();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

class _HeaderItem extends StatelessWidget {
  const _HeaderItem({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
