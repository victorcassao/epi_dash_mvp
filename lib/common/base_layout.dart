import 'package:epi_dash_mvp/common/widgets/layouts/headers/header.dart';
import 'package:epi_dash_mvp/common/widgets/layouts/sidebars/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar fixa
          Sidebar(),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Header fixo
                Header(),
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
