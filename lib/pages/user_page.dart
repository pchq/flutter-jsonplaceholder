import 'package:flutter/material.dart';
import 'package:jsonplaceholder/core/api.dart';
import 'package:jsonplaceholder/models/album.dart';
import 'package:jsonplaceholder/models/post.dart';
import 'package:jsonplaceholder/models/user.dart';
import 'package:jsonplaceholder/pages/posts_list_page.dart';
import 'package:jsonplaceholder/widgets/album_preview.dart';
import 'package:jsonplaceholder/widgets/post_preview.dart';

import 'albums_list_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.user}) : super(key: key);

  static const routeName = '/user';
  final User user;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late final User _user = widget.user;

  late Future<List<Post>?> _posts;
  late Future<List<Album>?> _albums;

  @override
  void initState() {
    super.initState();
    _posts = Api.getPosts(_user.id).then((value) => value);
    _albums = Api.getAlbums(_user.id).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_user.username)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              _user.name,
              style: const TextStyle(
                fontSize: 28,
                height: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(_user.email),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(_user.phone),
            ),
            ListTile(
              leading: const Icon(Icons.alternate_email),
              title: Text(_user.website),
            ),
            ListTile(
              leading: const Icon(Icons.phone_android),
              title: Text(_user.phone),
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_user.company.name),
                  Text(
                    _user.company.bs,
                    style: const TextStyle(fontWeight: FontWeight.w300, height: 1.5),
                  ),
                ],
              ),
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.format_quote,
                    size: 24,
                    color: Colors.white30,
                  ),
                  Text(
                    _user.company.catchPhrase,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pin_drop),
              title: Text(_user.address),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              color: Colors.grey[900],
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int idx) =>
                                  PostPreview(post: posts[idx]),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PostsListPage(
                                      user: _user,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('View all posts'),
                            )
                          ],
                        );
                      }
                  }
                },
              ),
            ),
            Container(
              color: Colors.grey[800],
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: FutureBuilder<List<Album>?>(
                future: _albums,
                builder: (BuildContext context, AsyncSnapshot<List<Album>?> snapshot) {
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
                        List<Album> albums = snapshot.data!;
                        return Column(
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              children: [
                                ...albums
                                    .map((item) => AlbumPreview(album: item))
                                    .toList()
                                    .sublist(0, 3),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AlbumsListPage(
                                      user: _user,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('View all albums'),
                            )
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
}
