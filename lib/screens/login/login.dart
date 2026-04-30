import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentmanagment/screens/Home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$';

    RegExp regex = RegExp(pattern);

    return regex.hasMatch(email);
  }

  Future<void> SaveEmail() async {
    final prefs = await SharedPreferences.getInstance();

    if (emailController.text.isNotEmpty) {

      await prefs.setString("email", emailController.text);

      print("The Email Successfully saved");

    } else {
      print("The Email not saved in the Shared Prefrences");
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: Image.asset(
                      "assets/images/331497.png",
                      height: 250,
                      width: 250,
                    ),
                  ),
                ),

                const Text(
                  "Login to Continue",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // EMAIL FIELD
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),

                    validator: (value) {

                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }

                      if (!isValidEmail(value)) {
                        return "Enter valid email";
                      }

                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),

                    validator: (value) {

                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }

                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }

                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,

                    child: ElevatedButton(

                      onPressed: () async  {

                        if (formKey.currentState!.validate()) {

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                          print(emailController.text);
                          print(passwordController.text);
                        }

                       await SaveEmail();
                      },

                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),

                        backgroundColor: const Color(0xFF228B22),
                      ),

                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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