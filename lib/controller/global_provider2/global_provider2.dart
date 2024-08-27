import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hudra/api/my_api.dart';
import 'package:hudra/controller/settings_provider/provider_church.dart';
import 'package:hudra/controller/settings_provider/provider_language.dart';
import 'package:hudra/data/data.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/ases_el_sene_model.dart';
import 'package:hudra/model/eid_al_kiyama_model.dart';
import 'package:hudra/model/maraji3_al_kiyama_model.dart';
import 'package:hudra/model/sabou3at.dart';
import 'package:hudra/widgets/PopUp/errorWarningPopup.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/utils/date_utils.dart';
import 'package:provider/provider.dart';

class GlobalProvider2 extends ChangeNotifier {
  ///
  String _currentLanguage = "en";

  ///fields
  int _currentYear = 0;
  Map<int, Map<String, DateTime>> holidaysAll = {};

  AsesElSeneModel _asesElSeneModel = AsesElSeneModel();
  final Maraji3AlKiyamaModel _maraji3alKiyamaModel = Maraji3AlKiyamaModel();
  final EidAlKiyamaModel _eidAlKiyamaModel = EidAlKiyamaModel();
  final SomElBa3outhModel _somElBa3outhModel = SomElBa3outhModel();
  final SomElKabirModel _somElKabirModel = SomElKabirModel();
  final EidElSou3oudModel _eidElSou3oudModel = EidElSou3oudModel();
  final NosardilModel _nosardilModel = NosardilModel();
  final EliyaModel _eliyaModel = EliyaModel();
  final MoussaModel _moussaModel = MoussaModel();
  final TakdisElBi3aModel _takdisElBi3aModel = TakdisElBi3aModel();
  final Jam3ElDene7SModel _jam3ElDene7Model = Jam3ElDene7SModel();

  String _asesElSeneString = "";
  String _maraji3AlKiyamaString = "";
  String _eidAlKiyamaString = "";
  String _somElBa3outh1String = "";
  String _somElBa3outh2String = "";
  String _somElBa3outh3String = "";
  String _somElKabirString = "";
  String _eidElSou3oudString = "";
  String _nosardilString = "";
  String _eliyaString = "";
  String _moussaString = "";
  String _takdisElBi3aString = "";
  int? _jam3ElDene7Int;

  /// 2a3yed Sebte
  String _a7adMaBa3daElmilad = "";
  String _khitanatAlRab = "";
  String _eidElDene7 = "";
  String _sebou3ElRousol = "";
  String _sebou3ElDene7 = "";
  String _sebou3ElBshara = "";
  String _marAntonios = "";
  String _doukhoulElRab2ilaElHaykal = "";
  String _tazkarMarKiwarkis = "";
  String _eidHafizatElZourou3 = "";
  String _eidZiyaratEl3azra2ilaElisabat = "";
  String _marBoutrosWBoulos = "";
  String _marToumaElRasoul = "";
  String _eidTajaliAlRabAlaJabalTabour = "";
  String _eid2intikalEl3azra2ilaElSama = "";
  String _eidWiladatEl3azraMaryam = "";

  String _eidElSalibElMoukadas = "";
  String _eidYasou3ElMalak = "";
  String _eidYa3koubElMkta3 = "";
  String _el2ediseBerbara = "";
  String _marNiklawous = "";
  String _eidEl3azraElMahboulBihaBilaDanas = "";
  String _eidMiladRabinaYasou3ElMasih = "";
  String _eidTatwibMaryamEl3azra = "";
  String _zikraKatel2atfalBeitLahm = "";

  String _joseph = "";
  String _annunciationMary = "";
  String _shmoni = "";
  String _memoryOf72disciples = "";
  String _ciriaco = "";
  String _virginMary = "";
  String _ephrem = "";
  String _maryOfPerpetualHelp = "";
  String _mikha = "";

  ///Getter
  int get currentYear => _currentYear;

  set currentYear(int value) {
    _currentYear = value;
    notifyListeners();
  }

  ///
  String get asesElSeneString => _asesElSeneString;

  String get maraji3AlKiyamaString => _maraji3AlKiyamaString;

  String get eidAlKiyamaString => _eidAlKiyamaString;

  String get somElBa3outh1String => _somElBa3outh1String;

  String get somElBa3outh2String => _somElBa3outh2String;

  String get somElBa3outh3String => _somElBa3outh3String;

  String get somElKabirString => _somElKabirString;

  String get eidElSou3oudString => _eidElSou3oudString;

  String get nosardilString => _nosardilString;

  String get eliyaString => _eliyaString;

  String get moussaString => _moussaString;

  String get takdisElBi3aString => _takdisElBi3aString;

  int? get jam3ElDene7Int => _jam3ElDene7Int;

  /// Methods
  calculateAsesElSene(int currentYear) {
    _asesElSeneModel = AsesElSeneModel();

    int initialNumber = 0;
    initialNumber = (currentYear - 1900).abs();
    while (initialNumber > 0 && initialNumber - 28 > 0) {
      initialNumber = initialNumber - 28;
    }
    if (initialNumber % 4 == 0) {
      int dividerNumber = (initialNumber / 4).round();
      var entryList = arkamAsasElSana.entries.toList();
      var currentIndex = entryList[dividerNumber - 1].key;
      _asesElSeneModel.initial = bRowList[initialNumber - 1];
      _asesElSeneModel.secondary = currentIndex;
    } else {
      _asesElSeneModel.initial = bRowList[initialNumber - 1];
    }

    if (_asesElSeneModel.secondary == 0) {
      _asesElSeneString = _asesElSeneModel.initial.toString();
    } else {
      _asesElSeneString =
          "${_asesElSeneModel.initial}(${_asesElSeneModel.secondary})";
    }
  }

  calculateMaraji3ElKiyama(int currentYear) {
    int initialNumber = 0;
    initialNumber = (currentYear - 1898).abs();
    while (initialNumber > 0 && initialNumber - 19 > 0) {
      initialNumber = initialNumber - 19;
    }
    _maraji3alKiyamaModel.first = maraje3AlKiyama[initialNumber]['first'];
    _maraji3alKiyamaModel.last = maraje3AlKiyama[initialNumber]['last'];
    _maraji3AlKiyamaString =
        "${maraje3AlKiyama[initialNumber]['first']} - ${maraje3AlKiyama[initialNumber]['last']}";
  }

  calculateEdiAlKiyama(int currentYear) {
    _eidAlKiyamaModel.year = currentYear;
    int t1 = 0;

    if (_asesElSeneModel.secondary != 0) {
      t1 = (_maraji3alKiyamaModel.last + _asesElSeneModel.secondary);
    } else {
      t1 = (_maraji3alKiyamaModel.last + _asesElSeneModel.initial);
    }
    int firstTotal = 0;
    if (t1 > 7) {
      firstTotal = t1 - 7;
    } else {
      firstTotal = t1;
    }

    if (firstTotal == 7) {
      if (_maraji3alKiyamaModel.first < 20) {
        _eidAlKiyamaModel.month = listOfMonths[4]!;
      } else {
        _eidAlKiyamaModel.month = listOfMonths[3]!;
      }
      int addedTotal = 0;
      if (_maraji3alKiyamaModel.first == 17 ||
          _maraji3alKiyamaModel.first == 18) {
        addedTotal = 1;
      } else {
        addedTotal = 8;
      }
      int secondTotal = addedTotal + _maraji3alKiyamaModel.first;
      if (secondTotal > 31) {
        _eidAlKiyamaModel.month = listOfMonths[4]!;
        _eidAlKiyamaModel.day = secondTotal - 31;
      } else {
        _eidAlKiyamaModel.day = secondTotal;
      }
    } else {
      int addedTotal = 0;
      switch (firstTotal) {
        case 1:
          addedTotal = 7;
          break;
        case 2:
          addedTotal = 6;
          break;
        case 3:
          addedTotal = 5;
          break;
        case 4:
          addedTotal = 4;
          break;
        case 5:
          addedTotal = 3;
          break;
        case 6:
          addedTotal = 2;
          break;
        case 7:
          addedTotal = 1;
          break;

        default:
      }
      int secondTotal = addedTotal + _maraji3alKiyamaModel.first;
      // int thirdTotal = secondTotal - 31;
      // int thirdTotalAbsolute = thirdTotal.abs();
      if (_maraji3alKiyamaModel.first < 20) {
        _eidAlKiyamaModel.month = listOfMonths[4]!;
      } else {
        _eidAlKiyamaModel.month = listOfMonths[3]!;
      }
      if (secondTotal > 31) {
        _eidAlKiyamaModel.month = listOfMonths[4]!;
        _eidAlKiyamaModel.day = secondTotal - 31;
      } else {
        _eidAlKiyamaModel.day = secondTotal;
      }
    }
    _eidAlKiyamaString =
        "${_eidAlKiyamaModel.day}-${_eidAlKiyamaModel.month}-$currentYear";
    print("el kiyama : $_eidAlKiyamaString");
  }

  calculateSomElBa3outh(int currentYear) {
    _somElBa3outhModel.year = currentYear;
    DateTime tmp = DateFormat('dd-MMMM-yyyy')
        .parse(_somElKabirString)
        .subtract(const Duration(days: 20));

    _somElBa3outhModel.day = tmp.day;
    _somElBa3outhModel.month = listOfMonths[tmp.month]!;

    // /// get arkam el ba3outh
    // int arkamElBa3outh = 0;
    // bool checkIsLeapYear = isLeapYear(currentYear);
    // if (checkIsLeapYear) {
    //   arkamElBa3outh = listOfArkamElBa3outh['leapYear']!;
    // } else {
    //   arkamElBa3outh = listOfArkamElBa3outh['normalYear']!;
    // }
    //
    // /// get som el ba3outh day
    // int t1 = arkamElBa3outh + _eidAlKiyamaModel.day;
    // if (t1 > 31) {
    //   int t2 = t1 - 31;
    //   _somElBa3outhModel.day = t2;
    // } else {
    //   _somElBa3outhModel.day = t1;
    // }
    //
    // /// get kiyama date
    // String formattedDate =
    //     "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    // DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);
    // DateTime startDate =
    //     DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-1");
    // DateTime endDate =
    //     DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-10");
    // if (kiyamaDate.difference(startDate).inDays == 0 ||
    //     kiyamaDate.difference(endDate).inDays == 0 ||
    //     kiyamaDate.isAfter(startDate) && kiyamaDate.isBefore(endDate)) {
    //   _somElBa3outhModel.month = listOfMonths[1]!;
    // } else {
    //   _somElBa3outhModel.month = listOfMonths[2]!;
    // }
    // if (kiyamaDate.difference(endDate).inDays == 0) {
    //   /// check if its a leap year
    //   bool result = isLeapYear(currentYear);
    //   if (result) {
    //     _somElBa3outhModel.month = listOfMonths[2]!;
    //   }
    // }

    _somElBa3outh1String =
        "${_somElBa3outhModel.day}-${_somElBa3outhModel.month}-$currentYear";
    _somElBa3outh2String =
        "${_somElBa3outhModel.day + 1}-${_somElBa3outhModel.month}-$currentYear";
    _somElBa3outh3String =
        "${_somElBa3outhModel.day + 2}-${_somElBa3outhModel.month}-$currentYear";
    // print("here $_somElBa3outh1String");
    // print("here $_somElBa3outh2String");
    // print("here $_somElBa3outh3String");
  }

