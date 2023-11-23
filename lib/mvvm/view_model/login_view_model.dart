import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/mvvm/view/components/google_sign_in_button.dart';

class LoginViewModel {
  final SupabaseAuthController authController = Get.find();
  GoogleSignInButton button = const GoogleSignInButton();
  final CustomerRepository api= Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var loading = false.obs;
  var eyeClicked = false.obs;
  var isLogin = true.obs;

  void setupAuthListener() {
    try {
      authController.setUpSubscription();
    } catch (e, s) {
      log('error', error: e, stackTrace: s);
      button = const GoogleSignInButton();
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
        authController.signOut();
        loading.value = false;
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

  init() {
    loading.value = false;
    setupAuthListener();
  }

  bool validEmail(String value) {
    return
    RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  String? validateEmail(String? value) {
      if (value == null || value.isEmpty ) {
        return 'Please enter a some textl';
      }
      if( !validEmail(value)){
        return 'Please enter a valid email';
      }
      return null;

  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a some text';
    }
    if(value.length <8) {
      return 'Please Enter a Valid Password';
    }
    return null;
  }
}
