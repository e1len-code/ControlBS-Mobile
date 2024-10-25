import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/presentation/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class UserDropDownWidget extends StatefulWidget {
  const UserDropDownWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<UserDropDownWidget> createState() => UserDropDownWidgetState();
}

class UserDropDownWidgetState extends State<UserDropDownWidget> {
  late UserBloc userBloc;

  // Initial Selected Value
  int? dropdownvalue = 0;
  // List of items in our dropdown menu
  late List<User?> userList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc = context.read<UserBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userBloc.add(UserListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(listener: (context, state) {
      if (state is ErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.message)));
      }
      if (state is GotListState) {
        userList = [
          User(persIden: 0, persName: '', persNmus: '', persStat: 1),
          ...state.userList
        ];
      }
    }, builder: (context, state) {
      if (state is LoadingState) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
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
    });
  }
}
