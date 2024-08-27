import 'dart:convert';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/settings_provider/book_mode_provider.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/view/bible_page.dart';
import 'package:hudra/view/reference_page.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:provider/provider.dart';

class BibleDetailsPage extends StatefulWidget {
  const BibleDetailsPage({
    super.key,
    required this.bibleObject,
  });

  final BibleObject bibleObject;

  @override
  State<BibleDetailsPage> createState() => _BibleDetailsPageState();
}

class _BibleDetailsPageState extends State<BibleDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<BookModeProvider>(context, listen: false)
          .loadBookModeSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    var textSizeProvider =
        Provider.of<ProviderTextSize>(context, listen: false);
    var bookModeProvider =
        Provider.of<BookModeProvider>(context, listen: false);
    final mediaQueryData = MediaQuery.of(context);
    var bibleData = jsonDecode(widget.bibleObject.itemDesc);
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
        // appBar: AppBar(),
        // appBar: AppBar(
        //   title: Text("Bible details page"),
        //   centerTitle: true,
        // ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 30.0),
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        // onTap: () => Provider.of<ProviderGlobal>(context,
                        //     listen: false).goBackAll(),
                        onTap: () => Navigator.of(context).pop(),
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
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 30.0),
                  child: MediaQuery(
                    data: mediaQueryData.copyWith(
                        textScaleFactor: textSizeProvider.textSize),
                    child: ScrollConfiguration(
                      behavior:
                          MyCustomScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Html(
                          // data: DeltaToHTML.encodeJson(bibleData),
                          data: DeltaToHTML.encodeJson(bibleData as List),

                          style: {
                            "body": Style(
                              fontSize: FontSize(18.0),
                              // fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          },
                          onLinkTap: (url, attributes, element) async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ReferencePage(param: url.toString()),
                              ),
                            );
                          },
                        ),
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
              ? SizedBox.shrink()
              : FloatingActionButton(
                  child: Icon(Icons.book),
                  onPressed: () {
                    bookModeProvider.disableBookMode();
                  },
                );
        }),
      ),
    );
  }
}
