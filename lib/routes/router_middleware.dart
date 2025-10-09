import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RouteMiddleware extends GetMiddleware{


  @override
  RouteSettings? redirect(String? route) {
    print("Rodou middleware");
    final isAuthenticated = true;
    return isAuthenticated ? null : const RouteSettings(name: Routes.login);
  }
}