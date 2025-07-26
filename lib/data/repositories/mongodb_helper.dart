import 'package:mongo_dart/mongo_dart.dart';

class MongoDBHelper {
  static late Db _db;

  static Future<void> connect() async {
    const connectionString =
        'mongodb+srv://hjpertuz:0813@gestionrecetas.pd25tev.mongodb.net/gestion_recetas?retryWrites=true&w=majority';
    final parsedUri = Db.create(connectionString);
    _db = await parsedUri;
    await _db.open();
    print('Connected to MongoDB');
  }

  static Db get db => _db;
}