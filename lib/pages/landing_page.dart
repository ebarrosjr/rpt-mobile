import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rptmobile/common/imagem_redonda.dart';
import 'package:rptmobile/styles/image_asset.dart';
import 'package:rptmobile/styles/colors.dart';
import 'package:rptmobile/styles/text_styles.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;
    final alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(larguraTela * 0.2, 0),
            child: Image.asset(logo),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.menu, color: principalTexto),
                      Icon(Icons.search, color: branco)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 0 , top: 16),
                        child: Row(
                          children: <Widget>[
                            ImagemRedondaWidget(imagePath: minhaFoto, isOnline: true, ranking: 15, showRanking: true),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Olá',
                                      style: userNameOla
                                    ),
                                    TextSpan(text: '\n'),
                                    TextSpan(text: "Everton", style: userNameStyle)
                                  ]
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 16, top: 16),
                        child: Material(
                          elevation: 4,
                          borderRadius: BorderRadius.all( Radius.circular(12) ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, top: 16, right: 16, bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "Solicitações realizadas"
                                      ), 
                                    )
                                  ],
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  '247 solicitações',
                                  style: solicitacoesFeitas,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}