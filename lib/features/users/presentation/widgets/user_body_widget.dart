import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/features/users/presentation/provider/user_provider.dart';
import 'package:controlbs_mobile/features/users/presentation/widgets/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBodyWidget extends StatefulWidget {
  const UserBodyWidget({Key? key}) : super(key: key);

  @override
  _UserBodyWidgetState createState() => _UserBodyWidgetState();
}

class _UserBodyWidgetState extends State<UserBodyWidget> {
  //final _nroDocController = TextEditingController();
  late final UserProvider userProvider;
  late final AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    userProvider = context.read<UserProvider>();
    authProvider = context.read<AuthProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.list();
    });
  }

  // Future<void> _handleRefresh() async {
  //   Future.delayed(Duration(seconds: 1));
  //   _search();
  //   //personaBloc.add(ListEvent());
  // }

  void _search(List<DateTime?> listDates) {
    userProvider.list();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.symmetric(vertical: vspaceM, horizontal: hspaceS),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                return userProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : UserListWidget(
                        userList: userProvider.listUsers,
                      );
              }))
            ]));
  }
}
