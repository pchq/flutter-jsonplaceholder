import 'package:flutter/material.dart';
import 'package:jsonplaceholder/core/api.dart';
import 'package:jsonplaceholder/models/post.dart';
import 'package:jsonplaceholder/models/user.dart';
import 'package:jsonplaceholder/widgets/post_preview.dart';

class PostsListPage extends StatefulWidget {
  const PostsListPage({Key? key, required this.user}) : super(key: key);

  static const routeName = '/user/posts';
  final User user;

  @override
  _PostsListPageState createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  late final User _user = widget.user;

  late Future<List<Post>?> _posts;

  @override
  void initState() {
    super.initState();
    _posts = Api.getPosts(_user.id).then((value) => value);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts of ${_user.username}')),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Post>?>(
          future: _posts,
          builder: (BuildContext context, AsyncSnapshot<List<Post>?> snapshot) {
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
                  List<Post> posts = snapshot.data!;
                  return Column(
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10.0),
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int idx) =>
                            PostPreview(post: posts[idx]),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
