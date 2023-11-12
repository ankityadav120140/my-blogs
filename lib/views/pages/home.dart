// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blogs/contollers/blog_controller.dart';
import 'package:my_blogs/views/pages/blog_form.dart';
import 'package:my_blogs/views/widgets/sort_filter_tile.dart';
import 'package:sizer/sizer.dart';

import '../../contollers/blog_form_controller.dart';
import '../widgets/blog_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BlogController blogController = Get.find();
  final BlogFormController blogFormController = Get.find();

  @override
  void initState() {
    blogFormController.image.value = "";
    blogFormController.selectedCategory.value = "Personal";
    blogController.loadBlogs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Blogs"),
        elevation: 1.h,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 5.h),
          child: SortFilterTile(),
        ),
      ),
      body: Obx(() {
        if (blogController.isLoading.isTrue) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (blogController.blogList.isEmpty) {
          return Center(
            child: Text("No Blog Found"),
          );
        } else {
          return Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 10.h),
              shrinkWrap: true,
              reverse: true,
              itemCount: blogController.blogList.length,
              itemBuilder: (context, index) {
                return BlogTile(blogController.blogList[index], index);
              },
            ),
          );
        }
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(BlogFormPage());
        },
        label: Row(
          children: [
            Icon(
              Icons.add,
              size: 25.sp,
            ),
            Text("Add New Blog")
          ],
        ),
      ),
    );
  }
}
