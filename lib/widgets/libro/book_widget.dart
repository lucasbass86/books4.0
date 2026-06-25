import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class BookWidget extends StatelessWidget {
  final Libro libro;
  final bool isFromCollection;
  const BookWidget({super.key, required this.libro, this.isFromCollection = false});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    late IconData icon;
    Servicio servicio = Provider.of<Servicio>(context, listen: false);
    Categoria categoria = servicio.categorias.firstWhere((c) => c.id == libro.categoriaId);
    List<CollectionBook> collectionsBook =
        servicio.collectionsBooks.where((c) => c.idLibro == libro.codigo.toString()).toList();
    CollectionBook? actualCollection;
    if (collectionsBook.isNotEmpty) {
      actualCollection = collectionsBook[0];
    }

    if (libro.leido == 'NO' && libro.fechInicio.isEmpty) {
      icon = Icons.book_rounded;
    } else if (libro.leido == 'NO' && libro.fechInicio.isNotEmpty) {
      icon = Icons.menu_book_rounded;
    } else if (servicio.siguientes.contains(libro)) {
      icon = Icons.bookmarks_rounded;
    }
    Leyendo? leyendo = Preferences.isLeyendo(libro.codigo);

    return Bounceable(
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
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        height: 160,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Utils.circulo2,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: Utils.circulo1),
          ),
          child: Row(
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Hero(
                  tag: 'libro${libro.codigo}',
                  child:
                      //  Image.network(
                      //   width: 90,
                      //   fit: BoxFit.fitWidth,
                      //   Utils.getImgURL(libro.codigo),
                      //   frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
                      //   loadingBuilder: (context, child, loadingProgress) {
                      //     if (loadingProgress == null) {
                      //       return Stack(
                      //         children: [
                      //           child,
                      //           if (actualCollection != null && isFromCollection)
                      //             Positioned(
                      //               top: 0,
                      //               left: 0,
                      //               child: Container(
                      //                 padding: const EdgeInsets.symmetric(horizontal: 5),
                      //                 decoration: BoxDecoration(
                      //                   color: Utils.colorDot.withAlpha(230),
                      //                   borderRadius:
                      //                       BorderRadius.only(bottomRight: Radius.circular(10)),
                      //                 ),
                      //                 child: Text(
                      //                   actualCollection.orden,
                      //                   style: TextStyle(fontSize: 20, color: Utils.circulo2),
                      //                 ),
                      //               ),
                      //             )
                      //         ],
                      //       );
                      //     } else {
                      //       return SizedBox(
                      //         width: 90,
                      //         child: Center(
                      //           child: CircularProgressIndicator(color: Utils.circulo4),
                      //         ),
                      //       );
                      //     }
                      //   },
                      //   errorBuilder: (context, error, stackTrace) => Utils.noImage,
                      // ),
                      CachedNetworkImage(
                    imageUrl: Utils.getImgURL(libro.codigo),
                    width: 90,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => SizedBox(
                      width: 90,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Utils.circulo4,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Utils.noImage,
                    imageBuilder: (context, imageProvider) {
                      return Stack(
                        children: [
                          Image(
                            image: imageProvider,
                            width: 90,
                            fit: BoxFit.fitWidth,
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
                                    fontSize: 20,
                                    color: Utils.circulo2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Text(libro.titulo,
                                  style:
                                      TextStyle(fontSize: 15, color: Colors.white.withAlpha(200))),
                            ),
                            CustomInkWell(
                              onLongPress: () {
                                String? routeName = ModalRoute.of(context)!.settings.name;
                                if (routeName != AutorPage.routeName) {
                                  Navigator.pushNamed(context, AutorPage.routeName,
                                      arguments: libro.autor);
                                }
                              },
                              child: Text(libro.autor,
                                  style:
                                      TextStyle(fontSize: 13, color: Colors.white.withAlpha(200)),
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text('${libro.paginas} páginas', style: Utils.thirdTextStyle),
                            Expanded(child: SizedBox(height: 1)),
                            LabelCatogorieColorWidget(
                                categoria: categoria, currentRoute: currentRoute!),
                          ],
                        ),
                      ),
                    ),
                    if (libro.leido == 'NO' && libro.fechInicio.isEmpty)
                      BounceInUp(child: Icon(icon)),
                    if (libro.leido == 'NO' && libro.fechInicio.isNotEmpty)
                      CircularProgressWidget(
                        currentValue: leyendo?.paginas ?? 0,
                        totalValue: libro.paginas,
                        progressColor: Utils.getCategoryColor(libro.categoria),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
