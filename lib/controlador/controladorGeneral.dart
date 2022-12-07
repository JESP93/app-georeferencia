import 'package:get/get.dart';
import 'package:reto4/proceso/peticiones.dart';

class controladorGeneral extends GetxController {
  final Rxn<List<Map<String, dynamic>>> _listaPosiciones =
      Rxn<List<Map<String, dynamic>>>();
  final _posicion = "".obs;

///////////////////////////////
  void cargaUnaPosicion(String X) {
    _posicion.value = X;
  }

  String get posicion => _posicion.value;
  ////////////////////////////////////

  void cargaListaPosiciones(List<Map<String, dynamic>> X) {
    _listaPosiciones.value = X;
  }

  List<Map<String, dynamic>>? get ListaPosiciones => _listaPosiciones.value;

///////////////////////////////////////////

  Future<void> CargarTodaBD() async {
    final datos = await PeticionesDB.mostrarTodasUbicaciones();
    cargaListaPosiciones(datos);
  }
}