  calculateAlSomeAlKabir(int currentYear) {
    _somElKabirModel.year = currentYear;
    int arkamElSom = 0;
    bool checkIsLeapYear = isLeapYear(currentYear);
    if (checkIsLeapYear) {
      arkamElSom = listOfAlSomAlKabir['leapYear']!;
    } else {
      arkamElSom = listOfAlSomAlKabir['normalYear']!;
    }

    String formattedDate =
        "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);
    DateTime startDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-1");
    DateTime endDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-18");
    if (kiyamaDate.difference(startDate).inDays == 0 ||
        kiyamaDate.difference(endDate).inDays == 0 ||
        kiyamaDate.isAfter(startDate) && kiyamaDate.isBefore(endDate)) {
      _somElKabirModel.month = listOfMonths[2]!;
    } else {
      _somElKabirModel.month = listOfMonths[3]!;
    }

    /// get some el kabir day
    int t1 = arkamElSom + _eidAlKiyamaModel.day;
    if (_somElKabirModel.month == listOfMonths[3]!) {
      if (checkIsLeapYear) {
        int t2 = t1 - 29;
        _somElKabirModel.day = t2;
      } else {
        int t2 = t1 - 28;
        _somElKabirModel.day = t2;
      }
    } else {
      if (t1 > 31) {
        int t2 = t1 - 31;
        _somElKabirModel.day = t2;
      } else {
        _somElKabirModel.day = t1;
      }
    }
    _somElKabirString =
        "${_somElKabirModel.day}-${_somElKabirModel.month}-$currentYear";
  }

  calculateEidElSou3oud(int currentYear) {
    _eidElSou3oudModel.year = currentYear;
    int arkamEidElSou3oud = 9;
    String formattedDate =
        "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);
    DateTime startDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-1");
    DateTime endDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-22");
    if (kiyamaDate.difference(startDate).inDays == 0 ||
        kiyamaDate.difference(endDate).inDays == 0 ||
        kiyamaDate.isAfter(startDate) && kiyamaDate.isBefore(endDate)) {
      _eidElSou3oudModel.month = listOfMonths[5]!;
    } else {
      _eidElSou3oudModel.month = listOfMonths[6]!;
    }

    /// get eid el sou3oud day
    int t1 = arkamEidElSou3oud + _eidAlKiyamaModel.day;
    if (t1 > 31) {
      int t2 = t1 - 31;
      _eidElSou3oudModel.day = t2;
    } else {
      _eidElSou3oudModel.day = t1;
    }
    _eidElSou3oudString =
        "${_eidElSou3oudModel.day}-${_eidElSou3oudModel.month!}-$currentYear";

    // print(_eidElSou3oudModel.toJson());
  }

  calculateNosardil(int currentYear) {
    _nosardilModel.year = currentYear;
    int arkamNosardil = 0;

    String formattedDate =
        "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);

    /// get nosardil date
    DateTime firstDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-23");
    DateTime secondDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-24");
    DateTime thirdDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-25");

    if (kiyamaDate.difference(firstDate).inDays == 0 ||
        kiyamaDate.difference(secondDate).inDays == 0) {
      _nosardilModel.month = listOfMonths[6]!;
      arkamNosardil = 6;
    } else if (kiyamaDate.difference(thirdDate).inDays == 0) {
      _nosardilModel.month = listOfMonths[8]!;
      arkamNosardil = 7;
    } else {
      _nosardilModel.month = listOfMonths[7]!;
      arkamNosardil = 7;
    }

    /// get nosardil day
    int t1 = arkamNosardil + _eidAlKiyamaModel.day;
    if (t1 > 31) {
      int t2 = t1 - 31;
      _nosardilModel.day = t2;
    } else {
      _nosardilModel.day = t1;
    }

    _nosardilString =
        "${_nosardilModel.day}-${_nosardilModel.month!}-$currentYear";
  }

  calculateEliya(int currentYear) {
    _eliyaModel.year = currentYear;

    String formattedDate =
        "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);

    /// get arkam eliya
    int arkamEliya = 25;

    DateTime startDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-20");
    DateTime endDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-25");
    if (kiyamaDate.difference(startDate).inDays == 0 ||
        kiyamaDate.difference(endDate).inDays == 0 ||
        kiyamaDate.isAfter(startDate) && kiyamaDate.isBefore(endDate)) {
      arkamEliya = 18;
    }

    /// get eliya date
    DateTime firstDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-1");
    DateTime secondDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-6");

    if (kiyamaDate.difference(firstDate).inDays == 0 ||
        kiyamaDate.difference(secondDate).inDays == 0 ||
        kiyamaDate.isAfter(firstDate) && kiyamaDate.isBefore(secondDate)) {
      _eliyaModel.month = listOfMonths[8]!;
    }
    DateTime thirdDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-7");
    DateTime fourthDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-25");
    if (kiyamaDate.difference(thirdDate).inDays == 0 ||
        kiyamaDate.difference(fourthDate).inDays == 0 ||
        kiyamaDate.isAfter(thirdDate) && kiyamaDate.isBefore(fourthDate)) {
      _eliyaModel.month = listOfMonths[9]!;
    }

    /// get eliya day
    int t1 = arkamEliya + _eidAlKiyamaModel.day;
    if (t1 > 31) {
      int t2 = t1 - 31;
      _eliyaModel.day = t2;
    } else {
      _eliyaModel.day = t1;
    }

    _eliyaString = "${_eliyaModel.day}-${_eliyaModel.month!}-$currentYear";
  }

  calculateMoussa(int currentYear) {
    _moussaModel.year = currentYear;

    /// check if moussa exist
    if (_jam3ElDene7Model.weeks == 9) {
      _moussaModel.day = 0;
      _moussaModel.month = '';
      _moussaString = "0";
      return;
    }
    String formattedDate =
        "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);
    // print("kiyama ${currentYear} : $kiyamaDate");

    /// check if moussa exist
    ///  DateTime date_18_4 =
    DateTime date_17_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-17");
    DateTime date_18_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-18");
    DateTime date_19_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-19");
    DateTime date_24_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-24");
    DateTime date_25_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-25");
    if (kiyamaDate.difference(date_17_4).inDays == 0 ||
        kiyamaDate.difference(date_18_4).inDays == 0 ||
        kiyamaDate.difference(date_19_4).inDays == 0 ||
        kiyamaDate.difference(date_24_4).inDays == 0 ||
        kiyamaDate.difference(date_25_4).inDays == 0) {
      _moussaModel.day = 0;
      _moussaModel.month = '';
      _moussaString = "0";
      return;
    }

    // DateTime date_17_4 =
    //     DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-17");
    // DateTime date_20_4 =
    //     DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-20");
    // DateTime date_21_4 =
    //     DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-21");
    // DateTime date_22_4 =
    //     DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-22");
    // DateTime date_23_4 =
    //     DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-23");
    // if (kiyamaDate.difference(date_17_4).inDays != 0 &&
    //     kiyamaDate.difference(date_20_4).inDays != 0 &&
    //     kiyamaDate.difference(date_21_4).inDays != 0 &&
    //     kiyamaDate.difference(date_22_4).inDays != 0 &&
    //     kiyamaDate.difference(date_23_4).inDays != 0) {
    //   _moussaModel.day = 0;
    //   _moussaModel.month = '';
    //   _moussaString = "0";
    //   return;
    // }

    /// get arkam moussa
    int arkamMoussa = 6;

    DateTime startDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-3");
    DateTime endDate =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-16");
    if (kiyamaDate.difference(startDate).inDays == 0 ||
        kiyamaDate.difference(endDate).inDays == 0 ||
        kiyamaDate.isAfter(startDate) && kiyamaDate.isBefore(endDate)) {
      arkamMoussa = 13;
    }

    /// get moussa date
    _moussaModel.month = listOfMonths[10]!;

    /// get moussa day
    int t1 = arkamMoussa + _eidAlKiyamaModel.day;
    if (t1 > 31) {
      int t2 = t1 - 31;
      _moussaModel.day = t2;
    } else {
      _moussaModel.day = t1;
    }

    _moussaString = "${_moussaModel.day}-${_moussaModel.month!}-$currentYear";
    // print(
    // "arkam : $arkamMoussa - moussa : $_moussaString - kiyama ${_eidAlKiyamaModel.toString()}");
    if (_eidAlKiyamaModel.day == 17 && _eidAlKiyamaModel.month == "April") {
      // print("the year : ${_eidAlKiyamaModel.year}");
    }
  }

