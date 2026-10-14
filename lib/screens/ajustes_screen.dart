
import 'package:flutter/material.dart';
import '../services/preferencias_service.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Apariencia',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          ValueListenableBuilder<ThemeMode>(
            valueListenable: PreferenciasService.temaActual,
            builder: (context, tema, child) {
              return SwitchListTile(
                title: const Text('Tema oscuro'),
                subtitle: const Text(
                  'Cambiar entre el tema claro y el oscuro',
                ),
                secondary: const Icon(Icons.dark_mode),
                value: tema == ThemeMode.dark,
                onChanged: (oscuro) {
                  PreferenciasService.guardarTema(oscuro);
                },
              );
            },
          ),

          const Divider(),

          ValueListenableBuilder<double>(
            valueListenable: PreferenciasService.tamanoLetra,
            builder: (context, tamano, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.format_size),
                    title: Text('Tamaño de letra'),
                    subtitle: Text(
                      'Ajusta el tamaño del texto de la aplicación',
                    ),
                  ),
                  Slider(
                    value: tamano,
                    min: 0.8,
                    max: 1.4,
                    divisions: 6,
                    label: '${(tamano * 100).round()}%',
                    onChanged: (valor) {
                      PreferenciasService.guardarTamanoLetra(valor);
                    },
                  ),
                  Text(
                    'Tamaño actual: ${(tamano * 100).round()}%',
                  ),
                ],
              );
            },
          ),

          const Divider(),

          ValueListenableBuilder<bool>(
            valueListenable:
            PreferenciasService.ocultarCompletados,
            builder: (context, ocultar, child) {
              return SwitchListTile(
                title: const Text(
                  'Ocultar hábitos completados',
                ),
                subtitle: const Text(
                  'No mostrar los hábitos que ya has completado hoy',
                ),
                secondary: const Icon(Icons.visibility_off),
                value: ocultar,
                onChanged: (valor) {
                  PreferenciasService.guardarOcultarCompletados(
                    valor,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}