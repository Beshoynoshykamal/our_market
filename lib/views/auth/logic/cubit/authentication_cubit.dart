import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:our_market/views/auth/logic/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());
  SupabaseClient clint = Supabase.instance.client;
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await clint.auth.signInWithPassword(password: password, email: email);
      await getUserData();
      emit(LoginSuccess());
    } on AuthException catch (e) {
      emit(LoginError(e.message));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());
    try {
      await clint.auth.signUp(password: password, email: email);
      await addUserData(name: name, email: email);
      await getUserData();
      emit(SignUpSuccess());
    } on AuthException catch (e) {
      emit(SignUpError(e.message));
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }

  GoogleSignInAccount? googleUser;
  // Future<AuthResponse> googleSignIn() async {
  //   emit(GoogleSignInLoading());
  //  const webClientId = '508901185106-idcpk7pv2n9utm62r7tao4bv9ocv0m9d.apps.googleusercontent.com';

  //   final GoogleSignIn googleSignIn =GoogleSignIn(
  //       scopes: ['email', 'profile'],
  //       serverClientId: webClientId,
  //    );

  //    googleUser = await googleSignIn.signIn();
  //    if(googleUser==null){
  //      return AuthResponse();
  //    }
  //   final googleAuth = await googleUser!.authentication;
  //   final accessToken = googleAuth.accessToken;
  //   final idToken = googleAuth.idToken;

  //   if (accessToken == null ||idToken == null) {
  //     emit(GoogleSignInError());
  //     return AuthResponse();
  //   }

  //   AuthResponse response = await clint.auth.signInWithIdToken(
  //     provider: OAuthProvider.google,
  //     idToken: idToken,
  //     accessToken: accessToken,
  //   );
  //   emit(GoogleSignInSuccess());
  //   return response;
  // }
  Future<AuthResponse?> googleSignIn() async {
    emit(GoogleSignInLoading());

    const String webClientId =
        '508901185106-idcpk7pv2n9utm62r7tao4bv9ocv0m9d.apps.googleusercontent.com';

    try {
      //  final GoogleSignIn googleSignIn = GoogleSignIn(
      //     scopes: ['email', 'profile'],
      //     serverClientId: webClientId,
      //   );
      //   final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(GoogleSignInError());
        return null; // user cancelled
      }
      final googleAuth = await googleUser!.authentication;
      //  final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      //  if (accessToken == null || idToken == null) {
      //       emit(GoogleSignInError());
      //       return null;
      //     }

      // final response = await clint.auth.signInWithIdToken(
      //   provider: OAuthProvider.google,
      //   idToken: idToken,
      //   accessToken: accessToken,
      // );
      await addUserData(
        name: googleUser!.displayName!,
        email: googleUser!.email,
      );
      await getUserData();
      emit(GoogleSignInSuccess());
      // return response;
    } catch (e) {
      emit(GoogleSignInError());
      rethrow;
    }
  }

  Future<void> signout() async {
    emit(LogoutLoading());
    try {
      clint.auth.signOut();
      emit(LogoutSuccess());
    } catch (e) {
      log(e.toString());
      emit(LogoutError());
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(PasswordResetLoading());
    try {
      await clint.auth.resetPasswordForEmail(email);
      emit(PasswordResetSuccess());
    } catch (e) {
      log(e.toString());
      emit(PasswordResetError());
    }
  }

  Future<void> addUserData({
    required String name,
    required String email,
  }) async {
    emit(UserDataAddedLoading());
    try {
      await clint.from('users').upsert({
        'name': name,
        'email': email,
        "user_id": clint.auth.currentUser!.id,
      });
      emit(UserDataAddedSuccess());
    } catch (e) {
      log(e.toString());
      emit(UserDataAddedError());
    }
  }

  UserDataModel? userDataModel;
  Future<void> getUserData() async {
    emit(GetUserDataLoading());
    try {
      final data = await clint
          .from('users')
          .select()
          .eq('user_id', clint.auth.currentUser!.id);

      userDataModel = UserDataModel(
        email: data[0]['email'],
        name: data[0]['name'],
        userId: data[0]['user_id'],
      );

      emit(GetUserDataSuccess());
    } catch (e) {
      log(e.toString());
      emit(GetUserDataError());
    }
  }
}
