import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchingWidget extends StatelessWidget {
  const SearchingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(child: SvgPicture.asset('assets/svg/searching.svg')),
          const SizedBox(height: 30),
          Text(
            'Buscando . . .',
            style: TextStyle(
                color: Utils.secondTextStyle.color, fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
