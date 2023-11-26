import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/view/login_screen.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  late final SupabaseClient _supabase;
  final _prefs = SharedPrefController.reference;
  final ConnectivityController connectivityController = Get.find();
  final GoogleSignIn googleSignInPlatform = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );
  String? firstName;
  String? lastName;
  String? id;
  ROLE? role;
  String? _token;
  String? userImage;
  late bool _connected;

  init() async {
    _setUpListener();
    if (_prefs.containsKey('token')) {
      firstName = _prefs.getString('first_name');
      lastName = _prefs.getString('last_name');
      id = _prefs.getString('user_id');
      _token = _prefs.getString('token');
      userImage = _prefs.getString('user_image');
      role = RoleUtil.fromString(_prefs.getString('role')!);
    }
    await initConnectivity();
    if (connectivityController.connected.value) {
      _supabase = Supabase.instance.client;
    }
    if (_token != null) {
      if (_connected) {
        await _supabase.auth.refreshSession();
      }
      if (role == ROLE.customer) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/recep_home');
      }
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  _setUpListener() {
    connectivityController.subscription.onData((data) {
      if (data == ConnectivityResult.wifi ||
          data == ConnectivityResult.mobile ||
          data == ConnectivityResult.ethernet) {
        _connected = true;
      } else {
        _connected = false;
      }
    });
  }

  initConnectivity() async {
    await connectivityController.initConnectivity();
    _connected = connectivityController.connected.value;
  }

  Future<AuthResponse> signUp(
      {required String email, required String password}) async {
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      tryLoggingIn(res);
      return res;
    } catch (e, _) {
      rethrow;
    }
  }

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      tryLoggingIn(res);
      return 'true';
    } catch (e) {
      String message = (e as AuthException).message;
      return message;
    }
  }

  signOut() async {
    if (_connected) {
      await _supabase.auth.signOut();
      if (await googleSignInPlatform.isSignedIn()) {
        googleSignInPlatform.signOut();
      }
      Get.offAll(() => const LoginScreen());
    } else {
      if (await googleSignInPlatform.isSignedIn()) {
        googleSignInPlatform.signOut();
      }
      _prefs.remove('role');
      _prefs.remove('user_id');
      _prefs.remove('first_name');
      _prefs.remove('last_name');
      _prefs.remove('user_image');
    }
  }

  Future<AuthResponse> googleSignIn() async {
    try {
      final googleUser = await googleSignInPlatform.signIn();
      if (googleUser == null) {
        throw 'Login Canceled';
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }
      return _signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> _signInWithIdToken(
      {required Provider provider,
      required String idToken,
      required String accessToken}) async {
    AuthResponse res = await _supabase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    await _prefs.setString(
        'user_image', res.session!.user.userMetadata!['avatar_url']);
    tryLoggingIn(res);
    return res;
  }

  tryLoggingIn(AuthResponse res) async {
    if (res.user != null) {
      await _prefs.setString('user_id', res.user!.id);
      await _prefs.setString('token', res.session!.accessToken);
      try {
        CustomerApi api = Get.find();
        await api.init();
        await api.getCustomerDetails(res.user!.id);
        if (role == ROLE.customer) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/recep_home');
        }
      } catch (e, s) {
        log('error', error: e, stackTrace: s);
        signOut();
      }
    }
  }
}
