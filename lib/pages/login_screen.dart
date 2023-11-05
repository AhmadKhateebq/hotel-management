import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/google_sign_in_button.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  final String title = 'Registration';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SupabaseAuthController authController = Get.find();
  late StreamSubscription subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var loading = false.obs;
  var showPassword = false;
  var eyeClicked = false.obs;
  var isLogin = true.obs;

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setupAuthListener() {
    subscription = authController.initWithData((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        authController.session = data.session;
        authController.user = data.session!.user;
        if (context.mounted) {
          Get.toNamed('/home');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: Get.height * (2 / 3),
                width: Get.width * (7 / 8),
                child:Obx(()=>
                loading.value ? loadingWidget() : loginForm()),
              ),
            ),
          ],
        ));
  }

  Form loginForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.asset(
                  'assets/hotel_logo.png',
                  scale: 3,
                )),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(()=>TextFormField(
              obscureText: !showPassword,
              enableSuggestions: false,
              autocorrect: false,
              controller: _passwordController,
              decoration:  InputDecoration(
                  suffixIcon: IconButton(onPressed: (){
                    showPassword = !showPassword;
                    eyeClicked.value = !eyeClicked.value;
                  }, icon: eyeClicked.value?const Icon(Icons.visibility):const Icon(Icons.visibility_off)),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white60,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              alignment: Alignment.center,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _signIn();
                  }
                },
                child:Obx(()=>
                    isLogin.value
                        ? buildText('Sign In')
                        : buildText('Register')
                ),
              ),
            ),
            const Center(child: GoogleSignInButton()),
            Container(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  isLogin.value = !isLogin.value;
                },
                child:Obx(()=>
                isLogin.value
                    ? buildText('don\'t have an account yet? Register', color: Colors.white60,fontSize: 15)
                    : buildText('do you have an account? Log in', color: Colors.white60,fontSize: 15)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return const Center(child: CircularProgressIndicator(),);
  }
  Text buildText(String text,{Color? color,double? fontSize}){
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize??20,
        color: color??Colors.black54,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _register() async {
    authController.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      loading.value = true;
    });
  }

  void _signIn() async {
    authController.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    ).then((value){
      if(value!='true'){
        loading.value = false;
        Get.snackbar(value, 'login failed');
      }
    });
    loading.value = true;
  }
}
