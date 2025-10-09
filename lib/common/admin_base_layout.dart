import 'package:epi_dash_mvp/common/widgets/layouts/headers/admin_header.dart';
import 'package:epi_dash_mvp/common/widgets/layouts/sidebars/admin_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminBaseLayout extends StatelessWidget {
  const AdminBaseLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar fixa
          AdminSidebar(),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Header fixo
                AdminHeader(),
                // Page content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
