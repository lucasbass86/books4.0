import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class LibroHomeWidget extends StatefulWidget {
  final Libro libro;
  final CollectionBook? collectionBook;
  final bool isFromTag;
  const LibroHomeWidget(
      {super.key, required this.libro, this.collectionBook, this.isFromTag = false});

  @override
  State<LibroHomeWidget> createState() => _LibroHomeWidgetState();
}

class _LibroHomeWidgetState extends State<LibroHomeWidget> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () => setState(() => isPressed = !isPressed),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Stack(
                children: [
                  Hero(
                    tag: 'libro${widget.libro.codigo}',
                    child: CachedNetworkImage(
                      imageUrl: Utils.getImgURL(widget.libro.codigo),
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Utils.circulo4,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, error, stackTrace) => Utils.noImage,
                    ),
                  ),
                  if ((widget.collectionBook != null || widget.isFromTag) &&
                      widget.libro.leido == 'NO')
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: BounceInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Utils.colorDot,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
                          ),
                          child: Icon(Icons.menu_book_rounded, size: 17),
                        ),
                      ),
                    ),
                  if (widget.collectionBook != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Utils.colorDot.withAlpha(230),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                        ),
                        child: Text(
                          widget.collectionBook!.orden.toString(),
                          style: TextStyle(fontSize: 30, color: Utils.circulo2),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            reverseDuration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: isPressed
                ? Container(
                    width: 200,
                    margin: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Utils.radiusCircular),
                        topRight: Radius.circular(Utils.radiusCircular),
                        bottomRight: Radius.circular(Utils.radiusCircular),
                      ),
                      color: Utils.colorContainer,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.libro.titulo,
                          style: Utils.secondTextStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Text(widget.libro.autor, style: Utils.thirdTextStyle),
                        Expanded(child: const SizedBox(height: 20)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(context, LibroPage.routeName,
                                arguments: widget.libro),
                            child: Text(
                              '+ Info',
                              style: TextStyle(color: Utils.colorDot, fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
