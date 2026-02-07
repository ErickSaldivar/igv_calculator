import 'package:flutter/material.dart';

class PerNaturalProvider extends ChangeNotifier {
  final int _valorUIT = 5500;
  double _ingresosCuarta = 0.0;
  double _ingresosQuinta = 0.0;
  int _itf = 0;
  int _retenciones = 0;

  //Getters
  int get valorUIT => _valorUIT;
  double get ingresosCuarta => _ingresosCuarta;
  double get ingresosQuinta => _ingresosQuinta;

  // Propiedades derivadas
  int get _rentaBruta => _ingresosCuarta.toInt() + _ingresosQuinta.toInt();
  int get _rentaNeta => _rentaBruta - (7 * _valorUIT) - _itf.toInt();
  int get _rentaPagar => (_rentaNeta * 0.08).toInt() - _retenciones;

  int get rentaBruta => _rentaBruta;
  int get rentaNeta => _rentaNeta;
  int get rentaPagar => _rentaPagar;

  // Setters
  void setIngresosCuarta(String ingresos) {
    _ingresosCuarta = double.tryParse(ingresos) ?? 0.0;
    notifyListeners();
  }

  void setIngresosQuinta(String ingresos) {
    _ingresosQuinta = double.tryParse(ingresos) ?? 0.0;
    notifyListeners();
  }

  void setDeducciones(String deducciones) {
    _itf = int.tryParse(deducciones) ?? 0;
    notifyListeners();
  }

  void setRetenciones(String retenciones) {
    _retenciones = int.tryParse(retenciones) ?? 0;
    notifyListeners();
  }

  int calcularRentaBruta() {
    return _rentaBruta;
  }

  int calcularRentaNeta() {
    return _rentaNeta;
  }

  int calcularRentaPagar() {
    return _rentaPagar;
  }

  void reset() {
    _ingresosCuarta = 0.0;
    _ingresosQuinta = 0.0;
    _itf = 0;
    _retenciones = 0;
    notifyListeners();
  }
}
