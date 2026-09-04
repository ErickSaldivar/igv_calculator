import 'package:flutter/material.dart';
import 'package:igv_calculator/providers/per_natural_provider.dart';
import 'package:igv_calculator/utils/animated_card.dart';
import 'package:igv_calculator/utils/tf_models.dart';
import 'package:provider/provider.dart';

class ImpPersonaNatural extends StatefulWidget {
  const ImpPersonaNatural({super.key});

  @override
  State<ImpPersonaNatural> createState() => _ImpPersonaNaturalState();
}

class _ImpPersonaNaturalState extends State<ImpPersonaNatural> {
  final TextEditingController ingresosCuarta = TextEditingController();
  final TextEditingController ingresosQuinta = TextEditingController();
  final TextEditingController deducciones = TextEditingController();
  final TextEditingController retenciones = TextEditingController();

  @override
  void dispose() {
    ingresosCuarta.dispose();
    ingresosQuinta.dispose();
    deducciones.dispose();
    retenciones.dispose();
    super.dispose();
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  void _resetFields() {
    ingresosCuarta.clear();
    ingresosQuinta.clear();
    deducciones.clear();
    retenciones.clear();
    FocusScope.of(context).unfocus();
  }

  Widget _buildInputWithInfo(
    double w,
    String label,
    TextEditingController controller,
    Function(String) onChanged,
    String infoText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFieldModelo(
          w: w,
          label: label,
          textController: controller,
          isEnabled: true,
          onChanged: onChanged,
        ),
        const SizedBox(width: 5),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
          onPressed: () => _showInfoDialog(label, infoText),
          tooltip: "Más información",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final provider = context.watch<PerNaturalProvider>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Renta Cuarta y Quinta Categoría",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Ingresos año actual",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildInputWithInfo(
                w,
                "Ingreso anual 4ta categoría",
                ingresosCuarta,
                (value) => provider.setIngresosCuarta(value),
                "Suma de todos tus recibos por honorarios emitidos en el año.",
              ),
              const SizedBox(height: 10),
              _buildInputWithInfo(
                w,
                "Ingreso anual 5ta categoría",
                ingresosQuinta,
                (value) => provider.setIngresosQuinta(value),
                "Suma de todos tus ingresos por planilla (sueldos, gratificaciones, etc.) en el año.",
              ),
              const SizedBox(height: 10),
              _buildInputWithInfo(
                w,
                "Deducciones sobre 5ta categoría",
                deducciones,
                (value) => provider.setDeducciones(value),
                "Monto de deducciones adicionales (hasta 3 UIT) más ITF que reducen tu base imponible.",
              ),
              const SizedBox(height: 10),
              _buildInputWithInfo(
                w,
                "Retenciones sobre 5ta categoría",
                retenciones,
                (value) => provider.setRetenciones(value),
                "Impuestos que ya te han sido retenidos por tu empleador o pagos a cuenta realizados.",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedCard(
                    w: w * 0.4,
                    label: "Ingresos\nTotales",
                    monto: 'S/. ${provider.rentaBruta}',
                  ),
                  AnimatedCard(
                    w: w * 0.4,
                    label: "Ingresos -\n7 UIT",
                    monto:
                        'S/. ${provider.rentaNeta >= 0 ? provider.rentaNeta : "0"}',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: w * 0.9,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: const Color.fromRGBO(124, 141, 159, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "RENTA A PAGAR",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "S/. ${provider.rentaPagar >= 0 ? provider.rentaPagar.toStringAsFixed(2) : "0"}",
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -14,
                      top: -14,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
                        onPressed: () => _showInfoDialog(
                          "Renta a Pagar",
                          "Este es el monto estimado de impuesto a pagar después de considerar tus ingresos, deducciones y retenciones.",
                        ),
                        tooltip: "Más información",
                      ),
                    ),
                    Positioned(
                      right: -11,
                      bottom: -10,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.blueGrey,
                          size: 40,
                        ),
                        onPressed: () {
                          _resetFields();
                          provider.reset();
                        },
                        tooltip: "Limpiar valores",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
