import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/controller/saved_verses_provider/provider_saved_verses.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/model/Daily/saved_verse_model.dart';
import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';

class SavedVersesItem extends StatefulWidget {
  SavedVerseModel savedVerseModel;

  SavedVersesItem({
    Key? key,
    required this.savedVerseModel,
  }) : super(key: key);

  @override
  State<SavedVersesItem> createState() => _SavedVersesItemState();
}

class _SavedVersesItemState extends State<SavedVersesItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 110,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.savedVerseModel.itemName,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.savedVerseModel.itemDescString,
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withOpacity(0.4),
                          fontSize: 17),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () => _onUnSave(),
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: SvgPicture.asset(
                          'Assets/Icons/heart(1).svg',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () async => await _onShare(),
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: SvgPicture.asset(
                          'Assets/Icons/vuesax-linear-export.svg',
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(
            thickness: 1.0,
            color: Theme.of(context).textTheme.bodySmall?.color,
          )
        ],
      ),
    );
  }

  Future<void> _onUnSave() async {
    await DatabaseHelper.deleteSavedVerses(widget.savedVerseModel.itemId);
    Provider.of<ProviderSavedVerses>(context, listen: false)
        .savedVersesChildren
        .removeWhere((element) =>
            element.savedVerseModel.itemId == widget.savedVerseModel.itemId);
    Provider.of<ProviderSavedVerses>(context, listen: false).notifyListeners();
    debugPrint('onUnSave');
  }

  Future<void> _onShare() async {
    debugPrint('share_outlined');
    debugPrint(widget.savedVerseModel.itemDescString);
    // await Share.share(
    //     widget.savedVerseModel.itemDescString.isEmpty
    //         ? 'Error!!'
    //         : widget.savedVerseModel.itemDescString,
    //     subject: widget.savedVerseModel.itemDescString.isEmpty
    //         ? 'Error!!'
    //         : widget.savedVerseModel.itemDescString);
  }
}
