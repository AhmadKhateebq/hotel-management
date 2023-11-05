import 'package:flutter/material.dart';
import 'package:hotel_managment/util/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_screen.dart';

void main() async{
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: publicAnonKey,
  );
  runApp( const MaterialApp(
    home: HomeScreen(),
  ));
}
