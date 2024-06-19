import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/presentation/widgets/user_item_widget.dart';
import 'package:flutter/material.dart';

class UserListWidget extends StatelessWidget {
  final List<User?> userList;
  final bool isSearching;
  const UserListWidget(
      {Key? key, required this.userList, this.isSearching = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        //shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        itemBuilder: (context, index) {
          return UserItemWidget(
            user: userList[index],
          );
        },
        itemCount: userList.length,
      ),
    );
  }
}
