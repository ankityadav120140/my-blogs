// ignore_for_file: must_be_immutable, prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blogs/contollers/blog_controller.dart';
import 'package:my_blogs/views/pages/blog_form.dart';
import 'package:sizer/sizer.dart';

import '../../utils/dateTimeFormatter.dart';

class BlogPage extends StatefulWidget {
  BlogPage({required this.blogIndex, super.key});

  int blogIndex;

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final BlogController blogController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(blogController.blogList[widget.blogIndex].title),
          actions: [
            IconButton(
              onPressed: () async {
                await blogController
                    .deleteBlog(blogController.blogList[widget.blogIndex]);
                Get.back();
              },
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {
                Get.to(BlogFormPage(
                  isEditing: true,
                  blog: blogController.blogList[widget.blogIndex],
                ));
              },
              icon: Icon(Icons.edit),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(1.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: blogController.blogList[widget.blogIndex].image != ""
                      ? Image(
                          image: FileImage(File(
                              blogController.blogList[widget.blogIndex].image)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                Container(
                  padding: EdgeInsets.all(5.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: double.infinity),
                      Text(
                        blogController.blogList[widget.blogIndex].title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        blogController.blogList[widget.blogIndex].category,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "~${blogController.blogList[widget.blogIndex].author}",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            "Published on : ${formattedDateTime(blogController.blogList[widget.blogIndex].datePublished)}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        blogController.blogList[widget.blogIndex].content,
                        style: TextStyle(fontSize: 13.sp),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
