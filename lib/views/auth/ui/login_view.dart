import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_market/core/app_colors.dart';
import 'package:our_market/core/functions/navigate_to.dart';
import 'package:our_market/core/functions/navigate_without_back.dart';
import 'package:our_market/core/widgets/show_msg.dart';
import 'package:our_market/views/auth/logic/cubit/authentication_cubit.dart';
import 'package:our_market/views/auth/ui/forgot_view.dart';
import 'package:our_market/views/auth/ui/signup_view.dart';
import 'package:our_market/views/nav_bar/ui/main_home_view.dart';
import 'widgets/custom_row_arrow_btn.dart';
import 'widgets/custom_text_button.dart';
import 'widgets/custom_text_form_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is LoginError) {
          showMsg(context, state.message);
        }
        if (state is LoginSuccess || state is GoogleSignInSuccess) {
          navigateWithoutBack(context, MainHomeView());
        }
      },
      builder: (context, state) {
        AuthenticationCubit cubit = BlocProvider.of<AuthenticationCubit>(
          context,
        );

        return Scaffold(
          body: SafeArea(
            child: state is LoginLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Welcome to Our Market",
                            style: TextStyle(
                              fontSize: 24,
                              color: AppColors.kBlackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Card(
                            color: AppColors.kWhiteColor,
                            margin: EdgeInsets.all(24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    controller: emailController,
                                    labelText: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: 20),
                                  CustomTextFormField(
                                    controller: passwordController,
                                    labelText: 'Password',
                                    keyboardType: TextInputType.visiblePassword,
                                    isSecured: isPasswordHidden,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordHidden = !isPasswordHidden;
                                        });
                                      },
                                      icon: Icon(
                                        isPasswordHidden
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomTextButton(
                                        text: 'Forgot Password?',
                                        onTap: () {
                                          navigateTo(context, ForgotView());
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  CustomRowWithArrowBtn(
                                    text: 'Log In',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        cubit.login(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  CustomRowWithArrowBtn(
                                    text: "Log In with Google",
                                    onPressed: () async {
                                      cubit.googleSignIn();
                                    },
                                  ),
                                  SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "don't have an account?",
                                        style: TextStyle(
                                          color: AppColors.kBlackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      CustomTextButton(
                                        text: "Sign Up",
                                        onTap: () {
                                          navigateTo(
                                            context,
                                            const SignupView(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
