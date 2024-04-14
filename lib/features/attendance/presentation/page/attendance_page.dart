import 'package:controlbs_mobile/features/attendance/presentation/widgets/attendance_body_widget.dart';
import 'package:flutter/material.dart';

class AttendacePage extends StatefulWidget {
  const AttendacePage({Key? key}) : super(key: key);

  @override
  _AttendacePageState createState() => _AttendacePageState();
}

class _AttendacePageState extends State<AttendacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asistencias"),
      ),
      body: const AttendanceBodyWidget(),
    );
  }
}
