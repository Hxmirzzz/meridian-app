import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'data/datasources/location_hardware_source.dart';
import 'data/repositories/location_repository_impl.dart';
import 'domain/repositories/location_repository.dart';
import 'data/models/alarm_model.dart';
import 'data/repositories/search_repository.dart';
import 'data/datasources/remote_search_source.dart';
import 'data/models/location_model.dart';
import 'core/constants/api_keys.dart';
import 'core/db/database_manager.dart';
import 'core/services/alarm_monitor_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/holiday_service.dart';
import 'presentation/screens/holidays_screen.dart';
import 'core/services/gps_foreground_service.dart';

void _onReceiveTaskData(Object data) {
  if (data is Map<String, dynamic> && data['type'] == 'location') {
    AlarmMonitorService().procesarPosicionForeground(
      data['lat'] as double,
      data['lng'] as double,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NotificationService.init();

  FlutterForegroundTask.initCommunicationPort();

  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  var locationStatus = await Permission.location.status;
  if (locationStatus.isDenied) {
    locationStatus = await Permission.location.request();
  }

  var backgroundLocationStatus = await Permission.locationAlways.status;
  if (backgroundLocationStatus.isDenied) {
    backgroundLocationStatus = await Permission.locationAlways.request();
  }

  try {
    final dir = await getApplicationDocumentsDirectory();
    await Isar.open(
      [AlarmModelSchema],
      directory: dir.path,
      name: "meridian_db",
    );
  } catch (e) {
    print("⚠️ ERROR INICIANDO ISAR (Modo UI seguro activado): $e");
  }

  runApp(const MeridianPremiumApp());
}

class MeridianPremiumApp extends StatelessWidget {
  const MeridianPremiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meridian App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          secondary: const Color(0xFF10B981),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AlarmasListView(),
    const ExplorarScreen(),
    const AlarmsPremiumScreen(),
    const SettingsPremiumScreen(),
  ];

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await HolidayService().init();
      await GpsForegroundService.initialize();
      await GpsForegroundService.requestPermissions();
      await GpsForegroundService.start();
      AlarmMonitorService().iniciarMonitoreo(context);
    });
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    AlarmMonitorService().detenerTodo();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Alarmas'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.route), label: 'Rutas'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}

class AlarmasListView extends StatelessWidget {
  const AlarmasListView({super.key});

  void _mostrarFormularioAlarma(BuildContext context, Isar isar, {AlarmModel? alarmaExistente}) {
    final _nombreController = TextEditingController(text: alarmaExistente?.name ?? "");
    TimeOfDay _horaSeleccionada = alarmaExistente != null
      ? TimeOfDay(hour: alarmaExistente.alarmHour, minute: alarmaExistente.alarmMinute)
      : TimeOfDay.now();
      
    bool _vibrar = true;
    bool _excludeHolidays = alarmaExistente?.excludeHolidays ?? false;
  
    List<String> _diasLetras = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    List<bool> _diasSeleccionados = alarmaExistente?.activeDays.toList() ?? 
        [true, true, true, true, true, false, false];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      alarmaExistente == null ? 'Nueva Alarma' : 'Editar Alarma', 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 20),
                    
