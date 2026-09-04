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
  String _impSeleccionado = '';
  Key _dropDownKey = UniqueKey();
  final TextEditingController valorVentas = TextEditingController();
  final TextEditingController valorCompras = TextEditingController();
  final FocusNode focusVentas = FocusNode();
  final FocusNode focusCompras = FocusNode();
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Adhelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Failed to load a Banner Ad: ${error.message}");
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              _isAdLoaded = false;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    valorCompras.dispose();
    valorVentas.dispose();
    focusVentas.dispose();
    focusCompras.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    final provider = context.watch<ImpuestosProvider>();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 300,
              height: _impSeleccionado == "ESPECIAL" ? 85.4 : 60,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    key: _dropDownKey,
                    items: const [
                      DropdownMenuItem(value: 'NRUS', child: Text('NUEVO RUS')),
                      DropdownMenuItem(
                        value: 'ESPECIAL',
                        child: Text('REGIMEN ESPECIAL'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _impSeleccionado = value ?? '';
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Seleccione el Régimen',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(124, 141, 159, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(124, 141, 159, 1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(124, 141, 159, 1),
                          width: 2,
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: Colors.white,
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    firstChild: const SizedBox(),
                    secondChild: const Text("Ingrese valores sin IGV"),
                    crossFadeState: _impSeleccionado == 'ESPECIAL'
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            TextFieldModelo(
              w: w,
              label: "Valor Ventas",
              textController: valorVentas,
              focusNode: focusVentas,
              isEnabled: true,
              onChanged: null,
            ),
            const SizedBox(height: 10),
            TextFieldModelo(
              w: w,
              label: "Valor Compras",
              textController: valorCompras,
              focusNode: focusCompras,
              isEnabled: true,
              onChanged: null,
            ),
            const SizedBox(height: 10),
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
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Consultar"),
              ),
            ),
            const SizedBox(height: 15),
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
                child: const Text("Limpiar Valores"),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  width: w * 0.35,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: const Border.symmetric(
                      vertical: BorderSide(
                        color: Color.fromRGBO(124, 141, 159, 1),
                        width: 1,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text("Resultados"),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _impSeleccionado.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              ? "S/. ${provider.impPagar.toStringAsFixed(0)}.00"
                              : _impSeleccionado == "ESPECIAL"
                              ? "S/. ${provider.igvPagar.toStringAsFixed(0)}.00"
                              : "",
                        ),
                        if (_impSeleccionado == "ESPECIAL")
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOut,
                            width: w * 0.4,
                            height: 130,
                            child: AnimatedCard(
                              w: w * 0.4,
                              label: "Pagar Renta:",
                              monto:
                                  "S/. ${provider.rentaPagar.toStringAsFixed(0)}.00",
                            ),
                          ),
                      ],
                    ),
                  )
                : const Text("Esperando Consulta . . ."),
            const SizedBox(height: 20),
            if (_isAdLoaded && _bannerAd != null)
              SizedBox(
                height: 100,
                width: 320,
                child: AdWidget(ad: _bannerAd!),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
