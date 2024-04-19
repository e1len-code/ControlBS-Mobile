import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:network_info_plus/network_info_plus.dart';

final info = NetworkInfo();

Future<Either<Failure, String>> getIpWifi() async {
  try {
    String? ipWifi = await info.getWifiGatewayIP();
    if (ipWifi != null || ipWifi == '') {
      return Right(ipWifi!);
    } else {
      return Left(DataFailure(message: "No se pudo recuperar la ip del Wifi"));
    }
  } catch (e) {
    return Left(DataFailure(message: "No se pudo recuperar la Ip del wifi"));
  }
}
