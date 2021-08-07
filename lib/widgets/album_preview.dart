import 'package:flutter/material.dart';
import 'package:jsonplaceholder/core/api.dart';
import 'package:jsonplaceholder/models/album.dart';
import 'package:jsonplaceholder/models/photo.dart';
import 'package:jsonplaceholder/pages/album_page.dart';

class AlbumPreview extends StatefulWidget {
  const AlbumPreview({Key? key, required this.album, this.onlyImg = true}) : super(key: key);

  final Album album;
  final bool onlyImg;

  @override
  State<AlbumPreview> createState() => _AlbumPreviewState();
}

class _AlbumPreviewState extends State<AlbumPreview> {
  late final Album _album = widget.album;
  late final bool _onlyImg = widget.onlyImg;

  late Future<List<Photo>?> _photos;

  @override
  void initState() {
    super.initState();
    _photos = Api.getPhotos(_album.id).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AlbumPage(album: widget.album),
          ),
        );
      },
      child: Card(
        child: FutureBuilder<List<Photo>?>(
          future: _photos,
          builder: (BuildContext context, AsyncSnapshot<List<Photo>?> snapshot) {
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
                  List<Photo> photos = snapshot.data!;
                  if (_onlyImg) {
                    return Image.network(
                      photos[0].thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Row(
                      children: [
                        Image.network(
                          photos[0].thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.black,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                ),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              _album.title,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }
}
