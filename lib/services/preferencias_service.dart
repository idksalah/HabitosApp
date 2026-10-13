
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habito.dart';

class PreferenciasService {
  static const String claveNombre = 'nombre';
  static const String claveObjetivo = 'objetivo';
  static const String claveHabitos = 'habitos';

  // Guarda el nombre y el objetivo del usuario.
  static Future<void> guardarDatosUsuario(
      String nombre,
      int objetivo,
      ) async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setString(claveNombre, nombre);
    await preferencias.setInt(claveObjetivo, objetivo);
  }

  // Recupera el nombre del usuario.
  static Future<String?> obtenerNombre() async {
    final preferencias = await SharedPreferences.getInstance();

    return preferencias.getString(claveNombre);
  }

  // Recupera el objetivo diario.
  static Future<int?> obtenerObjetivo() async {
    final preferencias = await SharedPreferences.getInstance();

    return preferencias.getInt(claveObjetivo);
  }

  // Comprueba si los datos del usuario son válidos.
  static Future<bool> hayDatosUsuario() async {
    String? nombre = await obtenerNombre();
    int? objetivo = await obtenerObjetivo();

    return nombre != null &&
        nombre.isNotEmpty &&
        objetivo != null &&
        objetivo > 0;
  }

  // Guarda la lista de hábitos.
  static Future<void> guardarHabitos(List<Habito> habitos) async {
    final preferencias = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> listaJson = [];

    for (Habito habito in habitos) {
      listaJson.add(habito.toJson());
    }

    String textoJson = jsonEncode(listaJson);

    await preferencias.setString(claveHabitos, textoJson);
  }

  // Recupera la lista de hábitos.
  static Future<List<Habito>> obtenerHabitos() async {
    final preferencias = await SharedPreferences.getInstance();

    String? textoJson = preferencias.getString(claveHabitos);

    if (textoJson == null) {
      return [];
    }

    List<dynamic> listaJson = jsonDecode(textoJson);
    List<Habito> habitos = [];

    for (dynamic elemento in listaJson) {
      Habito habito = Habito.fromJson(
        Map<String, dynamic>.from(elemento),
      );

      habitos.add(habito);
    }

    return habitos;
  }
}