//
//
// import 'package:flutter/material.dart';
//
// class DeepLinkHandler{
//   final BuildContext _context;
//
//   DeepLinkHandler({required BuildContext context}) : _context = context;
//   handle(String link) {
//     if (link case '/') {
//       if (_user == null) {
//         _login();
//       } else {
//         _homeScreen();
//       }
//     } else if (link case '/login') {
//       _login();
//     } else {
//       var uri = Uri.parse(link);
//       var fragment = Uri.parse(uri.fragment);
//       var queryParamaters = fragment.queryParameters;
//       String route = fragment.pathSegments[0];
//       if (route == 'preview') {
//         if (queryParamaters['uid'] != null && queryParamaters['id'] != null) {
//           var uid = (_user!.uid);
//           if (_user != null) {
//             if (uid == queryParamaters['uid']) {
//               _previewOwner(queryParamaters['id']!);
//             } else {
//               _previewLoggedIn(fragment.toString());
//             }
//           } else {
//             _previewVisitor(uri.toString());
//           }
//         } else {
//           if (_user != null) {
//             _homeScreen();
//           } else {
//             _login();
//           }
//         }
//       }
//     }
//   }
//   _login() => Navigator.pushReplacementNamed(_context, '/login');
// }