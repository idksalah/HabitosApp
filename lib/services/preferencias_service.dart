import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasService {
  static const String claveNombre = 'nombre';
  static const String claveObjetivo = 'objetivo';

  static Future<void> guardarDatosUsuario(
      String nombre,
      int objetivo,
      ) async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setString(claveNombre, nombre);
    await preferencias.setInt(claveObjetivo, objetivo);
  }
}