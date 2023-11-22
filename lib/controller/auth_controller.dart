import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotel_management/mvvm/model/login_user_model.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthController extends GetxController {
  late final SupabaseClient _supabase;
  User? _currentUser;
  var initUser = false.obs;
  bool _online = true;

  // Session? session;
  LoginUser loginUser = LoginUser();

  SupabaseAuthController.online() {
    _supabase = Supabase.instance.client;
    _currentUser = _supabase.auth.currentUser;
    _online = true;
  }

  SupabaseAuthController.offline() {
    // _supabase = Supabase.instance.client;
    _online = false;
  }

  late final StreamSubscription _authSubscription;
  final GoogleSignIn googleSignInPlatform = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: webClientId,
  );

  User? currentUser() {
    return _currentUser;
  }

  init() {
    // databaseController  = Get.find();
  }

  getUserData() {
    if (kDebugMode) {
      print(_online);
    }
    if (_online) {
      loginUser.user = _supabase.auth.currentUser;
      loginUser.profileImageUrl = loginUser.user!.userMetadata?['avatar_url'] !=
              null
          ? loginUser.user!.userMetadata!['avatar_url']
          : loginUser.currentCustomerDetails.pictureUrl ??
              'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG-Free-Download.png';
      loginUser.fullName = loginUser.user!.userMetadata?['full_name'] != null
          ? loginUser.user!.userMetadata!['full_name']
          : '${loginUser.currentCustomerDetails.firstName} ${loginUser.currentCustomerDetails.lastName}';
      loginUser.role = loginUser.role;
      _currentUser = _supabase.auth.currentUser;
    } else {
      _currentUser = null;
    }
  }

  setSubscriptionLog() {
    a(AuthState data) {
      final AuthChangeEvent event = data.event;
      // session = data.session;
      log(event.toString(), name: 'event');
    }

    _authSubscription = _supabase.auth.onAuthStateChange.listen(a);
  }

  StreamSubscription<AuthState> setSubscription(
      void Function(AuthState) onData) {
    // _authSubscription =
    return _supabase.auth.onAuthStateChange.listen(onData);
  }

  setUpSubscription() {
    if (_online) {
      if (_supabase.auth.currentUser != null) {
        initUser.value = true;
      }
      // _authSubscription =
      _supabase.auth.onAuthStateChange.listen((data) async {
        if (kDebugMode) {
          print(data.toString());
        }
        final event = data.event;
        if (event == AuthChangeEvent.signedIn) {
          // session = data.session;
          loginUser.user = data.session!.user;
          if (Get.context!.mounted) {
            try {
              await Get.find<CustomerRepository>()
                  .getCustomerDetails(loginUser.user!.id);
            } catch (e) {
              rethrow;
            }
          }
        }
      }, onError: (error, stackTrace) {
        log('error', error: error, stackTrace: stackTrace);
        signOut();
      });
    }
  }

  endSubscription() {
    _authSubscription.cancel();
  }

  resumeSubscription() {
    _authSubscription.resume();
  }

  pauseSubscription() {
    _authSubscription.pause();
  }

  Future<AuthResponse> signUp(
      {required String email, required String password}) async {
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      // session = res.session;
      loginUser.user = res.user;
      return res;
    } catch (e, s) {
      log(e.toString(), name: s.toString());
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
      // session = res.session;
      loginUser.user = res.user;
      return 'true';
    } catch (e) {
      String message = (e as AuthException).message;
      log('', error: message);
      return message;
    }
  }

  signInWithOtp(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: kIsWeb ? null : 'io.supabase.flutter://signin-callback/',
    );
    // session = _supabase.auth.currentSession;
    loginUser.user = _supabase.auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    await _supabase.auth.signInWithOAuth(Provider.google,
        context: context, authScreenLaunchMode: LaunchMode.inAppWebView);
  }

  signOut() async {
    if (_online) {
      await _supabase.auth.signOut();
      if (await googleSignInPlatform.isSignedIn()) {
        googleSignInPlatform.signOut();
      }
      loginUser.logout();
      initUser = false.obs;
      Get.offAllNamed('/login');
    } else {
      if (await googleSignInPlatform.isSignedIn()) {
        googleSignInPlatform.signOut();
      }
      loginUser.logout();
      initUser = false.obs;
      Get.find<CustomerRepository>().signOut();
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
      return signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> signInWithIdToken(
      {required Provider provider,
      required String idToken,
      required String accessToken}) async {
    AuthResponse res = await _supabase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    // session = res.session;
    loginUser.user = res.user;
    return res;
  }

  void cancelSubscription() {
    _authSubscription.cancel();
  }
}
