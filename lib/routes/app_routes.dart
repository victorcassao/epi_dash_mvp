import 'package:epi_dash_mvp/auth/middlewares/auth_middleware.dart';
import 'package:epi_dash_mvp/auth/screens/admin_login_screen.dart';
import 'package:epi_dash_mvp/auth/screens/login_screen.dart';
import 'package:epi_dash_mvp/common/base_layout.dart';
import 'package:epi_dash_mvp/modules/admin/screens/admin_streams_list_screen.dart';
import 'package:epi_dash_mvp/modules/streams/screens/streams_detail_screen.dart';
import 'package:epi_dash_mvp/modules/streams/screens/streams_list_screen.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.home,
      page: () => BaseLayout(body: Center(child: Text("Homepage"),)),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.streamDetailsWithId,
      page: () => BaseLayout(body: StreamDetailScreen()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.listStreams,
      page: () => BaseLayout(body: StreamListScreen()),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.alerts,
      page: () => BaseLayout(body: Center(child: Text("Alertas"),)),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.adminLogin,
      page: () => AdminLoginScreen(),
    ),

  ];
}
