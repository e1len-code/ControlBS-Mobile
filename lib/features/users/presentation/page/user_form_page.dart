import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/input_password_widget.dart';
import 'package:controlbs_mobile/core/widgets/input_widget.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/presentation/bloc/user_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserFormPage extends StatefulWidget {
  final String persIden;
  const UserFormPage({Key? key, required this.persIden}) : super(key: key);

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _nombresUserController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final UserBloc userBloc;
  int? _statusValue = 1;

  @override
  void initState() {
    super.initState();
    userBloc = context.read<UserBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.persIden != "0") {
        userBloc.add(GetUserEvent(int.parse(widget.persIden)));
      }
    });
  }

  void _fillForm(User? user) {
    _nombresController.text = user?.persName ?? "";
    _nombresUserController.text = user?.persNmus ?? "";
    //_passwordController.text = user?.persPass ?? "";
    _statusValue = user?.persStat;
  }

  _saved() async {
    User _user = User(
        persIden: int.parse(widget.persIden),
        persName: _nombresController.text,
        persNmus: _nombresUserController.text,
        persPass: _passwordController.text,
        persStat: _statusValue ?? 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Usuario"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(hspaceL),
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is ErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is SavedUserState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Guardado")));
                context.go('/Usuarios');
              } else if (state is GotUserState) {
                _fillForm(state.user);
              }
            },
            builder: (context, state) {
              return state is LoadingState
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputWidget(
                            label: "Nombres y Apellidos",
                            controller: _nombresController,
                          ),
                          InputWidget(
                            label: "Nombre de usuario",
                            controller: _nombresUserController,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: InputPasswordWidget(
                                    label: "Contraseña",
                                    controller: _passwordController,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: TextButton(
                                    onPressed: () {
                                      _passwordController.text =
                                          "${_nombresController.text[0]}password${DateTime.now().year}\$";
                                    },
                                    child: const Text("Generar contraseña"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: vspaceL),
                          const Text(
                            "Estado",
                            textAlign: TextAlign.left,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: <Widget>[
                                RadioListTile<int>(
                                    value: 1,
                                    groupValue: _statusValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _statusValue = value;
                                      });
                                    },
                                    title: const Text('Habilitado')),
                                RadioListTile<int>(
                                    value: 0,
                                    groupValue: _statusValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _statusValue = value;
                                      });
                                    },
                                    title: const Text('Deshabilitado')),
                              ],
                            ),
                          ),
                          const SizedBox(height: vspaceL),
                          Center(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  maximumSize: MaterialStateProperty.all<Size>(
                                      const Size(double.infinity, 50)),
                                ),
                                onPressed: _saved,
                                child: Text("Guardar")),
                          )
                        ],
                      ),
                    );
            },
          )),
    );
  }
}
