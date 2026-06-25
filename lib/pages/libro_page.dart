import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LibroPage extends StatefulWidget {
  static const routeName = 'LibroPage';
  const LibroPage({super.key});

  @override
  State<LibroPage> createState() => _LibroPageState();
}

class _LibroPageState extends State<LibroPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Libro libro;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true); // Repite hacia arriba y abajo

    _animation = Tween<double>(begin: -10, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    libro = ModalRoute.of(context)!.settings.arguments as Libro;
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Scaffold(
      body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.globalPosition.dx < 30) {
              Navigator.pop(context);
            }
          },
          child:
              //  CustomScrollView(
              //   slivers: [
              //     SliverAppBar(
              //       expandedHeight: 370,
              //       automaticallyImplyLeading: false,
              //       backgroundColor: Utils.colorScaffold,
              //       flexibleSpace: FlexibleSpaceBar(
              //         background: Column(
              //           children: [
              //             TopWigdet(title: libro.titulo, showBack: true),
              //             const SizedBox(height: 20),
              //             _headerData(context),
              //           ],
              //         ),
              //       ),
              //     ),
              //     SliverFillRemaining(
              //       fillOverscroll: false,
              //       hasScrollBody: true,
              //       child: LibroDataWidget(libro: libro, currentRoute: currentRoute!),
              //     )
              //   ],
              // ),
              NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 370,
                        automaticallyImplyLeading: false,
                        backgroundColor: Utils.colorScaffold,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Column(
                            children: [
                              TopWigdet(title: libro.titulo, showBack: true),
                              const SizedBox(height: 20),
                              _headerData(context),
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  body: LibroDataWidget(libro: libro, currentRoute: currentRoute!))),
    );
  }

  Widget _headerData(BuildContext context) {
    final String url = Utils.getImgURL(libro.codigo);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: 250,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, ImagePage.routeName, arguments: url),
        child: Center(
          child: Hero(
            tag: 'libro${libro.codigo}',
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_animation.value),
                  child: child,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child:
                    //  FadeInImage(
                    //   fit: BoxFit.fill,
                    //   placeholder: Utils.noImage.image,
                    //   image: NetworkImage(url),
                    // ),
                    CachedNetworkImage(
                  imageUrl: Utils.getImgURL(libro.codigo),
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Utils.circulo4,
                    ),
                  ),
                  errorWidget: (context, error, stackTrace) => Utils.noImage,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
