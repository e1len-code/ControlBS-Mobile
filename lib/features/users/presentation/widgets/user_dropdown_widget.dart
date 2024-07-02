import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/presentation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDropDownWidget extends StatefulWidget {
  const UserDropDownWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<UserDropDownWidget> createState() => UserDropDownWidgetState();
}

class UserDropDownWidgetState extends State<UserDropDownWidget> {
  late UserProvider userProvider;

  // Initial Selected Value
  int? dropdownvalue = 0;
  // List of items in our dropdown menu
  late List<User?> userList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProvider = context.read<UserProvider>();
    //userList = [User(persIden: 1, persName: "s", persNmus: "s", persStat: 0)];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await userProvider.list();
      setState(() {
        userList = [
          User(persIden: 0, persName: '', persNmus: '', persStat: 1),
          ...userProvider.listUsers
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Usuario"),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  style: BorderStyle.solid,
                  width: 1.8),
            ),
            child: DropdownButton(
              isExpanded: true,
              padding: const EdgeInsets.all(10),
              underline: DropdownButtonHideUnderline(child: Container()),
              // Initial Value
              value: dropdownvalue,

              // Down Arrow Icon
              icon: const Icon(Icons.keyboard_arrow_down),

              // Array list of items
              items: userList.map((User? items) {
                return DropdownMenuItem(
                  value: items?.persIden ?? 0,
                  child: Text(items?.persName ?? ""),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (int? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
