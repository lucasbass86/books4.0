import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/dialogs/modals.dart';
import 'package:books4/providers/mainprovider.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ListaPage extends StatefulWidget {
  static const String routeName = 'ListaPage';
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  bool isExpanded = false;
  final Curve curve = Curves.ease;
  TextEditingController searchController = TextEditingController(text: Preferences.search);
  late Servicio servicio;
  late MainProvider mainProvider;
  late ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    servicio = Provider.of<Servicio>(context, listen: false);
    mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
      floatingActionButton: Preferences.typeView != ETypeView.portada ? _fab() : null,
      body: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          appBar(),
          sliverLibros(context),
        ],
      ),
    );
  }

  Widget _fab() {
    return ScrollVisibilityWidget(
      controller: scrollController,
      child: ScrollToHideWidget(
        controller: scrollController,
        height: 50,
        withAnimatedOpacity: true,
        child: FloatingActionButton(
          backgroundColor: Utils.bottom,
          mini: true,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
          onPressed: () {
            scrollController.position.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear,
            );
          },
          child: Icon(Icons.keyboard_arrow_up_rounded),
        ),
      ),
    );
  }

  Widget appBar() {
    return SliverAppBar(
      pinned: false,
      expandedHeight: 230,
      backgroundColor: Utils.colorScaffold,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            TopWigdet(title: 'Libros'),
            _top(),
          ],
        ),
      ),
    );
  }

  Widget sliverLibros(BuildContext context) {
    return servicio.filter.isEmpty
        ? const SliverFillRemaining(
            child: NotFoundWidget(),
          )
        : ListaLibrosSliverWidget(libros: servicio.filter);
  }

  Widget _top() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: TextFormField(
                  controller: searchController,
                  maxLines: 1,
                  style: Utils.mainTextStyle,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    Preferences.search = value;
                    servicio.getFilter();
                  },
                  decoration: InputDecoration(
                    prefixIconColor: Utils.circulo1,
                    fillColor: Utils.circulo1.withAlpha(50),
                    filled: true,
                    hintText: "Buscar libros...",
                    hintStyle: TextStyle(fontSize: 13, color: Utils.circulo1),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Utils.circulo3),
                        borderRadius: BorderRadius.circular(20)),
                    prefixIcon: Icon(Utils.iconSearch),
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              searchController.text = '';
                              Preferences.search = '';
                              servicio.getFilter();
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                ),
              ),
              Container(
                height: 65,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  color: Utils.circulo1.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Utils.circulo1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomInkWell(
                      onTap: () => showModalTypeView(context),
                      child: Icon(Utils.iconView, size: Utils.iconSize),
                    ),
                    CustomInkWell(
                      onTap: () async {
                        final filter =
                            await filterDialogLibros(context, filter: Preferences.typeFilter);
                        if (filter != null) {
                          Preferences.typeFilter = filter;
                        }
                        servicio.getFilter();
                      },
                      child: const Icon(Utils.iconFilter, size: Utils.iconSize),
                    ),
                    CustomInkWell(
                      onTap: () {
                        orderDialogLibros(context).then((value) {
                          servicio.getFilter();
                        });
                      },
                      child: const Icon(Utils.iconOrder, size: Utils.iconSize),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 5,
                children: [
                  Icon(Icons.bookmark_rounded),
                  Text('Mi biblioteca', style: TextStyle(color: Utils.circulo3)),
                ],
              ),
              CustomInkWell(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Utils.colorContainer,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        height: 200,
                        child: Column(
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Libros leídos'),
                            LayoutBuilder(
                              builder: (context, constraints) => ProgressBarWidget(
                                width: constraints.maxWidth,
                                currentValue:
                                    servicio.filter.where((l) => l.leido == 'SI').toList().length,
                                maxValue: servicio.filter.length,
                                backgroundColor: Utils.colorCard,
                                progressColor: Utils.colorEtiqueta,
                                textStyle: Utils.mainTextStyle,
                                showCurrentValue: true,
                                showValues: true,
                                showRestValue: true,
                                valueTextStyle: Utils.mainTextStyle.copyWith(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  spacing: 5,
                  children: [
                    Text('${servicio.filter.length} libros',
                        style: TextStyle(color: Utils.circulo1)),
                    Icon(Icons.info_outline_rounded, size: 17),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
