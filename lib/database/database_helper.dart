import 'package:contacts/model/Contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'columns.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Database _db;

  get db async {
    if (_db != null)
      return _db;
    else
      return _db = await openDB();
  }

  Future<Database> openDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, DATABASE);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          'CREATE TABLE $TABLE_CONTACT($ID INTEGER PRIMARY KEY, $NAME TEXT, '
          '$EMAIL TEXT, $PHONE TEXT, $IMG TEXT)');
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database database = await db;
    contact.id = await database.insert(TABLE_CONTACT, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database database = await db;
    List<Map> maps = await database.query(TABLE_CONTACT,
        columns: [ID, NAME, EMAIL, PHONE, IMG],
        where: '$ID = ?',
        whereArgs: [id]);
    if (maps.length > 0)
      return Contact.fromMap(maps.first);
    else
      return null;
  }

  Future<int> deleteContact(int id) async {
    Database database = await db;
    return await database
        .delete(TABLE_CONTACT, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database database = await db;
    return await database.update(TABLE_CONTACT, contact.toMap(),
        where: '$ID = ?', whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database database = await db;
    List listMap = await database.rawQuery('SELECT * FROM $TABLE_CONTACT');
    List<Contact> listContact = List();
    for(Map<String, dynamic> map in listMap){
      listContact.add(Contact.fromMap(map));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database database = await db;
    return Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM $TABLE_CONTACT'));
  }

  Future close() async {
    Database database = await db;
    database.close();
  }
}
