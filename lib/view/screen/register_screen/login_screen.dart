import 'package:Lugowo/view/screen/register_screen/signUp_screen.dart';
import 'package:Lugowo/view/screen/welcome_screen.dart';
import 'package:Lugowo/view/widget/app_buttons.dart';
import 'package:Lugowo/view/widget/app_logo.dart';
import 'package:Lugowo/view/widget/app_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupNotificationListeners();
  }

  // Setup listener untuk notifikasi
  void _setupNotificationListeners() {
    // Kondisi foreground: mendengarkan notifikasi ketika aplikasi sedang aktif
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground notification received: ${message.notification?.title}');
      _showNotificationDialog(message.notification?.title ?? 'No Title');
    });

    // Kondisi background: mendengarkan notifikasi saat aplikasi dibuka melalui notifikasi ketika di background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Background notification opened: ${message.notification?.title}');
      _showNotificationDialog(message.notification?.title ?? 'No Title');
    });

    // Kondisi terminated: memeriksa notifikasi ketika aplikasi dibuka dari status terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('Terminated notification opened: ${message.notification?.title}');
        _showNotificationDialog(message.notification?.title ?? 'No Title');
      }
    });
  }

  // Menampilkan dialog notifikasi
  void _showNotificationDialog(String notificationTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Notification"),
        content: Text(notificationTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _loginUser() async {
    try {
      // Login logic
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Jika login berhasil, navigasi ke WelcomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Menangani error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              const AppLogo(),
              const SizedBox(height: 40),
              AppText.normalText("Welcome Back",
                  fontSize: 28, isBold: true, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              AppText.normalText("Log in to continue your journey",
                  fontSize: 16,
                  color: const Color(0xffA1A4B2),
                  textAlign: TextAlign.center),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: const Color(0xffF2F2F2),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: const Color(0xffF2F2F2),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.maxFinite,
                child: AppButtons.mainButton(
                  "Login",
                  onPressed: _loginUser,
                  buttonColor: const Color(0xff8E97FD),
                  textColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigasi ke halaman register
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: AppText.normalText(
                  "Don't have an account? Register",
                  fontSize: 14,
                  color: const Color(0xff8E97FD),
                  isBold: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
