// ignore_for_file: depend_on_referenced_packages, file_names

import 'package:my_blogs/consts/constant.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/blog.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    // final databasesPath = await getDatabasesPath();
    final databasesPath = await getApplicationDocumentsDirectory();
    final path = join(databasesPath.path, 'blog.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE blogs (
            id INTEGER PRIMARY KEY,
            image TEXT,
            title TEXT,
            category TEXT,
            content TEXT,
            author TEXT,
            datePublished TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertBlog(Blog blog) async {
    try {
      return await GLOBAL_DATABASE.insert('blogs', blog.toJson());
    } catch (e) {
      print("Exception In Insert : $e");
      return -1;
    }
  }

  Future<int> updateBlog(Blog blog) async {
    final db = GLOBAL_DATABASE;
    try {
      return await db.update(
        'blogs',
        blog.toJson(),
        where: 'id = ?',
        whereArgs: [blog.id],
      );
    } catch (e) {
      print("Exception caught in updating : $e");
      return -1;
    }
  }

  Future<int> deleteBlog(int id) async {
    return await GLOBAL_DATABASE.delete(
      'blogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Blog>> getAllBlogs({
    String? category,
    bool? ascending,
  }) async {
    final List<dynamic> whereArgs = [];
    final List<String> whereClauses = [];

    if (category != null) {
      whereClauses.add('category = ?');
      whereArgs.add(category);
    }

    final String orderByClause =
        ascending != null ? (ascending ? 'title DESC' : 'title ASC') : '';
    final String whereClause =
        whereClauses.isNotEmpty ? 'WHERE ${whereClauses.join(' AND ')}' : '';

    final String query =
        'SELECT * FROM blogs $whereClause${orderByClause.isNotEmpty ? ' ORDER BY $orderByClause' : ''}';

    final List<Map<String, dynamic>> maps =
        await GLOBAL_DATABASE.rawQuery(query, whereArgs);
    return List.generate(maps.length, (i) {
      return Blog.fromJson(maps[i]);
    });
  }
}
