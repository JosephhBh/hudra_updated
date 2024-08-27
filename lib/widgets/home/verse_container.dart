import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/controller/settings_provider/provider_theme.dart';
import 'package:hudra/data/data2.dart' as globals;
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/locale/get_storage_helper.dart';
import 'package:hudra/model/Daily/saved_verse_model.dart';
import 'package:hudra/model/Daily/verse_container_model.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/widgets/other/MyCustomScrollBehavior.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
// import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class VerseContainer extends StatefulWidget {
  VerseContainerModel verseContainerModel;
  bool isWeb;
  bool isClicked = false;
  Function onTap = () => null;

  VerseContainer({
    Key? key,
    required this.verseContainerModel,
    required this.isWeb,
    required this.onTap,
  }) : super(key: key);

  @override
  State<VerseContainer> createState() => _VerseContainerState();
}

class _VerseContainerState extends State<VerseContainer> {
  bool _visible = false;
  int _k = 0;
  final QuillEditorController quillController = QuillEditorController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.verseContainerModel.itemDescString != ''
        ? InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () => widget.isWeb
                ? setState(() {
                    widget.isClicked = !widget.isClicked;
                    widget.onTap();
                  })
                : null,
            child: Container(
              height: !widget.isWeb
                  ? MediaQuery.of(context).size.height * 0.43
                  : widget.isClicked
                      ? 400
                      : 200, //MediaQuery.of(context).size.height * 0.215
              width: MediaQuery.of(context).size.width * 0.92,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('Assets/Images/image1.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Provider.of<ProviderTheme>(context).themeMode == 'dark'
                          ? Colors.white.withOpacity(0.65)
                          : Colors.black.withOpacity(0.55),
                      Provider.of<ProviderTheme>(context).themeMode == 'dark'
                          ? BlendMode.lighten
                          : BlendMode.darken),
                ),
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomLeft,
                //   colors: [
                //     HexColor('#b3c2c4'),
                //     HexColor('#b3c2c4'),
                //     HexColor('#b3c2c4'),
                //     HexColor('#dad7d6'),
                //     HexColor('#dad7d6'),
                //   ],
                // ),
                borderRadius: const BorderRadius.all(Radius.circular(22.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  right: 40.0,
                  left: 40.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: !widget.isWeb
                          ? MediaQuery.of(context).size.height * 0.295
                          : widget.isClicked
                              ? 260
                              : 130, //MediaQuery.of(context).size.height * 0.1475,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.verseOfTheDay,
                              //'Verse of the day',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.8),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            SizedBox(
                              height: !widget.isWeb
                                  ? MediaQuery.of(context).size.height * 0.18
                                  : widget.isClicked
                                      ? 190
                                      : 70, //MediaQuery.of(context).size.height * 0.09,
                              width: 300,
                              child: ScrollConfiguration(
                                behavior: MyCustomScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: SingleChildScrollView(
                                  controller: ScrollController(),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: Text(widget
                                          .verseContainerModel.itemDescString),
                                      // QuillHtmlEditor(
                                      //   // text: DeltaToHTML.encodeJson(widget.verseContainerModel.itemDesc),
                                      //   // hintText: '',
                                      //   controller: quillController,
                                      //   height: (Provider.of<ProviderTextSize>(context).textSize) *
                                      //       widget.verseContainerModel.itemDesc.length,
                                      //   defaultFontSize:
                                      //   Provider.of<ProviderTextSize>(context).textSize,
                                      //   // + 2,
                                      //   defaultFontColor:
                                      //   Theme.of(context).textTheme.bodySmall?.color ??
                                      //       CustomColors.brown7,
                                      //   isEnabled: false,
                                      //   backgroundColor: Colors.transparent,
                                      // ),
                                    ),
                                  ),

                                  // Text(
                                  //   widget.verseContainerModel.notificationMessage,
                                  //   style: TextStyle(
                                  //     color: Theme.of(context)
                                  //         .primaryColorDark
                                  //         .withOpacity(0.3),
                                  //     fontSize: 17.0,
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 13.0),
                            widget.verseContainerModel.itemReference.isNotEmpty
                                ? Container(
                                    height: 25,
                                    width: 60,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(left: 4.0),
                                    decoration: BoxDecoration(
                                      color: CustomColors.brown4,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(6.0)),
                                    ),
                                    child: Text(
                                      widget.verseContainerModel.itemReference,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: CustomColors.brown7
                                            .withOpacity(0.8),
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                    widget.isClicked || !kIsWeb
                        ? const SizedBox(height: 32.0)
                        : const SizedBox.shrink(),
                    widget.isClicked || !kIsWeb
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () => _onSave(),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: FutureBuilder(
                                          key: ValueKey(_k),
                                          future: _heartIcon(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic> snapShot) {
                                            if (!snapShot.hasData) {
                                              return SvgPicture.asset(
                                                "Assets/Icons/heart.svg",
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.color,
                                              );
                                            }
                                            return SvgPicture.asset(
                                              snapShot.data,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color,
                                            );
                                          }),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .save, //'Save',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // const SizedBox(width: 110.0),
                              InkWell(
                                onTap: () async => await _onShare(),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 26,
                                      width: 26,
                                      child: SvgPicture.asset(
                                        'Assets/Icons/vuesax-linear-export.svg',
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .share, //'Share',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () => widget.isWeb
                ? setState(() {
                    widget.isClicked = !widget.isClicked;
                    widget.onTap();
                  })
                : null,
            child: Container(
              height: !widget.isWeb
                  ? MediaQuery.of(context).size.height * 0.43
                  : widget.isClicked
                      ? 400
                      : 200, //MediaQuery.of(context).size.height * 0.215
              width: MediaQuery.of(context).size.width * 0.92,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('Assets/Images/image1.png'),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Provider.of<ProviderTheme>(context).themeMode == 'dark'
                          ? Colors.white.withOpacity(0.65)
                          : Colors.black.withOpacity(0.55),
                      Provider.of<ProviderTheme>(context).themeMode == 'dark'
                          ? BlendMode.lighten
                          : BlendMode.darken),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(22.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  right: 40.0,
                  left: 40.0,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: !widget.isWeb
                          ? MediaQuery.of(context).size.height * 0.295
                          : widget.isClicked
                              ? 260
                              : 130, //MediaQuery.of(context).size.height * 0.1475,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "No verse found",
                              //'Verse of the day',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.8),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Future<void> _onSave() async {
    try {
      setState(() {
        _k++;
      });
      await DatabaseHelper.insertSavedVerses(SavedVerseModel(
          itemId: widget.verseContainerModel.itemId,
          itemName: widget.verseContainerModel.itemName,
          itemReference: widget.verseContainerModel.itemReference,
          // itemDesc: [],//widget.verseContainerModel.itemDesc,
          itemDescString: widget.verseContainerModel.itemDescString,
          itemLang: GetStorageHelper().getLanguage()));
    } catch (e) {
      print(e);
      debugPrint('Save Error');
    }
    debugPrint('favorite_border_outlined');
  }

  Future<void> _onShare() async {
    debugPrint('share_outlineds');
    debugPrint(await quillController.getText());
    // await Share.share(widget.verseContainerModel.itemDescString);
    // await Share.share(widget.text.isEmpty ? 'Error!!' : widget.text,
    //     subject: widget.text.isEmpty ? 'Error!!' : widget.text);
  }

  Future<String> _heartIcon() async {
    if (await DatabaseHelper.existsSavedVerses(SavedVerseModel(
        itemId: widget.verseContainerModel.itemId,
        itemName: widget.verseContainerModel.itemName,
        itemReference: widget.verseContainerModel.itemReference,
        // itemDesc: [],//widget.verseContainerModel.itemDesc,
        itemDescString: widget.verseContainerModel.itemDescString,
        itemLang: GetStorageHelper().getLanguage()))) {
      return 'Assets/Icons/heart(1).svg';
    } else {
      return 'Assets/Icons/heart.svg';
    }
  }
}
