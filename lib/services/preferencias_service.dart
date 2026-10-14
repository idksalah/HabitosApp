
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habito.dart';

class PreferenciasService {
  static const String claveNombre = 'nombre';
  static const String claveObjetivo = 'objetivo';
  static const String claveHabitos = 'habitos';

  static const String claveTemaOscuro = 'temaOscuro';
  static const String claveTamanoLetra = 'tamanoLetra';
  static const String claveOcultarCompletados =
      'ocultarCompletados';

  static final ValueNotifier<ThemeMode> temaActual =
  ValueNotifier(ThemeMode.light);

  static final ValueNotifier<double> tamanoLetra =
  ValueNotifier(1.0);

  static final ValueNotifier<bool> ocultarCompletados =
  ValueNotifier(false);

  static Future<void> cargarAjustes() async {
    final preferencias = await SharedPreferences.getInstance();

    final temaOscuro =
        preferencias.getBool(claveTemaOscuro) ?? false;

    final tamanoGuardado =
        preferencias.getDouble(claveTamanoLetra) ?? 1.0;

    final ocultarGuardado =
        preferencias.getBool(claveOcultarCompletados) ?? false;

    temaActual.value =
    temaOscuro ? ThemeMode.dark : ThemeMode.light;

    tamanoLetra.value = tamanoGuardado;
    ocultarCompletados.value = ocultarGuardado;
  }

  static Future<void> guardarTema(bool oscuro) async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setBool(claveTemaOscuro, oscuro);

    temaActual.value =
    oscuro ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> guardarTamanoLetra(double tamano) async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setDouble(claveTamanoLetra, tamano);
    tamanoLetra.value = tamano;
  }

  static Future<void> guardarOcultarCompletados(
      bool ocultar,
      ) async {
    final preferencias = await SharedPreferences.getInstance();

    await preferencias.setBool(claveOcultarCompletados, ocultar);
    ocultarCompletados.value = ocultar;
  }

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
    final nombre = await obtenerNombre();
    final objetivo = await obtenerObjetivo();

    return nombre != null &&
        nombre.isNotEmpty &&
        objetivo != null &&
        objetivo > 0;
  }

  static Future<void> guardarHabitos(
      List<Habito> habitos,
      ) async {
    final preferencias = await SharedPreferences.getInstance();

    final listaJson = <Map<String, dynamic>>[];

    for (final habito in habitos) {
      listaJson.add(habito.toJson());
    }

    final textoJson = jsonEncode(listaJson);

    await preferencias.setString(claveHabitos, textoJson);
  }

  static Future<List<Habito>> obtenerHabitos() async {
    final preferencias = await SharedPreferences.getInstance();
    final textoJson = preferencias.getString(claveHabitos);

    if (textoJson == null) return [];

    final List<dynamic> listaJson = jsonDecode(textoJson);
    final List<Habito> habitos = [];

    for (final elemento in listaJson) {
      final habito = Habito.fromJson(
        Map<String, dynamic>.from(elemento),
      );

      habitos.add(habito);
    }

    return habitos;
  }
}