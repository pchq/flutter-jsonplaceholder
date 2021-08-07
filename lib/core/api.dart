import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jsonplaceholder/core/shared_preferences.dart';
import 'package:jsonplaceholder/models/album.dart';
import 'package:jsonplaceholder/models/comment.dart';
import 'package:jsonplaceholder/models/photo.dart';
import 'package:jsonplaceholder/models/post.dart';
import 'package:jsonplaceholder/models/user.dart';

enum DataType { users, posts, comments, albums, photos }

class Api {
  static _makeUri(path) => Uri.parse('https://jsonplaceholder.typicode.com$path');

  static Future<String?> _getRemoteJson(String path) async {
    Uri uri = _makeUri(path);

    try {
      http.Client _httpClient = http.Client();
      http.Response response = await _httpClient.get(uri);
      _httpClient.close();
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ('Uncorrect status: ${response.statusCode}');
      }
    } catch (e) {
      print('$e');
    }
  }

  static String _makePath(DataType type, [int? id]) {
    String path;
    switch (type) {
      case DataType.users:
        path = '/users/';
        break;
      case DataType.posts:
        path = '/users/${id!}/posts';
        break;
      case DataType.comments:
        path = '/posts/${id!}/comments';
        break;
      case DataType.albums:
        path = '/users/${id!}/albums';
        break;
      case DataType.photos:
        path = '/albums/${id!}/photos';
        break;
    }
    return path;
  }

  static Future<String?> _getJson(path) async {
    SharedPrefs sharedPrefs = SharedPrefs();
    await sharedPrefs.init();
    if (sharedPrefs.isSaved(path) && sharedPrefs.getData(path) != null) {
      return sharedPrefs.getData(path)!;
    } else {
      try {
        String? json = await _getRemoteJson(path);
        if (json != null) {
          sharedPrefs.saveData(path, json);
        }
        return json;
      } catch (e) {
        print('$e');
      }
    }
  }

  static Future<List<User>?> getUsers() async {
    String path = _makePath(DataType.users);
    String? json = await _getJson(path);

    if (json != null) {
      return jsonDecode(json).map<User>((item) => User.fromJson(item)).toList();
    }
  }

  static Future<List<Post>?> getPosts(int userId) async {
    String path = _makePath(DataType.posts, userId);
    String? json = await _getJson(path);
    if (json != null) {
      return jsonDecode(json).map<Post>((item) => Post.fromJson(item)).toList();
    }
  }

  static Future<List<Album>?> getAlbums(int userId) async {
    String path = _makePath(DataType.albums, userId);
    String? json = await _getJson(path);

    if (json != null) {
      return jsonDecode(json).map<Album>((item) => Album.fromJson(item)).toList();
    }
  }

  static Future<List<Photo>?> getPhotos(int albumId) async {
    String path = _makePath(DataType.photos, albumId);
    String? json = await _getJson(path);

    if (json != null) {
      return jsonDecode(json).map<Photo>((item) => Photo.fromJson(item)).toList();
    }
  }

  static Future<List<Comment>?> getComments(int postId) async {
    String path = _makePath(DataType.comments, postId);
    String? json = await _getJson(path);

    if (json != null) {
      return jsonDecode(json).map<Comment>((item) => Comment.fromJson(item)).toList();
    }
  }

  static Future<List<Comment>?> addComment(Map<String, dynamic> commentData) async {
    String path = _makePath(DataType.comments, commentData['postId']);
    String? json = await _getJson(path);

    try {
      http.Response response = await http.post(
        _makeUri(path),
        body: jsonEncode(commentData),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 201) {
        SharedPrefs sharedPrefs = SharedPrefs();
        await sharedPrefs.init();
        String addedComment = response.body;
        List comments = jsonDecode(json!).toList()..add(jsonDecode(addedComment));

        String newJson = jsonEncode(comments);
        sharedPrefs.saveData(path, newJson);

        return comments.map<Comment>((item) => Comment.fromJson(item)).toList();
      } else {
        throw ('Uncorrect status: ${response.statusCode}');
      }
    } catch (e) {
      print('$e');
    }
  }
}
