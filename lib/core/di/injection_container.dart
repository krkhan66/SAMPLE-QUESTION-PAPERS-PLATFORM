import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  // Dio Client
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      getAccessToken: () => '',
      getRefreshToken: () => '',
      onTokenExpired: () async => false,
    ),
  );
}
