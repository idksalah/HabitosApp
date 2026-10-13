import '../services/preferencias_service.dart';

import 'package:flutter/material.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() {
    return _BienvenidaScreenState();
  }
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController objetivoController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    objetivoController.dispose();
    super.dispose();
  }

  Future<void> continuar() async {
    String nombre = nombreController.text.trim();
    String objetivo = objetivoController.text;

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes introducir tu nombre')),
      );
    } else if (objetivo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes introducir tu objetivo diario')),
      );
    } else {
      int? numeroObjetivo = int.tryParse(objetivo);

      if (numeroObjetivo == null || numeroObjetivo <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Introduce un número entero mayor que cero'),
          ),
        );
      } else {
        await PreferenciasService.guardarDatosUsuario(nombre, numeroObjetivo);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados correctamente')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HabitosApp')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido a HabitosApp',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Organiza tus hábitos diarios'),
              const SizedBox(height: 30),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: objetivoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Objetivo diario de habitos',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: continuar,
                child: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
