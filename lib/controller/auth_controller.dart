import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hotel_management/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthController extends GetxController{
  final _supabase = Supabase.instance.client;
  User? user;
  Session? session;
  late final StreamSubscription _authSubscription;
  init(){
    a(AuthState data) {
      final AuthChangeEvent event = data.event;
      session = data.session;
      log(event.toString(),name: 'event');
    }
    _authSubscription = _supabase.auth.onAuthStateChange.listen(a);
  }
  StreamSubscription<AuthState>initWithData(void Function(AuthState) onData){
    // _authSubscription =
        return _supabase.auth.onAuthStateChange.listen(onData);
  }
  endSubscription(){
    _authSubscription.cancel();
  }
  resumeSubscription(){
    _authSubscription.resume();
  }
  pauseSubscription(){
    _authSubscription.pause();
  }
  signUp({required String email, required String password}) async {
    final AuthResponse res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    session = res.session;
    user = res.user;

  }
  Future<String> signIn({required String email,required String password}) async {
    try{
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      session = res.session;
      user = res.user;
      return 'true';
    }catch(e,s){
      String message = (e as AuthException).message;
      print(message);
      return message;
    }
  }
  signInWithOtp(String email) async {
    await _supabase.auth.signInWithOtp(
      email: email,
      emailRedirectTo: kIsWeb ? null : 'io.supabase.flutter://signin-callback/',
    );
    session = _supabase.auth.currentSession;
    user = _supabase.auth.currentUser;
  }
  signInWithGoogle(BuildContext context) async {
    await _supabase.auth.signInWithOAuth(Provider.google,context: context,authScreenLaunchMode: LaunchMode.inAppWebView);
  }
  signOut() async {
    await _supabase.auth.signOut();
  }
  Future<AuthResponse> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
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
  }


  Future<AuthResponse> signInWithIdToken({required Provider provider, required String idToken, required String accessToken}) async {
    AuthResponse res =  await _supabase.auth.signInWithIdToken(
      provider: Provider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    session = res.session;
    user = res.user;
    return res;
  }
}