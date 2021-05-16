import 'package:get/get.dart';

import 'package:raptsociety/app/modules/auth/bindings/auth_binding.dart';
import 'package:raptsociety/app/modules/auth/views/auth_view.dart';
import 'package:raptsociety/app/modules/home/bindings/home_binding.dart';
import 'package:raptsociety/app/modules/home/views/home_view.dart';
import 'package:raptsociety/app/modules/login/bindings/login_binding.dart';
import 'package:raptsociety/app/modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AUTH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
  ];
}
