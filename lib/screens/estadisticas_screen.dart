
import 'package:flutter/material.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';

class EstadisticasScreen extends StatefulWidget {
  const EstadisticasScreen({super.key});

  @override
  State<EstadisticasScreen> createState() =>
      _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  List<Habito> habitos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarEstadisticas();
  }

  Future<void> cargarEstadisticas() async {
    final lista = await PreferenciasService.obtenerHabitos();

    if (!mounted) return;

    setState(() {
      habitos = lista;
      cargando = false;
    });
  }

  int calcularRacha(Habito habito) {
    if (habito.fechasCompletado.isEmpty) {
      return 0;
    }

    final fechas = habito.fechasCompletado.toSet();
    DateTime fecha = DateTime.now();

    String formatoFecha(DateTime fecha) {
      final mes = fecha.month.toString().padLeft(2, '0');
      final dia = fecha.day.toString().padLeft(2, '0');

      return '${fecha.year}-$mes-$dia';
    }

    // Si hoy no está completado, la racha puede terminar ayer.
    if (!fechas.contains(formatoFecha(fecha))) {
      fecha = fecha.subtract(const Duration(days: 1));
    }

    int racha = 0;

    while (fechas.contains(formatoFecha(fecha))) {
      racha++;
      fecha = fecha.subtract(const Duration(days: 1));
    }

    return racha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
      ),
      body: cargando
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : habitos.isEmpty
          ? const Center(
        child: Text('Todavía no tienes hábitos.'),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Estadísticas de tus hábitos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...habitos.map((habito) {
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(habito.color),
                ),
                title: Text(habito.nombre),
                subtitle: Text(
                  'Días completados: '
                      '${habito.fechasCompletado.toSet().length}\n'
                      'Racha actual: '
                      '${calcularRacha(habito)} días',
                ),
                isThreeLine: true,
              ),
            );
          }),
        ],
      ),
    );
  }
}