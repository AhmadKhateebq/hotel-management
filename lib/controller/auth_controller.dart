import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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
  initWithData(void Function(AuthState) onData){
    _authSubscription = _supabase.auth.onAuthStateChange.listen(onData);
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
  signUp(String email,String password) async {
    final AuthResponse res = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    session = res.session;
    user = res.user;
  }
  signIn(String email,String password) async {
    final AuthResponse res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    session = res.session;
    user = res.user;
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
    await _supabase.auth.signInWithOAuth(Provider.google,context: context);
  }
  signOut() async {
    await _supabase.auth.signOut();
  }
}