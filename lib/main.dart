// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blogs/consts/constant.dart';
import 'package:my_blogs/contollers/blog_controller.dart';
import 'package:my_blogs/contollers/blog_form_controller.dart';
import 'package:my_blogs/services/DatabaseHelper.dart';
import 'package:my_blogs/views/pages/home.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GLOBAL_DATABASE = await DatabaseHelper.instance.database;
  Get.put(BlogController());
  Get.put(BlogFormController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'My Blogs',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: HomePage());
    });
  }
}
