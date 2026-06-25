import 'package:books4/models/models.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/services/servicio.dart';
import 'package:books4/utils/utils.dart';
import 'package:books4/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPage extends StatefulWidget {
  static const String routeName = 'ChartPage';
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late Servicio provider;
  static const String leidoPendiente = 'Leídos / Pendientes';
  static const String leidosPorAnio = 'Leídos por año';
  static const String autores = 'Autores';
  static const String categorias = 'Categorías';
  static const String compradosAnio = 'Comprados por año';
  static const String precios = 'Precios';
  static const String preciosCategoria = 'Precios por categoría';
  static const String compradosLeidosAnio = 'Comprados / Leídos';
  static const String todos = 'Todos';
  static const String leidos = 'Leídos';
  static const String pendientes = 'Pendientes';
  static const String total = 'Total';
  static const String sinAsignar = 'Sin asignar';
  static const String si = 'Sí';
  static const String no = 'No';
  static const String sinFecha = 'SIN FECHA';
  List<String> years = [];
  late List<String> elementos = [
    leidoPendiente,
    leidosPorAnio,
    categorias,
    autores,
    compradosAnio,
    precios,
    preciosCategoria,
    compradosLeidosAnio,
  ];
  late String filter = elementos[0];
  late String selectedYear;
  DataLabelSettings dataLabelSettings = DataLabelSettings(
    isVisible: true,
    textStyle: Utils.secondTextStyle,
    color: Utils.colorContainer,
  );
  BorderRadius borderRadius =
      const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5));
  bool chartColumns = true;
  Categoria? categoria;
  final Map<int, String> meses = {
    1: 'ENE',
    2: 'FEB',
    3: 'MAR',
    4: 'ABR',
    5: 'MAY',
    6: 'JUN',
    7: 'JUL',
    8: 'AGO',
    9: 'SEP',
    10: 'OCT',
    11: 'NOV',
    12: 'DIC',
  };
  final orden = {
    'ENE': 1,
    'FEB': 2,
    'MAR': 3,
    'ABR': 4,
    'MAY': 5,
    'JUN': 6,
    'JUL': 7,
    'AGO': 8,
    'SEP': 9,
    'OCT': 10,
    'NOV': 11,
    'DIC': 12
  };

  @override
  void initState() {
    super.initState();
    provider = Provider.of<Servicio>(context, listen: false);

    //OBTENER LOS AÑOS:
    for (Libro l in provider.libros) {
      if (l.fechCompra.isNotEmpty) {
        String y = l.fechCompra.substring(6, 10);
        if (!years.contains(y)) {
          years.add(y);
        }
      } else {
        if (!years.contains(sinFecha)) {
          years.add(sinFecha);
        }
      }
    }
    years.sort((a, b) => b.compareTo(a));
    years.insert(0, todos);

    selectedYear = years[0];
  }

  final List<Color> colores = [
    Utils.circulo4,
    Utils.circulo2,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 30) {
            Navigator.pop(context);
          }
        },
        child: CustomScrollView(
          slivers: [
            _appBar(),
            _graphic(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return SliverAppBar(
      pinned: false,
      expandedHeight: filter == preciosCategoria ? 300 : 255,
      backgroundColor: Utils.colorScaffold,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
          background: Column(
        children: [
          TopWigdet(title: 'Estadísticas', showBack: true),
          _filter(),
        ],
      )),
    );
  }

  Widget _filter() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Utils.colorCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: filter,
                elevation: 16,
                iconSize: 30,
                style: TextStyle(
                  color: Utils.colorEtiquetaTexto,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Utils.circulo4,
                onChanged: (String? value) {
                  setState(() {
                    filter = value!;
                    selectedYear = todos;
                  });
                },
                items: elementos.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (filter == leidosPorAnio ||
                  filter == compradosAnio ||
                  filter == autores ||
                  filter == categorias ||
                  filter == precios ||
                  filter == preciosCategoria ||
                  filter == compradosLeidosAnio)
                DropdownButton<String>(
                  value: selectedYear,
                  elevation: 16,
                  iconSize: 30,
                  style: TextStyle(
                    color: Utils.colorEtiquetaTexto,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(20),
                  dropdownColor: Utils.circulo4,
                  onChanged: (String? value) {
                    setState(() {
                      selectedYear = value!;
                    });
                  },
                  items: years
                      .where((y) => y != sinFecha)
                      .toList()
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(chartColumns ? 'Gráfica de columnas' : 'Gráfica de línea',
                  style: Utils.mainTextStyle),
              Switch(
                activeColor: Utils.colorDot,
                activeTrackColor: Utils.circulo2,
                inactiveTrackColor: Utils.circulo1,
                inactiveThumbColor: Utils.circulo3,
                value: chartColumns,
                onChanged: (value) {
                  setState(() {
                    chartColumns = !chartColumns;
                  });
                },
              ),
            ],
          ),
          if (filter == preciosCategoria) _filterCategories(),
        ],
      ),
    );
  }

  Widget _graphic() {
    List<CartesianSeries<_Statisct, String>> charts = getChart();
    return SliverFillRemaining(
      child: charts[0].dataSource!.isNotEmpty
          ? Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Utils.colorCard,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: Utils.mainTextStyle.copyWith(fontSize: 13),
                ),
                primaryYAxis: NumericAxis(
                  decimalPlaces: 0,
                  labelStyle: Utils.mainTextStyle,
                ),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  enableDoubleTapZooming: true,
                ),
                legend: Legend(isVisible: true, textStyle: Utils.mainTextStyle),
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: Colors.transparent,
                  textStyle: Utils.secondTextStyle,
                  builder: (data, point, series, pointIndex, seriesIndex) {
                    String value = '';
                    if (point.y is double) {
                      if (filter == compradosLeidosAnio ||
                          filter == compradosAnio ||
                          filter == leidosPorAnio) {
                        value = ((point.y) as double).toStringAsFixed(2);
                      } else {
                        value = '${((point.y) as double).toStringAsFixed(2)}€';
                      }
                    } else if (point.y is int) {
                      value = point.y.toString();
                    }
                    final String name = point.x?.toString() ?? '';
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Utils.colorScaffold,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Utils.colorScaffold.withAlpha((0.8 * 255).toInt()),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (series.name != 'Media')
                            Text(
                              name,
                              style:
                                  Utils.mainTextStyle.copyWith(fontSize: 13, color: Utils.colorDot),
                            ),
                          const SizedBox(height: 2),
                          Text(value, style: Utils.secondTextStyle.copyWith(color: Utils.circulo3)),
                          if (data is _Statisct)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 5,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: series.color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Utils.circulo1),
                                  ),
                                ),
                                Text(
                                  series.name ?? "Precio",
                                  style: Utils.secondTextStyle
                                      .copyWith(fontSize: 12, color: Utils.circulo3),
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                ),
                series: charts,
                palette: colores,
              ),
            )
          : NotFoundWidget(),
    );
  }

  Widget _filterCategories() {
    return Row(
      spacing: 10,
      children: [
        Text('Categoria', style: Utils.secondTextStyle),
        Expanded(
          child: DropdownButton(
            isExpanded: true,
            value: categoria,
            elevation: 16,
            iconSize: 30,
            style: TextStyle(
              color: Utils.colorEtiquetaTexto,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(20),
            dropdownColor: Utils.circulo4,
            items: provider.categorias
                .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.name, style: Utils.mainTextStyle.copyWith(fontSize: 17))))
                .toList(),
            onChanged: (value) {
              setState(() {
                categoria = value as Categoria;
              });
            },
          ),
        ),
        if (categoria != null)
          CustomInkWell(
              onTap: () {
                setState(() {
                  categoria = null;
                });
              },
              child: Icon(Icons.delete)),
      ],
    );
  }

  List<CartesianSeries<_Statisct, String>> getChart() {
    switch (filter) {
      case leidoPendiente:
        return chartReadAndUnread();
      case categorias:
        return chartCategories();
      case autores:
        return chartAuthors();
      case leidosPorAnio:
        return chartReadPerYear();
      case compradosAnio:
        return chartBuyedPerYear();
      case precios:
        return chartPrices();
      case preciosCategoria:
        return chartCategoriesPrices();
      case compradosLeidosAnio:
        return chartBuyedReadPerYear();
      default:
        return chartReadAndUnread();
    }
  }

  List<CartesianSeries<_Statisct, String>> chartAuthors() {
    List<_Statisct> sAutoresSI = [];
    List<_Statisct> sAutoresNO = [];

    int count = 0;
    if (selectedYear != todos) {
      for (Autor a in provider.autores) {
        List<Libro> leidos = provider.libros
            .where((l) =>
                l.leido == 'SI' &&
                l.fechFin.isNotEmpty &&
                l.autor == a.name &&
                l.fechFin.substring(6, 10) == selectedYear)
            .toList();
        if (leidos.isNotEmpty) {
          count += leidos.length;
          sAutoresSI.add(_Statisct(a.name, leidos));
        }
      }
    } else {
      for (Autor a in provider.autores) {
        sAutoresSI.add(_Statisct(
            a.name, provider.libros.where((l) => l.leido == 'SI' && l.autor == a.name).toList()));
      }
      for (Autor a in provider.autores) {
        sAutoresNO.add(_Statisct(
            a.name, provider.libros.where((l) => l.leido == 'NO' && l.autor == a.name).toList()));
      }
    }
    String nameC1 = selectedYear == todos ? leidos : '$leidos $count';
    String nameC2 = pendientes;
    return [
      if (chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sAutoresSI,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC1,
          dataLabelSettings: dataLabelSettings,
          color: colores[1],
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sAutoresSI[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sAutoresSI[pointInteractionDetails.pointIndex!].name}. ${sAutoresSI[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sAutoresSI,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC1,
          dataLabelSettings: dataLabelSettings,
          color: colores[1],
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sAutoresSI[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sAutoresSI[pointInteractionDetails.pointIndex!].name}. ${sAutoresSI[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (selectedYear == todos && chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sAutoresNO,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC2,
          dataLabelSettings: dataLabelSettings,
          color: colores[0],
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sAutoresNO[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sAutoresNO[pointInteractionDetails.pointIndex!].name}. ${sAutoresNO[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (selectedYear == todos && !chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sAutoresNO,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC2,
          dataLabelSettings: dataLabelSettings,
          color: colores[0],
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sAutoresNO[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sAutoresNO[pointInteractionDetails.pointIndex!].name}. ${sAutoresNO[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
    ];
  }

  List<CartesianSeries<_Statisct, String>> chartCategories() {
    List<_Statisct> sCategoriasSI = [];
    List<_Statisct> sCategoriasNO = [];

    int count = 0;
    if (selectedYear != todos) {
      for (Categoria c in provider.categorias) {
        List<Libro> cat = provider.libros
            .where((l) =>
                l.leido == 'SI' &&
                l.fechFin.isNotEmpty &&
                l.categoriaId == c.id &&
                l.fechFin.substring(6, 10) == selectedYear)
            .toList();
        if (cat.isNotEmpty) {
          count += cat.length;
          sCategoriasSI.add(_Statisct(c.name, cat));
        }
      }
    } else {
      for (Categoria c in provider.categorias) {
        List<Libro> lLeidos =
            provider.libros.where((l) => l.leido == 'SI' && l.categoriaId == c.id).toList();
        if (lLeidos.isNotEmpty) sCategoriasSI.add(_Statisct(c.name, lLeidos));
      }
      for (Categoria c in provider.categorias) {
        List<Libro> lNoLeidos =
            provider.libros.where((l) => l.leido == 'NO' && l.categoriaId == c.id).toList();
        if (lNoLeidos.isNotEmpty) sCategoriasNO.add(_Statisct(c.name, lNoLeidos));
      }
    }
    String nameC1 = selectedYear == todos ? leidos : '$leidos $count';
    String nameC2 = pendientes;
    return [
      if (chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sCategoriasSI,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC1,
          dataLabelSettings: dataLabelSettings,
          color: colores[0],
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCategoriasSI[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCategoriasSI[pointInteractionDetails.pointIndex!].name}. ${sCategoriasSI[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sCategoriasSI,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC1,
          dataLabelSettings: dataLabelSettings,
          color: colores[0],
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCategoriasSI[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCategoriasSI[pointInteractionDetails.pointIndex!].name}. ${sCategoriasSI[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (selectedYear == todos && chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sCategoriasNO,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC2,
          dataLabelSettings: dataLabelSettings,
          color: colores[1],
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCategoriasNO[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCategoriasNO[pointInteractionDetails.pointIndex!].name}. ${sCategoriasNO[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (selectedYear == todos && !chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sCategoriasNO,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: nameC2,
          dataLabelSettings: dataLabelSettings,
          color: colores[1],
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCategoriasNO[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCategoriasNO[pointInteractionDetails.pointIndex!].name}. ${sCategoriasNO[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
    ];
  }

  List<CartesianSeries<_Statisct, String>> chartReadAndUnread() {
    List<Libro> lLeidos = provider.libros.where((l) => l.leido == 'SI').toList();
    List<Libro> lNoLeidos = provider.libros.where((l) => l.leido == 'NO').toList();
    List<_Statisct> sLeidosNoLeidos = [_Statisct(si, lLeidos), _Statisct(no, lNoLeidos)];
    String name = '$leidoPendiente: ${lLeidos.length + lNoLeidos.length}';
    return [
      if (chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sLeidosNoLeidos,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: name,
          dataLabelSettings: dataLabelSettings,
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sLeidosNoLeidos[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sLeidosNoLeidos[pointInteractionDetails.pointIndex!].name}. ${sLeidosNoLeidos[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
          pointColorMapper: (_Statisct statisct, int index) => colores[index],
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sLeidosNoLeidos,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: leidoPendiente,
          dataLabelSettings: dataLabelSettings,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sLeidosNoLeidos[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sLeidosNoLeidos[pointInteractionDetails.pointIndex!].name}. ${sLeidosNoLeidos[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
          pointColorMapper: (_Statisct statisct, int index) => colores[index],
        ),
    ];
  }

  List<CartesianSeries<_Statisct, String>> chartReadPerYear() {
    List<_Statisct> sLeidos = [];

    List<Libro> leidos =
        provider.libros.where((l) => l.leido == 'SI' && l.fechFin.isNotEmpty).toList();
    int count = 0;
    if (selectedYear != todos) {
      sLeidos.clear();
      for (int mes = 1; mes <= 12; mes++) {
        List<Libro> librosDelMes = leidos.where((l) {
          try {
            final partes = l.fechFin.split('/');
            if (partes.length != 3) return false;
            final fecha = DateTime.parse('${partes[2]}-${partes[1]}-${partes[0]}');
            return fecha.month == mes && fecha.year.toString() == selectedYear;
          } catch (_) {
            return false;
          }
        }).toList();
        if (librosDelMes.isNotEmpty) {
          sLeidos.add(_Statisct(meses[mes]!, librosDelMes));
        }
      }
      sLeidos.sort((a, b) => orden[a.name]!.compareTo(orden[b.name]!));
    } else {
      for (String y in years.reversed) {
        if (y != todos) {
          List<Libro> libros = leidos.where((l) => l.fechFin.substring(6, 10) == y).toList();
          if (libros.isNotEmpty) sLeidos.add(_Statisct(y, libros));
        }
      }
    }
    for (_Statisct s in sLeidos) {
      count += s.libros.length;
    }
    double avg = count / sLeidos.length;
    String name = '$total $count';
    return [
      if (chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sLeidos,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: name,
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo2,
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sLeidos[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sLeidos[pointInteractionDetails.pointIndex!].name}. ${sLeidos[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sLeidos,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: name,
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo2,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sLeidos[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sLeidos[pointInteractionDetails.pointIndex!].name}. ${sLeidos[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      LineSeries<_Statisct, String>(
        dataSource: sLeidos,
        xValueMapper: (_Statisct statisct, _) => statisct.name,
        yValueMapper: (_Statisct statisct, _) => avg,
        name: 'Media',
        color: Utils.colorDot,
      ),
    ];
  }

  List<CartesianSeries<_Statisct, String>> chartBuyedPerYear() {
    List<_Statisct> sCompradosAnio = [];

    List<Libro> comprados = provider.libros.where((l) => l.fechCompra.isNotEmpty).toList();

    int count = 0;
    if (selectedYear != todos) {
      sCompradosAnio.clear();
      for (int mes = 1; mes <= 12; mes++) {
        List<Libro> librosDelMes = comprados.where((l) {
          try {
            final partes = l.fechCompra.split('/');
            if (partes.length != 3) return false;
            final fecha = DateTime.parse('${partes[2]}-${partes[1]}-${partes[0]}');
            return fecha.month == mes && fecha.year.toString() == selectedYear;
          } catch (_) {
            return false;
          }
        }).toList();
        if (librosDelMes.isNotEmpty) {
          sCompradosAnio.add(_Statisct(meses[mes]!, librosDelMes));
        }
      }
      sCompradosAnio.sort((a, b) => orden[a.name]!.compareTo(orden[b.name]!));
    } else {
      for (String y in years.reversed) {
        List<Libro> count = comprados.where((l) => Utils.getYear(l.fechCompra) == y).toList();
        if (count.isNotEmpty) {
          sCompradosAnio.add(_Statisct(y, count));
        }
      }
      List<Libro> sinFecha = provider.libros.where((l) => l.fechCompra.isEmpty).toList();
      sCompradosAnio.add(_Statisct(sinAsignar, sinFecha));
    }
    for (_Statisct s in sCompradosAnio) {
      count += s.libros.length;
    }
    double avg = count / sCompradosAnio.length;
    String name = 'Comprados: $count';
    return [
      if (chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sCompradosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: name,
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo2,
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCompradosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCompradosAnio[pointInteractionDetails.pointIndex!].name}. ${sCompradosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sCompradosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: name,
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo2,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCompradosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCompradosAnio[pointInteractionDetails.pointIndex!].name}. ${sCompradosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      LineSeries<_Statisct, String>(
        dataSource: sCompradosAnio,
        xValueMapper: (_Statisct statisct, _) => statisct.name,
        yValueMapper: (_Statisct statisct, _) => avg,
        name: 'Media',
        color: Utils.colorDot,
      ),
    ];
  }

  List<CartesianSeries<_Statisct, String>> chartPrices() {
    List<_Statisct> sPreciosAnio = [];
    List<Libro> lPrecios = selectedYear == todos
        ? provider.libros.where((l) => l.precio != 0).toList()
        : provider.libros.where((l) => l.precio != 0 && l.fechCompra.isNotEmpty).toList();

    double count = 0;
    double avg = 0;
    if (selectedYear != todos) {
      sPreciosAnio.clear();
      for (int mes = 1; mes <= 12; mes++) {
        List<Libro> libros = lPrecios.where((l) {
          if (int.parse(l.fechCompra.substring(3, 5)) == mes &&
              l.fechCompra.substring(6, 10) == selectedYear) {
            return true;
          } else {
            return false;
          }
        }).toList();
        double price =
            libros.fold<double>(0, (previousValue, element) => previousValue + element.precio);
        if (libros.isNotEmpty) {
          sPreciosAnio.add(_Statisct(meses[mes]!, libros, price: price));
        }
      }
    } else {
      for (String y in years.reversed) {
        List<Libro> lCount = lPrecios
            .where((l) =>
                (Utils.getYear(l.fechCompra) == y || (l.fechCompra.isEmpty && y == sinFecha)) &&
                l.precio != 0)
            .toList();
        double pCount =
            lCount.fold<double>(0, (previousValue, element) => previousValue + element.precio);
        if (lCount.isNotEmpty) {
          sPreciosAnio.add(_Statisct(y, lCount, price: pCount));
        }
      }
    }
    for (_Statisct s in sPreciosAnio) {
      count += s.price!;
    }
    avg = count / sPreciosAnio.length;
    String name = 'Precio: ${count.toStringAsFixed(2)}€';
    return [
      if (chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sPreciosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.price,
          name: name,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder:
                (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
              final double value = point.y;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Utils.colorContainer,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3)],
                ),
                child: Text('${value.toStringAsFixed(2)} €', style: Utils.secondTextStyle),
              );
            },
          ),
          color: Utils.circulo2,
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sPreciosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sPreciosAnio[pointInteractionDetails.pointIndex!].name}. ${sPreciosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sPreciosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.price,
          name: name,
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo2,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sPreciosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sPreciosAnio[pointInteractionDetails.pointIndex!].name}. ${sPreciosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      LineSeries<_Statisct, String>(
        dataSource: sPreciosAnio,
        xValueMapper: (_Statisct statisct, _) => statisct.name,
        yValueMapper: (_Statisct statisct, _) => avg,
        name: 'Media',
        color: Utils.colorDot,
      ),
    ];
  }

  List<CartesianSeries<_Statisct, String>> chartCategoriesPrices() {
    List<_Statisct> sCategorias = [];
    List<Libro> lPrecios = selectedYear == todos
        ? provider.libros.where((l) => l.precio != 0).toList()
        : provider.libros.where((l) => l.precio != 0 && l.fechCompra.isNotEmpty).toList();

    if (categoria != null) {
      lPrecios = lPrecios.where((l) => l.categoriaId == categoria!.id).toList();
    }
    double count = 0;
    if (selectedYear != todos && categoria == null) {
      for (Categoria c in provider.categorias) {
        List<Libro> cat = lPrecios
            .where((l) => l.categoriaId == c.id && l.fechCompra.substring(6, 10) == selectedYear)
            .toList();
        double pCat = cat.fold(0, (previousValue, element) => previousValue + element.precio);
        if (cat.isNotEmpty) {
          sCategorias.add(_Statisct(c.name, cat, price: pCat));
        }
      }
    } else if (categoria != null) {
      lPrecios = lPrecios.where((l) => l.categoriaId == categoria!.id).toList();
      if (selectedYear != todos) {
        sCategorias.clear();
        for (int mes = 1; mes <= 12; mes++) {
          List<Libro> libros = lPrecios.where((l) {
            if (int.parse(l.fechCompra.substring(3, 5)) == mes &&
                l.fechCompra.substring(6, 10) == selectedYear) {
              return true;
            } else {
              return false;
            }
          }).toList();
          double price =
              libros.fold<double>(0, (previousValue, element) => previousValue + element.precio);
          if (libros.isNotEmpty) {
            sCategorias.add(_Statisct(meses[mes]!, libros, price: price));
          }
        }
      } else {
        for (String y in years.reversed.where((y) => y != sinFecha && y != todos)) {
          List<Libro> count = lPrecios
              .where((l) => l.categoriaId == categoria!.id && Utils.getYear(l.fechCompra) == y)
              .toList();
          double pCat = count.fold(0, (previousValue, element) => previousValue + element.precio);
          if (count.isNotEmpty) {
            sCategorias.add(_Statisct(y, count, price: pCat));
          }
        }
      }
    } else {
      for (Categoria c in provider.categorias) {
        List<Libro> lCat = provider.libros.where((l) => l.categoriaId == c.id).toList();
        double pCat = lCat.fold(0, (previousValue, element) => previousValue + element.precio);
        if (lCat.isNotEmpty) {
          sCategorias.add(_Statisct(c.name, lCat, price: pCat));
        }
      }
    }
    for (_Statisct s in sCategorias) {
      count += s.price!;
    }
    double avg = count / sCategorias.length;
    String nameC1 = '$total: ${count.toStringAsFixed(2)}€';
    return [
      if (chartColumns)
        ColumnSeries<_Statisct, String>(
          dataSource: sCategorias,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.price,
          name: nameC1,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            builder:
                (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
              final double value = point.y;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Utils.colorContainer,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3)],
                ),
                child: Text('${value.toStringAsFixed(2)} €',
                    style: Utils.secondTextStyle, overflow: TextOverflow.ellipsis),
              );
            },
          ),
          color: colores[1],
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCategorias[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCategorias[pointInteractionDetails.pointIndex!].name}. ${sCategorias[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sCategorias,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.price,
          name: nameC1,
          dataLabelSettings: dataLabelSettings,
          color: colores[1],
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCategorias[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCategorias[pointInteractionDetails.pointIndex!].name}. ${sCategorias[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      LineSeries<_Statisct, String>(
        dataSource: sCategorias,
        xValueMapper: (_Statisct statisct, _) => statisct.name,
        yValueMapper: (_Statisct statisct, _) => avg,
        name: 'Media',
        color: Utils.colorDot,
      ),
    ];
  }

  List<CartesianSeries<_Statisct, String>> chartBuyedReadPerYear() {
    List<_Statisct> sCompradosAnio = [];
    List<_Statisct> sLeidosAnio = [];

    List<Libro> comprados = provider.libros.where((l) => l.fechCompra.isNotEmpty).toList();
    List<Libro> leidos = provider.libros.where((l) => l.leido == 'SI').toList();

    int countComprados = 0;
    int countLeidos = 0;
    if (selectedYear != todos) {
      sCompradosAnio.clear();
      sLeidosAnio.clear();

      ///COMPRADOS
      for (int mes = 1; mes <= 12; mes++) {
        List<Libro> librosDelMes = comprados.where((l) {
          if (l.fechCompra.isEmpty) return false;
          try {
            final partes = l.fechCompra.split('/');
            if (partes.length != 3) return false;
            final fecha = DateTime.parse('${partes[2]}-${partes[1]}-${partes[0]}');
            return fecha.month == mes && fecha.year.toString() == selectedYear;
          } catch (_) {
            return false;
          }
        }).toList();
        if (librosDelMes.isNotEmpty) {
          sCompradosAnio.add(_Statisct(meses[mes]!, librosDelMes));
        }
      }

      ///LEIDOS
      for (int mes = 1; mes <= 12; mes++) {
        List<Libro> librosDelMes = leidos.where((l) {
          try {
            final partes = l.fechFin.split('/');
            if (partes.length != 3) return false;
            final fecha = DateTime.parse('${partes[2]}-${partes[1]}-${partes[0]}');
            return fecha.month == mes && fecha.year.toString() == selectedYear;
          } catch (_) {
            return false;
          }
        }).toList();
        if (librosDelMes.isNotEmpty) {
          sLeidosAnio.add(_Statisct(meses[mes]!, librosDelMes));
        }
      }

      sCompradosAnio.sort((a, b) => orden[a.name]!.compareTo(orden[b.name]!));
    } else {
      for (String y in years.reversed) {
        List<Libro> countCompradosAnio =
            comprados.where((l) => Utils.getYear(l.fechCompra) == y).toList();
        if (countCompradosAnio.isNotEmpty) {
          sCompradosAnio.add(_Statisct(y, countCompradosAnio));
        }
        List<Libro> countLeidosAnio = leidos.where((l) => Utils.getYear(l.fechFin) == y).toList();
        if (countLeidosAnio.isNotEmpty) {
          sLeidosAnio.add(_Statisct(y, countLeidosAnio));
        }
      }
    }
    for (_Statisct s in sCompradosAnio) {
      countComprados += s.libros.length;
    }
    double avgComprados = countComprados / sCompradosAnio.length;
    for (_Statisct s in sLeidosAnio) {
      countLeidos += s.libros.length;
    }
    double avgLeidos = countLeidos / sLeidosAnio.length;
    return [
      if (chartColumns)
        StackedColumnSeries<_Statisct, String>(
          dataSource: sCompradosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: 'Comprados',
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo2,
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCompradosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCompradosAnio[pointInteractionDetails.pointIndex!].name}. ${sCompradosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (chartColumns)
        StackedColumnSeries<_Statisct, String>(
          dataSource: sLeidosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: 'Leídos',
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo3,
          borderRadius: borderRadius,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sLeidosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sLeidosAnio[pointInteractionDetails.pointIndex!].name}. ${sLeidosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sCompradosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: 'Comprados',
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo2,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sCompradosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sCompradosAnio[pointInteractionDetails.pointIndex!].name}. ${sCompradosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      if (!chartColumns)
        SplineSeries<_Statisct, String>(
          dataSource: sLeidosAnio,
          xValueMapper: (_Statisct statisct, _) => statisct.name,
          yValueMapper: (_Statisct statisct, _) => statisct.libros.length,
          name: 'Leídos',
          dataLabelSettings: dataLabelSettings,
          color: Utils.circulo3,
          onPointLongPress: (pointInteractionDetails) {
            List<Libro> selected = sLeidosAnio[pointInteractionDetails.pointIndex!].libros;
            String title =
                '$filter. $selectedYear. ${sLeidosAnio[pointInteractionDetails.pointIndex!].name}. ${sLeidosAnio[pointInteractionDetails.pointIndex!].libros.length}';
            Navigator.pushNamed(context, ChartDetailPage.routeName, arguments: [selected, title]);
          },
        ),
      LineSeries<_Statisct, String>(
        dataSource: sCompradosAnio,
        xValueMapper: (_Statisct statisct, _) => statisct.name,
        yValueMapper: (_Statisct statisct, _) => avgComprados,
        name: 'Media Comprados',
        color: Utils.colorDot,
        isVisibleInLegend: false,
      ),
      LineSeries<_Statisct, String>(
        dataSource: sLeidosAnio,
        xValueMapper: (_Statisct statisct, _) => statisct.name,
        yValueMapper: (_Statisct statisct, _) => avgLeidos,
        name: 'Media Leídos',
        color: Utils.circulo1,
        isVisibleInLegend: false,
      ),
    ];
  }
}

class _Statisct {
  final String name;
  final List<Libro> libros;
  final double? price;

  _Statisct(this.name, this.libros, {this.price = 0});

  @override
  String toString() => name;
}
