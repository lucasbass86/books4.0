import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotFoundWidget extends StatelessWidget {
  final String title;
  const NotFoundWidget({super.key, this.title = 'Ningún resultado'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 30,
        children: [
          Expanded(child: SvgPicture.asset(Utils.urlNotFound)),
          Text(
            title,
            style: TextStyle(
                color: Utils.secondTextStyle.color, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
