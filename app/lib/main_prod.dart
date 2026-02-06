import 'package:skeleton_app/common/config.dart';
import 'package:skeleton_app/app.dart';
import 'package:skeleton_app/initialize.dart';
import 'package:flutter/material.dart';

void main() async {
  Config.setEnvironment(Environment.prod);

  await initializeApp();

  runApp(const MyApp());
}
