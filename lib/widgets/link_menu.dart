import 'package:flutter/material.dart';

class LinkMenu extends StatelessWidget {
  final String label;
  final GestureTapCallback link;

  const LinkMenu({
    super.key,
    required this.label,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: link,
      child: Container(
        margin: EdgeInsets.only(
          top: 5,
        ),
        padding: EdgeInsets.all(8),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
