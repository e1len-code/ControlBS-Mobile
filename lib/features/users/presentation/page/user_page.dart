import 'package:controlbs_mobile/features/users/presentation/widgets/user_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Usuarios"),
        actions: [
          IconButton(
            onPressed: () => context.go('/Usuarios/0'),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: const UserBodyWidget(),
    );
  }
}
