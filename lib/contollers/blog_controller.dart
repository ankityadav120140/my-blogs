import 'package:get/get.dart';
import 'package:my_blogs/models/blog.dart';

import '../services/DatabaseHelper.dart';

class BlogController extends GetxController {
  var isLoading = true.obs;
  var blogList = <Blog>[].obs;

  @override
  void onInit() async {
    await loadBlogs();
    super.onInit();
  }

  loadBlogs({String? category, bool? ascending}) async {
    try {
      isLoading(true);
      final dbHelper = DatabaseHelper();
      final blogs = await dbHelper.getAllBlogs(
        category: category,
        ascending: ascending,
      );
      blogList.assignAll(blogs);
    } catch (e) {
      print("EXCEPTION CAUGHT : $e");
    } finally {
      isLoading(false);
    }
  }

  deleteBlog(Blog blog) async {
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteBlog(blog.id);
      await loadBlogs();
    } catch (e) {
      print("Exception while deleting : $e");
    }
  }
}