  calculateTakdisElBi3a(int currentYear) {
    _takdisElBi3aModel.year = currentYear;

    String formattedDate =
        "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);

    /// get takdisElBi3a date
    DateTime date_29_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-29");
    DateTime date_5_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-5");
    DateTime date_12_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-12");
    DateTime date_19_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-19");

    if (kiyamaDate.difference(date_29_3).inDays == 0 ||
        kiyamaDate.difference(date_5_4).inDays == 0 ||
        kiyamaDate.difference(date_12_4).inDays == 0 ||
        kiyamaDate.difference(date_19_4).inDays == 0) {
      _takdisElBi3aModel.day = 1;
      _takdisElBi3aModel.month = listOfMonths[11]!;
      _takdisElBi3aString =
          '${_takdisElBi3aModel.day}-${_takdisElBi3aModel.month}-$currentYear';
      return;
    }

    DateTime date_23_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-23");
    DateTime date_30_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-30");
    DateTime date_6_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-6");
    DateTime date_13_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-13");
    DateTime date_20_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-20");

    if (kiyamaDate.difference(date_23_3).inDays == 0 ||
        kiyamaDate.difference(date_30_3).inDays == 0 ||
        kiyamaDate.difference(date_6_4).inDays == 0 ||
        kiyamaDate.difference(date_13_4).inDays == 0 ||
        kiyamaDate.difference(date_20_4).inDays == 0) {
      _takdisElBi3aModel.day = 2;
      _takdisElBi3aModel.month = listOfMonths[11]!;
      _takdisElBi3aString =
          '${_takdisElBi3aModel.day}-${_takdisElBi3aModel.month}-$currentYear';
      return;
    }

    DateTime date_24_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-24");
    DateTime date_31_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-31");
    DateTime date_7_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-7");
    DateTime date_14_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-14");
    DateTime date_21_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-21");

    if (kiyamaDate.difference(date_24_3).inDays == 0 ||
            kiyamaDate.difference(date_31_3).inDays == 0 ||
            kiyamaDate.difference(date_7_4).inDays == 0 ||
            kiyamaDate.difference(date_14_4).inDays == 0 ||
            kiyamaDate.difference(date_21_4).inDays == 0
        // ||
        // kiyamaDate.isAfter(date_14_4) && kiyamaDate.isBefore(date_21_4)
        ) {
      _takdisElBi3aModel.day = 3;
      _takdisElBi3aModel.month = listOfMonths[11]!;
      _takdisElBi3aString =
          '${_takdisElBi3aModel.day}-${_takdisElBi3aModel.month}-$currentYear';
      return;
    }

    DateTime date_25_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-25");
    DateTime date_1_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-1");
    DateTime date_8_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-8");
    DateTime date_15_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-15");
    DateTime date_22_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-22");

    if (kiyamaDate.difference(date_25_3).inDays == 0 ||
        kiyamaDate.difference(date_1_4).inDays == 0 ||
        kiyamaDate.difference(date_8_4).inDays == 0 ||
        kiyamaDate.difference(date_15_4).inDays == 0 ||
        kiyamaDate.difference(date_22_4).inDays == 0) {
      _takdisElBi3aModel.day = 4;
      _takdisElBi3aModel.month = listOfMonths[11]!;
      _takdisElBi3aString =
          '${_takdisElBi3aModel.day}-${_takdisElBi3aModel.month}-$currentYear';
      return;
    }

    DateTime date_26_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-26");
    DateTime date_9_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-9");
    DateTime date_2_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-2");
    DateTime date_16_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-16");
    DateTime date_23_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-23");

    if (kiyamaDate.difference(date_26_3).inDays == 0 ||
        kiyamaDate.difference(date_9_4).inDays == 0 ||
        kiyamaDate.difference(date_2_4).inDays == 0 ||
        kiyamaDate.difference(date_16_4).inDays == 0 ||
        kiyamaDate.difference(date_23_4).inDays == 0) {
      _takdisElBi3aModel.day = 5;
      _takdisElBi3aModel.month = listOfMonths[11]!;
      _takdisElBi3aString =
          '${_takdisElBi3aModel.day}-${_takdisElBi3aModel.month}-$currentYear';
      return;
    }

    DateTime date_27_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-27");
    DateTime date_3_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-3");
    DateTime date_10_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-10");
    DateTime date_17_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-17");
    DateTime date_24_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-24");

    if (kiyamaDate.difference(date_27_3).inDays == 0 ||
        kiyamaDate.difference(date_3_4).inDays == 0 ||
        kiyamaDate.difference(date_10_4).inDays == 0 ||
        kiyamaDate.difference(date_17_4).inDays == 0 ||
        kiyamaDate.difference(date_24_4).inDays == 0) {
      _takdisElBi3aModel.day = 30;
      _takdisElBi3aModel.month = listOfMonths[10]!;
      _takdisElBi3aString =
          '${_takdisElBi3aModel.day}-${_takdisElBi3aModel.month}-$currentYear';
      return;
    }

    DateTime date_28_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-28");
    DateTime date_4_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-4");
    DateTime date_11_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-11");
    DateTime date_18_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-18");
    DateTime date_25_4 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-April-25");

    if (kiyamaDate.difference(date_28_3).inDays == 0 ||
        kiyamaDate.difference(date_4_4).inDays == 0 ||
        kiyamaDate.difference(date_11_4).inDays == 0 ||
        kiyamaDate.difference(date_18_4).inDays == 0 ||
        kiyamaDate.difference(date_25_4).inDays == 0) {
      _takdisElBi3aModel.day = 31;
      _takdisElBi3aModel.month = listOfMonths[10]!;
      _takdisElBi3aString =
          '${_takdisElBi3aModel.day}-${_takdisElBi3aModel.month}-$currentYear';
      return;
    }
  }

  calculateJam3ElDene7(int currentYear) {
    _jam3ElDene7Model.year = currentYear;

    String formattedDate =
        "$currentYear-${_eidAlKiyamaModel.month}-${_eidAlKiyamaModel.day}";
    DateTime kiyamaDate = DateFormat('yyyy-MMMM-dd').parse(formattedDate);

    /// get jam3ElDene7 date
    DateTime date_1_3 =
        DateFormat('yyyy-MMMM-dd').parse("$currentYear-March-1");

    if (kiyamaDate.month == 3) {
      _jam3ElDene7Model.weeks = (kiyamaDate.day + 8) ~/ 7;
    }
    if (kiyamaDate.month == 4) {
      _jam3ElDene7Model.weeks = (31 + kiyamaDate.day + 8) ~/ 7;
    }
    _jam3ElDene7Int = _jam3ElDene7Model.weeks;
  }

  /// whether or not is leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  void khitanatAlRab(int currentYear) =>
      _khitanatAlRab = "1-${listOfMonths[1]}-$currentYear";

  void a7adMaBa3daElmilad(int currentYear) {
    // _a7adMaBa3daElmilad = "26-${listOfMonths[12]}-$currentYear";

    if (DateTime.parse(DateFormat('dd-MMMM-yyyy')
                .parse(_eidMiladRabinaYasou3ElMasih)
                .toString())
            .weekday ==
        7) {
      _a7adMaBa3daElmilad = _eidMiladRabinaYasou3ElMasih;
    } else {
      DateTime tmp1 = findNthDayAfter(
          startDate: DateTime.parse(DateFormat('dd-MMMM-yyyy')
              .parse(_eidMiladRabinaYasou3ElMasih)
              .toString()),
          x: 1,
          dayName: 'Sunday');
      _a7adMaBa3daElmilad =
          "${tmp1.day}-${listOfMonths[tmp1.month]}-${tmp1.year}";
    }

    DateTime tmp2 = findNthDayAfter(
        startDate: DateTime.parse(
            DateFormat('dd-MMMM-yyyy').parse(_takdisElBi3aString).toString()),
        x: 4,
        dayName: 'Sunday');
    _sebou3ElBshara = "${tmp2.day}-${listOfMonths[tmp2.month]}-${tmp2.year}";
  }

