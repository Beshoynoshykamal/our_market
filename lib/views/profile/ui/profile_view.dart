import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_market/core/app_colors.dart';
import 'package:our_market/core/functions/navigate_to.dart';
import 'package:our_market/core/functions/navigate_without_back.dart';
import 'package:our_market/views/auth/logic/cubit/authentication_cubit.dart';
import 'package:our_market/views/auth/logic/models/user_model.dart';
import 'package:our_market/views/auth/ui/login_view.dart';
import 'package:our_market/views/profile/ui/edit_name_view.dart';
import 'package:our_market/views/profile/ui/my_orders.dart';

import 'widgets/custom_row_btn.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit()..getUserData(),
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            navigateWithoutBack(context, LoginView());
          }
        },
        builder: (context, state) {
          UserDataModel? user = context
              .read<AuthenticationCubit>()
              .userDataModel;
          return state is LogoutLoading || state is GetUserDataLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Card(
                      color: AppColors.kWhiteColor,
                      margin: EdgeInsets.all(24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: AppColors.kPrimaryColor,
                              foregroundColor: AppColors.kWhiteColor,
                              child: Icon(Icons.person, size: 45),
                            ),
                            SizedBox(height: 10),
                            Text(
                              user?.name ?? "user name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(user?.email ?? "user email"),
                            SizedBox(height: 10),
                            CustomRowBtn(
                              onTap: () {
                                navigateTo(context, EditNameView());
                              },
                              text: 'Edit Name',
                              icon: Icons.arrow_forward_ios,
                            ),
                            SizedBox(height: 10),
                            CustomRowBtn(
                              onTap: () {
                                navigateTo(context, MyOrders());
                              },
                              text: 'My Orders',
                              icon: Icons.shopping_basket,
                            ),
                            SizedBox(height: 10),
                            CustomRowBtn(
                              onTap: () async {
                                await context
                                    .read<AuthenticationCubit>()
                                    .signout();
                              },
                              text: 'Logout',
                              icon: Icons.logout,
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
