// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blogs/consts/categories.dart';
import 'package:my_blogs/contollers/blog_controller.dart';
import 'package:sizer/sizer.dart';

Widget SortFilterTile() {
  BlogController blogController = Get.find();
  String? selectedCategory;
  bool? ascending;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        width: 40.w,
        child: ElevatedButton(
          onPressed: () {
            Get.bottomSheet(
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.category_rounded),
                      title: Text("All"),
                      onTap: () {
                        selectedCategory = null;
                        Get.back();
                        blogController.loadBlogs(ascending: ascending);
                      },
                    ),
                    Container(
                      height: 80.h,
                      child: ListView.builder(
                          itemCount: CATEGORIES.length,
                          itemBuilder: (contex, index) {
                            return ListTile(
                              leading: Icon(Icons.category),
                              title: Text(CATEGORIES[index]),
                              onTap: () {
                                selectedCategory = CATEGORIES[index];
                                Get.back();
                                blogController.loadBlogs(
                                    ascending: ascending,
                                    category: CATEGORIES[index]);
                              },
                            );
                          }),
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(
            Icons.filter_alt,
            size: 25.sp,
          ),
        ),
      ),
      Container(
        width: 40.w,
        child: ElevatedButton(
          onPressed: () {
            Get.bottomSheet(
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.arrow_upward),
                      title: Text("A - Z"),
                      onTap: () {
                        ascending = true;
                        Get.back();
                        blogController.loadBlogs(
                          category: selectedCategory,
                          ascending: true,
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.arrow_downward),
                      title: Text("Z - A"),
                      onTap: () {
                        ascending = false;
                        Get.back();
                        blogController.loadBlogs(
                          category: selectedCategory,
                          ascending: false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(
            Icons.sort,
            size: 25.sp,
          ),
        ),
      )
    ],
  );
}
