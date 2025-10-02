import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_market/core/app_colors.dart';
import 'package:our_market/core/widgets/show_msg.dart';
import 'package:our_market/views/auth/logic/cubit/authentication_cubit.dart';
import 'package:our_market/views/nav_bar/ui/main_home_view.dart';
import 'widgets/custom_row_arrow_btn.dart';
import 'widgets/custom_text_button.dart';
import 'widgets/custom_text_form_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is SignUpError) {
          showMsg(context, state.message);
        }
        if (state is SignUpSuccess || state is GoogleSignInSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainHomeView()),
          );
        }
      },
      builder: (context, state) {
        AuthenticationCubit cubit = BlocProvider.of<AuthenticationCubit>(
          context,
        );

        return Scaffold(
          body: SafeArea(
            child: state is SignUpLoading
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
                                    controller: nameController,
                                    labelText: "Name",
                                    keyboardType: TextInputType.name,
                                  ),
                                  SizedBox(height: 20),
                                  CustomTextFormField(
                                    controller: emailController,
                                    labelText: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: 20),
                                  CustomTextFormField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    labelText: 'Password',
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

                                  CustomRowWithArrowBtn(
                                    text: 'Sign Up',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        cubit.register(
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  CustomRowWithArrowBtn(
                                    text: "Sign Up with Google",
                                    onPressed: () {
                                      cubit.googleSignIn();
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: TextStyle(
                                          color: AppColors.kBlackColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      CustomTextButton(
                                        text: "Log In",
                                        onTap: () {
                                          Navigator.pop(context);
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
