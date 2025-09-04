import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rptmobile/Controllers/plataformas_controller.dart';
import 'package:rptmobile/Models/plataformas.dart';
import 'package:rptmobile/Services/api.dart';
import 'package:rptmobile/widgets/h1.dart';
import 'package:rptmobile/widgets/panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double xoffset;
  late double yoffset;
  late double scaleFactor;
  late bool isDrawerOpen;
  late IconData icon;

  @override
  void initState() {
    xoffset = 0;
    yoffset = 0;
    scaleFactor = 1;
    isDrawerOpen = false;
    icon = Icons.menu_sharp;
    super.initState();
    Get.find<PlataformasController>().loadPlataformas();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xoffset, yoffset, 0)
        ..scale(scaleFactor),
      duration: Duration(milliseconds: 250),
      color: Colors.white,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      xoffset = isDrawerOpen ? 0 : 230;
                      yoffset = isDrawerOpen ? 0 : 150;
                      scaleFactor = isDrawerOpen ? 1 : 0.75;
                      isDrawerOpen = isDrawerOpen ? false : true;
                      icon = isDrawerOpen
                          ? Icons.arrow_back_ios
                          : Icons.menu_sharp;
                    });
                  },
                  icon: Icon(icon),
                ),
                Column(
                  children: [
                    Text(
                      "Nome do seu grupo de pesquisa",
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Row(children: [Text("Grupo externo"), Text(" - UFF")]),
                  ],
                ),
                CircleAvatar(),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 173, 212, 218),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 12),
                  Text("Buscar serviço ou equipamento"),
                ],
              ),
            ),
            H1(titulo: "Conheça nossas Plataformas"),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 70,
              child: FutureBuilder<List<Plataforma>>(
                future: Api.getPlataformas(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(255, 236, 245, 255),
                          ),
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: 12),
                          alignment: Alignment.center,
                          child: SvgPicture.network(
                            "http://plataformas.local/img/${(snapshot.data![index].icone ?? 'ico_rpt.svg')}",
                            width: 50,
                            height: 50,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            H1(titulo: "Resumo"),
            Row(
              children: [
                Panel(titulo: "Crédito Fiocruz", bgColor: Color(0xE10C324B)),
              ],
            ),
            Row(
              children: [
                Panel(titulo: "Crédito Financeiro", bgColor: Color(0xE00C4B2B)),
                VerticalDivider(width: 10),
                Panel(titulo: "Crédito em Insumos", bgColor: Color(0xDF9E7722)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
