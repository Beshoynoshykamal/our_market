import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:our_market/core/my_observer.dart';
import 'package:our_market/core/sensitive_data.dart';
import 'package:our_market/views/auth/logic/cubit/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:our_market/views/nav_bar/ui/main_home_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app_colors.dart';
import 'views/auth/ui/login_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gzuuzhyazixrjrvqusfk.supabase.co',
    anonKey: anonKey,
  );
  Bloc.observer = MyObserver();
  runApp(const OurMarket());
}

class OurMarket extends StatelessWidget {
  const OurMarket({super.key});

  @override
  Widget build(BuildContext context) {
    SupabaseClient clint = Supabase.instance.client;
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.kScaffoldColor,
          useMaterial3: true,
        ),

        home: clint.auth.currentUser != null ? MainHomeView() : LoginView(),
      ),
    );
  }
}
