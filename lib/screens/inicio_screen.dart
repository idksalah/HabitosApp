
import 'package:flutter/material.dart';
import 'package:habitos_app/screens/estadisticas_screen.dart';
import '../models/habito.dart';
import '../services/preferencias_service.dart';
import 'package:habitos_app/screens/ajustes_screen.dart';
import '../widgets/tarjeta_habito.dart';
import 'editar_habito_screen.dart';

class InicioScreen extends StatefulWidget {
  final String nombre;
  final int objetivo;

  const InicioScreen({
    super.key,
    required this.nombre,
    required this.objetivo,
  });

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  List<Habito> habitos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarHabitos();
  }

  Future<void> cargarHabitos() async {
    final lista = await PreferenciasService.obtenerHabitos();

    if (!mounted) return;

    setState(() {
      habitos = lista;
      cargando = false;
    });
  }

  String obtenerFechaHoy() {
    final hoy = DateTime.now();
    final mes = hoy.month.toString().padLeft(2, '0');
    final dia = hoy.day.toString().padLeft(2, '0');

    return '${hoy.year}-$mes-$dia';
  }

  int obtenerCompletadosHoy() {
    final hoy = obtenerFechaHoy();

    return habitos.where((habito) {
      return habito.fechasCompletado.contains(hoy);
    }).length;
  }

  Future<void> cambiarCompletado(
      Habito habito,
      bool completado,
      ) async {
    final hoy = obtenerFechaHoy();

    if (completado) {
      if (!habito.fechasCompletado.contains(hoy)) {
        habito.fechasCompletado.add(hoy);
      }
    } else {
      habito.fechasCompletado.remove(hoy);
    }

    await PreferenciasService.guardarHabitos(habitos);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> guardarNuevoHabito(String nombre) async {
    final nuevoHabito = Habito(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      color: Colors.green.toARGB32(),
    );

    final nuevaLista = List<Habito>.from(habitos);
    nuevaLista.add(nuevoHabito);

    await PreferenciasService.guardarHabitos(nuevaLista);

    if (!mounted) return;

    setState(() {
      habitos = nuevaLista;
    });
  }

  Future<void> mostrarFormulario() async {
    final controlador = TextEditingController();

    final nombre = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo hábito'),
          content: TextField(
            controller: controlador,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nombre del hábito',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final texto = controlador.text.trim();

                if (texto.isNotEmpty) {
                  Navigator.pop(context, texto);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    controlador.dispose();

    if (nombre == null || nombre.isEmpty) return;

    await guardarNuevoHabito(nombre);
  }

  Future<void> editarHabito(Habito habito) async {
    final resultado = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarHabitoScreen(
          nombre: habito.nombre,
          color: habito.color,
        ),
      ),
    );

    // Si se cancela, no modificamos nada.
    if (!mounted || resultado == null) return;

    final nuevoNombre = resultado['nombre'] as String;
    final nuevoColor = resultado['color'] as int;

    setState(() {
      habito.nombre = nuevoNombre;
      habito.color = nuevoColor;
    });

    await PreferenciasService.guardarHabitos(habitos);
  }

  Future<void> eliminarHabito(Habito habito) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar hábito'),
          content: Text(
            '¿Quieres eliminar "${habito.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    final nuevaLista = List<Habito>.from(habitos);
    nuevaLista.removeWhere(
          (elemento) => elemento.id == habito.id,
    );

    await PreferenciasService.guardarHabitos(nuevaLista);

    if (!mounted) return;

    setState(() {
      habitos = nuevaLista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis hábitos'),
      ),
      body: cargando
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '¡Hola, ${widget.nombre}!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Objetivo diario: ${widget.objetivo} hábitos',
                ),
                const SizedBox(height: 8),
                Text(
                  'Progreso de hoy: '
                      '${obtenerCompletadosHoy()} / '
                      '${widget.objetivo}',
                ),
              ],
            ),
          ),
          Expanded(
            child: habitos.isEmpty
                ? const Center(
              child: Text(
                'Todavía no tienes hábitos. '
                    'Pulsa + para añadir uno.',
                textAlign: TextAlign.center,
              ),
            )
                : ListView.builder(
              itemCount: habitos.length,
              itemBuilder: (context, index) {
                final habito = habitos[index];

                return TarjetaHabito(
                  habito: habito,
                  completado: habito.fechasCompletado
                      .contains(obtenerFechaHoy()),
                  alCambiarCompletado: (completado) {
                    cambiarCompletado(
                      habito,
                      completado,
                    );
                  },
                  alEditar: () {
                    editarHabito(habito);
                  },
                  alEliminar: () {
                    eliminarHabito(habito);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: FloatingActionButton(
              heroTag: 'estadisticas',
              tooltip: 'Estadísticas',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const EstadisticasScreen(),
                  ),
                );
              },
              child: const Icon(Icons.bar_chart),
            ),
          ),
          FloatingActionButton(
            heroTag: 'nuevoHabito',
            tooltip: 'Añadir hábito',
            onPressed: mostrarFormulario,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}