import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

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
        children: [
          ...libros.map(
            (libro) => Bounceable(
              onTap: () => showModalBottomSheet(
                backgroundColor: Colors.transparent,
                enableDrag: true,
                isScrollControlled: true,
                context: context,
                builder: (context) =>
                    BottomContainerWidget(libro: libro, currentRoute: MainPage.routeName),
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: InteractiveViewer(
                  clipBehavior: Clip.hardEdge,
                  minScale: 1,
                  maxScale: 5,
                  child: CachedNetworkImage(
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
          ),
        ],
      ),
    );
  }
}
