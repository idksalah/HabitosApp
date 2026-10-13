
import 'package:flutter/material.dart';
import 'package:habitos_app/screens/bienvenida_screen.dart';
import 'package:habitos_app/screens/inicio_screen.dart';
import 'package:habitos_app/services/preferencias_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitosApp',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const PantallaInicial(),
    );
  }
}

class PantallaInicial extends StatefulWidget {
  const PantallaInicial({super.key});

  @override
  State<PantallaInicial> createState() {
    return _PantallaInicialState();
  }
}

class _PantallaInicialState extends State<PantallaInicial> {
  String? nombre;
  int? objetivo;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    nombre = await PreferenciasService.obtenerNombre();
    objetivo = await PreferenciasService.obtenerObjetivo();

    if (!mounted) return;

    setState(() {
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (nombre != null &&
        nombre!.isNotEmpty &&
        objetivo != null &&
        objetivo! > 0) {
      return InicioScreen(
        nombre: nombre!,
        objetivo: objetivo!,
      );
    }

    return const BienvenidaScreen();
  }
}