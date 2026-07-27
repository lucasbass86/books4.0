import 'package:animate_do/animate_do.dart';
import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/helpers/helper.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LibroDataWidget extends StatefulWidget {
  final Libro libro;
  final String currentRoute;
  final ScrollController? scrollController;
  const LibroDataWidget(
      {super.key, required this.libro, required this.currentRoute, this.scrollController});

  @override
  State<LibroDataWidget> createState() => _LibroDataWidgetState();
}

class _LibroDataWidgetState extends State<LibroDataWidget> {
  final double alturaSeparacion = 20;
  bool isInNext = false;
  late Servicio servicio;
  late Leyendo? leyendo;
  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context);
    leyendo = Preferences.isLeyendo(widget.libro.codigo);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.globalPosition.dx < 30) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Utils.colorContainer,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(Utils.radiusCircular),
              topRight: Radius.circular(Utils.radiusCircular)),
        ),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _prestado(),
              _idIconos(context),
              _titulo(),
              ExpandableWidget(
                  libro: widget.libro, type: EExpandableType.autor, icon: Utils.iconAutor),
              ExpandableWidget(
                  libro: widget.libro, type: EExpandableType.categoria, icon: Utils.iconCategoria),
              ExpandableWidget(
                  libro: widget.libro,
                  type: EExpandableType.coleccion,
                  icon: Utils.iconColecciones),
              ExpandableWidget(
                  libro: widget.libro, type: EExpandableType.editorial, icon: Utils.iconEditorial),
              TagsBook(libro: widget.libro),
              _isbnGoogleAmazon(),
              _paginasYComprado(),
              _fechas(),
              _nota(),
              _observaciones(),
              _portada(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _prestado() {
    if (widget.libro.prestado != 'SI') {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Utils.colorEtiqueta,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text('PRESTADO',
                style: Utils.mainTextStyle.copyWith(color: Utils.circulo3, fontSize: 35)),
          ),
        ),
        SizedBox(height: alturaSeparacion),
      ],
    );
  }

  Widget _idIconos(BuildContext context) {
    late IconData icon;
    if (servicio.siguientes.any((l) => l.codigo == widget.libro.codigo)) {
      icon = Icons.bookmarks_rounded;
      isInNext = true;
    } else if (widget.libro.leido == 'NO' && widget.libro.fechInicio.isEmpty) {
      icon = Icons.book_rounded;
    } else if (widget.libro.leido == 'NO' && widget.libro.fechInicio.isNotEmpty) {
      icon = Icons.menu_book_rounded;
    }
    return Row(
      spacing: 5,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID', style: Utils.secondTextStyle),
              Text(widget.libro.codigo.toString(), style: Utils.mainTextStyle),
            ],
          ),
        ),
        //LIBRO LEYENDO
        // if (widget.libro.leido == 'NO' && widget.libro.fechInicio.isNotEmpty)
        //   CustomInkWell(
        //     onTap: () => _restPages(context),
        //     child: BounceInUp(child: Icon(icon)),
        //   ),
        //LIBRO MARCABLE PARA PROXIMA LECTURA
        if (!isInNext && widget.libro.leido == 'NO' && widget.libro.fechInicio.isEmpty)
          CustomInkWell(
            onTap: () async {
              final mark = await showMessage(
                  context: context, message: '¿Marcar para siguiente lectura?', cancel: true);
              if (mark == true && context.mounted) {
                final resp = await password(context);
                if (resp[1] == Utils.password && context.mounted) {
                  servicio.setNextRead(widget.libro.codigo).then((value) {
                    if (value.type == 'INSERT' && context.mounted) {
                      showMessage(context: context, message: 'Libro agregado');
                    }
                  });
                  setState(() {});
                } else {
                  if (context.mounted) {
                    showMessage(context: context, message: 'Password incorrecto...');
                  }
                }
              }
            },
            child: BounceInUp(child: Icon(icon)),
          ),
        //LIBRO EN PROXIMA LECTURA
        if (isInNext)
          CustomInkWell(
            onTap: () async {
              final mark = await showMessage(
                  context: context, message: '¿Borrar de próxima lectura?', cancel: true);
              if (mark == true && context.mounted) {
                final resp = await password(context);
                if (resp[0] == true) {
                  if (resp[1] == Utils.password) {
                    servicio.deleteNextRead(widget.libro.codigo).then((value) {
                      if (value.type == 'DELETED' && context.mounted) {
                        showMessage(context: context, message: 'Libro eliminado');
                        Navigator.pop(context);
                      }
                    });
                    setState(() {});
                  } else {
                    if (context.mounted) {
                      showMessage(context: context, message: 'Password incorrecto...');
                    }
                  }
                }
              }
            },
            child: BounceInUp(child: Icon(icon)),
          ),
        //ABRIR PAGINA DEL LIBRO
        if (widget.currentRoute != LibroPage.routeName)
          CustomInkWell(
            onTap: () async {
              await Navigator.pushNamed(context, LibroPage.routeName, arguments: widget.libro);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: BounceInRight(
              child: Icon(Icons.fullscreen_rounded, size: 30),
            ),
          ),
        if (widget.libro.leido == 'NO' &&
            widget.libro.fechInicio.isNotEmpty &&
            widget.currentRoute == MainPage.routeName)
          CustomInkWell(
            onTap: () => Helper.restPages(context: context, libro: widget.libro, leyendo: leyendo),
            child: FadeInRight(
              child: CircularProgressWidget(
                currentValue: leyendo?.paginas ?? 0,
                totalValue: widget.libro.paginas,
                progressColor: Utils.getCategoryColor(widget.libro.categoria),
              ),
            ),
          ),
        if (widget.libro.leido == 'NO' &&
            widget.libro.fechInicio.isNotEmpty &&
            widget.currentRoute == LibroPage.routeName)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double w = constraints.maxWidth;
                return ProgressBarWidget(
                  width: w,
                  currentValue: leyendo?.paginas ?? 0,
                  maxValue: widget.libro.paginas,
                  backgroundColor: Utils.getCategoryColor(widget.libro.categoria).withAlpha(110),
                  progressColor: Utils.getCategoryColor(widget.libro.categoria),
                  textStyle: Utils.mainTextStyle,
                  valueTextStyle: Utils.mainTextStyle.copyWith(fontSize: 11),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _titulo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: alturaSeparacion),
        Text('Título', style: Utils.secondTextStyle),
        Text(widget.libro.titulo, style: Utils.mainTextStyle),
      ],
    );
  }

  Widget _observaciones() {
    if (widget.libro.observaciones.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: alturaSeparacion),
        Text('Observaciones', style: Utils.secondTextStyle),
        Text(widget.libro.observaciones, style: Utils.mainTextStyle),
      ],
    );
  }

  Widget _isbnGoogleAmazon() {
    if (widget.libro.codBarras.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(height: alturaSeparacion),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ISBN', style: Utils.secondTextStyle),
                Text(widget.libro.codBarras, style: Utils.mainTextStyle),
              ],
            ),
            SlideInDown(
              child: CustomInkWell(
                onTap: () async => await launchUrl(
                    Uri.parse('https://www.amazon.es/s?k=${widget.libro.codBarras}')),
                child: const FaIcon(FontAwesomeIcons.amazon, size: Utils.iconSize),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paginasYComprado() {
    return Column(
      children: [
        SizedBox(height: alturaSeparacion),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Páginas', style: Utils.secondTextStyle),
                Text(widget.libro.paginas.toString(), style: Utils.mainTextStyle),
              ],
            ),
            if (widget.libro.fechCompra.isNotEmpty && widget.libro.fechCompra != '  /  /')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comprado', style: Utils.secondTextStyle),
                  Text(widget.libro.fechCompra, style: Utils.mainTextStyle),
                ],
              ),
            if (widget.libro.precio != 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Precio', style: Utils.secondTextStyle),
                  Text('${widget.libro.precio.toStringAsFixed(2)}€', style: Utils.mainTextStyle),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _fechas() {
    if (widget.libro.fechInicio.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(height: alturaSeparacion),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.libro.fechInicio.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Iniciado', style: Utils.secondTextStyle),
                  Text(widget.libro.fechInicio, style: Utils.mainTextStyle),
                ],
              ),
            if (widget.libro.fechFin.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Acabado', style: Utils.secondTextStyle),
                  Text(widget.libro.fechFin, style: Utils.mainTextStyle),
                ],
              ),
            if (widget.libro.fechInicio.isNotEmpty && widget.libro.fechFin.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Duración', style: Utils.secondTextStyle),
                  Text(Utils.dateInterval(widget.libro.fechInicio, widget.libro.fechFin),
                      style: Utils.mainTextStyle),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _portada() {
    if (widget.scrollController == null) {
      return SizedBox.shrink();
    }
    return BounceInUp(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Hero(
                tag: 'libro${widget.libro.codigo}',
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 7,
                  child: GestureDetector(
                    onLongPress: () => Navigator.pushNamed(context, ImagePage.routeName,
                        arguments: Utils.getImgURL(widget.libro.codigo)),
                    child: Image.network(
                      fit: BoxFit.fitWidth,
                      Utils.getImgURL(widget.libro.codigo),
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) => Utils.noImage,
                      // errorBuilder: (context, error, stackTrace) =>
                      //     Image.asset('assets/no_image.jpg', width: 200, height: 300),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(child: CircularProgressIndicator(color: Utils.circulo4));
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nota() {
    if (widget.libro.nota == -1 || widget.libro.leido == 'NO') {
      return SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.only(top: alturaSeparacion),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text('Nota', style: Utils.secondTextStyle),
              Text(widget.libro.nota.toString(), style: Utils.mainTextStyle),
            ],
          ),
          RatingBar.builder(
            initialRating: widget.libro.nota,
            itemSize: 21,
            minRating: 0,
            maxRating: 10,
            ignoreGestures: true,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 10,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {},
          ),
        ],
      ),
    );
  }
}
