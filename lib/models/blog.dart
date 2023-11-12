class Blog {
  final int id;
  final String image;
  final String title;
  final String category;
  final String content;
  final String author;
  final String datePublished;

  Blog({
    required this.id,
    required this.image,
    required this.title,
    required this.category,
    required this.content,
    required this.author,
    required this.datePublished,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      datePublished: DateTime.parse(json['datePublished'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'datePublished': datePublished,
      'image': image,
      'category': category,
    };
  }
}
