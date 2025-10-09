import 'package:epi_dash_mvp/auth/middlewares/admin_auth_middleware.dart';
import 'package:epi_dash_mvp/auth/screens/admin_login_screen.dart';
import 'package:epi_dash_mvp/common/admin_base_layout.dart';
import 'package:epi_dash_mvp/modules/admin/bindings/admin_add_camera_bindings.dart';
import 'package:epi_dash_mvp/modules/admin/bindings/admin_add_company_bindings.dart';
import 'package:epi_dash_mvp/modules/admin/bindings/admin_stream_detail_bindings.dart';
import 'package:epi_dash_mvp/modules/admin/bindings/admin_streams_list_bindings.dart';
import 'package:epi_dash_mvp/modules/admin/screens/admin_add_camera_screen.dart';
import 'package:epi_dash_mvp/modules/admin/screens/admin_add_company_screen.dart';
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
      binding: AdminStreamsListBindings(),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.adminStreamDetail,
      page: () => AdminBaseLayout(body: AdminStreamDetailScreen()),
      binding: AdminStreamDetailBindings(),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.adminAlerts,
      page: () => AdminBaseLayout(body: Center(child: Text("Alertas Admin"))),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.addCompany,
      page: () => AdminBaseLayout(body: AdminAddCompanyScreen()),
      binding: AdminAddCompanyBindings(),
      middlewares: [AdminAuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.addCamera,
      page: () => const AdminBaseLayout(body: AdminAddCameraScreen()),
      binding: AdminAddCameraBindings(),
      middlewares: [AdminAuthMiddleware()],
    )
  ];
}
