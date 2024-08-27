import 'dart:convert';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:hudra/controller/loaded_data/bible_data.dart';
import 'package:hudra/controller/loaded_data/mazmour_data.dart';
import 'package:hudra/controller/settings_provider/book_mode_provider.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/reference_model.dart';
import 'package:hudra/remote/request.dart';
import 'package:hudra/view/bible_page.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReferencePage extends StatefulWidget {
  const ReferencePage({
    super.key,
    required this.param,
  });

  final String param;

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  String _appBarTitle = "";
  ReferenceModel _referenceModel = ReferenceModel();
  dynamic referenceData = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BookModeProvider>(context, listen: false)
          .loadBookModeSettings();
    });
    loadData2();
  }

  loadData2() async {
    try {
      _isLoading = true;
      setState(() {});
      _listOfBibles = await BibleData.loadBibleByNumbers(widget.param);
      print(_listOfBibles.length);
      _isLoading = false;
      setState(() {});
    } catch (e) {
      _isLoading = false;
      setState(() {});
      print("loading bibles in ref error $e");
    }
  }

  // loadData() async {
  //   try {
  //     _isLoading = true;
  //     setState(() {});
  //     // Splitting the string using the '/' character
  //     List<String> parts = widget.param.replaceAll("app://", "").split('/');

  //     String refType = parts[0];
  //     int? id = int.tryParse(parts[1]);

  //     if (refType == "mz" && id != null) {
  //       _referenceModel = await MazmourData.loadMazmourBydId(id);
  //       _appBarTitle = refType == "rf"
  //           ? "Reference ${_referenceModel.name}"
  //           : "Mazmour ${_referenceModel.name}";
  //       referenceData = jsonDecode(_referenceModel.data);
  //       setState(() {});
  //     }
  //     _isLoading = false;
  //     setState(() {});
  //   } catch (e) {
  //     print("error loading reference data $e");
  //     _isLoading = false;
  //     setState(() {});
  //   }
  // }

  List<BibleObject> _listOfBibles = [];

  @override
  Widget build(BuildContext context) {
    var textSizeProvider =
        Provider.of<ProviderTextSize>(context, listen: false);
    final mediaQueryData = MediaQuery.of(context);
    var bookModeProvider =
        Provider.of<BookModeProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          return true;
        }
        if (bookModeProvider.isBookMode) {
          FullScreenWindow.setFullScreen(false);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        // appBar: AppBar(
        // title: Text(_appBarTitle),
        // centerTitle: true,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: 25,
                margin: const EdgeInsets.only(top: 40),
                child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () => Navigator.of(context).pop(),
                    // Provider.of<ProviderGlobal>(
                    // context,
                    // listen: false)
                    // .goBackAll(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    )
                    // Image.asset(
                    //   'Assets/Icons/menu.png',
                    //   color: secondaryColor,
                    // ),
                    ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior()
                      .copyWith(overscroll: false, scrollbars: true),
                  child: SingleChildScrollView(
                    child: MediaQuery(
                      data: mediaQueryData.copyWith(
                          textScaleFactor: textSizeProvider.textSize),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _listOfBibles.length,
                        shrinkWrap: true,
                        itemBuilder: (c, i) {
                          return Column(
                            children: [
                              Text(
                                _listOfBibles[i].itemName!,
                                maxLines: 2,
                                style: TextStyle(
                                  // overflow: TextOverflow.fade,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Html(
                                data: DeltaToHTML.encodeJson(
                                    jsonDecode(_listOfBibles[i].itemDesc)
                                        as List),
                                style: {
                                  "body": Style(
                                    fontSize: FontSize(16.0),
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                                },
                              ),
                              Divider(
                                thickness: 1.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        floatingActionButton:
            Consumer<BookModeProvider>(builder: (context, bookModeProvider, _) {
          return !bookModeProvider.isBookMode
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  child: const Icon(Icons.book),
                  onPressed: () {
                    bookModeProvider.disableBookMode();
                  },
                );
        }),
      ),
    );
  }
}

loadBiblesByNumbers() async {
  try {} catch (e) {}
}

// bool isEnglish(String input) {
//   const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
//   if (english.contains(input[0])) {
//     return true;
//   }
//   return false;
// }

int replaceArabicNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  if (english.contains(input[0])) return int.parse(input);
  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(arabic[i], english[i]);
  }
  return int.parse(input);
}

String replaceEnglishNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  // if (arabic.contains(input[0])) return int.parse(input);
  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], arabic[i]);
  }
  return input;
}
