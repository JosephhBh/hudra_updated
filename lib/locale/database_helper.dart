import 'package:flutter/foundation.dart';
import 'package:hudra/controller/saved_verses_provider/provider_saved_verses.dart';
import 'package:hudra/data/data.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/Daily/saved_verse_model.dart';
import 'package:hudra/model/Notifications/notification_model.dart';
import 'package:hudra/model/prayer_model.dart';
import 'package:hudra/model/reference_model.dart';
import 'package:hudra/model/ritual_model.dart';
import 'package:hudra/view/bible_page.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database _database;

  static initDatabase() async {
    if (kIsWeb) {
      return;
    }
    _database = await initDb();
  }

  static Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'Hudra.db');

    return await openDatabase(
      path,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        await upgradeDB(db, oldVersion, newVersion);
      },
      onCreate: (db, version) {
        debugPrint("creating db v$version");
        db.execute('''DROP TABLE IF EXISTS Mazmour''');
        db.execute('''DROP TABLE IF EXISTS BibleEnglish''');
        db.execute('''DROP TABLE IF EXISTS BibleSyriac''');
        db.execute('''DROP TABLE IF EXISTS BibleArabic''');
        db.execute('''DROP TABLE IF EXISTS RitualsEnglish''');
        db.execute('''DROP TABLE IF EXISTS RitualsArabic''');
        db.execute('''DROP TABLE IF EXISTS RitualsSyriac''');
        db.execute('''DROP TABLE IF EXISTS PrayersEnglish''');
        db.execute('''DROP TABLE IF EXISTS PrayersArabic''');
        db.execute('''DROP TABLE IF EXISTS PrayersSyriac''');
        db.execute('''DROP TABLE IF EXISTS Notifications''');
        db.execute('''DROP TABLE IF EXISTS SavedVerses''');
        db.execute('''
  CREATE TABLE BibleEnglish (
      itemId VARCHAR PRIMARY KEY,
      number VARCHAR,
      itemName VARCHAR,
      itemDesc TEXT,
      isSelected INTEGER
  )
  ''');
        db.execute('''
  CREATE TABLE BibleSyriac (
      itemId VARCHAR PRIMARY KEY,
      number VARCHAR,
      itemName VARCHAR,
      itemDesc TEXT,
      isSelected INTEGER
  )
  ''');
        db.execute('''
  CREATE TABLE BibleArabic (
      itemId VARCHAR PRIMARY KEY,
      number VARCHAR,
      itemName VARCHAR,
      itemDesc TEXT,
      isSelected INTEGER
  )
  ''');

        db.execute('''
  CREATE TABLE RitualsEnglish (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      createdAt VARCHAR
  )
  ''');
        db.execute('''
  CREATE TABLE RitualsArabic (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      createdAt VARCHAR
  )
  ''');
        db.execute('''
  CREATE TABLE RitualsSyriac (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      createdAt VARCHAR
  )
  ''');

        db.execute('''
  CREATE TABLE PrayersEnglish (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemRelatedHoliday VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      week VARCHAR,
      day VARCHAR,
      prayerTime VARCHAR,
      createdAt VARCHAR
  )
  ''');
        db.execute('''
  CREATE TABLE PrayersArabic (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemRelatedHoliday VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      week VARCHAR,
      day VARCHAR,
      prayerTime VARCHAR,
      createdAt VARCHAR
  )
  ''');
        db.execute('''
  CREATE TABLE PrayersSyriac (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemRelatedHoliday VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      week VARCHAR,
      day VARCHAR,
      prayerTime VARCHAR,
      createdAt VARCHAR
  )
  ''');
        db.execute('''
  CREATE TABLE Notifications (
      notificationId VARCHAR PRIMARY KEY,
      notificationTitle VARCHAR,
      notificationMessage TEXT
  )
  ''');

        db.execute('''
  CREATE TABLE SavedVerses (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemReference VARCHAR,
      itemDescString TEXT,
      itemLang VARCHAR
  )
  ''');
      },
    );
  }

  static Future<void> upgradeDB(
      Database db, int oldVersion, int newVersion) async {
    debugPrint("Upgrading db from v$oldVersion to v$newVersion");

    await db.execute('''DROP TABLE IF EXISTS Mazmour''');
    await db.execute('''DROP TABLE IF EXISTS BibleEnglish''');
    await db.execute('''DROP TABLE IF EXISTS BibleSyriac''');
    await db.execute('''DROP TABLE IF EXISTS BibleArabic''');
    await db.execute('''DROP TABLE IF EXISTS RitualsEnglish''');
    await db.execute('''DROP TABLE IF EXISTS RitualsArabic''');
    await db.execute('''DROP TABLE IF EXISTS RitualsSyriac''');
    await db.execute('''DROP TABLE IF EXISTS PrayersEnglish''');
    await db.execute('''DROP TABLE IF EXISTS PrayersArabic''');
    await db.execute('''DROP TABLE IF EXISTS PrayersSyriac''');
    await db.execute('''DROP TABLE IF EXISTS Notifications''');
    await db.execute('''DROP TABLE IF EXISTS SavedVerses''');
    await db.execute('''
  CREATE TABLE BibleEnglish (
      itemId VARCHAR PRIMARY KEY,
      number VARCHAR,
      itemName VARCHAR,
      itemDesc TEXT,
      isSelected INTEGER
  )
  ''');
    await db.execute('''
  CREATE TABLE BibleSyriac (
      itemId VARCHAR PRIMARY KEY,
      number VARCHAR,
      itemName VARCHAR,
      itemDesc TEXT,
      isSelected INTEGER
  )
  ''');
    await db.execute('''
  CREATE TABLE BibleArabic (
      itemId VARCHAR PRIMARY KEY,
      number VARCHAR,
      itemName VARCHAR,
      itemDesc TEXT,
      isSelected INTEGER
  )
  ''');

    await db.execute('''
  CREATE TABLE RitualsEnglish (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      createdAt VARCHAR
  )
  ''');
    await db.execute('''
  CREATE TABLE RitualsArabic (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      createdAt VARCHAR
  )
  ''');
    await db.execute('''
  CREATE TABLE RitualsSyriac (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      createdAt VARCHAR
  )
  ''');

    await db.execute('''
  CREATE TABLE PrayersEnglish (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemRelatedHoliday VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      week VARCHAR,
      day VARCHAR,
      prayerTime VARCHAR,
      createdAt VARCHAR
  )
  ''');
    await db.execute('''
  CREATE TABLE PrayersArabic (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemRelatedHoliday VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      week VARCHAR,
      day VARCHAR,
      prayerTime VARCHAR,
      createdAt VARCHAR
  )
  ''');
    await db.execute('''
  CREATE TABLE PrayersSyriac (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemRelatedHoliday VARCHAR,
      itemDesc TEXT,
      isSyriac INTEGER,
      isChaldean INTEGER,
      week VARCHAR,
      day VARCHAR,
      prayerTime VARCHAR,
      createdAt VARCHAR
  )
  ''');
    await db.execute('''
  CREATE TABLE Notifications (
      notificationId VARCHAR PRIMARY KEY,
      notificationTitle VARCHAR,
      notificationMessage TEXT
  )
  ''');

    await db.execute('''
  CREATE TABLE SavedVerses (
      itemId VARCHAR PRIMARY KEY,
      itemName VARCHAR,
      itemReference VARCHAR,
      itemDescString TEXT,
      itemLang VARCHAR
  )
  ''');
  }

  static Future<void> insertNotifications(
      NotificationModel notificationModel) async {
    print("inserting notification ${notificationModel.notificationId}");
    await _database.insert('Notifications', notificationModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertMazmour(ReferenceModel referenceModel) async {
    print("inserting mazmour ${referenceModel.id}");
    await _database.insert('Mazmour', referenceModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertBible(
      String tableName, BibleObject bibleObject) async {
    print("inserting bible ${bibleObject.itemId}");
    await _database.insert(tableName, bibleObject.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertRitual(
      String tableName, RitualObject ritualObject) async {
    print("inserting prayer ${ritualObject.itemId}");
    await _database.insert(tableName, ritualObject.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> insertPrayer(
      String tableName, PrayerObject prayerObject) async {
    print("inserting prayer ${prayerObject.itemId}");
    await _database.insert(tableName, prayerObject.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<bool> existsSavedVerses(SavedVerseModel savedVerseModel) async {
    List<Map<String, dynamic>> tmp =
        await DatabaseHelper.querySavedVersesByLang(
            GetStorageHelper().getLanguage());

    for (Map<String, dynamic> element in tmp) {
      if (element['itemId'] == savedVerseModel.itemId) {
        return true;
      }
    }

    return false;
  }

  static Future<void> insertSavedVerses(SavedVerseModel savedVerseModel) async {
    bool isExist = false;

    List<Map<String, dynamic>> tmp =
        await DatabaseHelper.querySavedVersesByLang(
            GetStorageHelper().getLanguage());

    for (Map<String, dynamic> element in tmp) {
      if (element['itemId'] == savedVerseModel.itemId) {
        isExist = true;
        break;
      }
    }

    if (isExist) {
      deleteSavedVerses(savedVerseModel.itemId);
    }
    if (!isExist) {
      print("inserting verse ${savedVerseModel.itemId}");
      await _database.insert("SavedVerses", savedVerseModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<void> deleteSavedVerses(String itemId) async {
    print("deleting verse $itemId");
    await _database.delete("SavedVerses", where: '"itemId" = \'$itemId\'');
  }

  static Future<List<Map<String, Object?>>> queryBibles(
      String tableName) async {
    return await _database.query(tableName);
  }

  static Future<List<Map<String, Object?>>> queryPrayers(
      String tableName) async {
    return await _database.query(tableName);
  }

  static Future<List<Map<String, Object?>>> querySavedVersesByLang(
      String lang) async {
    return await _database.query('SavedVerses', where: "itemLang = '$lang'");
  }

  static Future<List<Map<String, Object?>>> queryHolidyPrayerByName(
      String tableName, String prayerName, int isSyriac) async {
    return await _database.query(tableName,
        where:
            "itemRelatedHoliday = '$prayerName' AND `isSyriac` = '$isSyriac' ORDER BY createdAt DESC LIMIT 1");
  }

  // static Future<List<Map<String, Object?>>> queryMazmourById(
  //     int mazmourId) async {
  //   return await _database.query('Mazmour', where: "id = '$mazmourId'");
  // }

  static Future<List<Map<String, Object?>>> queryAllNotifications() async {
    return await _database.query('Notifications');
  }

  static Future<List<Map<String, Object?>>> queryDailyVerses(
      String tableName) async {
    return await _database.query(tableName, where: "isSelected = 1  LIMIT 3");
  }

  static Future<List<Map<String, Object?>>> queryBiblesByNumber(
      String tableName, String numbers) async {
    return await _database.query(tableName, where: "number in ($numbers)");
  }

// static Future<void> quersyAllData() async {
//   var data = await _database.query('Mazmour');
//   print(data);

//   // print(await _database.query('MazmourArabic'));
//   // print(await _database.query('MazmourSyriac'));
// }
}
