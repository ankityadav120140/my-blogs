// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blogs/views/pages/blog_page.dart';
import 'package:sizer/sizer.dart';

import '../../models/blog.dart';

Widget BlogTile(Blog blog, int index) {
  return InkWell(
    onTap: () {
      Get.to(BlogPage(
        blogIndex: index,
      ));
    },
    child: Container(
      padding: EdgeInsets.all(1.w),
      width: double.infinity,
      height: 20.h,
      child: Stack(
        children: [
          blog.image != ""
              ? Container(
                  width: double.infinity,
                  height: 20.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(blog.image),
                      ),
                    ),
                  ),
                )
              : Container(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter,
                  stops: [
                    0,
                    0.9,
                  ],
                  colors: [
                    Colors.black12,
                    Colors.black,
                  ]),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  blog.category,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  blog.author,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
