import 'package:Lugowo/view/widget/app_buttons.dart';
import 'package:Lugowo/view/widget/app_logo.dart';
import 'package:Lugowo/view/widget/app_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Firebase Messaging Instance
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // Inisialisasi notifikasi Firebase
    setupFirebaseMessaging();
  }

  // Setup Firebase Messaging for Foreground, Background, and Terminated states
  void setupFirebaseMessaging() {
    // Handle Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showForegroundNotification(message.notification!.title, message.notification!.body);
      }
    });

    // Handle when the app is opened from the background or terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageOnAppOpen(message);
    });

    // Handle when the app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessageOnAppOpen(message);
      }
    });
  }

  // Menampilkan notifikasi saat aplikasi dalam kondisi foreground
  void _showForegroundNotification(String? title, String? body) {
    if (title != null && body != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$title: $body"),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.blueAccent,
        ),
      );
    }
  }

  // Menangani pesan saat aplikasi dibuka dari notifikasi
  void _handleMessageOnAppOpen(RemoteMessage message) {
    if (message.notification != null) {
      String? title = message.notification?.title;
      String? body = message.notification?.body;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title ?? "No Title"),
          content: Text(body ?? "No Content"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  // Fungsi untuk mendaftar pengguna baru
  void _registerUser(BuildContext context) async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        // Mendaftar pengguna baru dengan email dan password
        await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        // Menampilkan snackbar jika registrasi berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        // Navigasi kembali ke halaman login atau halaman lain
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Menangani error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
    } else {
      // Menampilkan pesan jika password tidak sama
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const AppLogo(),
                const SizedBox(height: 30),
                AppText.normalText(
                  "Create Account", 
                  fontSize: 28, 
                  isBold: true, 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 10),
                AppText.normalText(
                  "Sign up to get started", 
                  fontSize: 16, 
                  color: const Color(0xffA1A4B2), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xffF2F2F2),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xffF2F2F2),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: const Color(0xffF2F2F2),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.maxFinite,
                  child: AppButtons.mainButton(
                    "Daftar Sekarang",
                    onPressed: () => _registerUser(context),
                    buttonColor: const Color(0xff8E97FD),
                    textColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigasi kembali ke halaman login
                    Navigator.pop(context);
                  },
                  child: AppText.normalText(
                    "Already have an account? Log In", 
                    fontSize: 14, 
                    color: const Color(0xff8E97FD), 
                    isBold: true
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
