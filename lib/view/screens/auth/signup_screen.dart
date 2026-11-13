import 'package:expense_tracker/services/firebase_services/firebase_auth_services.dart';
import 'package:expense_tracker/view/components/custom_button.dart';
import 'package:expense_tracker/view/components/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/Utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        // Back Button
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.colorE3E8EE),
              color: AppColors.pureWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // Create Account
                Text(
                  "Create account",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.pureBlack,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Create an account to start tracking your expenses.",
                  style: TextStyle(color: AppColors.greyColor, fontSize: 17),
                ),

                const SizedBox(height: 35),

                // Full Name
                Text(
                  "Full Name",
                  style: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                const CustomTextField(hintText: "Enter your name"),

                const SizedBox(height: 22),

                // Email
                Text(
                  "Email",
                  style: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  hintText: "you@example.com",
                  textFieldController: emailController,
                ),

                const SizedBox(height: 22),

                // Password
                Text(
                  "Password",
                  style: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  hintText: "Enter your password",
                  suffixIcon: Icons.visibility_off_outlined,
                  textFieldController: passwordController,
                ),

                const SizedBox(height: 22),

                // Confirm Password
                Text(
                  "Confirm Password",
                  style: TextStyle(
                    color: AppColors.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  hintText: "Confirm your password",
                  suffixIcon: Icons.visibility_off_outlined,
                  textFieldController: confirmpasswordController,
                ),

                const SizedBox(height: 30),

                // Sign Up Button
                CustomButton(
                  buttonText: "Sign up",
                  buttonColor: AppColors.greenColor,
                  textColor: AppColors.pureWhite,
                  // borderColor: AppColors.greenColor,

                  onButtonTap: () {
                    FirebaseAuthServices().signupWithEmailAndPassword(
                      emailAddress: emailController.text,
                      password: passwordController.text,
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Already have account
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(width: 5),

                      // Login Clickable
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: Text(
                          "Log in",
                          style: TextStyle(
                            color: AppColors.greenColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
