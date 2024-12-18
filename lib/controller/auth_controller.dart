import 'package:Lugowo/view/screen/register_screen/login_screen.dart';
import 'package:Lugowo/view/screen/register_screen/signUp_screen.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Untuk mengelola navigasi
  void goToLogin() {
    Get.to(() => LoginScreen());
  }

  void goToRegister() {
    Get.to(() => const RegisterScreen());
  }
}
