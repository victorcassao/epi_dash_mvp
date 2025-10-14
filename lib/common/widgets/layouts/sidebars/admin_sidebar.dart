import 'package:epi_dash_mvp/common/controllers/admin_sidebar_controller.dart';
import 'package:epi_dash_mvp/common/widgets/layouts/sidebars/admin_sidebar_item.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  DrawerHeader _buildAdminSidebarHeader() {
    return const DrawerHeader(
      child: Text("Menu Admin", style: TextStyle(fontSize: 22)),
    );
  }

  List<AdminSidebarItem> _builAdmindSidebarItems(AdminSidebarController controller) {
    return [
      AdminSidebarItem(
        label: "Início",
        icon: Icons.home,
        route: AdminRoutes.adminHome,
        selected: controller.selectedRoute.value == AdminRoutes.adminHome,
        onTap: () => controller.select(AdminRoutes.adminHome),
      ),
      AdminSidebarItem(
        label: "Streams",
        icon: Icons.play_circle_fill_outlined,
        route: AdminRoutes.adminListStreams,
        selected: controller.selectedRoute.value == AdminRoutes.adminListStreams,
        onTap: () => controller.select(AdminRoutes.adminListStreams),
      ),
      AdminSidebarItem(
        label: "Alertas",
        icon: Icons.error,
        route: AdminRoutes.adminAlerts,
        selected: controller.selectedRoute.value == AdminRoutes.adminAlerts,
        onTap: () => controller.select(AdminRoutes.adminAlerts),
      ),
      AdminSidebarItem(
        label: "Cadastrar Câmera",
        icon: Icons.videocam_outlined,
        route: AdminRoutes.addCamera,
        selected: controller.selectedRoute.value == AdminRoutes.addCamera,
        onTap: () => controller.select(AdminRoutes.addCamera),
      ),
      AdminSidebarItem(
        label: "Cadastrar Empresa",
        icon: Icons.business_sharp,
        route: AdminRoutes.addCompany,
        selected: controller.selectedRoute.value == AdminRoutes.addCompany,
        onTap: () => controller.select(AdminRoutes.addCompany),
      ),
      AdminSidebarItem(
        label: "Cadastrar Funcionário",
        icon: Icons.person_add,
        route: AdminRoutes.addEmployee,
        selected: controller.selectedRoute.value == AdminRoutes.addEmployee,
        onTap: () => controller.select(AdminRoutes.addEmployee),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final adminSidebarController = Get.put(AdminSidebarController());

    return Obx(() {
      return Container(
        width: 250,
        color: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAdminSidebarHeader(),
            ..._builAdmindSidebarItems(adminSidebarController)
          ],
        ),
      );
    });
  }
}

