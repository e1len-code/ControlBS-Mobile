import 'package:collection/collection.dart';
import 'package:controlbs_mobile/core/widgets/checkbox_widget.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:flutter/material.dart';

class AttendanceCheckBoxWidget extends StatefulWidget {
  const AttendanceCheckBoxWidget({super.key, required this.listAttendance});
  final List<AttendanceResp?> listAttendance;
  @override
  State<AttendanceCheckBoxWidget> createState() =>
      AttendanceCheckBoxWidgetState();
}

class AttendanceCheckBoxWidgetState extends State<AttendanceCheckBoxWidget> {
  int nroCheckBoxSelected = 0;
  List<GlobalKey<CheckBoxWidgetState>> keyCap =
      List<GlobalKey<CheckBoxWidgetState>>.generate(
          4,
          (index) => GlobalKey<CheckBoxWidgetState>(
              debugLabel: 'keyCheckBoxWidget_$index'),
          growable: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  get nroCheckBoxSelectedF => _searchNroCheckSelected();

  int _searchNroCheckSelected() {
    GlobalKey<CheckBoxWidgetState>? keyCheckBoxSelected =
        keyCap.firstWhereOrNull((element) => element.currentState!.selected);
    nroCheckBoxSelected = (keyCheckBoxSelected == null)
        ? 0
        : keyCheckBoxSelected.currentState!.nroLine;
    return nroCheckBoxSelected;
  }

  void cleanSelected() {
    for (var e in keyCap) {
      e.currentState!.selected = false;
    }
    print(keyCap.map((e) => e.currentState!.selected).toList());
  }

  List<Widget> list(List<AttendanceResp?> listAttendance) {
    List<Widget> list = [];
    for (int i = 1; i <= 4; i++) {
      AttendanceResp? att = listAttendance.firstWhere(
          (element) => (i) == element!.attnLine,
          orElse: () => null);
      if (att != null) {
        list.add(CheckBoxWidget(
          key: keyCap[i - 1],
          disabled: true,
          hour: att.attnDate,
          nroLine: i,
        ));
      } else {
        list.add(CheckBoxWidget(
          key: keyCap[i - 1],
          disabled: false,
          nroLine: i,
          cleanSelected: cleanSelected,
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: list(widget.listAttendance),
    );
  }
}
