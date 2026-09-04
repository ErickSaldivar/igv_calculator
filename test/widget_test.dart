import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igv_calculator/providers/igv_provider.dart';
import 'package:igv_calculator/providers/impuestos_provider.dart';
import 'package:igv_calculator/providers/per_natural_provider.dart';

void main() {
  group('IgvProvider Tests', () {
    test('Calcula IGV correctamente desde subtotal sin IGV', () {
      final provider = IgvProvider();
      provider.actualizarDesdeSinIgv('100.00');

      expect(provider.sinIgv, 100.0);
      expect(provider.igv, closeTo(18.0, 0.001));
      expect(provider.conIgv, closeTo(118.0, 0.001));
    });

    test('Calcula IGV correctamente desde total con IGV', () {
      final provider = IgvProvider();
      provider.actualizarDesdeConIgv('118.00');

      expect(provider.conIgv, 118.0);
      expect(provider.sinIgv, closeTo(100.0, 0.001));
      expect(provider.igv, closeTo(18.0, 0.001));
    });

    test('Limpiar valores restablece a cero', () {
      final provider = IgvProvider();
      provider.actualizarDesdeSinIgv('100.00');
      provider.limpiar();

      expect(provider.sinIgv, 0.0);
      expect(provider.igv, 0.0);
      expect(provider.conIgv, 0.0);
    });
  });

  group('ImpuestosProvider Tests', () {
    testWidgets('Calcula NRUS etapa 2 (hasta 5000) correctamente',
        (WidgetTester tester) async {
      final provider = ImpuestosProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              provider.impuestoNrus(context, '4500', '3000');
              return Container();
            },
          ),
        ),
      );

      expect(provider.impPagar, 20.0);
    });

    testWidgets('Calcula NRUS etapa 1 (hasta 8000) correctamente',
        (WidgetTester tester) async {
      final provider = ImpuestosProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              provider.impuestoNrus(context, '7500', '4000');
              return Container();
            },
          ),
        ),
      );

      expect(provider.impPagar, 50.0);
    });

    test('Calcula Régimen Especial correctamente', () {
      final provider = ImpuestosProvider();
      provider.impuestoEspecial('10000', '6000');

      expect(provider.igvPagar, closeTo(720.0, 0.001)); // (10000 - 6000) * 0.18
      expect(provider.rentaPagar, closeTo(150.0, 0.001)); // 10000 * 0.015
    });

    test('Régimen Especial con compras mayores a ventas no produce IGV negativo', () {
      final provider = ImpuestosProvider();
      provider.impuestoEspecial('5000', '8000');

      expect(provider.igvPagar, 0.0);
      expect(provider.rentaPagar, closeTo(75.0, 0.001));
    });
  });

  group('PerNaturalProvider Tests', () {
    test('Calcula renta bruta y neta correctamente', () {
      final provider = PerNaturalProvider();
      provider.setIngresosCuarta('30000');
      provider.setIngresosQuinta('25000');
      provider.setDeducciones('0');
      provider.setRetenciones('0');

      expect(provider.rentaBruta, 55000);
      // 55000 - 7 * 5500 = 55000 - 38500 = 16500
      expect(provider.rentaNeta, 16500);
      // 16500 * 0.08 = 1320
      expect(provider.rentaPagar, 1320);
    });

    test('Resta retenciones correctamente', () {
      final provider = PerNaturalProvider();
      provider.setIngresosCuarta('30000');
      provider.setIngresosQuinta('25000');
      provider.setDeducciones('0');
      provider.setRetenciones('500');

      expect(provider.rentaPagar, 820);
    });
  });
}
