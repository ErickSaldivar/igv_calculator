import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    String infoText =
        '''Esta aplicacion únicamente ayuda a hacer cálculos de impuestos, recuerde que para tener datos precisos debe consultar con un profesional contable, el uso de esta aplicacion para calcular sus impuestos, es netamente de su responsabilidad y usted renuncia a cualquier tipo de demanda al equipo desarrollador por el uso de esta aplicacion.
Valores actualizados al 2026.''';
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Divider(),
                Text(
                  'TÉRMINOS DE USO',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(infoText, textAlign: TextAlign.justify),
                ),
                Divider(),
                Text("Calculador IGV - Renta ver. 2.0"),
                Text(
                  "Gracias por usar nuestra app, invítanos un café para seguir desarrollando más aplicaciones.",
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Image.asset("assets/yape.jpeg"),
                ),
                Text("Contacto: natsatengineerandsoftware@gmail.com"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
