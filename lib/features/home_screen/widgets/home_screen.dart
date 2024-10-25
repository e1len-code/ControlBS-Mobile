import 'package:controlbs_mobile/core/widgets/draw_svg_widget.dart';
import 'package:controlbs_mobile/core/widgets/title_widget.dart';
import 'package:controlbs_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:controlbs_mobile/features/file/presentation/bloc/file_provider_bloc.dart'
    as filebloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        MultiBlocListener(listeners: [
          BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is ErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<filebloc.FileBloc, filebloc.FileState>(
            listener: (context, state) {
              if (state is filebloc.ErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ], child: Container())
      ],
    );
  }
}
