import 'package:epi_dash_mvp/auth/middlewares/admin_auth_middleware.dart';
import 'package:epi_dash_mvp/auth/screens/admin_login_screen.dart';
import 'package:epi_dash_mvp/common/admin_base_layout.dart';
import 'package:epi_dash_mvp/modules/admin/screens/admin_stream_detail_screen.dart';
import 'package:epi_dash_mvp/modules/admin/screens/admin_streams_list_screen.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AdminAppRoutes {
  static final List<GetPage> pages = [
    GetPage(name: AdminRoutes.adminLogin, page: () => AdminLoginScreen()),
    GetPage(
      name: AdminRoutes.adminHome,
      page: () => AdminBaseLayout(body: Center(child: Text("Home"),)),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.adminListStreams,
      page: () => AdminBaseLayout(body: AdminStreamsListScreen()),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.adminStreamDetail,
      page: () => AdminBaseLayout(body: AdminStreamDetailScreen()),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.adminAlerts,
      page: () => AdminBaseLayout(body: Center(child: Text("Alertas Admin"))),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.addCompany,
      page: () => AdminBaseLayout(body: Center(child: Text("Adicionar Empresa"))),
      middlewares: [AdminAuthMiddleware()],
    ),
  ];
}
