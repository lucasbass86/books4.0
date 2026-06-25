import 'package:animate_do/animate_do.dart';
import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class TagsBook extends StatefulWidget {
  final Libro libro;
  const TagsBook({super.key, required this.libro});

  @override
  State<TagsBook> createState() => _TagsBookState();
}

class _TagsBookState extends State<TagsBook> {
  Etiqueta? _etiquetaExpandida;
  late Servicio servicio;

  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context, listen: false);
    final etiquetaBooks =
        servicio.etiquetasBooks.where((c) => c.idLibro == widget.libro.codigo.toString()).toList();

    if (etiquetaBooks.isEmpty) {
      return const SizedBox.shrink();
    }

    final etiquetas = servicio.etiquetas
        .where((e) => etiquetaBooks.map((x) => x.idEtiqueta).contains(e.id))
        .toList();

    return ZoomIn(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Utils.colorEtiqueta,
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: const BoxConstraints(
                minHeight: 70,
              ),
              child: GestureDetector(
                onTap: () => setState(() {
                  if (_etiquetaExpandida != null) {
                    _etiquetaExpandida = null;
                  } else {
                    _etiquetaExpandida = etiquetas[0];
                  }
                }),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Etiquetas',
                            style: Utils.secondTextStyle.copyWith(color: Utils.colorCard)),
                        Icon(
                            _etiquetaExpandida != null
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: Utils.colorCard)
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 42,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: etiquetas.length,
                        itemBuilder: (context, index) {
                          final Etiqueta etiqueta = etiquetas[index];
                          final bool estaExpandida = _etiquetaExpandida?.id == etiqueta.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Bounceable(
                              onTap: () {
                                setState(() {
                                  if (estaExpandida) {
                                    _etiquetaExpandida = null;
                                  } else {
                                    _etiquetaExpandida = etiqueta;
                                  }
                                });
                              },
                              child: _TagWidget(etiqueta: etiqueta),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_etiquetaExpandida != null) _buildLibrosRelacionados(_etiquetaExpandida!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibrosRelacionados(Etiqueta etiqueta) {
    final relaciones =
        servicio.etiquetasBooks.where((rel) => rel.idEtiqueta == etiqueta.id).toList();
    final librosRelacionados = servicio.libros
        .where((lib) => relaciones.any((r) => r.idLibro == lib.codigo.toString()))
        .toList();
    if (librosRelacionados.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text("No se encontraron otros libros con esta etiqueta", style: Utils.mainTextStyle),
      );
    }
    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: librosRelacionados.length,
                itemBuilder: (context, index) {
                  return LibroHomeWidget(libro: librosRelacionados[index], isFromTag: true);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${librosRelacionados.length} libros', style: Utils.thirdTextStyle),
                CustomInkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, EtiquetaPage.routeName, arguments: etiqueta),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Text('Mostrar', textAlign: TextAlign.right, style: Utils.thirdTextStyle),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagWidget extends StatelessWidget {
  final Etiqueta etiqueta;
  const _TagWidget({required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Utils.circulo2,
        borderRadius: BorderRadius.circular(Utils.radiusCircular),
      ),
      child: Center(
        child: Text(etiqueta.descripcion,
            style: Utils.secondTextStyle
                .copyWith(color: Utils.colorCard, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
