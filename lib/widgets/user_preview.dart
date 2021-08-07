import 'package:flutter/material.dart';
import 'package:jsonplaceholder/models/user.dart';
import 'package:jsonplaceholder/pages/user_page.dart';

class UserPreview extends StatelessWidget {
  const UserPreview({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => UserPage(
              user: user,
            ),
          ),
        )
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.black12,
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.person_outline,
                  size: 50,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  Text(user.name),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
