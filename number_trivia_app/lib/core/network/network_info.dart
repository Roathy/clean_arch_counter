import 'dart:async';

import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

abstract class NetworkInfo {
  Future<bool>? get isConnected;
}

class NetworkInfoImp implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImp(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
  // Future<bool>? get isConnected {
  //   connectionChecker.hasConnection;
  //   return Future.value(true);
  // }
}

// Future<void> main() async {
//   final InternetConnectionChecker customInstance = InternetConnectionChecker.createInstance(
//     checkTimeout: const Duration(seconds: 1),
//     checkInterval: const Duration(seconds: 1),
//   );

//   await execute(customInstance);
// }

// Future<void> execute(InternetConnectionChecker internetConnectionChecker) async {
//   final bool isConnected = await InternetConnectionChecker().hasConnection;

//   // actively listen for status updates
//   final StreamSubscription<InternetConnectionStatus> listener = InternetConnectionChecker().onStatusChange.listen(
//     (InternetConnectionStatus status) {
//       switch (status) {
//         case InternetConnectionStatus.connected:
//           // ignore: avoid_print
//           // print('Data connection is available.');
//           break;
//         case InternetConnectionStatus.disconnected:
//           // ignore: avoid_print
//           // print('You are disconnected from the internet.');
//           break;
//       }
//     },
//   );

//   await Future<void>.delayed(const Duration(seconds: 30));
//   await listener.cancel();
// }
