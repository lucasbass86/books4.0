import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCarouselWidget extends StatelessWidget {
  final List<Libro> libros;
  const BookCarouselWidget({super.key, required this.libros});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: CarouselView(
        backgroundColor: Utils.colorScaffold,
        itemExtent: double.infinity,
        scrollDirection: Axis.horizontal,
        shrinkExtent: 100,
        overlayColor: WidgetStatePropertyAll(Utils.bottom.withAlpha(170)),
        enableSplash: false,
        itemSnapping: true,
        padding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: (value) => showModalBottomSheet(
          backgroundColor: Colors.transparent,
          enableDrag: true,
          isScrollControlled: true,
          context: context,
          builder: (context) =>
              BottomContainerWidget(libro: libros[value], currentRoute: MainPage.routeName),
        ),
        children: [
          ...libros.map(
            (libro) => ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: InteractiveViewer(
                clipBehavior: Clip.hardEdge,
                minScale: 1,
                maxScale: 5,
                child:
                    //  Image.network(
                    //   fit: BoxFit.fitWidth,
                    //   Utils.getImgURL(libro.codigo),
                    //   frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    //     return child;
                    //   },
                    //   loadingBuilder: (context, child, loadingProgress) {
                    //     if (loadingProgress == null) {
                    //       return child;
                    //     } else {
                    //       return Center(
                    //         child: CircularProgressIndicator(color: Utils.circulo4),
                    //       );
                    //     }
                    //   },
                    // ),
                    CachedNetworkImage(
                  imageUrl: Utils.getImgURL(libro.codigo),
                  fit: BoxFit.fitWidth,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Utils.circulo4,
                    ),
                  ),
                  errorWidget: (context, url, error) => Utils.noImage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
