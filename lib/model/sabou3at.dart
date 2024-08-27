class SomElBa3outhModel {
  int day;
  String month;
  int year;
  SomElBa3outhModel({
    this.day = 0,
    this.month = "",
    this.year = 0,
  });
  Map<String, dynamic> toJson() => {
    "day": day,
    "month": month,
    "year": year,
  };
}

class SomElKabirModel {
  int day;
  String month;
  int year;
  SomElKabirModel({
    this.day = 0,
    this.month = "",
    this.year = 0,
  });
  Map<String, dynamic> toJson() => {
    "day": day,
    "month": month,
    "year": year,
  };
}

class EidElSou3oudModel {
  int? day;
  String? month;
  int? year;
  EidElSou3oudModel({
    this.day,
    this.month,
    this.year,
  });
  Map<String, dynamic> toJson() => {
    "day": day,
    "month": month,
    "year": year,
  };
}

class NosardilModel {
  int? day;
  String? month;
  int? year;
  NosardilModel({
    this.day,
    this.month,
    this.year,
  });
  Map<String, dynamic> toJson() => {
    "day": day,
    "month": month,
    "year": year,
  };
}

class EliyaModel {
  int? day;
  String? month;
  int? year;
  EliyaModel({
    this.day,
    this.month,
    this.year,
  });
  Map<String, dynamic> toJson() => {
    "day": day,
    "month": month,
    "year": year,
  };
}

class MoussaModel {
  int? day;
  String? month;
  int? year;
  MoussaModel({
    this.day,
    this.month,
    this.year,
  });
  Map<String, dynamic> toJson() => {
    "day": day,
    "month": month,
    "year": year,
  };
}

class TakdisElBi3aModel {
  int? day;
  String? month;
  int? year;
  TakdisElBi3aModel({
    this.day,
    this.month,
    this.year,
  });
  Map<String, dynamic> toJson() => {
    "day": day,
    "month": month,
    "year": year,
  };
}

class Jam3ElDene7SModel {
  int? weeks;
  int? year;
  Jam3ElDene7SModel({
    this.weeks,
    this.year,
  });
  Map<String, dynamic> toJson() => {
    "weeks": weeks,
    "year": year,
  };
}
