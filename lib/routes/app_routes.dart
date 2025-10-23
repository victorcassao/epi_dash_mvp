import 'package:epi_dash_mvp/auth/middlewares/auth_middleware.dart';
import 'package:epi_dash_mvp/auth/screens/admin_login_screen.dart';
import 'package:epi_dash_mvp/auth/screens/login_screen.dart';
import 'package:epi_dash_mvp/common/base_layout.dart';
import 'package:epi_dash_mvp/modules/alerts/bindings/alerts_list_bindings.dart';
import 'package:epi_dash_mvp/modules/alerts/bindings/camera_alerts_bindings.dart';
import 'package:epi_dash_mvp/modules/alerts/screens/alerts_list_screen.dart';
import 'package:epi_dash_mvp/modules/alerts/screens/camera_alerts_screen.dart';
import 'package:epi_dash_mvp/modules/streams/bindings/stream_detail_bindings.dart';
import 'package:epi_dash_mvp/modules/streams/bindings/stream_list_bindings.dart';
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
      binding: StreamDetailBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.listStreams,
      page: () => BaseLayout(body: StreamListScreen()),
      binding: StreamListBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AdminRoutes.adminLogin,
      page: () => AdminLoginScreen(),
    ),
    GetPage(
      name: Routes.alerts,
      page: () => BaseLayout(body: AlertsListScreen()),
      binding: AlertsListBindings(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.cameraAlerts,
      page: () => BaseLayout(body: CameraAlertsScreen()),
      binding: CameraAlertsBindings(),
      middlewares: [AuthMiddleware()],
    )
  ];
}
