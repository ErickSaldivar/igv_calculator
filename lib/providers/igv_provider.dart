import 'package:flutter/material.dart';

class IgvProvider extends ChangeNotifier {
  final double _tasaIgv = 0.18;

  double _sinIgv = 0.0;
  double _igv = 0.0;
  double _conIgv = 0.0;

  // Getters
  double get sinIgv => _sinIgv;
  double get igv => _igv;
  double get conIgv => _conIgv;

  // Set desde Subtotal
  void actualizarDesdeSinIgv(String valor) {
    double parsed = double.tryParse(valor) ?? 0.0;
    _sinIgv = parsed;
    _igv = _sinIgv * _tasaIgv;
    _conIgv = _sinIgv + _igv;
    notifyListeners();
  }

  // Set desde Total
  void actualizarDesdeConIgv(String valor) {
    double parsed = double.tryParse(valor) ?? 0.0;
    _conIgv = parsed;
    _sinIgv = _conIgv / (1 + _tasaIgv);
    _igv = _conIgv - _sinIgv;
    notifyListeners();
  }

  void limpiar() {
    _sinIgv = 0.0;
    _igv = 0.0;
    _conIgv = 0.0;
    notifyListeners();
  }
}
