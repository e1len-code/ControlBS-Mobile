import 'package:collection/collection.dart';
import 'package:controlbs_mobile/core/config/valueListenables/checkbox_status.dart';
import 'package:controlbs_mobile/core/config/valueListenables/time_status.dart';
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
  TimeStatusVListenable timeStatusVListenable =
      TimeStatusVListenable.instance();
  CheckBoxStatusVListenable checkBoxStatusVListenable =
      CheckBoxStatusVListenable.instance();
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      checkBoxStatusVListenable.statusCheckName(nroCheckBoxSelected);
    });
  }

  get nroCheckBoxSelectedF => _searchNroCheckSelected();
  get isAllCheckBoxDisabled => isDisabledCheckBoxes();
  int _searchNroCheckSelected() {
    GlobalKey<CheckBoxWidgetState>? keyCheckBoxSelected =
        keyCap.firstWhereOrNull((element) => element.currentState!.selected);
    nroCheckBoxSelected = (keyCheckBoxSelected == null)
        ? 0
        : keyCheckBoxSelected.currentState!.nroLine;
    if (nroCheckBoxSelected == 0) {
      keyCheckBoxSelected = keyCap.firstWhereOrNull(
          (element) => element.currentState!.widget.disabled == false);
      nroCheckBoxSelected = (keyCheckBoxSelected == null)
          ? 0
          : keyCheckBoxSelected.currentState!.nroLine;
      return nroCheckBoxSelected;
    }
    return nroCheckBoxSelected;
  }

  void cleanSelected() {
    for (var e in keyCap) {
      e.currentState!.selected = false;
    }
  }

  bool isDisabledCheckBoxes() {
    bool isDisabled = false;
    for (var key in keyCap) {
      isDisabled = isDisabled || key.currentState!.widget.disabled;
    }
    return isDisabled;
  }

  bool getCorrectHour(int i) {
    switch (i) {
      case 1:
        return timeStatusVListenable.timeStatus.value.hour >= 8 &&
            timeStatusVListenable.timeStatus.value.hour < 12;
      case 2:
        return timeStatusVListenable.timeStatus.value.hour >= 12 &&
            timeStatusVListenable.timeStatus.value.hour < 14;
      case 3:
        AttendanceResp? att = widget.listAttendance.firstWhere(
            (element) => element!.attnLine == 2,
            orElse: () => null);
        int mins = 0;
        if (att != null) {
          mins = (timeStatusVListenable.timeStatus.value.minute -
                  att.attnDate!.minute) +
              (timeStatusVListenable.timeStatus.value.hour -
                      att.attnDate!.hour) *
                  60;
        }
        return timeStatusVListenable.timeStatus.value.hour >= 13 &&
            timeStatusVListenable.timeStatus.value.hour < 18 &&
            mins >= 10;
      case 4:
        return timeStatusVListenable.timeStatus.value.hour >= 18;
      default:
        return false;
    }
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
        nroCheckBoxSelected = i;
      } else {
        list.add(CheckBoxWidget(
          key: keyCap[i - 1],
          disabled: !(getCorrectHour(i)),
          nroLine: i,
          cleanSelected: cleanSelected,
        ));
      }
      if (i != 3 && getCorrectHour(i)) {
        nroCheckBoxSelected++;
      }
      if (i == 3 && getCorrectHour(i)) {
        nroCheckBoxSelected == 2;
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: timeStatusVListenable.timeStatus,
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: list(widget.listAttendance),
          );
        });
  }
}
