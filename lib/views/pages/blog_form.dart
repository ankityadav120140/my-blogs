// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_blogs/consts/categories.dart';
import 'package:my_blogs/contollers/blog_controller.dart';
import 'package:my_blogs/contollers/blog_form_controller.dart';
import 'package:my_blogs/models/blog.dart';
import 'package:my_blogs/utils/pick_image.dart';
import 'package:sizer/sizer.dart';
import '../../services/DatabaseHelper.dart';
import '../../utils/uniqueIDGenerator.dart';

class BlogFormPage extends StatefulWidget {
  BlogFormPage({this.isEditing, this.blog, super.key});
  bool? isEditing = false;
  Blog? blog;

  @override
  State<BlogFormPage> createState() => _BlogFormPageState();
}

class _BlogFormPageState extends State<BlogFormPage> {
  final BlogFormController blogFormController = Get.find();
  final BlogController blogController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int id = 0;
  @override
  void initState() {
    if (widget.isEditing == true) {
      id = generateUniqueId();
      titleController.text = widget.blog!.title;
      blogFormController.selectedCategory.value = widget.blog!.category;
      contentController.text = widget.blog!.content;
      blogFormController.image.value = widget.blog!.image;
    } else {
      blogFormController.image.value = "";
      blogFormController.selectedCategory.value = "Personal";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: widget.isEditing != true
            ? Text("Write Blog")
            : Text("Edit Your Blog"),
      ),
      body: blogFormController.isLoading.isTrue
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 2.h),
                  Text(
                    "Saving!",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(1.w),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    Obx(
                      () {
                        if (blogFormController.image.isEmpty) {
                          return InkWell(
                            onTap: () async {
                              pickImage(id, (localImage) {
                                if (localImage != null) {
                                  blogFormController.image.value = localImage;
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 100.w,
                              height: 30.h,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50.sp,
                              ),
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () async {
                              pickImage(id, (String? imagePath) {
                                if (imagePath != null && imagePath.isNotEmpty) {
                                  blogFormController.image.value = imagePath;
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 100.w,
                              height: 30.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: FileImage(
                                    File(blogFormController.image.toString()),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter blog title';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Title'),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Select Category',
                            style: TextStyle(fontSize: 15.sp),
                          ),
                          SizedBox(height: 2.h),
                          Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: DropdownButton<String>(
                                  iconSize: 30.sp,
                                  isExpanded: true,
                                  value:
                                      blogFormController.selectedCategory.value,
                                  items: CATEGORIES.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Center(
                                          child: Text(
                                        item,
                                        style: TextStyle(fontSize: 15.sp),
                                      )),
                                    );
                                  }).toList(),
                                  onChanged: (String? selectedItem) {
                                    blogFormController.selectedCategory.value =
                                        selectedItem!;
                                  },
                                ),
                              ),
                            );
                          }),
                          TextFormField(
                            controller: contentController,
                            minLines: 1,
                            maxLines: 3,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please write your blog here!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Content'),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                String title =
                                    titleController.text.capitalize ?? "";
                                String category =
                                    blogFormController.selectedCategory.value;
                                String content = contentController.text;
                                Blog blog = Blog(
                                  id: widget.isEditing == true
                                      ? widget.blog!.id
                                      : generateUniqueId(),
                                  image: blogFormController.image.toString(),
                                  title: title,
                                  category: category,
                                  content: content,
                                  author: "You",
                                  datePublished: widget.isEditing == true
                                      ? widget.blog!.datePublished
                                      : DateTime.now().toString(),
                                );
                                var dbHelper = DatabaseHelper.instance;
                                if (widget.isEditing == true) {
                                  await dbHelper
                                      .updateBlog(blog)
                                      .then((result) async {
                                    print("RESULT : $result");
                                    if (result != -1) {
                                      blogController.loadBlogs();
                                      Get.back();
                                    }
                                  });
                                } else {
                                  await dbHelper.insertBlog(blog).then(
                                    (result) async {
                                      print("RESULT : $result");
                                      if (result != -1) {
                                        blogFormController.isLoading(true);
                                        await blogController.loadBlogs();
                                        blogFormController.isLoading(false);
                                        Get.back();
                                      } else {
                                        Get.snackbar(
                                          "Erron In Saving",
                                          "Please Retry",
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    },
                                  );
                                }
                              }
                            },
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
