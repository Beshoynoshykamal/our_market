import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_market/core/app_colors.dart';
import 'package:our_market/core/functions/navigate_to.dart';
import 'package:our_market/core/widgets/custom_circle_pro_ind.dart';
import 'package:our_market/core/widgets/show_msg.dart';
import 'package:our_market/views/auth/logic/cubit/authentication_cubit.dart';
import 'login_view.dart';
import 'widgets/custom_elevated_btn.dart';
import 'widgets/custom_text_form_field.dart';

class ForgotView extends StatefulWidget {
  const ForgotView({super.key});

  @override
  State<ForgotView> createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state is PasswordResetSuccess) {
          Navigator.pop(context);
          showMsg(context, "email was sent");
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is PasswordResetLoading
              ? CustomCircleProgIndicator()
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Enter Your Email To Reset Password",
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
                                  CustomEBtn(
                                    text: "Sumbit",
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        context
                                            .read<AuthenticationCubit>()
                                            .resetPassword(
                                              email: emailController.text,
                                            );
                                      }
                                    },
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
    super.dispose();
  }
}
