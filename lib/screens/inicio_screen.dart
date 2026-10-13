import 'package:flutter/material.dart';

import '../models/habito.dart';
import '../services/preferencias_service.dart';
import '../widgets/tarjeta_habito.dart';

class InicioScreen extends StatefulWidget {
  final String nombre;
  final int objetivo;

  const InicioScreen({super.key, required this.nombre, required this.objetivo});

  @override
  State<InicioScreen> createState() {
    return _InicioScreenState();
  }
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
    List<Habito> lista = await PreferenciasService.obtenerHabitos();

    if (!mounted) return;

    setState(() {
      habitos = lista;
      cargando = false;
    });
  }

  Future<void> guardarNuevoHabito(String nombre) async {
    Habito nuevoHabito = Habito(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      color: Colors.green.value,
    );

    List<Habito> nuevaLista = List.from(habitos);
    nuevaLista.add(nuevoHabito);

    await PreferenciasService.guardarHabitos(nuevaLista);

    if (!mounted) return;

    setState(() {
      habitos = nuevaLista;
    });
  }

  void mostrarFormulario() {
    TextEditingController nombreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo hábito'),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: 'Nombre del hábito'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String nombre = nombreController.text.trim();

                if (nombre.isEmpty) {
                  return;
                }

                await guardarNuevoHabito(nombre);

                if (!context.mounted) return;

                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis hábitos')),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text(
                  '¡Hola, ${widget.nombre}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Objetivo diario: ${widget.objetivo} hábitos'),
                Expanded(
                  child: habitos.isEmpty
                      ? const Center(child: Text('Todavía no tienes hábitos'))
                      : ListView.builder(
                          itemCount: habitos.length,
                          itemBuilder: (context, index) {
                            return TarjetaHabito(habito: habitos[index]);
                          },
                        ),
                ),
              ],
            ),

      // Botón para añadir hábitos
      floatingActionButton: FloatingActionButton(
        onPressed: mostrarFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}
