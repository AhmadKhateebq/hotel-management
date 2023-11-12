import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/view/components/google_sign_in_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginViewModel {
  final SupabaseAuthController authController = Get.find();
  final GoogleSignInButton button = GoogleSignInButton();
  final CustomerApi api = CustomerApi();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var loading = false.obs;
  var eyeClicked = false.obs;
  var isLogin = true.obs;

  StreamSubscription<AuthState> setSubscription(
      void Function(AuthState) onData) {
    return authController.setSubscription(onData);
  }

  void setupAuthListener() {
    try {
      authController.setUpSubscription();
    } catch (e,s) {
      log('error',error: e,stackTrace: s);
      button.rebuild();
      authController.signOut();
      rethrow;
    }
  }

  void register() async {
    await authController.signUp(
      email: emailController.text,
      password: passwordController.text,
    );
  }

  void signIn() async {
    authController
        .signIn(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((value) {
      if (value != 'true') {
        Get.snackbar(value, 'login failed');
      }
    });
  }

  void clickEye() {
    eyeClicked.value = !eyeClicked.value;
  }

  void loginButtonOnAction() async {
    if (formKey.currentState!.validate()) {
      loading.value = true;
      if (isLogin.value) {
        signIn();
      } else {
        register();
      }
    }
  }

  void switchState() {
    isLogin.value = !isLogin.value;
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
