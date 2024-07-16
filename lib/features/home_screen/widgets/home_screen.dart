import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/widgets/draw_svg_widget.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderHomeScreen extends StatelessWidget {
  const HeaderHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(
          child: DrawSVGWidget(),
        ),
        const Center(child: TitleWidget(text: "CONTROL BS")),
        Consumer2<AttendanceProvider, FileProvider>(
            builder: (context, attendanceProvider, fileProvider, child) {
          return attendanceProvider.isLoading || fileProvider.isLoading
              ? const CircularProgressIndicator()
              : Text(
                  attendanceProvider.error + fileProvider.error,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: fontWeightBold,
                      fontSize: fontSizeL),
                );
        }),
      ],
    );
  }
}
