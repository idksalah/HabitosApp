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
  static Future<String?> obtenerNombre() async {
    final preferencias = await SharedPreferences.getInstance();

    return preferencias.getString(claveNombre);
  }

  static Future<int?> obtenerObjetivo() async {
    final preferencias = await SharedPreferences.getInstance();

    return preferencias.getInt(claveObjetivo);
  }
  static Future<bool> hayDatosUsuario() async {
    String? nombre = await obtenerNombre();
    int? objetivo = await obtenerObjetivo();

    return nombre != null &&
        nombre.isNotEmpty &&
        objetivo != null &&
        objetivo > 0;
  }
}