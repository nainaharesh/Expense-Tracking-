
import 'package:expense_tracker/services/firebase_services/firebase_auth_services.dart';
import 'package:expense_tracker/utils/app_assets.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:expense_tracker/view/components/custom_button.dart';
import 'package:expense_tracker/view/components/custom_text_field.dart';
import 'package:expense_tracker/view/screens/auth/signup_screen.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main_screen/bottom_nav_screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
const LoginScreen({super.key});

@override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
bool isPasswordHidden = true;
bool isLoading = false;

final TextEditingController emailController =
TextEditingController();

final TextEditingController passwordController =
TextEditingController();

final TextEditingController nameController =
TextEditingController();

@override
void initState() {
super.initState();
initializeGoogleSignIn();
}

Future<void> initializeGoogleSignIn() async {
try {
await GoogleSignIn.instance.initialize(
serverClientId:
'227309526515-4nvaq9kk7m3vhcc3rqr8shcff117cd84.apps.googleusercontent.com',
);
} catch (e) {
debugPrint('Google Sign-In initialization error: $e');
}
}

void onEyeTapped() {
setState(() {
isPasswordHidden = !isPasswordHidden;
});
}

void navigateToHome() {
if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => const HomeScreen(),
),
);
}

Future<void> loginWithEmail() async {
if (emailController.text.trim().isEmpty ||
passwordController.text.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please enter your email and password.'),
),
);
return;
}

setState(() {
isLoading = true;
});

try {
await FirebaseAuthServices().signinWithEmailAndPassword(
emailAddress: emailController.text.trim(),
password: passwordController.text,
name: nameController.text,
);

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Login successful!'),
),
);

navigateToHome();
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Login failed: $e'),
),
);
} finally {
if (mounted) {
setState(() {
isLoading = false;
});
}
}
}

Future<void> loginWithGoogle() async {
setState(() {
isLoading = true;
});

try {
await FirebaseAuthServices().signInWithGoogle();

if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Google sign-in successful!'),
),
);

navigateToHome();
} catch (e) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text('Google sign-in failed: $e'),
),
);
} finally {
if (mounted) {
setState(() {
isLoading = false;
});
}
}
}

@override
void dispose() {
emailController.dispose();
passwordController.dispose();
nameController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: SafeArea(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 10),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const SizedBox(height: 20),
Container(
padding: const EdgeInsets.all(15),
decoration: BoxDecoration(
color: AppColors.greenColor,
borderRadius: BorderRadius.circular(15),
),
child: Image.asset(
AppAssets.walletIcon,
scale: 2,
),
),
const SizedBox(height: 20),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Welcome back',
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.w600,
fontFamily:
GoogleFonts.plusJakartaSans().fontFamily,
),
),
const SizedBox(height: 5),
Text(
'Log in to see your expenses on any device.',
style: TextStyle(
color: AppColors.greyColor,
fontSize: 15,
),
),
],
),
],
),

Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Email',
style: TextStyle(
color: AppColors.greyColor,
fontSize: 13,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 5),
CustomTextField(
hintText: 'you@yopmail.com',
textFieldController: emailController,
),
const SizedBox(height: 25),
Text(
'Password',
style: TextStyle(
color: AppColors.greyColor,
fontSize: 13,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 5),
CustomTextField(
hintText: 'Enter your password',
suffixIcon: isPasswordHidden
? Icons.visibility_off
    : Icons.remove_red_eye,
onSuffixTap: onEyeTapped,
isObscure: isPasswordHidden,
textFieldController: passwordController,
),
const SizedBox(height: 10),
Align(
alignment: Alignment.centerRight,
child: Text(
'Forgot password?',
style: TextStyle(
color: AppColors.greenColor,
fontWeight: FontWeight.bold,
fontSize: 14,
),
),
),
],
),

Column(
children: [
CustomButton(
buttonColor: AppColors.greenColor,
buttonText:
isLoading ? 'Please wait...' : 'Login',
textColor: AppColors.pureWhite,
onButtonTap:
isLoading ? null : loginWithEmail,
),
const SizedBox(height: 10),
Row(
children: [
Expanded(
child: Divider(
color: AppColors.whiteColor,
),
),
const Padding(
padding: EdgeInsets.symmetric(horizontal: 10),
child: Text('or'),
),
Expanded(
child: Divider(
color: AppColors.whiteColor,
),
),
],
),
const SizedBox(height: 10),
CustomButton(
buttonColor: AppColors.pureWhite,
buttonText: isLoading
? 'Please wait...'
    : 'Continue with Google',
textColor: AppColors.pureBlack,
onButtonTap:
isLoading ? null : loginWithGoogle,
),
],
),

Center(
child: RichText(
text: TextSpan(
text: 'New to Kharcha? ',
style: TextStyle(
color: AppColors.greyColor,
fontSize: 18,
),
children: [
TextSpan(
text: 'Create account',
style: TextStyle(
color: AppColors.greenColor,
fontWeight: FontWeight.bold,
),
recognizer: TapGestureRecognizer()
..onTap = () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) =>
const SignupScreen(),
),
);
},
),
],
),
),
),
const SizedBox(height: 10),
],
),
),
),
);
}
}
