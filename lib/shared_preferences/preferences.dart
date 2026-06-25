import 'package:books4/models/models.dart';
import 'package:books4/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  ///////NOMBRES DE VARIABLES;
  static const String sTabPage = 'tabPage';
  static const String sIsDarkTheme = 'isDarkTheme';
  static const String sTypeView = 'typeView';
  static const String sTypeOrder = 'typeOrder';
  static const String sTypeFilter = 'typeFilter';
  static const String sType = 'type';
  static const String sTheme = 'theme';
  static const String sTypeHome = 'typeHome';
  static const String sZoom = 'zoom';
  static const String sSearch = 'search';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const String sLicense = 'license';
  static String _license = '';
  static String get license => _prefs.getString(sLicense) ?? _license;
  static set license(String value) {
    _license = value;
    _prefs.setString(sLicense, value);
  }

  static String _search = "";
  static String get search => _prefs.getString(sSearch) ?? _search;
  static set search(String value) {
    _search = value;
    _prefs.setString(sSearch, value);
  }

  static int _zoom = 2;
  static int get zoom {
    return _prefs.getInt(sZoom) ?? _zoom;
  }

  static set zoom(int value) {
    _zoom = value;
    _prefs.setInt(sZoom, _zoom);
  }

  static int _typeHome = 0;
  static int get typeHome {
    return _prefs.getInt(sTypeHome) ?? _typeHome;
  }

  static set typeHome(int value) {
    _typeHome = value;
    _prefs.setInt(sTypeHome, _typeHome);
  }

  static bool _isDarkTheme = false;
  static bool get isDarkTheme {
    return _prefs.getBool(sIsDarkTheme) ?? _isDarkTheme;
  }

  static set isDarkTheme(bool value) {
    _isDarkTheme = value;
    _prefs.setBool(sIsDarkTheme, value);
  }

  static ETypeView _typeView = ETypeView.lista;
  static ETypeView get typeView {
    String p = _prefs.getString(sTypeView) ?? '';
    _typeView = p.isNotEmpty ? ETypeView.values.byName(p) : ETypeView.lista;
    return _typeView;
  }

  static set typeView(ETypeView value) {
    _typeView = value;
    _prefs.setString(sTypeView, value.name);
  }

  static ETypeOrder _typeOrder = ETypeOrder.ascendente;
  static ETypeOrder get typeOrder {
    String p = _prefs.getString(sTypeOrder) ?? '';
    _typeOrder = p.isNotEmpty ? ETypeOrder.values.byName(p) : ETypeOrder.ascendente;
    return _typeOrder;
  }

  static set typeOrder(ETypeOrder value) {
    _typeOrder = value;
    _prefs.setString(sTypeOrder, value.name);
  }

  static ETypeFilter _typeFilter = ETypeFilter.todos;
  static ETypeFilter get typeFilter {
    String p = _prefs.getString(sTypeFilter) ?? '';
    _typeFilter = p.isNotEmpty ? ETypeFilter.values.byName(p) : ETypeFilter.todos;
    return _typeFilter;
  }

  static set typeFilter(ETypeFilter value) {
    _typeFilter = value;
    _prefs.setString(sTypeFilter, value.name);
  }

  static EType _type = EType.id;
  static EType get type {
    String p = _prefs.getString(sType) ?? '';
    _type = p.isNotEmpty ? EType.values.byName(p) : EType.id;
    return _type;
  }

  static set type(EType value) {
    _type = value;
    _prefs.setString(sType, value.name);
  }

  static final String sLibrosLeyendo = 'LibrosLeyendo';
  static List<Leyendo> leyendo = [];

  static void getLeyendo() {
    String? l = _prefs.getString(sLibrosLeyendo);
    leyendo = l != null ? leyendoFromJson(l) : [];
  }

  static Leyendo? isLeyendo(int codigo) {
    final index = leyendo.indexWhere(
      (l) => l.codigoLibro == codigo,
    );
    return index == -1 ? null : leyendo[index];
  }

  static void addLeyendo(Leyendo leo) {
    leyendo.add(leo);
    updateLeyendo();
  }

  static void removeLeyendo(int codigo) {
    leyendo.removeWhere((l) => l.codigoLibro == codigo);
    updateLeyendo();
  }

  static void updateLeyendo({Leyendo? leo}) {
    if (leo != null) {
      leyendo.firstWhere((l) => l.codigoLibro == leo.codigoLibro).paginas = leo.paginas;
    }
    String json = leyendoToJson(leyendo);
    _prefs.setString(sLibrosLeyendo, json);
  }
}
