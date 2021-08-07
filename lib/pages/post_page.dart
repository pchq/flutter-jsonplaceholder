import 'package:flutter/material.dart';
import 'package:jsonplaceholder/config.dart';
import 'package:jsonplaceholder/core/api.dart';
import 'package:jsonplaceholder/models/comment.dart';
import 'package:jsonplaceholder/models/post.dart';
import 'package:jsonplaceholder/widgets/comment_preview.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key, required this.post}) : super(key: key);

  static const routeName = '/post';
  final Post post;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final Post _post = widget.post;
  late Future<List<Comment>?> _comments;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _comments = Api.getComments(_post.id).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_post.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    _post.title,
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    _post.body,
                    style: const TextStyle(
                      height: 2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              color: Colors.grey[900],
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FutureBuilder<List<Comment>?>(
                future: _comments,
                builder: (BuildContext context, AsyncSnapshot<List<Comment>?> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        List<Comment> comments = snapshot.data!;
                        return Column(
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(10.0),
                              itemCount: comments.length,
                              itemBuilder: (BuildContext context, int idx) =>
                                  CommentPreview(comment: comments[idx]),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                _showModalBottomSheet(context);
                              },
                              icon: const Icon(Icons.add_comment),
                              label: const Text('Add comment'),
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModalBottomSheet(context) {
    Map<String, dynamic> newCommentData = {'postId': _post.id};

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Config.firmColor,
                    ),
                    labelText: 'Name',
                  ),
                  validator: (String? value) {
                    return value == '' ? 'Required field' : null;
                  },
                  onSaved: (newValue) {
                    newCommentData.addAll({'name': newValue.toString()});
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Config.firmColor,
                    ),
                    labelText: 'Email',
                  ),
                  validator: (String? value) {
                    return (value == null || !value.contains('@')) ? 'Required field' : null;
                  },
                  onSaved: (newValue) {
                    newCommentData.addAll({'email': newValue.toString()});
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.comment,
                      color: Config.firmColor,
                    ),
                    labelText: 'Comment',
                  ),
                  minLines: 3,
                  maxLines: 3,
                  validator: (String? value) {
                    return value == '' ? 'Required field' : null;
                  },
                  onSaved: (newValue) {
                    newCommentData.addAll({'body': newValue.toString()});
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() {
                        _comments = Api.addComment(newCommentData).then((value) => value);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
