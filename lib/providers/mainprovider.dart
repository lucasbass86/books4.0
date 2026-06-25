import 'package:books4/shared_preferences/preferences.dart';
import 'package:books4/utils/enums.dart';
import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  ETypeView get selectedView => Preferences.typeView;
  set selectedView(ETypeView view) {
    Preferences.typeView = view;
    switch (Preferences.typeView) {
      case ETypeView.lista:
        Utils.iconVistaSelected = Utils.iconVistaGrilla;
        break;
      case ETypeView.cuadricula:
        Utils.iconVistaSelected = Utils.iconVistaPortada;
        break;
      case ETypeView.portada:
        Utils.iconVistaSelected = Utils.iconVistaListaGlass;
        break;
      case ETypeView.listaGlass:
        Utils.iconVistaSelected = Utils.iconVistaLista;
        break;
    }
    notifyListeners();
  }

  int _selectedHome = Preferences.typeHome;
  int get selectedHome => _selectedHome;
  set selectedHome(int view) {
    _selectedHome = view;
    Preferences.typeHome = view;
    notifyListeners();
  }
}
