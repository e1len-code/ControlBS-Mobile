import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/date_picker_widget.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class AttendancePageEdit extends StatefulWidget {
  const AttendancePageEdit({Key? key}) : super(key: key);

  @override
  _AttendancePageEditState createState() => _AttendancePageEditState();
}

class _AttendancePageEditState extends State<AttendancePageEdit> {
  TextEditingController? _dateController;

  @override
  void initState() {
    _dateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar asistencia"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: vspaceM, horizontal: hspaceS),
        child: Column(
          children: <Widget>[
            Card(
                child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SubTitleWidget(text: "Buscar"),
                  ],
                ),
                DatePickerWidget(label: "Fecha", controller: _dateController),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
