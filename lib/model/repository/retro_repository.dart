import 'package:flutter_application_1/model/db/app_database.dart';
import '../entity/retro.dart';

class RetroRepository {
  final AppDatabase _appDatabase;

  RetroRepository(this._appDatabase);

  Future<List<Retro>> loadAllRetro() => _appDatabase.loadAllRetro();

  Future insert(Retro retro) => _appDatabase.insert(retro);

  Future update(Retro retro) => _appDatabase.update(retro);

  Future delete(Retro retro) => _appDatabase.delete(retro);
}