class AppConstant {
  static final AppConstant _singleton = AppConstant._internal();

  factory AppConstant() {
    return _singleton;
  }

  AppConstant._internal();

  // final apiUrl = "";
  final apiUrl = "https://hudra.org/";
  // final apiUrl = "https://cros-anywhere.herokuapp.com/https://hudra.org/";
  // final url = "https://www.hudra.org/";

  final appTitle = 'Hudra';
}