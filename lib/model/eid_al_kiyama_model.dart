// ignore_for_file: public_member_api_docs, sort_constructors_first
class EidAlKiyamaModel {
  int day;
  String month;
  int year;
  EidAlKiyamaModel({
    this.day = 0,
    this.month = "",
    this.year = 0,
  });

  Map<String, dynamic> toJson() => {
        "day": day,
        "month": month,
        "year": year,
      };

  @override
  String toString() =>
      'EidAlKiyamaModel(day: $day, month: $month, year: $year)';
}
