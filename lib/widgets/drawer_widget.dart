import 'package:books4/dialogs/dialogs.dart';
import 'package:books4/pages/_pages.dart';
import 'package:books4/providers/librarymanager.dart';
import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  ETypeHome typeHome = Preferences.typeHome == 0 ? ETypeHome.categoria : ETypeHome.autor;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Utils.colorScaffold,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Utils.circulo1),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/icon.png', width: 40, height: 40),
                    OutlinedText(
                      text: Text(
                        'Libros 4.0',
                        style: TextStyle(
                            color: Utils.colorFontTop, fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      strokes: [
                        OutlinedTextStroke(color: Utils.circulo2, width: 3),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.bookmark_border_rounded, color: Utils.colorIcon),
                    title: Text('Biblioteca', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, BibliotecaPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconAutor, color: Utils.colorIcon),
                    title: Text('Autores', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, AutoresPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconCategoria, color: Utils.colorIcon),
                    title: Text('Categorías', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, CategoriasPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconColecciones, color: Utils.colorIcon),
                    title: Text('Colecciones', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, CollectionsPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.label, color: Utils.colorIcon),
                    title: Text('Etiquetas', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, EtiquetasPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Utils.iconEditorial, color: Utils.colorIcon),
                    title: Text('Editoriales', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, EditorialesPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.pie_chart, color: Utils.colorIcon),
                    title: Text('Estadísticas', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, ChartPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  Divider(color: Utils.circulo1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.local_library_rounded, color: Utils.colorIcon),
                    title: Text('Estanterías', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, EstanteriasPage.routeName);
                      Scaffold.of(context).closeDrawer();
                      LibraryManager manager = Provider.of(context, listen: false);
                      manager.selectedShelf = null;
                    },
                  ),
                  Divider(color: Utils.circulo1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.star, color: Utils.colorIcon),
                    title: Text('Recomendar', style: Utils.mainTextStyle),
                    onTap: () {
                      shuffleBook(context: context);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.bookmarks_rounded, color: Utils.colorIcon),
                    title: Text('Próximos', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, NextBooksPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                  Divider(color: Utils.circulo1),
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    leading: Icon(Icons.person_outlined, color: Utils.colorIcon),
                    title: Text('Prestados', style: Utils.mainTextStyle),
                    onTap: () {
                      Navigator.pushNamed(context, PrestadosPage.routeName);
                      Scaffold.of(context).closeDrawer();
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Licencia: ${Preferences.license}', style: Utils.thirdTextStyle),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      PackageInfo packageInfo = snapshot.data as PackageInfo;
                      return Text(packageInfo.version, style: Utils.thirdTextStyle);
                    } else {
                      return Text('');
                    }
                  },
                ),
              ],
            ),
            trailing: Icon(Icons.power_settings_new_rounded, color: Utils.colorIcon, size: 35),
            onTap: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
