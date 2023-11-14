import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view_model/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginViewModel viewModel = LoginViewModel();

  @override
  void initState() {
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    viewModel.loading.value = false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              ClipRect(
                  child: Image.asset(
                'assets/st_barth.jpg',
                fit: BoxFit.fill,
                height: Get.height / 4,
                width: Get.width,
              )),
              ClipRect(
                  child: Image.asset(
                'assets/maldives.jpg',
                fit: BoxFit.fill,
                height: Get.height / 4,
                width: Get.width,
              )),
              ClipRect(
                  child: Image.asset(
                'assets/thailand.jpg',
                fit: BoxFit.fill,
                height: Get.height / 4,
                width: Get.width,
              )),
              ClipRect(
                  child: Image.asset(
                'assets/thailand.jpg',
                fit: BoxFit.fill,
                height: Get.height / 4,
                width: Get.width,
              )),
            ],
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 2),
                  color: Colors.redAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              height: Get.height * (2 / 3) + 10,
              width: Get.width * (7 / 8),
              child: Obx(() =>
                  viewModel.loading.value ? loadingWidget() : loginForm()),
            ),
          ),
        ],
      ));

  Form loginForm() => Form(
        key: viewModel.formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.asset(
                'assets/image/hotel_logo.png',
                scale: 3,
              )),
               Divider(
                thickness: 1,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: viewModel.emailController,
                decoration:  const InputDecoration(
                    floatingLabelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.white60,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                validator:viewModel.validateEmail

              ),
              const SizedBox(
                height: 10,
              ),
              Obx(() => TextFormField(
                    obscureText: !viewModel.eyeClicked.value,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: viewModel.passwordController,
                    decoration: InputDecoration(
                        floatingLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        suffixIcon: IconButton(
                            onPressed: viewModel.clickEye,
                            icon: viewModel.eyeClicked.value
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white60,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                    validator: viewModel.validatePassword,
                  )),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                alignment: Alignment.center,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: viewModel.loginButtonOnAction,
                  child: Obx(() => viewModel.isLogin.value
                      ? buildText('Sign In')
                      : buildText('Register')),
                ),
              ),
              Center(child: viewModel.button),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: viewModel.switchState,
                  child: Obx(() => viewModel.isLogin.value
                      ? buildText('don\'t have an account yet? Register',
                          color: Colors.white60, fontSize: 15)
                      : buildText('do you have an account? Log in',
                          color: Colors.white60, fontSize: 15)),
                ),
              )
            ],
          ),
        ),
      );

  Widget loadingWidget() => const Center(
        child: CircularProgressIndicator(),
      );

  Text buildText(String text, {Color? color, double? fontSize}) => Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 20,
          color: color ?? Colors.black54,
          fontWeight: FontWeight.w600,
        ),
      );
}
