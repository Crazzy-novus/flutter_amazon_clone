import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/custom_button.dart';
import 'package:flutter_amazon_clone/common/widget/custom_textfield.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/features/auth/services/auth_service.dart';
enum Auth {
  signIn,
  signUp,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({ super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;
  final _signupFormKey = GlobalKey<FormState>();
  final _signinFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void dispose () {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(context: context, email: _emailController.text, password: _passwordController.text, name: _nameController.text);
  }

  void signInUser() {
    authService.signInUser(context: context, email: _emailController.text, password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text( "Welcome",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                ),
                ListTile(
                  tileColor: _auth == Auth.signUp ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundColor,
                  title: const Text("Create Account",

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    leading: Radio(
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signUp,
                      groupValue: _auth,
                      onChanged: (Auth? value){
                        setState(() {
                          _auth = value!;
                        });
                      },

                    )
                ),
                if (_auth == Auth.signUp)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: GlobalVariables.backgroundColor,
                    child: Form(
                      key: _signupFormKey,
                      child: Column(
                        children: [
                          CustomTextField(controller: _emailController, hintText: "Email"),
                          const SizedBox(height: 10),
                          CustomTextField(controller: _nameController, hintText: "Name"),
                          const SizedBox(height: 10),
                          CustomTextField(controller: _passwordController, hintText: "Password"),
                          const SizedBox(height: 10),
                          CustomButton(
                              text: 'Sign Up',
                              onTap: () {
                                if (_signupFormKey.currentState!.validate()) {
                                  signUpUser();
                                }
                              }
                          )
                        ],

                      ),

                    ),
                  ),
                ListTile(
                    tileColor: _auth == Auth.signIn ? GlobalVariables.backgroundColor : GlobalVariables.greyBackgroundColor,
                    title: const Text("Sign In.",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Radio(
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signIn,
                      groupValue: _auth,
                      onChanged: (Auth? value){
                        setState(() {
                          _auth = value!;
                        });
                      },

                    )
                ),
                if (_auth == Auth.signIn)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _signinFormKey,
                    child: Column(
                      children: [
                        CustomTextField(controller: _emailController, hintText: "Email"),
                        const SizedBox(height: 10),
                        CustomTextField(controller: _passwordController, hintText: "Password"),
                        const SizedBox(height: 10),
                        CustomButton(
                            text: 'Sign In',
                            onTap: () {
                              if (_signinFormKey.currentState!.validate()) {
                                signInUser();
                              }
                            }
                        )
                      ],

                    ),

                  ),
                ),
              ]
            ),
          )
      ),

    );
  }
}
