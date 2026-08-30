import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:igv_calculator/models/adhelper.dart';
import 'package:igv_calculator/providers/impuestos_provider.dart';
import 'package:igv_calculator/utils/animated_card.dart';
import 'package:igv_calculator/utils/tf_models.dart';
import 'package:provider/provider.dart';

class Impuestos extends StatefulWidget {
  const Impuestos({super.key});

  @override
  State<Impuestos> createState() => _ImpuestosState();
}

class _ImpuestosState extends State<Impuestos> {
  late String _impSeleccionado;
  Key _dropDownKey = UniqueKey();
  TextEditingController valorVentas = TextEditingController();
  TextEditingController valorCompras = TextEditingController();
  late ImpuestosProvider _provider;
  late FocusNode focusVentas;
  late FocusNode focusCompras;
  BannerAd? _bannerAd;

  @override
  void initState() {
    _impSeleccionado = '';
    _provider = Provider.of<ImpuestosProvider>(context, listen: false);
    focusVentas = FocusNode();
    focusCompras = FocusNode();

    BannerAd(
      adUnitId: Adhelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Failed to load a Banner Ad: ${error.message}");
          ad.dispose();
        },
      ),
    ).load();
    super.initState();
  }

  @override
  void dispose() {
    valorCompras.dispose();
    valorVentas.dispose();
    focusVentas.dispose();
    focusCompras.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 300,
                height: _impSeleccionado == "ESPECIAL" ? 85.4 : 60,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      key: _dropDownKey,
                      items: [
                        DropdownMenuItem(
                          value: 'NRUS',
                          child: Text('NUEVO RUS'),
                        ),
                        DropdownMenuItem(
                          value: 'ESPECIAL',
                          child: Text('REGIMEN ESPECIAL'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _impSeleccionado = value as String;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Seleccione el Régimen',
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(124, 141, 159, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(124, 141, 159, 1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(124, 141, 159, 1),
                            width: 2,
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      dropdownColor: Colors.white,
                    ),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 300),
                      firstChild: SizedBox(),
                      secondChild: Text("Ingrese valores sin IGV"),
                      crossFadeState: _impSeleccionado == 'ESPECIAL'
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFieldModelo(
                w: w,
                label: "Valor Ventas",
                textController: valorVentas,
                focusNode: focusVentas,
                isEnabled: true,
                onChanged: null,
              ),
              SizedBox(height: 10),
              TextFieldModelo(
                w: w,
                label: "Valor Compras",
                textController: valorCompras,
                focusNode: focusCompras,
                isEnabled: true,
                onChanged: null,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    if (valorCompras.text.isNotEmpty &&
                        valorVentas.text.isNotEmpty &&
                        _impSeleccionado.isNotEmpty) {
                      if (_impSeleccionado == "NRUS") {
                        context.read<ImpuestosProvider>().impuestoNrus(
                          context,
                          valorVentas.text,
                          valorCompras.text,
                        );
                      } else {
                        context.read<ImpuestosProvider>().impuestoEspecial(
                          valorVentas.text,
                          valorCompras.text,
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AwesomeSnackbarContent(
                            title: "Error",
                            message:
                                "Ingresa revisa los valores y selecciona un Régimen",
                            contentType: ContentType.warning,
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                    FocusScope.of(context).unfocus();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    //padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Consultar"),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ImpuestosProvider>().limpiar();
                    valorCompras.clear();
                    valorVentas.clear();
                    focusCompras.unfocus();
                    focusVentas.unfocus();
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _impSeleccionado = '';
                      _dropDownKey = UniqueKey();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("Limpiar Valores"),
                ),
              ),
              SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Container(
                    width: w * 0.35,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color: Color.fromRGBO(124, 141, 159, 1),
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text("Resultados"),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _impSeleccionado.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: _impSeleccionado == "NRUS"
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceEvenly,
                        children: [
                          AnimatedCard(
                            w: w * 0.4,
                            label: _impSeleccionado == "NRUS"
                                ? "Impuesto a Pagar:"
                                : _impSeleccionado == "ESPECIAL"
                                ? "Pagar IGV:"
                                : "",
                            monto: _impSeleccionado == "NRUS"
                                ? "S/. ${_provider.impPagar.toStringAsFixed(0)}.00"
                                : _impSeleccionado == "ESPECIAL"
                                ? "S/. ${_provider.igvPagar.toStringAsFixed(0)}.00"
                                : "",
                          ),
                          _impSeleccionado == "ESPECIAL"
                              ? Visibility(
                                  visible: _impSeleccionado == "ESPECIAL",
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 1000),
                                    curve: Curves.easeOut,
                                    width: w * 0.4,
                                    height: 130,
                                    child: AnimatedCard(
                                      w: w * 0.4,
                                      label: "Pagar Renta:",
                                      monto:
                                          "S/. ${_provider.rentaPagar.toStringAsFixed(0)}.00",
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    )
                  : Text("Esperando Consulta . . ."),
              SizedBox(height: 20),
              _bannerAd == null
                  ? SizedBox()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: AdWidget(ad: _bannerAd!),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
