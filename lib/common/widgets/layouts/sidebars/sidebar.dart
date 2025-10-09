import 'package:epi_dash_mvp/common/controllers/sidebar_controller.dart';
import 'package:epi_dash_mvp/common/widgets/layouts/sidebars/sidebar_item.dart';
import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  DrawerHeader _buildSidebarHeader() {
    return const DrawerHeader(
      child: Text("Menu", style: TextStyle(fontSize: 22)),
    );
  }

  List<SidebarItem> _buildSidebarItems(SidebarController controller) {
    return [
      SidebarItem(
        label: "Início",
        icon: Icons.home,
        route: Routes.home,
        selected: controller.selectedRoute.value == Routes.home,
        onTap: () => controller.select(Routes.home),
      ),
      SidebarItem(
        label: "Streams",
        icon: Icons.play_circle_fill_outlined,
        route: Routes.listStreams,
        selected: controller.selectedRoute.value == Routes.listStreams,
        onTap: () => controller.select(Routes.listStreams),
      ),
      SidebarItem(
        label: "Alertas",
        icon: Icons.error,
        route: Routes.alerts,
        selected: controller.selectedRoute.value == Routes.alerts,
        onTap: () => controller.select(Routes.alerts),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sidebarController = Get.put(SidebarController());

    return Obx(() {
      return Container(
        width: 250,
        color: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSidebarHeader(),
            ..._buildSidebarItems(sidebarController)
          ],
        ),
      );
    });
  }
}

