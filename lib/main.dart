// All the import statement starts

import 'package:chime/app.dart';
import 'package:chime/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// All the important statement ends

//Main entry point of the Chime App

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AuthViewModel(), child: App()));
}
