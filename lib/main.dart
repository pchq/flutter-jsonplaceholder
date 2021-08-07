import 'package:flutter/material.dart';
import 'package:jsonplaceholder/config.dart';
import 'package:jsonplaceholder/pages/album_page.dart';
import 'package:jsonplaceholder/pages/albums_list_page.dart';
import 'package:jsonplaceholder/pages/page_404.dart';
import 'package:jsonplaceholder/pages/post_page.dart';
import 'package:jsonplaceholder/pages/posts_list_page.dart';
import 'package:jsonplaceholder/pages/user_page.dart';
import 'package:jsonplaceholder/pages/users_list_page.dart';

void main() {
  runApp(const JsonPlaceholderApp());
}

class JsonPlaceholderApp extends StatelessWidget {
  const JsonPlaceholderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Config.appTheme,
      home: const UsersListPage(),
      initialRoute: UsersListPage.routeName,
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Page404(),
      ),
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;

        switch (settings.name) {
          case UsersListPage.routeName:
            return MaterialPageRoute(
              builder: (context) => const UsersListPage(),
            );

          case UserPage.routeName:
            return MaterialPageRoute(
              builder: (context) =>
                  args['user'] != null ? UserPage(user: args['user']!) : const Page404(),
            );

          case PostsListPage.routeName:
            return MaterialPageRoute(
              builder: (context) =>
                  args['user'] != null ? PostsListPage(user: args['user']!) : const Page404(),
            );

          case PostPage.routeName:
            return MaterialPageRoute(
              builder: (context) =>
                  args['post'] != null ? PostPage(post: args['post']!) : const Page404(),
            );
          case AlbumsListPage.routeName:
            return MaterialPageRoute(
              builder: (context) =>
                  args['user'] != null ? AlbumsListPage(user: args['user']!) : const Page404(),
            );
          case AlbumPage.routeName:
            return MaterialPageRoute(
              builder: (context) =>
                  args['album'] != null ? AlbumPage(album: args['album']!) : const Page404(),
            );

          default:
            return MaterialPageRoute(
              builder: (context) => const Page404(),
            );
        }
      },
    );
  }
}
