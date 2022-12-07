import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart' as sql;

class PeticionesDB {
  static Future<void> CrearTabla(sql.Database database) async {
    await database.execute(""" CREATE TABLE posiciones(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      localizacion TEXT,
      fechahora TEXT
    ) """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("geolocalizacion.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await CrearTabla(database);
    });
  }

  static Future<void> guardarPosicion(localiza, fechora) async {
    final base = await PeticionesDB.db();
    final datos = {"localizacion": localiza, "fechahora": fechora};
    await base.insert("posiciones", datos,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> eliminarPosicion(int idpo) async {
    final base = await PeticionesDB.db();
    base.delete("posiciones", where: "id=?", whereArgs: [idpo]);
  }

  static Future<void> eliminarTodas() async {
    final base = await PeticionesDB.db();
    base.delete("posiciones");
  }

  static Future<List<Map<String, dynamic>>> mostrarTodasUbicaciones() async {
    final base = await PeticionesDB.db();
    return base.query("posiciones", orderBy: "fechahora");
  }

  static Future<void> GuardarPosicion(coor, fec) async {
    final base = await PeticionesDB.db();
    final datos = {"localizacion": coor, "fechahora": fec};
    await base.insert("posiciones", datos,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
