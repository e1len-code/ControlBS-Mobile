import 'package:controlbs_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_req.dart';
import 'package:controlbs_mobile/features/attendance/domain/entities/attendance_resp.dart';
import 'package:controlbs_mobile/features/attendance/domain/useCase/attendance_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceUseCase useCase;

  //variablesBloc
  Map<String, List<AttendanceResp?>> listFilterMapDates = {};
  List<AttendanceResp?> listAttendance = [];

  AttendanceBloc({required this.useCase}) : super(AttendanceInitial()) {
    on<SaveEvent>((event, emit) => saveAttendance(event, emit));
    on<FilterListEvent>((event, emit) => filterList(event, emit));
    on<GetListEvent>((event, emit) => getListAttendance(event, emit));
  }
  Future<void> saveAttendance(
      SaveEvent event, Emitter<AttendanceState> emit) async {
    emit(LoadingState());
    final result = await useCase.save(event.attendance);
    result.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(SavedState(saved: r)));
  }

  Future<void> filterList(
      FilterListEvent event, Emitter<AttendanceState> emit) async {
    emit(LoadingState());
    final result = await useCase.filter(event.attendanceReq);
    result.fold((l) => emit(ErrorState(message: l.message)), (r) {
      listAttendance = r;
      mapDatesAttendance(r);
      emit(FilteredListState(mapList: listFilterMapDates));
    });
  }

  Future<void> getListAttendance(
      GetListEvent event, Emitter<AttendanceState> emit) async {
    emit(LoadingState());
    final result = await useCase.filter(event.attendanceReq);
    result.fold((l) => emit(ErrorState(message: l.message)), (r) {
      listAttendance = r;
      emit(GotListState(list: listAttendance));
    });
  }

  Future<void> getReportAttendance(
      GetReportEvent event, Emitter<AttendanceState> emit) async {
    emit(LoadingState());
    final result = await useCase.getReport(event.attendanceReq);
    result.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(GotReportState(base64Report: r)));
  }

  void mapDatesAttendance(List<AttendanceResp?> list) {
    listFilterMapDates = {};
    for (var elemento in list) {
      String fechaFormateada =
          DateFormat('yyyy-MM-dd').format(elemento!.attnDate!);
      if (listFilterMapDates.containsKey(fechaFormateada)) {
        listFilterMapDates[fechaFormateada]!.add(elemento);
      } else {
        listFilterMapDates[fechaFormateada] = [elemento];
      }
    }
  }
}
