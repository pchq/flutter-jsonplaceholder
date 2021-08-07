import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jsonplaceholder/core/api.dart';
import 'package:jsonplaceholder/models/album.dart';
import 'package:jsonplaceholder/models/photo.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key? key, required this.album}) : super(key: key);

  static const routeName = '/album';
  final Album album;

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late final Album _album = widget.album;

  late Future<List<Photo>?> _photos;

  @override
  void initState() {
    super.initState();
    _photos = Api.getPhotos(_album.id).then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_album.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Photo>?>(
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
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                Text(
                                  _album.title,
                                  style: const TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              aspectRatio: 1,
                              enlargeCenterPage: true,
                              enlargeStrategy: CenterPageEnlargeStrategy.height,
                            ),
                            items: photos
                                .map(
                                  (item) => Stack(
                                    children: [
                                      Image.network(
                                        item.url,
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
                                      Positioned(
                                        child: Container(
                                          child: Text(item.title),
                                          color: Colors.black.withOpacity(.5),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 10,
                                          ),
                                        ),
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
