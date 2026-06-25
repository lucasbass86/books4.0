import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LibroSmallWidget extends StatelessWidget {
  final Libro libro;
  final bool isFromCollection;
  const LibroSmallWidget({super.key, required this.libro, this.isFromCollection = false});

  @override
  Widget build(BuildContext context) {
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    final currentRoute = ModalRoute.of(context)?.settings.name;
    double rounded = 0;
    List<CollectionBook> collectionsBook =
        servicio.collectionsBooks.where((c) => c.idLibro == libro.codigo.toString()).toList();
    CollectionBook? actualCollection;
    if (collectionsBook.isNotEmpty) {
      actualCollection = collectionsBook[0];
    }
    switch (Preferences.zoom) {
      case 1:
        rounded = 25;
        break;
      case 2:
        rounded = 20;
        break;
      case 3:
        rounded = 15;
        break;
      case 4:
        rounded = 7;
        break;
    }
    return GestureDetector(
      onLongPress: () => Navigator.pushNamed(context, LibroPage.routeName, arguments: libro),
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          enableDrag: true,
          isScrollControlled: true,
          context: context,
          builder: (context) => BottomContainerWidget(libro: libro, currentRoute: currentRoute!),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        height: Utils.cardheight,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(rounded),
              child: Hero(
                tag: 'libro${libro.codigo}',
                child:
                    //  Image.network(
                    //   fit: BoxFit.cover,
                    //   Utils.getImgURL(libro.codigo),
                    //   frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
                    //   loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
                    //       ? Stack(
                    //           children: [
                    //             child,
                    //             if (actualCollection != null && isFromCollection)
                    //               Positioned(
                    //                 top: 0,
                    //                 left: 0,
                    //                 child: Container(
                    //                   padding: const EdgeInsets.symmetric(horizontal: 5),
                    //                   decoration: BoxDecoration(
                    //                     color: Utils.colorDot.withAlpha(230),
                    //                     borderRadius:
                    //                         BorderRadius.only(bottomRight: Radius.circular(10)),
                    //                   ),
                    //                   child: Text(
                    //                     actualCollection.orden,
                    //                     style: TextStyle(fontSize: rounded, color: Utils.circulo2),
                    //                   ),
                    //                 ),
                    //               )
                    //           ],
                    //         )
                    //       : Center(
                    //           child: CircularProgressIndicator(color: Utils.circulo4),
                    //         ),
                    // ),
                    Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: Utils.getImgURL(libro.codigo),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Utils.noImage,
                    ),
                    if (actualCollection != null && isFromCollection)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Utils.colorDot.withAlpha(230),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            actualCollection.orden,
                            style: TextStyle(
                              fontSize: rounded,
                              color: Utils.circulo2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
