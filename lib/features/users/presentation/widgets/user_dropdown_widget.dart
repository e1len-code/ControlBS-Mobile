import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:flutter/material.dart';

class UserDropDownWidget extends StatefulWidget {
  final User? user;
  const UserDropDownWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDropDownWidget> createState() => _UserDropDownWidgetState();
}

class _UserDropDownWidgetState extends State<UserDropDownWidget> {
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      // Initial Value
      value: dropdownvalue,

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }
}
