import 'package:data_connection_checker/data_connection_checker.dart';

Future<bool> isConnected() async => await DataConnectionChecker().hasConnection;