                    // Selector de Hora y Minuto
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? tiempo = await showTimePicker(
                          context: context,
                          initialTime: _horaSeleccionada,
                        );
                        if (tiempo != null) {
                          setModalState(() {
                            _horaSeleccionada = tiempo;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time_filled, color: Color(0xFF2563EB)),
                                const SizedBox(width: 12),
                                Text(
                                  _horaSeleccionada.format(context),
                                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                                ),
                              ],
                            ),
                            const Text(
                              "Cambiar hora",
                              style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Input del Nombre (Ahora Opcional)
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Etiqueta de la alarma (Opcional)',
                        hintText: 'Ej: Trabajo / Universidad',
                        prefixIcon: const Icon(Icons.label_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Selector de Días de la Semana
                    const Text(
                      "Repetir días",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_diasLetras.length, (index) {
                        final seleccionado = _diasSeleccionados[index];
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              _diasSeleccionados[index] = !_diasSeleccionados[index];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: seleccionado ? const Color(0xFF2563EB) : Colors.grey.shade100,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: seleccionado ? const Color(0xFF2563EB) : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _diasLetras[index],
                                style: TextStyle(
                                  color: seleccionado ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    
                    // Toggle de Vibración
                    SwitchListTile.adaptive(
                      title: const Text('Vibración', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Vibrar al activarse la alerta'),
                      value: _vibrar,
                      activeColor: const Color(0xFF2563EB),
                      secondary: const Icon(Icons.vibration),
                      onChanged: (val) {
                        setModalState(() {
                          _vibrar = val;
                        });
                      },
                    ),
                    
                    // Toggle de Festivos
                    SwitchListTile.adaptive(
                      title: const Text('Silenciar en festivos', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('No sonar los días feriados programados'),
                      value: _excludeHolidays,
                      activeColor: Colors.purple,
                      secondary: const Icon(Icons.calendar_month, color: Colors.purple),
                      onChanged: (val) {
                        setModalState(() {
                          _excludeHolidays = val;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          final alarma = alarmaExistente ?? AlarmModel()
                            ..latitude = 0.0 
                            ..longitude = 0.0
                            ..radiusMeters = 500
                            ..createdAt = DateTime.now()
                            ..isActive = true;

                          alarma.alarmHour = _horaSeleccionada.hour;
                          alarma.alarmMinute = _horaSeleccionada.minute;

                          String nombreFinal = _nombreController.text.trim();
                          if (nombreFinal.isEmpty) {
                            nombreFinal = "Alarma ${_horaSeleccionada.format(context)}";
                          }

                          alarma.name = nombreFinal;
                          alarma.excludeHolidays = _excludeHolidays;
                          alarma.activeDays = List<bool>.from(_diasSeleccionados);

                          await isar.writeTxn(() async {
                            await isar.alarmModels.put(alarma);
                          });

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          alarmaExistente == null ? 'Guardar Alarma' : 'Actualizar Cambios', 
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                    
                    if (alarmaExistente != null) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await isar.writeTxn(() async {
                              await isar.alarmModels.delete(alarmaExistente.id);
                            });
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          label: const Text("Eliminar Alarma", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Mis Alarmas", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<Isar?>(
        future: Future.value(DatabaseManager.instance),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isar = snapshot.data!;

          return Stack(
            children: [
              StreamBuilder<List<AlarmModel>>(
                stream: isar.alarmModels.where().watch(fireImmediately: true),
                builder: (context, streamSnapshot) {
                  if (!streamSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                  
                  final alarmasTodas = streamSnapshot.data!;
                  final alarmasNormales = alarmasTodas.where((a) => a.latitude == 0.0 && a.longitude == 0.0).toList();
                  
                  if (alarmasNormales.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.alarm_off, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text("No hay alarmas programadas", style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: alarmasNormales.length,
                    itemBuilder: (ctx, i) {
                      final alarm = alarmasNormales[i];
                      
                      return Dismissible(
                        key: Key(alarm.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(20)),
                          alignment: Alignment.centerRight,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Eliminar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8), Icon(Icons.delete, color: Colors.white),
                            ],
                          ),
                        ),
                        onDismissed: (direction) async {
                          await isar.writeTxn(() async { await isar.alarmModels.delete(alarm.id); });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: alarm.isActive ? Colors.blue.withOpacity(0.5) : Colors.transparent, width: 2),
                            boxShadow: [
                              BoxShadow(color: alarm.isActive ? Colors.blue.withOpacity(0.1) : Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            leading: CircleAvatar(
                              backgroundColor: alarm.excludeHolidays ? Colors.purple.shade100 : Colors.blue.shade100,
                              child: Icon(alarm.excludeHolidays ? Icons.calendar_month : Icons.access_time_filled, color: alarm.excludeHolidays ? Colors.purple : Colors.blue.shade700),
                            ),
                            title: Text(alarm.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(alarm.excludeHolidays ? "Lun a Vie • Silenciada en festivos" : "Lun a Vie • Alarma activa", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                            ),
                            trailing: Switch.adaptive(
                              value: alarm.isActive,
                              activeColor: Colors.blue,
                              onChanged: (v) async {
                                await isar.writeTxn(() async {
                                  alarm.isActive = v;
                                  await isar.alarmModels.put(alarm);
                                });
                              },
                            ),
                            onTap: () => _mostrarFormularioAlarma(context, isar, alarmaExistente: alarm),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () => _mostrarFormularioAlarma(context, isar),
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.add, size: 28),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// PAGINA DEL MAPITA
class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({super.key});

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  final MapController _mapController = MapController();
  late final SearchRepository _searchRepository;
  late final LocationRepository _locationRepository;
  
  bool _isSearching = false;
  List<LocationModel> _searchResults = [];
  LatLng? _miUbicacionReal;

  final LatLng _ubicacionCasa = const LatLng(4.590093415680107, -74.17876583555564);
  late LatLng _destinoActual;
  late final List<Map<String, dynamic>> _lugaresSugeridos;

  @override
  void initState() {
    super.initState();
    _destinoActual = _ubicacionCasa;
    
    _searchRepository = SearchRepository(
      remoteSource: RemoteSearchSource(client: http.Client()),
    );
  
    _locationRepository = LocationRepositoryImpl(
      LocationHardwareSource(),
    );

    _lugaresSugeridos = [
      {"nombre": "Universidad CUN (Centro)", "coords": const LatLng(4.6029446915992045, -74.07409252126322)},
      {"nombre": "Casa", "coords": _ubicacionCasa},
      {"nombre": "Portal del Norte", "coords": const LatLng(4.754841517349627, -74.04606496359166)},
    ];

    _inicializarGPS();
  }

  Future<void> _inicializarGPS() async {
    try {
      final tienePermiso = await _locationRepository.requestPermissions();
      
      if (tienePermiso) {
        final Position position = await _locationRepository.getCurrentPosition();
        
        if (mounted) {
          setState(() {
            _miUbicacionReal = LatLng(position.latitude, position.longitude);
            _destinoActual = _miUbicacionReal!;
          });
          _mapController.move(_miUbicacionReal!, 15.0);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Info GPS: $e'), backgroundColor: Colors.orange),
        );
      }
    }
  }

  void _onMapTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      _destinoActual = latlng;
    });
  }

  void _abrirConfiguracionAlarma(BuildContext context) {
    bool ignorarFestivos = true;
    final _nombreRutaController = TextEditingController();
    double _radioSeleccionado = 100;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 20),
                    const Text('Guardar Ruta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nombreRutaController,
                      decoration: InputDecoration(
                        labelText: 'Nombre personalizado',
                        hintText: 'Ej: Regreso a casa',
                        prefixIcon: const Icon(Icons.edit_location_alt),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.radar, color: Colors.blue),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Radio de alerta: ${_radioSeleccionado.toInt()} metros',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                    ),
                                    const Text('Ajusta el radio para la demostración', style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _radioSeleccionado,
                            min: 1,
                            max: 500,
                            divisions: 499,
                            label: '${_radioSeleccionado.toInt()}m',
                            activeColor: const Color(0xFF2563EB),
                            onChanged: (value) {
                              setModalState(() {
                                _radioSeleccionado = value;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1m', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                              Text('500m', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    SwitchListTile(
                      title: const Text('Silenciar en festivos', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('No recibirás alertas en días festivos.'),
                      value: ignorarFestivos,
                      activeColor: const Color(0xFF2563EB),
                      onChanged: (val) {
                        setModalState(() {
                          ignorarFestivos = val;
                        });
                      },
                      secondary: const Icon(Icons.calendar_month, color: Colors.purple),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final isar = DatabaseManager.instance;
                            if (isar == null) {
                              throw Exception("Base de datos no inicializada");
                            }

                            final nuevaAlarmaUbicacion = AlarmModel()
                              ..name = _nombreRutaController.text.trim().isEmpty ? "Destino en Mapa" : _nombreRutaController.text.trim()
                              ..latitude = _destinoActual.latitude
                              ..longitude = _destinoActual.longitude
                              ..radiusMeters = _radioSeleccionado.toInt() // ⭐ USA EL RADIO SELECCIONADO
                              ..isActive = true
                              ..excludeHolidays = ignorarFestivos
                              ..createdAt = DateTime.now()
                              ..alarmHour = 0
                              ..alarmMinute = 0
                              ..activeDays = [true, true, true, true, true, true, true]
                              ..lastTriggered = null;

                            await isar.writeTxn(() async {
                              await isar.alarmModels.put(nuevaAlarmaUbicacion);
                            });

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Ruta guardada exitosamente.'),
                                  backgroundColor: const Color(0xFF10B981),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al guardar la ruta: $e'),
                                  backgroundColor: Colors.red.shade600,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text('Confirmar Alarma', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarOpcionesMarcador(BuildContext context, AlarmModel alarma) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(alarma.name),
        content: const Text("¿Deseas eliminar esta geocerca del monitoreo?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red, elevation: 0),
            onPressed: () async {
              final isar = DatabaseManager.instance!;
              await isar.writeTxn(() async {
                await isar.alarmModels.delete(alarma.id);
              });
              Navigator.pop(ctx);
            }, 
            child: const Text("Eliminar Ruta")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Isar?>(
        future: Future.value(DatabaseManager.instance),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isar = snapshot.data!;

          return StreamBuilder<List<AlarmModel>>(
            stream: isar.alarmModels.where().watch(fireImmediately: true),
            builder: (context, streamSnapshot) {
              
              final alarmas = streamSnapshot.data ?? [];
              final alarmasUbicacion = alarmas.where((a) => a.latitude != 0.0 && a.longitude != 0.0).toList();

              return Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _destinoActual,
                      initialZoom: 15.0,
                      onTap: _onMapTap,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}@2x?access_token=${ApiKeys.mapboxToken}',
                        maxNativeZoom: 19,
                        userAgentPackageName: 'com.meridian.meridian',
                      ),
                      
                      CircleLayer(
                        circles: alarmasUbicacion.map((alarma) => CircleMarker(
                          point: LatLng(alarma.latitude, alarma.longitude),
                          color: alarma.isActive ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                          borderStrokeWidth: 2,
                          borderColor: alarma.isActive ? Colors.green : Colors.grey,
                          useRadiusInMeter: true,
                          radius: alarma.radiusMeters.toDouble(), 
                        )).toList(),
                      ),
                      
                      MarkerLayer(
                        markers: [
                          if (_miUbicacionReal != null)
                            Marker(
                              point: _miUbicacionReal!,
                              width: 24,
                              height: 24,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 4,
                                    )
                                  ]
                                ),
                              ),
                            ),

                          // Marcador rojo de la búsqueda actual
                          Marker(
                            point: _destinoActual,
                            width: 50,
                            height: 50,
                            child: const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 45),
                          ),
                          // Marcadores de las alarmas guardadas
                          ...alarmasUbicacion.map((alarma) => Marker(
                            point: LatLng(alarma.latitude, alarma.longitude),
                            width: 60,
                            height: 60,
                            child: GestureDetector(
                              onTap: () => _mostrarOpcionesMarcador(context, alarma),
                              child: Icon(Icons.radar_rounded, color: alarma.isActive ? Colors.green.shade700 : Colors.grey, size: 40),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),

                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Autocomplete<Map<String, dynamic>>(
                      optionsBuilder: (TextEditingValue textEditingValue) async {
                        if (textEditingValue.text.length < 3) return _lugaresSugeridos; 
                        try {
                          final results = await _searchRepository.searchLocations(textEditingValue.text);
                          return results.map((loc) => {
                            'nombre': loc.displayName ?? 'Sin nombre',
                            'coords': LatLng(loc.lat, loc.lon),
                          }).toList();
                        } catch (e) {
                          return [];
                        }
                      },
                      displayStringForOption: (option) => option['nombre'],
                      onSelected: (Map<String, dynamic> seleccion) {
                        setState(() {
                          _destinoActual = seleccion['coords'];
                          _mapController.move(_destinoActual, 15.0);
                        });
                      },
                      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
                          ),
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: "Buscar estación o destino...",
                              prefixIcon: _isSearching 
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  )
                                : const Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Zona de Llegada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(20)),
                                child: const Text("500m", style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Busca tu destino y establece un punto de alerta.",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _abrirConfiguracionAlarma(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text("Crear Alerta Aquí", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          );
        }
      ),
    );
  }
}

// ==========================================
// PANTALLA 2: MIS RUTAS
// ==========================================
class AlarmsPremiumScreen extends StatelessWidget {
  const AlarmsPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Rutas Guardadas', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<Isar?>(
        future: Future.value(DatabaseManager.instance),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final isar = snapshot.data!;

          return StreamBuilder<List<AlarmModel>>(
            stream: isar.alarmModels.where().watch(fireImmediately: true),
            builder: (context, streamSnapshot) {
              if (!streamSnapshot.hasData) return const Center(child: CircularProgressIndicator());

              // FILTRO: SOLO ALARMAS DE MAPA (Latitud distinta de 0.0)
              final alarmasTodas = streamSnapshot.data!;
              final alarmasUbicacion = alarmasTodas.where((a) => a.latitude != 0.0 && a.longitude != 0.0).toList();

              if (alarmasUbicacion.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text("No tienes rutas monitoreadas", style: TextStyle(color: Colors.grey.shade500, fontSize: 18)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: alarmasUbicacion.length,
                itemBuilder: (context, index) {
                  final alarma = alarmasUbicacion[index];
                  // Color premium estático para las rutas
                  final colorRuta = const Color(0xFF10B981); // Esmeralda

                  return Dismissible(
                    key: Key(alarma.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(color: Colors.red.shade600, borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.centerRight,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Eliminar Ruta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8), Icon(Icons.delete, color: Colors.white),
                        ],
                      ),
                    ),
                    onDismissed: (direction) async {
                      await isar.writeTxn(() async { await isar.alarmModels.delete(alarma.id); });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: alarma.isActive ? colorRuta.withOpacity(0.5) : Colors.transparent, width: 2),
                        boxShadow: [
                          BoxShadow(color: alarma.isActive ? colorRuta.withOpacity(0.1) : Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: alarma.isActive ? colorRuta.withOpacity(0.1) : Colors.grey.shade100, shape: BoxShape.circle),
                              child: Icon(Icons.directions_bus_filled, color: alarma.isActive ? colorRuta : Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(alarma.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text("GPS • Aviso a ${alarma.radiusMeters}m", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                ],
                              ),
                            ),
                            Switch.adaptive(
                              value: alarma.isActive,
                              activeColor: colorRuta,
                              onChanged: (bool value) async {
                                await isar.writeTxn(() async {
                                  alarma.isActive = value;
                                  await isar.alarmModels.put(alarma);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ==========================================
// PANTALLA 3: AJUSTES 
// ==========================================
class SettingsPremiumScreen extends StatefulWidget {
  const SettingsPremiumScreen({super.key});

  @override
  State<SettingsPremiumScreen> createState() => _SettingsPremiumScreenState();
}

class _SettingsPremiumScreenState extends State<SettingsPremiumScreen> {
  bool vibra = true;
  bool sonido = true;
  bool festivos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader("Notificaciones"),
          _buildSettingsCard([
            _buildSettingsRow(Icons.vibration, "Vibración al llegar", vibra, Colors.orange, (v) => setState(() => vibra = v)),
            _buildDivider(),
            _buildSettingsRow(Icons.volume_up_rounded, "Sonido de alerta", sonido, Colors.blue, (v) => setState(() => sonido = v)),
          ]),
          const SizedBox(height: 25),
          _buildSectionHeader("Opciones Avanzadas"),
          _buildSettingsCard([
            _buildSettingsRow(Icons.calendar_month, "Silenciar días festivos", festivos, Colors.purple, (v) => setState(() => festivos = v)),
            _buildDivider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.edit_calendar, color: Colors.red, size: 20),
              ),
              title: const Text('Administrar festivos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HolidaysScreen()),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, bool value, Color iconColor, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          Switch.adaptive(value: value, onChanged: onChanged, activeColor: const Color(0xFF2563EB)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 60, color: Colors.grey.shade200);
  }
}