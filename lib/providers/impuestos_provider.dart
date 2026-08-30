import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class ImpuestosProvider extends ChangeNotifier {
  final double _tasaIGV = 0.18;
  final double _tasaRenta = 0.015;

  double _ventas = 0.0;
  double _compras = 0.0;
  double _igvPagar = 0.0;
  double _rentaPagar = 0.0;
  double _impPagar = 0.0;
  final double _limite = 525000.0;
  final double _limite1 = 5000.0;
  final double _limite2 = 8000.0;

  //Getters
  double get ventas => _ventas;
  double get compras => _compras;
  double get igvPagar => _igvPagar;
  double get rentaPagar => _rentaPagar;
  double get impPagar => _impPagar;
  double get limite => _limite;
  double get limite1 => _limite1;
  double get limite2 => _limite2;

  // Set desde Impuestos de NRUS
  void impuestoNrus(BuildContext context, String ventas, String compras) {
    _ventas = double.tryParse(ventas) ?? 0.0;
    _compras = double.tryParse(compras) ?? 0.0;

    //bool out = _ventas < 8000 && _compras < 8000;
    bool etapa1 =
        (_ventas <= 8000 && _compras <= 8000) &&
        (_ventas >= 0 && _compras >= 0);
    bool etapa2 = _ventas <= 5000 && _compras <= 5000;

    if (etapa1) {
      if (etapa2) {
        _impPagar = 20.0;
        return;
      }
      _impPagar = 50.0;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message:
                "Los valores estan fuera de Rango. \nNo corresponde este régimen.",
            contentType: ContentType.failure,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    notifyListeners();
  }

  // Set desde Impuesto Especial
  void impuestoEspecial(String ventas, String compras) {
    double diferencia = 0;
    _ventas = double.tryParse(ventas) ?? 0;
    _compras = double.tryParse(compras) ?? 0;
    diferencia = (_ventas - _compras);
    _igvPagar = (diferencia) * _tasaIGV;
    _rentaPagar = _ventas * _tasaRenta;
    debugPrint("$_rentaPagar");
    notifyListeners();
  }

  void limpiar() {
    _ventas = 0.0;
    _compras = 0.0;
    _impPagar = 0.0;
    _igvPagar = 0.0;
    _rentaPagar = 0.0;
    notifyListeners();
  }
}
