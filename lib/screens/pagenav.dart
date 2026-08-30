import 'package:flutter/material.dart';
import 'package:igv_calculator/screens/cronograma.dart';
import 'package:igv_calculator/screens/igv.dart';
import 'package:igv_calculator/screens/imp_persona_natural.dart';
import 'package:igv_calculator/screens/impuestos.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:igv_calculator/screens/info.dart';

class Pagenav extends StatefulWidget {
  const Pagenav({super.key});

  @override
  State<Pagenav> createState() => _PagenavState();
}

class _PagenavState extends State<Pagenav> {
  int currentIndexTab = 0;
  late PageController _pageController;

  List<Widget> pages = [
    const Igv(),
    const Impuestos(),
    const ImpPersonaNatural(),
    const Cronograma(),
    const Info(),
  ];
  List<String> titles = [
    'Calculadora de IGV',
    'Impuesto NRUS y ESPECIAL',
    'Impuesto Persona Natural',
    'Cronograma de Vencimientos',
    'Acerca de la Aplicación',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndexTab);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF081034),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: AppBar(
              title: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                key: Key(titles[currentIndexTab]),
                child: Text(
                  titles[currentIndexTab],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
          ),
        ),

        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: pages,
          onPageChanged: (index) {
            setState(() {
              currentIndexTab = index;
            });
          },
        ),
        bottomNavigationBar: GNav(
          tabs: [
            GButton(icon: Icons.account_balance_rounded, text: 'IGV'),
            GButton(icon: Icons.calculate_rounded, text: 'Impuestos'),
            GButton(icon: Icons.person_rounded, text: "Persona Natural"),
            GButton(icon: Icons.calendar_month_rounded, text: "Cronograma"),
            GButton(icon: Icons.info_outline_rounded, text: "Info"),
          ],

          selectedIndex: currentIndexTab,
          onTabChange: (index) {
            setState(() {
              currentIndexTab = index;
            });
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },

          backgroundColor: Color(0xffffffff),
          activeColor: Color(0xFF081034),
          color: Color.fromRGBO(124, 141, 159, 1),
          tabActiveBorder: Border.all(color: Color(0xFF081034), width: 1),
          tabMargin: EdgeInsets.symmetric(vertical: 5),
          textStyle: TextStyle(fontWeight: FontWeight.bold),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          textSize: 13,
        ),
      ),
    );
  }
}
