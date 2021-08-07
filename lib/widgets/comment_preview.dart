import 'package:flutter/material.dart';
import 'package:jsonplaceholder/models/comment.dart';

class CommentPreview extends StatelessWidget {
  const CommentPreview({Key? key, required this.comment}) : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[800],
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.format_quote,
                  size: 36,
                ),
                Expanded(
                  child: Text(
                    comment.body,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    comment.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    comment.email,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
