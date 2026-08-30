import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:igv_calculator/models/adhelper.dart';
import 'package:igv_calculator/providers/igv_provider.dart';
import 'package:igv_calculator/utils/tf_models.dart';
import 'package:provider/provider.dart';

class Igv extends StatefulWidget {
  const Igv({super.key});

  @override
  State<Igv> createState() => _IgvState();
}

class _IgvState extends State<Igv> {
  late TextEditingController sinIgv;
  late TextEditingController igv;
  late TextEditingController conIgv;
  late FocusNode sinFocus;
  late FocusNode conFocus;
  late IgvProvider _provider;
  late VoidCallback _listener;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    sinIgv = TextEditingController();
    igv = TextEditingController();
    conIgv = TextEditingController();
    sinFocus = FocusNode();
    conFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider = Provider.of<IgvProvider>(context, listen: false);
      _listener = () {
        // Solo actualiza campos no enfocados
        if (!sinFocus.hasFocus) {
          sinIgv.text = _provider.sinIgv.toStringAsFixed(2);
        }
        // IGV es siempre de solo lectura
        igv.text = _provider.igv.toStringAsFixed(2);
        if (!conFocus.hasFocus) {
          conIgv.text = _provider.conIgv.toStringAsFixed(2);
        }
      };
      _provider.addListener(_listener);
    });

    BannerAd(
      adUnitId: Adhelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.mediumRectangle,
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
  }

  @override
  void dispose() {
    _provider.removeListener(_listener);
    sinIgv.dispose();
    igv.dispose();
    conIgv.dispose();
    sinFocus.dispose();
    conFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFieldModelo(
                  w: w,
                  label: "Monto sin IGV",
                  textController: sinIgv,
                  focusNode: sinFocus,
                  isEnabled: true,
                  onChanged: (val) =>
                      context.read<IgvProvider>().actualizarDesdeSinIgv(val),
                ),
                _botonCopiar(sinIgv),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFieldModelo(
                  w: w,
                  label: "IGV (18%)",
                  textController: igv,
                  isEnabled: false,
                  onChanged: null,
                ),
                _botonCopiar(igv),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFieldModelo(
                  w: w,
                  label: "Total con IGV",
                  textController: conIgv,
                  focusNode: conFocus,
                  isEnabled: true,
                  onChanged: (val) =>
                      context.read<IgvProvider>().actualizarDesdeConIgv(val),
                ),
                _botonCopiar(conIgv),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: w * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  context.read<IgvProvider>().limpiar();
                  sinIgv.clear();
                  igv.clear();
                  conIgv.clear();
                  FocusScope.of(context).unfocus();
                },
                child: const Text('Limpiar Valores'),
              ),
            ),
            SizedBox(height: 45),
            _bannerAd == null
                ? SizedBox()
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: AdWidget(ad: _bannerAd!),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _botonCopiar(TextEditingController c) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(124, 141, 159, 1),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: c.text));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Copiado al portapapeles')),
          );
        },
        icon: const Icon(Icons.copy_all_rounded),
        tooltip: 'Copiar',
      ),
    );
  }
}
