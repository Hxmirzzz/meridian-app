import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/theme/app_theme.dart';
import 'domain/usecases/calculate_geofence.dart';
import 'domain/usecases/manage_alarms.dart';
import 'domain/usecases/verify_holiday_alarm.dart';
import 'domain/repositories/alarm_repository.dart';
import 'domain/repositories/location_repository.dart';
import 'presentation/bloc/alarm_bloc.dart';
import 'presentation/bloc/location_bloc.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/list_alarms_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Punto de entrada de la aplicación.
/// Configura los providers de BLoC globales y las rutas.
class MeridianApp extends StatelessWidget {
  const MeridianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlarmBloc>(
          create: (_) => AlarmBloc(
            manageAlarms: GetIt.I<ManageAlarms>(),
          ),
        ),
        BlocProvider<LocationBloc>(
          create: (_) => LocationBloc(
            locationRepository: GetIt.I<LocationRepository>(),
            alarmRepository: GetIt.I<AlarmRepository>(),
            calculateGeofence: GetIt.I<CalculateGeofence>(),
            verifyHolidayAlarm: GetIt.I<VerifyHolidayAlarm>(),
            notifications: GetIt.I<FlutterLocalNotificationsPlugin>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Meridian',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: '/',
        routes: {
          '/': (_) => const HomeScreen(),
          '/alarms': (_) => const ListAlarmsScreen(),
          '/settings': (_) => const SettingsScreen(),
        },
      ),
    );
  }
}