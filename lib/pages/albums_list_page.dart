import 'package:flutter/material.dart';
import 'package:jsonplaceholder/core/api.dart';
import 'package:jsonplaceholder/models/album.dart';
import 'package:jsonplaceholder/models/user.dart';
import 'package:jsonplaceholder/widgets/album_preview.dart';

class AlbumsListPage extends StatefulWidget {
  const AlbumsListPage({Key? key, required this.user}) : super(key: key);

  static const routeName = '/user/albums';
  final User user;

  @override
  _AlbumsListPageState createState() => _AlbumsListPageState();
}

class _AlbumsListPageState extends State<AlbumsListPage> {
  late final User _user = widget.user;

  late Future<List<Album>?> _albums;

  @override
  void initState() {
    super.initState();
    _albums = Api.getAlbums(_user.id).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Albums of ${_user.username}')),
      body: SingleChildScrollView(
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
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10.0),
                        itemCount: albums.length,
                        itemBuilder: (BuildContext context, int idx) => AlbumPreview(
                          album: albums[idx],
                          onlyImg: false,
                        ),
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
