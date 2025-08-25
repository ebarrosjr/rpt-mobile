import 'package:flutter/material.dart';
import 'package:rptmobile/widgets/link_menu.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0),
      color: Color.fromARGB(255, 8, 44, 73),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 64,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/logo_branco.png',
            width: 150,
          ),
          SizedBox(
            height: 50,
          ),
          LinkMenu(label: "Resumo", link: () => {}),
          LinkMenu(label: "Meu Perfil", link: () => {}),
          LinkMenu(label: "Grupos de Pesquisa", link: () => {}),
          LinkMenu(label: "Orçamentos", link: () => {}),
          LinkMenu(label: "Solicitações", link: () => {}),
          LinkMenu(label: "Notícias", link: () => {}),
        ],
      ),
    );
  }
}
