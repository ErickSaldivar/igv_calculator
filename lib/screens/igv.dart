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
  late final TextEditingController sinIgv;
  late final TextEditingController igv;
  late final TextEditingController conIgv;
  late final FocusNode sinFocus;
  late final FocusNode conFocus;
  IgvProvider? _provider;
  VoidCallback? _listener;
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    sinIgv = TextEditingController();
    igv = TextEditingController();
    conIgv = TextEditingController();
    sinFocus = FocusNode();
    conFocus = FocusNode();

    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Adhelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newProvider = Provider.of<IgvProvider>(context, listen: false);
    if (_provider != newProvider) {
      if (_provider != null && _listener != null) {
        _provider!.removeListener(_listener!);
      }
      _provider = newProvider;
      _listener = () {
        if (!mounted || _provider == null) return;
        if (!sinFocus.hasFocus) {
          sinIgv.text = _provider!.sinIgv == 0.0 ? '' : _provider!.sinIgv.toStringAsFixed(2);
        }
        igv.text = _provider!.igv == 0.0 ? '' : _provider!.igv.toStringAsFixed(2);
        if (!conFocus.hasFocus) {
          conIgv.text = _provider!.conIgv == 0.0 ? '' : _provider!.conIgv.toStringAsFixed(2);
        }
      };
      _provider!.addListener(_listener!);
    }
  }

  @override
  void dispose() {
    if (_provider != null && _listener != null) {
      _provider!.removeListener(_listener!);
    }
    sinIgv.dispose();
    igv.dispose();
    conIgv.dispose();
    sinFocus.dispose();
    conFocus.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
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
          const SizedBox(height: 45),
          if (_isAdLoaded && _bannerAd != null)
            SizedBox(
              height: 250,
              width: 300,
              child: AdWidget(ad: _bannerAd!),
            ),
          const SizedBox(height: 20),
        ],
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
          if (c.text.isEmpty) return;
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
