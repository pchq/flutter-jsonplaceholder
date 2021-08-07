import 'package:flutter/material.dart';
import 'package:jsonplaceholder/models/post.dart';
import 'package:jsonplaceholder/pages/post_page.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostPage(post: post),
          ),
        );
      },
      child: Card(
        color: Colors.grey[800],
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                post.previewText,
                style: const TextStyle(
                  height: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
