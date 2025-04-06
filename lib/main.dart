import 'package:flutter/material.dart';
import 'app.dart';
import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.init();
  runApp(const MyApp());
}

