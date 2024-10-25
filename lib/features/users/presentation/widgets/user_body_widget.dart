import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/features/users/presentation/bloc/user_bloc.dart';
import 'package:controlbs_mobile/features/users/presentation/widgets/user_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBodyWidget extends StatefulWidget {
  const UserBodyWidget({Key? key}) : super(key: key);

  @override
  _UserBodyWidgetState createState() => _UserBodyWidgetState();
}

class _UserBodyWidgetState extends State<UserBodyWidget> {
  //final _nroDocController = TextEditingController();
  late final UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userBloc.add(UserListEvent());
    });
  }

  // Future<void> _handleRefresh() async {
  //   Future.delayed(Duration(seconds: 1));
  //   _search();
  //   //personaBloc.add(ListEvent());
  // }

  void _search(List<DateTime?> listDates) {
    userBloc.add(UserListEvent());
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
              BlocBuilder<UserBloc, UserState>(
                bloc: userBloc,
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GotListState) {
                    return UserListWidget(userList: state.userList);
                  } else if (state is ErrorState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const Center(
                      child: Text("No hay datos"),
                    );
                  }
                },
              ),
            ]));
  }
}
