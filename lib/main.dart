// All the import statement starts
import 'package:chime/app/app.dart';
import 'package:chime/app/service_locator/service_locator.dart';
import 'package:flutter/material.dart';

//Main entry point of the Chime App
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(App());
}
