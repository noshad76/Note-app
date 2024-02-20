import 'package:flutter/material.dart';

import 'routes/add_route.dart';
import 'routes/home_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Map<String, Widget Function(BuildContext)> routes = {
  'initRoute': (p0) {
    return const HomeRoute();
  },
  'addRoute': (p0) {
    return const AddRoute();
  }
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'initRoute',
      routes: routes,
    );
  }
}
