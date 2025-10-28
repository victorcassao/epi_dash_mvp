import 'package:epi_dash_mvp/routes/admin_app_routes.dart';
import 'package:epi_dash_mvp/routes/app_routes.dart';
import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "EPI Dashboard",
      // initialBinding: AppBindings(),
      getPages: [...AppRoutes.pages, ...AdminAppRoutes.pages],
      defaultTransition: Transition.noTransition,
      initialRoute: Routes.login,
      debugShowCheckedModeBanner: false,
      unknownRoute: GetPage(
        name: '/page-not-found',
        page: () => Scaffold(body: Center(child: Text("Page not found"))),
      ),
    );
  }
}
