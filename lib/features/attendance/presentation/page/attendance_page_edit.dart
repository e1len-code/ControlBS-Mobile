import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/utils/extensions.dart';
import 'package:controlbs_mobile/core/widgets/date_picker_widget.dart';
import 'package:controlbs_mobile/core/widgets/hour_picker_widget.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/users/presentation/widgets/user_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';

class AttendancePageEdit extends StatefulWidget {
  const AttendancePageEdit({Key? key}) : super(key: key);

  @override
  _AttendancePageEditState createState() => _AttendancePageEditState();
}

class _AttendancePageEditState extends State<AttendancePageEdit> {
  TextEditingController? _dateController;
  late final List<TextEditingController> _listHoursController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  late final List<GlobalKey<HourPickerWidgetState>> _listHoursKey = [
    GlobalKey<HourPickerWidgetState>(debugLabel: "hourPickerKey1"),
    GlobalKey<HourPickerWidgetState>(debugLabel: "hourPickerKey2"),
    GlobalKey<HourPickerWidgetState>(debugLabel: "hourPickerKey3"),
    GlobalKey<HourPickerWidgetState>(debugLabel: "hourPickerKey4")
  ];
  late final AttendanceProvider attendanceProvider;
  final _userDropDownKey =
      GlobalKey<UserDropDownWidgetState>(debugLabel: "userDropDownKey");

  @override
  void initState() {
    _dateController = TextEditingController();
    attendanceProvider = context.read<AttendanceProvider>();
    super.initState();
  }

  _clearForm() {
    for (int i = 0; i <= 3; i++) {
      _listHoursController[i].clear();
    }
  }

  _save() {
    _listHoursKey.asMap().forEach((index, e) {
      if (e.currentState!.controller!.text.isNotEmpty) {
        AttendanceResp? attendance =
            attendanceProvider.listAttendance.firstWhereOrNull(
          (element) => element!.attnLine == index + 1,
        );
        if (attendance != null) {
          attendance.attnDate = DateTime.parse(attendance.attnDate.toString());
          attendance.attnDate = attendance.attnDate!.applyTimeOfDay(
              hour: e.currentState!.timeOfDay!.hour,
              minute: e.currentState!.timeOfDay!.minute);
          attendanceProvider.save(Attendance(
              attnIden: attendance.attnIden,
              persIden: attendance.persIden,
              attnline: attendance.attnLine,
              attnUbic: attendance.attnUbic,
              attnDate: attendance.attnDate!));
        } else {
          attendanceProvider.save(Attendance(
              attnIden: 0,
              attnline: index + 1,
              attnDate: DateTime.parse(_dateController!.text).applyTimeOfDay(
                  hour: e.currentState!.timeOfDay!.hour,
                  minute: e.currentState!.timeOfDay!.minute),
              attnUbic: null,
              persIden: _userDropDownKey.currentState!.dropdownvalue!));
        }
      }
    });
  }

  _search() async {
    _clearForm();
    await attendanceProvider.getAttendance(AttendanceReq(
        persIden: _userDropDownKey.currentState!.dropdownvalue,
        attnDtIn: DateTime.parse(_dateController!.text),
        atttnDtFn: DateTime.parse(_dateController!.text)));

    for (int i = 0; i < attendanceProvider.listAttendance.length; i++) {
      AttendanceResp attendanceResp = attendanceProvider.listAttendance[i]!;
      _listHoursController[attendanceResp.attnLine - 1].text =
          TimeOfDay.fromDateTime(attendanceResp.attnDate!).format(context);
    }
  }

  _generarReporte(BuildContext context) async {
    await attendanceProvider.getReport(AttendanceReq(
        persIden: _userDropDownKey.currentState!.dropdownvalue,
        attnDtIn: DateTime.parse(_dateController!.text),
        atttnDtFn: DateTime.parse(_dateController!.text)));
    // Decodificar la cadena Base64 a bytes
    final bytes = base64Decode(attendanceProvider.base64Report ?? "");
    //Save single text file
    DocumentFileSavePlus doc = DocumentFileSavePlus();
    doc.saveFile(
        bytes,
        "${_userDropDownKey.currentState!.dropdownvalue}-${DateTime.now()}}.xlsx",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

    // Abrir el archivo con la aplicación predeterminada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar asistencia"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: vspaceM, horizontal: hspaceL),
        child: Column(
          children: <Widget>[
            Card(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: vspaceM),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          const SubTitleWidget(text: "Filtro de Busqueda"),
                        ],
                      ),
                    ],
                  ),
                ),
                UserDropDownWidget(
                  key: _userDropDownKey,
                ),
                const SizedBox(height: hspaceL),
                DatePickerWidget(label: "Fecha", controller: _dateController),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer)),
                          onPressed: () => _generarReporte(context),
                          child: const Text("Genera Reporte")),
                      const SizedBox(width: hspaceL),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer)),
                          onPressed: () => _search(),
                          child: const Text("Buscar")),
                    ],
                  ),
                ),
              ],
            )),
            const SizedBox(
              height: vspaceM,
            ),
            const SubTitleWidget(text: "Horario de asistencia"),
            Card(
              color: Theme.of(context).colorScheme.background,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: HourPickerWidget(
                              key: _listHoursKey[0],
                              label: "Hora de entrada",
                              controller: _listHoursController[0]),
                        ),
                        const SizedBox(
                          width: hspaceL,
                        ),
                        Expanded(
                          child: HourPickerWidget(
                              key: _listHoursKey[1],
                              label: "Hora inicial almuerzo",
                              controller: _listHoursController[1]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: HourPickerWidget(
                              key: _listHoursKey[2],
                              label: "Hora final almuerzo",
                              controller: _listHoursController[2]),
                        ),
                        const SizedBox(
                          width: hspaceL,
                        ),
                        Expanded(
                          child: HourPickerWidget(
                              key: _listHoursKey[3],
                              label: "Hora de salida",
                              controller: _listHoursController[3]),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: _save,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primaryContainer)),
                child: Text("Guardar"))
          ],
        ),
      ),
    );
  }
}
