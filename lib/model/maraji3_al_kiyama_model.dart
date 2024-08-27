class Maraji3AlKiyamaModel {
  int first;
  int last;
  Maraji3AlKiyamaModel({
    this.first = 0,
    this.last = 0,
  });
  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
  };
}
