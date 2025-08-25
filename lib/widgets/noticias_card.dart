import 'package:flutter/material.dart';
import 'package:rptmobile/Models/noticias.dart';

class NoticiasCard extends StatelessWidget {
  final Noticia noticia;
  const NoticiasCard({super.key, required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 35,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF1a456d),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(
              '${noticia.data.day.toString().padLeft(2, '0')}/'
              '${noticia.data.month.toString().padLeft(2, '0')}/'
              '${noticia.data.year}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  noticia.titulo,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(noticia.lead),
                SizedBox(height: 5),
                Text(
                  noticia.usuarioName,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