  void eidElDene7(int currentYear) {
    _eidElDene7 = "6-${listOfMonths[1]}-$currentYear";

    DateTime tmp = findNthDayAfter(
        startDate: DateTime.parse(
            DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
        x: 1,
        dayName: 'Sunday');
    _sebou3ElDene7 = "${tmp.day}-${listOfMonths[tmp.month]}-${tmp.year}";
    // print("deneh : ${_sebou3ElDene7}");
  }

  void marAntonios(int currentYear) =>
      _marAntonios = "17-${listOfMonths[1]}-$currentYear";

  void doukhoulElRab2ilaElHaykal(int currentYear) =>
      _doukhoulElRab2ilaElHaykal = "2-${listOfMonths[2]}-$currentYear";

  void tazkarMarKiwarkis(int currentYear) =>
      _tazkarMarKiwarkis = "24-${listOfMonths[4]}-$currentYear";

  void eidHafizatElZourou3(int currentYear) =>
      _eidHafizatElZourou3 = "15-${listOfMonths[5]}-$currentYear";

  void eidZiyaratEl3azra2ilaElisabat(int currentYear) =>
      _eidZiyaratEl3azra2ilaElisabat = "21-${listOfMonths[6]}-$currentYear";

  void marBoutrosWBoulos(int currentYear) =>
      _marBoutrosWBoulos = "29-${listOfMonths[6]}-$currentYear";

  void marToumaElRasoul(int currentYear) =>
      _marToumaElRasoul = "3-${listOfMonths[7]}-$currentYear";

  void eidTajaliAlRabAlaJabalTabour(int currentYear) =>
      _eidTajaliAlRabAlaJabalTabour = "6-${listOfMonths[8]}-$currentYear";

  void eid2intikalEl3azra2ilaElSama(int currentYear) =>
      _eid2intikalEl3azra2ilaElSama = "15-${listOfMonths[8]}-$currentYear";

  void eidWiladatEl3azraMaryam(int currentYear) =>
      _eidWiladatEl3azraMaryam = "8-${listOfMonths[9]}-$currentYear";

  void eidElSalibElMoukadas(int currentYear) =>
      _eidElSalibElMoukadas = "14-${listOfMonths[9]}-$currentYear";

  void eidYasou3ElMalak(int currentYear) =>
      _eidYasou3ElMalak = "31-${listOfMonths[10]}-$currentYear";

  void eidYa3koubElMkta3(int currentYear) =>
      _eidYa3koubElMkta3 = "27-${listOfMonths[11]}-$currentYear";

  void el2ediseBerbara(int currentYear) =>
      _el2ediseBerbara = "4-${listOfMonths[12]}-$currentYear";

  void marNiklawous(int currentYear) =>
      _marNiklawous = "6-${listOfMonths[12]}-$currentYear";

  void eidEl3azraElMahboulBihaBilaDanas(int currentYear) =>
      _eidEl3azraElMahboulBihaBilaDanas = "8-${listOfMonths[12]}-$currentYear";

  void eidMiladRabinaYasou3ElMasih(int currentYear) =>
      _eidMiladRabinaYasou3ElMasih = "25-${listOfMonths[12]}-$currentYear";

  void eidTatwibMaryamEl3azra(int currentYear) =>
      _eidTatwibMaryamEl3azra = "26-${listOfMonths[12]}-$currentYear";

  void zikraKatel2atfalBeitLahm(int currentYear) =>
      _zikraKatel2atfalBeitLahm = "27-${listOfMonths[12]}-$currentYear";

  void joseph(int currentYear) =>
      _joseph = "19-${listOfMonths[3]}-$currentYear";

  void annunciationMary(int currentYear) =>
      _annunciationMary = "25-${listOfMonths[3]}-$currentYear";

  void memoryOf72disciples(int currentYear) =>
      _memoryOf72disciples = "1-${listOfMonths[5]}-$currentYear";

  void sebou3ElRousol(int currentYear) {
    DateTime tmp = findNthDayAfter(
        startDate: DateTime.parse(
            DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
        x: 7,
        dayName: 'Sunday');

    _sebou3ElRousol = "${tmp.day}-${listOfMonths[tmp.month]}-${tmp.year}";
  }

  void shmoni(int currentYear) => _shmoni = "1-${listOfMonths[5]}-$currentYear";

  void ciriaco(int currentYear) =>
      _ciriaco = "15-${listOfMonths[7]}-$currentYear";

  void virginMary(int currentYear) =>
      _virginMary = "31-${listOfMonths[5]}-$currentYear";

  void ephrem(int currentYear) =>
      _ephrem = "18-${listOfMonths[6]}-$currentYear";

  void maryOfPerpetualHelp(int currentYear) =>
      _maryOfPerpetualHelp = "27-${listOfMonths[6]}-$currentYear";

  void mikha(int currentYear) => _mikha = "1-${listOfMonths[11]}-$currentYear";

  ///Result

  Map<String, DateTime> getAllResults(
      {required BuildContext context, required int currentYear}) {
    // print("getting all results ");
    Map<String, DateTime> holidays = {};
    if (currentYear > 1900) {
      this.currentYear = currentYear;

      calculateAsesElSene(currentYear); //
      calculateMaraji3ElKiyama(currentYear); //
      calculateEdiAlKiyama(currentYear);
      sebou3ElRousol(currentYear);
      calculateAlSomeAlKabir(currentYear);
      calculateSomElBa3outh(currentYear);
      calculateEidElSou3oud(currentYear);
      calculateNosardil(currentYear);
      calculateEliya(currentYear);
      calculateTakdisElBi3a(currentYear);
      calculateJam3ElDene7(currentYear); //
      calculateMoussa(currentYear);

      khitanatAlRab(currentYear);
      eidElDene7(currentYear);
      marAntonios(currentYear);
      doukhoulElRab2ilaElHaykal(currentYear);
      tazkarMarKiwarkis(currentYear);
      eidHafizatElZourou3(currentYear);
      eidZiyaratEl3azra2ilaElisabat(currentYear);
      marBoutrosWBoulos(currentYear);
      marToumaElRasoul(currentYear);
      eidTajaliAlRabAlaJabalTabour(currentYear);
      eid2intikalEl3azra2ilaElSama(currentYear);
      eidWiladatEl3azraMaryam(currentYear);

      eidElSalibElMoukadas(currentYear);
      eidYasou3ElMalak(currentYear);
      eidYa3koubElMkta3(currentYear);
      el2ediseBerbara(currentYear);
      marNiklawous(currentYear);
      eidEl3azraElMahboulBihaBilaDanas(currentYear);
      eidMiladRabinaYasou3ElMasih(currentYear);

      a7adMaBa3daElmilad(currentYear);

      eidTatwibMaryamEl3azra(currentYear);
      zikraKatel2atfalBeitLahm(currentYear);

      joseph(currentYear);
      annunciationMary(currentYear);
      shmoni(currentYear);
      memoryOf72disciples(currentYear);
      ciriaco(currentYear);
      virginMary(currentYear);
      ephrem(currentYear);
      maryOfPerpetualHelp(currentYear);
      mikha(currentYear);

      _currentLanguage = GetStorageHelper().getLanguage();

      if (Provider.of<ProviderChurch>(context, listen: false).churchName ==
          "Chaldean") {
        holidays = _checkChaldean(holidays: holidays);
        holidays = _checkJam3ElDene7Chaldean(holidays: holidays);
      }
      if (Provider.of<ProviderChurch>(context, listen: false).churchName ==
          "Syriac") {
        holidays = _checkSyriac(holidays: holidays);
        holidays = _checkJam3ElDene7Syriac(holidays: holidays);
      }

      // for (int i = 0; i < holidaysNames.length; i++) {
      //   if(holidays.keys.contains(holidaysNames[i][_currentLanguage])){
      //     print("$i: ${holidaysNames[i][_currentLanguage]}");
      //   }
      // }
      // print("Length: ${holidays.length}");
      // print("LengthHolidaysNames: ${holidaysNames.length - 1}");
    }

    notifyListeners();
    return holidays;
  }

  Map<int, Map<String, DateTime>> getAllResultsAllYears(
      {required BuildContext context,
      required String startYear,
      required String endYear}) {
    /// Check empty
    if (startYear.toString().trim().isEmpty ||
        endYear.toString().trim().isEmpty) {
      errorPopup(context, "Field can not be empty.");
      return {};
    }

    /// Initialize
    holidaysAll = {};
    int startYearInt = int.parse(startYear);
    int endYearInt = int.parse(endYear);

    /// Check endYear grater than startYear
    if (startYearInt <= 1900) {
      errorPopup(context, "Start Year has to be grater than 1900.");
      return {};
    }
    if (startYearInt <= 1900) {
      errorPopup(context, "End Year has to be grater than 1900.");
      return {};
    }

    /// Check endYear grater/equal than/to  startYear
    if (endYearInt < startYearInt) {
      errorPopup(
          context, "End Year has to be grater/equal than/to Start Year.");
      return {};
    }

    _currentLanguage = GetStorageHelper().getLanguage();
    for (int currentYear = startYearInt;
        currentYear <= endYearInt;
        currentYear++) {
      holidaysAll[currentYear] =
          getAllResults(context: context, currentYear: currentYear);
    }
    notifyListeners();
    return holidaysAll;
  }

  // void getAllResultsAllYearsExcel(
  //     {required BuildContext context,
  //       required String startYear,
  //       required String endYear}) {
  //   /// Check empty
  //   if (startYear.toString().trim().isEmpty ||
  //       endYear.toString().trim().isEmpty) {
  //     errorPopup(context, "Field can not be empty.");
  //     return;
  //   }
  //
  //   /// Initialize
  //   holidaysAll = {};
  //   int startYearInt = int.parse(startYear);
  //   int endYearInt = int.parse(endYear);
  //
  //   /// Check endYear grater than startYear
  //   if (startYearInt <= 1900) {
  //     errorPopup(context, "Start Year has to be grater than 1900.");
  //     return;
  //   }
  //   if (startYearInt <= 1900) {
  //     errorPopup(context, "End Year has to be grater than 1900.");
  //     return;
  //   }
  //
  //   /// Check endYear grater/equal than/to  startYear
  //   if (endYearInt < startYearInt) {
  //     errorPopup(
  //         context, "End Year has to be grater/equal than/to Start Year.");
  //     return;
  //   }
  //
  //   getAllResultsAllYears(
  //     context: context,
  //     startYear: startYear,
  //     endYear: endYear,
  //   );
  //
  //   if (holidaysAll == {}) {
  //     errorPopup(context, "No Holidays found.");
  //     return;
  //   }
  //
  //   final excel = Excel.createExcel();
  //
  //   for (int currentYear = startYearInt;
  //   currentYear <= endYearInt;
  //   currentYear++) {
  //     if (holidaysAll[currentYear] == {}) {
  //       errorPopup(context, "No Holidays found for year $currentYear.");
  //       return;
  //     }
  //
  //     final sheet = excel['$currentYear'];
  //     sheet.appendRow(['Holidays', 'Dates']);
  //
  //     holidaysAll[currentYear]!.forEach((key, value) {
  //       sheet.appendRow(
  //           [key, convertDateTimeDisplay(value.toString()).toString()]);
  //     });
  //     // List<String> keys = holidaysAll[currentYear]!.keys.toList();
  //     // List<DateTime> values = holidaysAll[currentYear]!.values.toList();
  //   }
  //   excel.delete('Sheet1');
  //
  //   /// Save
  //
  //   /// Web
  //   var bytes =
  //   excel.save(fileName: "Holidays_${startYearInt}_$endYearInt.csv");
  //   // var bytes = excel.save(fileName: "Holidays_${startYearInt}_$endYearInt.xlsx");
  //
  //   /// Desktop (MacOs Windows)
  //   // String outputFile = "${Directory.current.path}/Holidays_${startYearInt}_$endYearInt.xlsx";
  //   // List<int>? fileBytes = excel.save();
  //   //print('saving executed in ${stopwatch.elapsed}');
  //   // if (fileBytes != null) {
  //   //   debugPrint("Saved at path: $outputFile");
  //   //   File(outputFile)
  //   //     ..createSync(recursive: true)
  //   //     ..writeAsBytesSync(fileBytes);
  //   // }
  //   // final fileBytes = excel.encode();
  //
  //   notifyListeners();
  //   return;
  // }

  DateTime findNthDayAfter(
      {required DateTime startDate, required int x, required String dayName}) {
    // Create a map to map the day names to their corresponding numerical representation
    final dayMap = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    // Get the numerical representation of the desired day
    final desiredDay = dayMap[dayName];

    // Start iterating from the next day after the start date
    var currentDate = startDate.add(const Duration(days: 1));

    // Keep track of the number of occurrences found
    var occurrencesFound = 0;

    // Iterate until the desired number of occurrences are found
    while (occurrencesFound < x) {
      // If the current day matches the desired day, increment the occurrences count
      if (currentDate.weekday == desiredDay) {
        occurrencesFound++;
      }

      // Move to the next day
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return currentDate.subtract(const Duration(days: 1));
  }

  DateTime findNthDayBefore({
    required DateTime startDate,
    required int x,
    required String dayName,
  }) {
    // Create a map to map the day names to their corresponding numerical representation
    final dayMap = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    // Get the numerical representation of the desired day
    final desiredDay = dayMap[dayName];

    // Start iterating from the day before the start date
    var currentDate = startDate.subtract(const Duration(days: 1));

    // Keep track of the number of occurrences found
    var occurrencesFound = 0;

    // Iterate until the desired number of occurrences are found
    while (occurrencesFound < x) {
      // If the current day matches the desired day, increment the occurrences count
      if (currentDate.weekday == desiredDay) {
        occurrencesFound++;
      }

      // Move to the previous day
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return currentDate.add(const Duration(days: 1));
  }

// Future<void> getAllResultsWithDB(int currentYear) async {
//   if (currentYear > 1900) {
//     ///Calculate
//     calculateAsesElSene(currentYear); //
//     calculateMaraji3ElKiyama(currentYear); //
//     calculateEdiAlKiyama(currentYear);
//     calculateSomElBa3outh(currentYear);
//     calculateAlSomeAlKabir(currentYear);
//     calculateEidElSou3oud(currentYear);
//     calculateNosardil(currentYear);
//     calculateEliya(currentYear);
//     calculateTakdisElBi3a(currentYear);
//     calculateJam3ElDene7(currentYear); //
//     calculateMoussa(currentYear);
//
//     ///Create holidaysList
//     //  String _asesElSeneString = "";//
//     //   String _maraji3AlKiyamaString = "";//
//     //   String _eidAlKiyamaString = "";
//     //   String _somElBa3outhString = "";
//     //   String _somElKabirString = "";
//     //   String _eidElSou3oudString = "";
//     //   String _nosardilString = "";
//     //   String _eliyaString = "";
//     //   String _moussaString = "";
//     //   String _takdisElBi3aString = "";
//     //   String _jam3ElDene7String = "";//
//
//     List<Map<String, dynamic>> holidaysList = [];
//     holidaysList.addAll([
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Eid Al Kiyama',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString(),
//       },
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Som El Ba3outh',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_somElBa3outhString).toString(),
//       },
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Som El Kabir',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString(),
//       },
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Eid El Sou3oud',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_eidElSou3oudString).toString(),
//       },
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Nosardil',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString(),
//       },
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Eliya',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString(),
//       },
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Moussa',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_moussaString).toString(),
//       },
//       {
//         'prayer_id': 0,
//         'holiday_name': 'Takdis El Bi3a',
//         'holiday_date':
//             DateFormat('dd-MMMM-yyyy').parse(_takdisElBi3aString).toString(),
//       }
//     ]);
//
//     ///Send data to the database
//     var data = {
//       'version': globals.version,
//       'holidaysList': holidaysList,
//     };
//
//     // print(data);
//     // var res = await CallApi().postData(data, '/Holidays/Control/(Control)insertHolidays.php');
//     // print(res.body);
//     // List<dynamic> body = json.decode(res.body);
//     //
//     // if (res.statusCode == 200) {
//     //   if (body[0] == "Success") {
//     //     debugPrint('Success');
//     //     ///setState
//     //     notifyListeners();
//     //   }
//     // }
//   }
// }

  Future<void> getAllResultsWithDB(int currentYear) async {
    if (currentYear > 1900) {
      ///Calculate
      calculateAsesElSene(currentYear); //
      calculateMaraji3ElKiyama(currentYear); //
      calculateEdiAlKiyama(currentYear);
      calculateSomElBa3outh(currentYear);
      calculateAlSomeAlKabir(currentYear);
      calculateEidElSou3oud(currentYear);
      calculateNosardil(currentYear);
      calculateEliya(currentYear);
      calculateTakdisElBi3a(currentYear);
      calculateJam3ElDene7(currentYear); //
      calculateMoussa(currentYear);

      ///Create holidaysList
      //  String _asesElSeneString = "";//
      //   String _maraji3AlKiyamaString = "";//
      //   String _eidAlKiyamaString = "";
      //   String _somElBa3outhString = "";
      //   String _somElKabirString = "";
      //   String _eidElSou3oudString = "";
      //   String _nosardilString = "";
      //   String _eliyaString = "";
      //   String _moussaString = "";
      //   String _takdisElBi3aString = "";
      //   String _jam3ElDene7String = "";//

      List<Map<String, dynamic>> holidaysList = [];
      // holidaysList.addAll([
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Eid Al Kiyama',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString(),
      //   },
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Som El Ba3outh',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_somElBa3outhString).toString(),
      //   },
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Som El Kabir',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString(),
      //   },
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Eid El Sou3oud',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_eidElSou3oudString).toString(),
      //   },
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Nosardil',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString(),
      //   },
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Eliya',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString(),
      //   },
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Moussa',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_moussaString).toString(),
      //   },
      //   {
      //     'prayer_id': 0,
      //     'holiday_name': 'Takdis El Bi3a',
      //     'holiday_date':
      //         DateFormat('dd-MMMM-yyyy').parse(_takdisElBi3aString).toString(),
      //   }
      // ]);

      ///Send data to the database
      var data = {
        'version': globals.version,
        'holidaysList': holidaysList,
      };

      // print(data);
      // var res = await CallApi().postData(data, '/Holidays/Control/(Control)insertHolidays.php');
      // print(res.body);
      // List<dynamic> body = json.decode(res.body);
      //
      // if (res.statusCode == 200) {
      //   if (body[0] == "Success") {
      //     debugPrint('Success');
      //     ///setState
      //     notifyListeners();
      //   }
      // }
    }
  }

  // Yellow
  Map<String, DateTime> _checkChaldean(
      {required Map<String, DateTime> holidays}) {
    return {
      // 'Ases El Sene': calculateAsesElSene(currentYear),
      // 'Maraji3 El Kiyama': calculateMaraji3ElKiyama(currentYear),

      // 'A7ad Ma Ba3da Elmilad'
      holidaysNames[1][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_a7adMaBa3daElmilad).toString()),

      // 'Sebou3 El Bshara'
      holidaysNames[2][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_sebou3ElBshara).toString()),

      // 'Eid El Dene7'
      holidaysNames[3][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_sebou3ElDene7).toString()),

      // 'Al Some Al Kabir'
      holidaysNames[4][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),

      // 'Eid Al Kiyama'
      holidaysNames[5][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),

      // 'Sabou3 El Rousoul'
      holidaysNames[6][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),

      // 'Nosardil' summer
      holidaysNames[7][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
      // 'Eliya'
      holidaysNames[8][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString()),
      // 'Moussa'
      holidaysNames[9][_currentLanguage] ?? 'error': _moussaString == "0"
          ? DateTime(0)
          : DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_moussaString).toString()),
      // 'Takdis El Bi3a'
      holidaysNames[10][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_takdisElBi3aString).toString()),

      // 'Jam3 El Dene7': calculateJam3ElDene7(currentYear),

      /// 2a3yed sebte

      holidaysNames[20][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_el2ediseBerbara).toString()),
      // 'Mar Niklawous'
      holidaysNames[21][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_marNiklawous).toString()),
      // 'Eid El 3azra El Mahboul Biha Bila Danas'
      holidaysNames[22][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eidEl3azraElMahboulBihaBilaDanas)
              .toString()),
      // 'Eid Milad Rabina Yasou3 El Masih'
      holidaysNames[23][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eidMiladRabinaYasou3ElMasih)
              .toString()),
      // 'Eid Tatwib Maryam El 3azra'
      holidaysNames[24][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidTatwibMaryamEl3azra).toString()),
      holidaysNames[25][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_zikraKatel2atfalBeitLahm)
              .toString()),
      // 'Khitanat Al Rab'
      holidaysNames[26][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse("1-${listOfMonths[1]}-$currentYear")
              .toString()),
      // DateFormat('dd-MMMM-yyyy').parse(_khitanatAlRab).toString()),
      // 'Eid El Dene7'
      holidaysNames[27][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
      // 'Mar Antonios'
      holidaysNames[28][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_marAntonios).toString()),
      // 'Doukhoul El Rab 2ila El Haykal'
      holidaysNames[29][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_doukhoulElRab2ilaElHaykal)
              .toString()),
      // 'Tazkar Mar Kiwarkis'
      holidaysNames[30][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_tazkarMarKiwarkis).toString()),
      // 'Eid Hafizat El Zourou3'
      holidaysNames[31][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidHafizatElZourou3).toString()),
      // 'Eid Ziyarat El 3azra 2ila El isabat'
      holidaysNames[32][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eidZiyaratEl3azra2ilaElisabat)
              .toString()),
      // 'Mar Touma El Rasoul'
      holidaysNames[33][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_marToumaElRasoul).toString()),
      // 'Eid Tajali Al Rab Ala Jabal Tabour'
      holidaysNames[34][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eidTajaliAlRabAlaJabalTabour)
              .toString()),
      // 'Eid 2intikal El 3azra 2ila El Sama'
      holidaysNames[35][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eid2intikalEl3azra2ilaElSama)
              .toString()),
      // 'Eid Wiladat El 3azra Maryam'
      holidaysNames[36][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eidWiladatEl3azraMaryam)
              .toString()),
      // 'Eid El Salib El Moukadas'
      holidaysNames[37][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidElSalibElMoukadas).toString()),
      // 'Eid Yasou3 El Malak'
      holidaysNames[38][_currentLanguage] ?? 'error': findNthDayBefore(
          startDate: DateTime.parse(DateFormat('dd-MMMM-yyyy')
              .parse("1-${listOfMonths[11]}-$currentYear")
              .toString()),
          x: 1,
          dayName: 'Sunday'),
      // 'Eid Ya3koub El Mkta3'
      holidaysNames[39][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidYa3koubElMkta3).toString()),
      holidaysNames[40][_currentLanguage] ?? 'error':
          DateTime.parse(DateFormat('dd-MMMM-yyyy').parse(_joseph).toString()),

      //'Feast of the annunciation of the Virgin Mary'
      holidaysNames[41][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_sebou3ElBshara).toString()),
          x: 1, // 2 - (1)
          dayName: 'Sunday'),
      holidaysNames[42][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 3,
          dayName: 'Monday'),

      holidaysNames[43][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(DateFormat('dd-MMMM-yyyy')
              .parse("30-${listOfMonths[4]}-$currentYear")
              .toString()),
          x: 1,
          dayName: 'Tuesday'),

      //'Memory of saint Adday the Apostle'
      holidaysNames[44][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 4, //5 - (1)
          dayName: 'Sunday'),

      // 'Eid El Sou3oud'
      holidaysNames[45][_currentLanguage] ?? 'error': DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString())
          .add(const Duration(days: 39)), // 40 - (1)

      // 'Solemnity of Pentecost'
      holidaysNames[46][_currentLanguage] ?? 'error': DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString())
          .add(const Duration(days: 49)), // 50 - (1)

      //'The Gold Friday'
      holidaysNames[47][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),
          x: 1,
          dayName: 'Friday'),

      //'Corpus Christi'
      holidaysNames[48][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),
          x: 2,
          dayName: 'Thursday'),

      //'Memory of 72 disciples'
      holidaysNames[49][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),
          x: 7,
          dayName: 'Friday'),
      // holidaysNames[49][_currentLanguage] ?? 'error': DateTime.parse(
      //     DateFormat('dd-MMMM-yyyy').parse(_memoryOf72disciples).toString()),

      //'Memory of 12 Apostles'
      holidaysNames[50][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 0, // 1 - (1)
          dayName: 'Sunday'),

      //'Memory of saint Shimun Bar-Sabba’i'
      holidaysNames[51][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 6,
          dayName: 'Friday'),

      holidaysNames[52][_currentLanguage] ?? 'error':
          DateTime.parse(DateFormat('dd-MMMM-yyyy').parse(_ciriaco).toString()),

      //'Memory of the Sacred Heart of Jesus'
      holidaysNames[53][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),
          x: 3,
          dayName: 'Friday'),

      holidaysNames[54][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_virginMary).toString()),
      holidaysNames[55][_currentLanguage] ?? 'error':
          DateTime.parse(DateFormat('dd-MMMM-yyyy').parse(_ephrem).toString()),
      holidaysNames[56][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_maryOfPerpetualHelp).toString()),
      holidaysNames[57][_currentLanguage] ?? 'error':
          DateTime.parse(DateFormat('dd-MMMM-yyyy').parse(_mikha).toString()),
      // 'Som El Ba3outh'
      holidaysNames[58][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_somElBa3outh1String).toString()),
      holidaysNames[59][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_somElBa3outh2String).toString()),
      holidaysNames[60][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_somElBa3outh3String).toString()),
      holidaysNames[64][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 1,
          dayName: 'Friday'),
      holidaysNames[65][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 5, //6 - (1)
          dayName: 'Sunday'),
      holidaysNames[66][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 6,
          dayName: 'Friday'),
      holidaysNames[67][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 6, //7 - (1)
          dayName: 'Sunday'),
      holidaysNames[68][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 7,
          dayName: 'Thursday'),
      holidaysNames[69][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 7,
          dayName: 'Friday'),
      holidaysNames[70][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 7,
          dayName: 'Saturday'),
      holidaysNames[71][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 0, // 1 - (1)
          dayName: 'Sunday'),
      holidaysNames[72][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 1, // 2 - (1)
          dayName: 'Sunday'),
      holidaysNames[73][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 1,
          dayName: 'Friday'),
      holidaysNames[74][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 2,
          dayName: 'Friday'),
      holidaysNames[75][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 7,
          dayName: 'Friday'),
      holidaysNames[76][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString()),
          x: 1,
          dayName: 'Friday'),
      holidaysNames[77][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString()),
          x: 7,
          dayName: 'Friday'),
      holidaysNames[78][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse("1-${listOfMonths[9]}-$currentYear")
              .toString()),
      holidaysNames[79][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_takdisElBi3aString).toString()),
          x: 1,
          dayName: 'Friday'),
    };
  }

  // Red
  Map<String, DateTime> _checkSyriac(
      {required Map<String, DateTime> holidays}) {
    return {
      // 'Ases El Sene': calculateAsesElSene(currentYear),
      // 'Maraji3 El Kiyama': calculateMaraji3ElKiyama(currentYear),

      // 'A7ad Ma Ba3da Elmilad'
      holidaysNames[1][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_a7adMaBa3daElmilad).toString()),

      // 'Sebou3 El Bshara'
      holidaysNames[2][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_sebou3ElBshara).toString()),

      // 'Eid El Dene7'
      holidaysNames[3][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_sebou3ElDene7).toString()),

      // 'Al Some Al Kabir'
      holidaysNames[4][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),

      // 'Eid Al Kiyama'
      holidaysNames[5][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),

      // 'Sabou3 El Rousoul'
      holidaysNames[6][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),

      // 'Nosardil' summer
      holidaysNames[7][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
      // 'Eliya'
      holidaysNames[8][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString()),
      // 'Moussa'
      holidaysNames[9][_currentLanguage] ?? 'error': _moussaString == "0"
          ? DateTime(0)
          : DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_moussaString).toString()),
      // 'Takdis El Bi3a'
      holidaysNames[10][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_takdisElBi3aString).toString()),

      // 'Jam3 El Dene7': calculateJam3ElDene7(currentYear),

      /// 2a3yed sebte

      // 'Eid Milad Rabina Yasou3 El Masih'
      holidaysNames[23][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eidMiladRabinaYasou3ElMasih)
              .toString()),
      // 'Eid El Dene7'
      holidaysNames[27][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
      // 'Tazkar Mar Kiwarkis'
      holidaysNames[30][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_tazkarMarKiwarkis).toString()),
      // 'Mar Touma El Rasoul'
      holidaysNames[33][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_marToumaElRasoul).toString()),
      // 'Eid Tajali Al Rab Ala Jabal Tabour'
      holidaysNames[34][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eidTajaliAlRabAlaJabalTabour)
              .toString()),
      // 'Eid El Salib El Moukadas'
      holidaysNames[37][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse("13-${listOfMonths[9]}-$currentYear")
              .toString()),
      // 'Eid Ya3koub El Mkta3'
      holidaysNames[39][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse("19-${listOfMonths[11]}-$currentYear")
              .toString()),
      holidaysNames[42][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse("25-${listOfMonths[10]}-$currentYear")
              .toString()),
      holidaysNames[43][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(DateFormat('dd-MMMM-yyyy')
              .parse("30-${listOfMonths[4]}-$currentYear")
              .toString()),
          x: 1,
          dayName: 'Tuesday'),
      //'Memory of saint Adday the Apostle'
      holidaysNames[44][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 4, // 4 - (1)
          dayName: 'Sunday'),
      // 'Eid El Sou3oud'
      holidaysNames[45][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 39, // 40 - (1)
          dayName: 'Thursday'),
      // 'Solemnity of Pentecost'
      holidaysNames[46][_currentLanguage] ?? 'error': DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString())
          .add(const Duration(days: 49)), // 50 - (1)
      //'The Gold Friday'
      holidaysNames[47][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),
          x: 1,
          dayName: 'Friday'),
      //'Memory of 72 disciples'
      holidaysNames[49][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_sebou3ElRousol).toString()),
          x: 7,
          dayName: 'Friday'),
      //'Memory of 12 Apostles'
      holidaysNames[50][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 0, // 1 - (1)
          dayName: 'Sunday'),
      //'Memory of saint Shimun Bar-Sabba’i'
      holidaysNames[51][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 6,
          dayName: 'Friday'),
      holidaysNames[52][_currentLanguage] ?? 'error':
          DateTime.parse(DateFormat('dd-MMMM-yyyy').parse(_ciriaco).toString()),

      // 'Som El Ba3outh'
      // holidaysNames[58][_currentLanguage] ?? 'error': DateTime.parse(
      //     DateFormat('dd-MMMM-yyyy').parse(_somElBa3outh1String).toString()),
      // holidaysNames[59][_currentLanguage] ?? 'error': DateTime.parse(
      //     DateFormat('dd-MMMM-yyyy').parse(_somElBa3outh2String).toString()),
      // holidaysNames[60][_currentLanguage] ?? 'error': DateTime.parse(
      //     DateFormat('dd-MMMM-yyyy').parse(_somElBa3outh3String).toString()),

      holidaysNames[61][_currentLanguage] ?? 'error': findNthDayBefore(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Friday'),

      holidaysNames[62][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy').parse(_eidHafizatElZourou3).toString()),

      holidaysNames[63][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse(_eid2intikalEl3azra2ilaElSama)
              .toString()),

      holidaysNames[64][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 1,
          dayName: 'Friday'),
      holidaysNames[65][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 5, //6 - (1)
          dayName: 'Sunday'),
      holidaysNames[66][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 6,
          dayName: 'Friday'),
      holidaysNames[67][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 6, //7 - (1)
          dayName: 'Sunday'),
      holidaysNames[68][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 7,
          dayName: 'Thursday'),
      holidaysNames[69][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 7,
          dayName: 'Friday'),
      holidaysNames[70][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_somElKabirString).toString()),
          x: 7,
          dayName: 'Saturday'),
      holidaysNames[71][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 0, //1 - (1)
          dayName: 'Sunday'),
      holidaysNames[72][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 2,
          dayName: 'Monday'),
      holidaysNames[73][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 1,
          dayName: 'Friday'),
      holidaysNames[74][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 2,
          dayName: 'Friday'),
      holidaysNames[75][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 7,
          dayName: 'Friday'),
      holidaysNames[76][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString()),
          x: 1,
          dayName: 'Friday'),
      holidaysNames[77][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eliyaString).toString()),
          x: 7,
          dayName: 'Friday'),
      holidaysNames[78][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse("1-${listOfMonths[9]}-$currentYear")
              .toString()),
      holidaysNames[79][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_takdisElBi3aString).toString()),
          x: 1,
          dayName: 'Friday'),
      holidaysNames[80][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_nosardilString).toString()),
          x: 5,
          dayName: 'Friday'),

      holidaysNames[81][_currentLanguage] ?? 'error': findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidAlKiyamaString).toString()),
          x: 2,
          dayName: 'Friday'),
      holidaysNames[82][_currentLanguage] ?? 'error': DateTime.parse(
          DateFormat('dd-MMMM-yyyy')
              .parse("1-${listOfMonths[11]}-$currentYear")
              .toString()),
    };
  }

  Map<String, DateTime> _checkJam3ElDene7Chaldean(
      {required Map<String, DateTime> holidays}) {
    Map<String, DateTime> holidaysTMP = holidays;

    DateTime sebou3ElDene7 = DateFormat('dd-MMMM-yyyy').parse(_sebou3ElDene7);
    _currentYear = sebou3ElDene7.year;

    // print("year:${_currentYear}");
    // print("_jam3ElDene7Int:$_jam3ElDene7Int");

    if (_jam3ElDene7Int == 9) {
      holidaysTMP[holidaysNames[11][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[12][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 2,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[13][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 3,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[14][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 4,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[15][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 5,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[16][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 6,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[18][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 7,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[17][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 8,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[19][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 9,
          dayName: 'Friday');
    }

    if (_jam3ElDene7Int == 8) {
      holidaysTMP[holidaysNames[11][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[12][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 2,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[13][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 3,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[14][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 4,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[15][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 5,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[16][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 6,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[17][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 7,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[19][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 8,
          dayName: 'Friday');
    }

    if (_jam3ElDene7Int == 7) {
      holidaysTMP[holidaysNames[11][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[12][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 2,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[13][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 3,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[14][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 4,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[15][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 5,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[16][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 5,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[17][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 6,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[19][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 7,
          dayName: 'Friday');
    }

    if (_jam3ElDene7Int == 6) {
      holidaysTMP[holidaysNames[11][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[12][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 2,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[13][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 3,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[14][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 4,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[17][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 5,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[19][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 6,
          dayName: 'Friday');
    }

    if (_jam3ElDene7Int == 5) {
      holidaysTMP[holidaysNames[11][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[12][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 2,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[13][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 3,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[14][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 4,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[19][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 5,
          dayName: 'Friday');
    }

    if (_jam3ElDene7Int == 4) {
      holidaysTMP[holidaysNames[11][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[12][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 2,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[13][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 3,
          dayName: 'Friday');

      holidaysTMP[holidaysNames[14][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 1,
          dayName: 'Sunday');

      holidaysTMP[holidaysNames[19][_currentLanguage]] = findNthDayAfter(
          startDate: DateTime.parse(
              DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
          x: 4,
          dayName: 'Friday');
    }

    return holidaysTMP;
  }

  Map<String, DateTime> _checkJam3ElDene7Syriac(
      {required Map<String, DateTime> holidays}) {
    Map<String, DateTime> holidaysTMP = holidays;
    DateTime sebou3ElDene7 = DateFormat('dd-MMMM-yyyy').parse(_sebou3ElDene7);

    holidaysTMP[holidaysNames[11][_currentLanguage]] = findNthDayAfter(
        startDate: DateTime.parse(
            DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
        x: 1,
        dayName: 'Friday');

    holidaysTMP[holidaysNames[12][_currentLanguage]] =
        holidaysTMP[holidaysNames[11][_currentLanguage]]!
            .add(const Duration(days: 7));
    holidaysTMP[holidaysNames[13][_currentLanguage]] =
        holidaysTMP[holidaysNames[12][_currentLanguage]]!
            .add(const Duration(days: 7));
    holidaysTMP[holidaysNames[14][_currentLanguage]] =
        holidaysTMP[holidaysNames[13][_currentLanguage]]!
            .add(const Duration(days: 7));
    holidaysTMP[holidaysNames[15][_currentLanguage]] =
        holidaysTMP[holidaysNames[14][_currentLanguage]]!
            .add(const Duration(days: 7));
    holidaysTMP[holidaysNames[16][_currentLanguage]] =
        holidaysTMP[holidaysNames[15][_currentLanguage]]!
            .add(const Duration(days: 7));
    holidaysTMP[holidaysNames[17][_currentLanguage]] =
        holidaysTMP[holidaysNames[16][_currentLanguage]]!
            .add(const Duration(days: 7));
    holidaysTMP[holidaysNames[18][_currentLanguage]] =
        holidaysTMP[holidaysNames[17][_currentLanguage]]!
            .add(const Duration(days: 7));
    holidaysTMP[holidaysNames[19][_currentLanguage]] =
        holidaysTMP[holidaysNames[18][_currentLanguage]]!
            .add(const Duration(days: 7));

    if (_jam3ElDene7Int == 4) {
      //11 - 12 - 13
      holidaysTMP[holidaysNames[12][_currentLanguage]] =
          holidaysTMP[holidaysNames[11][_currentLanguage]]!;
      holidaysTMP[holidaysNames[13][_currentLanguage]] =
          holidaysTMP[holidaysNames[11][_currentLanguage]]!;

      //14-17
      holidaysTMP[holidaysNames[14][_currentLanguage]] =
          holidaysTMP[holidaysNames[14][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[17][_currentLanguage]] =
          holidaysTMP[holidaysNames[14][_currentLanguage]]!;

      //15 - 16
      holidaysTMP[holidaysNames[15][_currentLanguage]] =
          holidaysTMP[holidaysNames[15][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[16][_currentLanguage]] =
          holidaysTMP[holidaysNames[15][_currentLanguage]]!;

      holidaysTMP[holidaysNames[18][_currentLanguage]] =
          holidaysTMP[holidaysNames[18][_currentLanguage]]!
              .subtract(const Duration(days: 14));
      holidaysTMP[holidaysNames[19][_currentLanguage]] =
          holidaysTMP[holidaysNames[19][_currentLanguage]]!
              .subtract(const Duration(days: 14));
    }

    if (_jam3ElDene7Int == 5) {
      //12 - 13
      holidaysTMP[holidaysNames[13][_currentLanguage]] =
          holidaysTMP[holidaysNames[12][_currentLanguage]]!;

      //14-17
      holidaysTMP[holidaysNames[14][_currentLanguage]] =
          holidaysTMP[holidaysNames[14][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[17][_currentLanguage]] =
          holidaysTMP[holidaysNames[14][_currentLanguage]]!;

      //15 - 16
      holidaysTMP[holidaysNames[15][_currentLanguage]] =
          holidaysTMP[holidaysNames[15][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[16][_currentLanguage]] =
          holidaysTMP[holidaysNames[15][_currentLanguage]]!;

      holidaysTMP[holidaysNames[18][_currentLanguage]] =
          holidaysTMP[holidaysNames[18][_currentLanguage]]!
              .subtract(const Duration(days: 21));
      holidaysTMP[holidaysNames[19][_currentLanguage]] =
          holidaysTMP[holidaysNames[19][_currentLanguage]]!
              .subtract(const Duration(days: 21));
    }

    if (_jam3ElDene7Int! == 6) {
      //12 - 13
      holidaysTMP[holidaysNames[13][_currentLanguage]] =
          holidaysTMP[holidaysNames[12][_currentLanguage]]!;

      holidaysTMP[holidaysNames[14][_currentLanguage]] =
          holidaysTMP[holidaysNames[14][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      //15 - 16
      holidaysTMP[holidaysNames[15][_currentLanguage]] =
          holidaysTMP[holidaysNames[15][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[16][_currentLanguage]] =
          holidaysTMP[holidaysNames[15][_currentLanguage]]!;

      holidaysTMP[holidaysNames[17][_currentLanguage]] =
          holidaysTMP[holidaysNames[17][_currentLanguage]]!
              .subtract(const Duration(days: 14));
      holidaysTMP[holidaysNames[18][_currentLanguage]] =
          holidaysTMP[holidaysNames[18][_currentLanguage]]!
              .subtract(const Duration(days: 14));
      holidaysTMP[holidaysNames[19][_currentLanguage]] =
          holidaysTMP[holidaysNames[19][_currentLanguage]]!
              .subtract(const Duration(days: 14));
    }

    if (_jam3ElDene7Int! == 7) {
      //12 - 13
      holidaysTMP[holidaysNames[13][_currentLanguage]] =
          holidaysTMP[holidaysNames[12][_currentLanguage]]!;

      holidaysTMP[holidaysNames[14][_currentLanguage]] =
          holidaysTMP[holidaysNames[14][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[15][_currentLanguage]] =
          holidaysTMP[holidaysNames[15][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[16][_currentLanguage]] =
          holidaysTMP[holidaysNames[16][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[17][_currentLanguage]] =
          holidaysTMP[holidaysNames[17][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[18][_currentLanguage]] =
          holidaysTMP[holidaysNames[18][_currentLanguage]]!
              .subtract(const Duration(days: 7));
      holidaysTMP[holidaysNames[19][_currentLanguage]] =
          holidaysTMP[holidaysNames[19][_currentLanguage]]!
              .subtract(const Duration(days: 7));
    }

    if (_jam3ElDene7Int! != 9) {
      holidaysTMP[holidaysNames[19][_currentLanguage]] =
          holidaysTMP[holidaysNames[18][_currentLanguage]]!;
      holidaysTMP.remove(holidaysNames[18][_currentLanguage]);
    }

    print(
        "${holidaysTMP[holidaysNames[11][_currentLanguage]]!.year} : $_jam3ElDene7Int");
    // print("[19]: ${holidaysTMP[holidaysNames[19][_currentLanguage]]!.year} _jam3ElDene7Int:$_jam3ElDene7Int");
    return holidaysTMP;
  }

// Map<String, DateTime> _checkMariyamChaldean(
//     {required Map<String, DateTime> holidays}) {
//   Map<String, DateTime> holidaysTMP = holidays;
//
//   holidaysTMP[holidaysNames[22][_currentLanguage]] = DateTime.parse(
//       DateFormat('dd-MMMM-yyyy')
//           .parse(_eidEl3azraElMahboulBihaBilaDanas)
//           .toString());
//   holidaysTMP[holidaysNames[31][_currentLanguage]] = DateTime.parse(
//       DateFormat('dd-MMMM-yyyy').parse(_eidHafizatElZourou3).toString());
//   holidaysTMP[holidaysNames[35][_currentLanguage]] = DateTime.parse(
//       DateFormat('dd-MMMM-yyyy')
//           .parse(_eid2intikalEl3azra2ilaElSama)
//           .toString());
//
//   holidaysTMP.remove(holidaysNames[61][_currentLanguage]);
//   holidaysTMP.remove(holidaysNames[62][_currentLanguage]);
//   holidaysTMP.remove(holidaysNames[63][_currentLanguage]);
//
//   return holidaysTMP;
// }

// Map<String, DateTime> _checkMariyamSyriac(
//     {required Map<String, DateTime> holidays}) {
//   Map<String, DateTime> holidaysTMP = holidays;
//
//   holidaysTMP[holidaysNames[61][_currentLanguage]] = findNthDayBefore(
//       startDate: DateTime.parse(
//           DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
//       x: 1,
//       dayName: 'Friday');
//   holidaysTMP[holidaysNames[62][_currentLanguage]] = DateTime.parse(
//       DateFormat('dd-MMMM-yyyy').parse(_eidHafizatElZourou3).toString());
//   holidaysTMP[holidaysNames[63][_currentLanguage]] = DateTime.parse(
//       DateFormat('dd-MMMM-yyyy')
//           .parse(_eid2intikalEl3azra2ilaElSama)
//           .toString());
//
//   holidaysTMP.remove(holidaysNames[22][_currentLanguage]);
//   holidaysTMP.remove(holidaysNames[31][_currentLanguage]);
//   holidaysTMP.remove(holidaysNames[35][_currentLanguage]);
//
//   return holidaysTMP;
// }

// int _countFridays({required DateTime start, required DateTime end}) {
//   if (start.isAfter(end)) {
//     // Swap the dates if start date is after end date
//     final temp = start;
//     start = end;
//     end = temp;
//   }
//
//   int fridayCount = 0;
//   for (DateTime date = start;
//       date.isBefore(end);
//       date = date.add(Duration(days: 1))) {
//     if (date.weekday == DateTime.friday) {
//       fridayCount++;
//     }
//   }
//
//   return fridayCount;
// }
}

//Map<String, DateTime> _checkJam3ElDene7Chaldean(
//       {required Map<String, DateTime> holidays}) {
//     Map<String, DateTime> holidaysTMP = holidays;
//     DateTime sebou3ElDene7 = DateFormat('dd-MMMM-yyyy').parse(_sebou3ElDene7);
//     int monthInt = 2;
//     if (_somElKabirModel.month == listOfMonths[3]) {
//       monthInt = 3;
//     }
//     int countAfterSebou3ElDene7 = _countFridays(
//         start: sebou3ElDene7,
//         end: DateTime(_somElKabirModel.year, monthInt, _somElKabirModel.day));
//
//     currentYear = sebou3ElDene7.year;
//
//     holidaysTMP[holidaysNames[11][_currentLanguage]] = DateTime.parse(
//         DateFormat('dd-MMMM-yyyy')
//             .parse("7-${listOfMonths[1]}-$currentYear")
//             .toString());
//
//     holidaysTMP[holidaysNames[12][_currentLanguage]] = findNthDayAfter(
//         startDate: DateTime.parse(
//             DateFormat('dd-MMMM-yyyy').parse(_sebou3ElDene7).toString()),
//         x: 1,
//         dayName: 'Friday');
//     // holidaysTMP[holidaysNames[11][_currentLanguage]]!
//     //     .add(const Duration(days: 7));
//     holidaysTMP[holidaysNames[13][_currentLanguage]] =
//         holidaysTMP[holidaysNames[12][_currentLanguage]]!
//             .add(const Duration(days: 7));
//     holidaysTMP[holidaysNames[14][_currentLanguage]] =
//         holidaysTMP[holidaysNames[13][_currentLanguage]]!
//             .add(const Duration(days: 7));
//     holidaysTMP[holidaysNames[15][_currentLanguage]] =
//         holidaysTMP[holidaysNames[14][_currentLanguage]]!
//             .add(const Duration(days: 7));
//     holidaysTMP[holidaysNames[16][_currentLanguage]] =
//         holidaysTMP[holidaysNames[15][_currentLanguage]]!
//             .add(const Duration(days: 7));
//     holidaysTMP[holidaysNames[17][_currentLanguage]] =
//         holidaysTMP[holidaysNames[16][_currentLanguage]]!
//             .add(const Duration(days: 7));
//     holidaysTMP[holidaysNames[18][_currentLanguage]] =
//         holidaysTMP[holidaysNames[17][_currentLanguage]]!
//             .add(const Duration(days: 7));
//     holidaysTMP[holidaysNames[19][_currentLanguage]] =
//         holidaysTMP[holidaysNames[18][_currentLanguage]]!
//             .add(const Duration(days: 7));
//
//     if (_jam3ElDene7Int! <= 8) {
//       // if (holidaysTMP[holidaysNames[11][_currentLanguage]]!
//       //     .isBefore(sebou3ElDene7)) {
//       holidaysTMP[holidaysNames[18][_currentLanguage]] = DateTime.parse(
//           DateFormat('dd-MMMM-yyyy')
//               .parse("9-${listOfMonths[3]}-$currentYear")
//               .toString());
//
//       // 9
//       if (_jam3ElDene7Int! == 8) {
//         if (countAfterSebou3ElDene7 == 8) {
//           holidaysTMP[holidaysNames[11][_currentLanguage]] =
//               holidaysTMP[holidaysNames[15][_currentLanguage]]!
//                   .subtract(const Duration(days: 14));
//           holidaysTMP[holidaysNames[13][_currentLanguage]] =
//               holidaysTMP[holidaysNames[13][_currentLanguage]]!
//                   .add(const Duration(days: 7));
//         } else {
//           holidaysTMP[holidaysNames[19][_currentLanguage]] =
//               holidaysTMP[holidaysNames[19][_currentLanguage]]!
//                   .subtract(const Duration(days: 7));
//         }
//       }
//     }
//
//     if (_jam3ElDene7Int! <= 7) {
//       holidaysTMP[holidaysNames[12][_currentLanguage]] = DateTime.parse(
//           DateFormat('dd-MMMM-yyyy')
//               .parse("29-${listOfMonths[6]}-$currentYear")
//               .toString());
//
//       //2 - 9
//       holidaysTMP[holidaysNames[13][_currentLanguage]] = findNthDayAfter(
//           startDate: holidaysTMP[holidaysNames[11][_currentLanguage]]!,
//           x: 1,
//           dayName: 'Friday');
//
//       if (_jam3ElDene7Int! == 7) {
//         if (countAfterSebou3ElDene7 == 7) {
//           holidaysTMP[holidaysNames[11][_currentLanguage]] =
//               holidaysTMP[holidaysNames[15][_currentLanguage]]!
//                   .subtract(const Duration(days: 14));
//           holidaysTMP[holidaysNames[13][_currentLanguage]] =
//               holidaysTMP[holidaysNames[13][_currentLanguage]]!
//                   .add(const Duration(days: 7));
//         } else {
//           holidaysTMP[holidaysNames[14][_currentLanguage]] =
//               holidaysTMP[holidaysNames[14][_currentLanguage]]!
//                   .subtract(const Duration(days: 7));
//           holidaysTMP[holidaysNames[15][_currentLanguage]] =
//               holidaysTMP[holidaysNames[15][_currentLanguage]]!
//                   .subtract(const Duration(days: 7));
//           holidaysTMP[holidaysNames[16][_currentLanguage]] =
//               holidaysTMP[holidaysNames[16][_currentLanguage]]!
//                   .subtract(const Duration(days: 7));
//           holidaysTMP[holidaysNames[17][_currentLanguage]] =
//               holidaysTMP[holidaysNames[17][_currentLanguage]]!
//                   .subtract(const Duration(days: 7));
//           holidaysTMP[holidaysNames[19][_currentLanguage]] =
//               holidaysTMP[holidaysNames[19][_currentLanguage]]!
//                   .subtract(const Duration(days: 14));
//         }
//       }
//     }
//
//     if (_jam3ElDene7Int! <= 6) {
//       // if (holidaysTMP[holidaysNames[11][_currentLanguage]]!
//       //     .isBefore(sebou3ElDene7)) {
//       holidaysTMP[holidaysNames[14][_currentLanguage]] = findNthDayAfter(
//           startDate: DateTime.parse(
//               DateFormat('dd-MMMM-yyyy').parse(_eidElDene7).toString()),
//           x: 1,
//           dayName: 'Sunday');
//
//       //5 - 9
//       if (_jam3ElDene7Int! == 6) {
//         print(
//             "mar youhana: ${holidaysTMP[holidaysNames[11][_currentLanguage]]}");
//         if (countAfterSebou3ElDene7 == 6) {
//           holidaysTMP[holidaysNames[11][_currentLanguage]] =
//               holidaysTMP[holidaysNames[15][_currentLanguage]]!
//                   .subtract(const Duration(days: 14));
//           holidaysTMP[holidaysNames[13][_currentLanguage]] =
//               holidaysTMP[holidaysNames[13][_currentLanguage]]!
//                   .add(const Duration(days: 7));
//         } else {
//           holidaysTMP[holidaysNames[13][_currentLanguage]] =
//               holidaysTMP[holidaysNames[13][_currentLanguage]]!
//                   .add(const Duration(days: 7));
//           holidaysTMP[holidaysNames[15][_currentLanguage]] =
//               holidaysTMP[holidaysNames[15][_currentLanguage]]!
//                   .subtract(const Duration(days: 14));
//           holidaysTMP[holidaysNames[16][_currentLanguage]] =
//               holidaysTMP[holidaysNames[16][_currentLanguage]]!
//                   .subtract(const Duration(days: 14));
//           holidaysTMP[holidaysNames[17][_currentLanguage]] =
//               holidaysTMP[holidaysNames[17][_currentLanguage]]!
//                   .subtract(const Duration(days: 14));
//           holidaysTMP[holidaysNames[19][_currentLanguage]] =
//               holidaysTMP[holidaysNames[19][_currentLanguage]]!
//                   .subtract(const Duration(days: 21));
//         }
//       }
//     }
//
//     if (_jam3ElDene7Int! <= 5) {
//       // 6-9
//       // holidaysTMP.remove(holidaysNames[15][_currentLanguage]);
//       // holidaysTMP.remove(holidaysNames[16][_currentLanguage]);
//       // holidaysTMP.remove(holidaysNames[17][_currentLanguage]);
//       // holidaysTMP.remove(holidaysNames[18][_currentLanguage]);
//
//       if (_jam3ElDene7Int! == 5) {
//         holidaysTMP[holidaysNames[15][_currentLanguage]] =
//             holidaysTMP[holidaysNames[15][_currentLanguage]]!
//                 .subtract(const Duration(days: 7));
//         holidaysTMP[holidaysNames[16][_currentLanguage]] =
//             holidaysTMP[holidaysNames[16][_currentLanguage]]!
//                 .subtract(const Duration(days: 7));
//         holidaysTMP[holidaysNames[17][_currentLanguage]] =
//             holidaysTMP[holidaysNames[17][_currentLanguage]]!
//                 .subtract(const Duration(days: 7));
//         holidaysTMP[holidaysNames[19][_currentLanguage]] =
//             holidaysTMP[holidaysNames[19][_currentLanguage]]!
//                 .subtract(const Duration(days: 7));
//       }
//     }
//
//     if (_jam3ElDene7Int! <= 4) {
//       // 7-9
//       holidaysTMP[holidaysNames[17][_currentLanguage]] =
//           holidaysTMP[holidaysNames[17][_currentLanguage]]!
//               .subtract(const Duration(days: 7));
//       holidaysTMP[holidaysNames[18][_currentLanguage]] =
//           holidaysTMP[holidaysNames[18][_currentLanguage]]!
//               .subtract(const Duration(days: 7));
//       holidaysTMP[holidaysNames[19][_currentLanguage]] =
//           holidaysTMP[holidaysNames[19][_currentLanguage]]!
//               .subtract(const Duration(days: 7));
//
//       //5
//       holidaysTMP[holidaysNames[15][_currentLanguage]] =
//           holidaysTMP[holidaysNames[14][_currentLanguage]]!;
//       //6
//       holidaysTMP[holidaysNames[16][_currentLanguage]] =
//           holidaysTMP[holidaysNames[14][_currentLanguage]]!;
//     }
//
//     return holidaysTMP;
//   }
