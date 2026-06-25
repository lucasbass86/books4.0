import 'dart:ui';

import 'package:books4/models/models.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BottomContainerWidget extends StatelessWidget {
  final Libro libro;
  final String currentRoute;
  const BottomContainerWidget({super.key, required this.libro, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    // final DraggableScrollableController sheetController = DraggableScrollableController();
    // sheetController.addListener(() {
    //   if (sheetController.size >= 0.99) {
    //     Navigator.pop(context);
    //     Navigator.pushNamed(context, LibroPage.routeName, arguments: libro);
    //     sheetController.removeListener(() {});
    //   }
    // });
    return DraggableScrollableSheet(
      // controller: sheetController,
      initialChildSize: libro.leido == 'SI' ? 0.75 : 0.55,
      minChildSize: 0.2,
      maxChildSize: 1.0,
      expand: false,
      // snapSizes: const [0.4, 0.8, 1.0],
      builder: (BuildContext context, ScrollController scrollController) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: LibroDataWidget(
              libro: libro,
              currentRoute: currentRoute,
              scrollController: scrollController,
            ),
          ),
        );
      },
    );
  }
}
