class AsesElSeneModel {
  int initial;
  int secondary;
  AsesElSeneModel({
    this.initial = 0,
    this.secondary = 0,
  });

  Map<String, dynamic> toJson() => {
    "initial": initial,
    "secondary": secondary,
  };
}
