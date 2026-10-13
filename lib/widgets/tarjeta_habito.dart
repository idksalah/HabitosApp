
import 'package:flutter/material.dart';
import '../models/habito.dart';

class TarjetaHabito extends StatelessWidget {
  final Habito habito;

  const TarjetaHabito({
    super.key,
    required this.habito,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(habito.color),
        ),
        title: Text(habito.nombre),
        subtitle: Text(
          'Días completados: ${habito.fechasCompletado.length}',
        ),
      ),
    );
  }
}