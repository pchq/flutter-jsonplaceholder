import 'package:flutter/material.dart';
import 'package:jsonplaceholder/core/api.dart';
import 'package:jsonplaceholder/models/user.dart';
import 'package:jsonplaceholder/widgets/user_preview.dart';
import 'package:jsonplaceholder/core/shared_preferences.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  late Future<List<User>?> _users;

  @override
  void initState() {
    super.initState();
    _users = Api.getUsers().then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // >> cleaning shared preferencse

      floatingActionButton: IconButton(
        onPressed: () async {
          SharedPrefs.clearAll();
        },
        icon: const Icon(Icons.delete_forever),
      ),

      // << cleaning shared preferencse

      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: FutureBuilder<List<User>?>(
        future: _users,
        builder: (BuildContext context, AsyncSnapshot<List<User>?> snapshot) {
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
                return ListView(
                  padding: const EdgeInsets.all(10.0),
                  children: [
                    ...snapshot.data!
                        .map(
                          (item) => UserPreview(
                            user: item,
                          ),
                        )
                        .toList()
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
