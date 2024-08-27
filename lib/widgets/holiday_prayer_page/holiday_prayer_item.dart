import 'dart:convert';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hudra/controller/other/delta_to_html.dart';
import 'package:hudra/controller/settings_provider/provider_text_size.dart';
import 'package:hudra/model/Prayers/prayer_model.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:hudra/view/reference_page.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:provider/provider.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class HolidayPrayerItem extends StatefulWidget {
  PrayerModel prayerModel;

  HolidayPrayerItem({
    Key? key,
    required this.prayerModel,
  }) : super(key: key);

  @override
  State<HolidayPrayerItem> createState() => _HolidayPrayerItemState();
}

class _HolidayPrayerItemState extends State<HolidayPrayerItem> {
  bool isLoading = true;

  final QuillEditorController quillController = QuillEditorController();

  @override
  void initState() {
    // TODO: implement initState
    /// To fix QuillHtmlEditor white screen
    Future.delayed(const Duration(milliseconds: 550), () {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(DeltaToHTML.encodeJson(widget.prayerModel.prayerText).toString());
    var textSizeProvider =
        Provider.of<ProviderTextSize>(context, listen: false);
    final mediaQueryData = MediaQuery.of(context);
    // var prayerData = jsonDecode(widget.prayerModel.prayerText.toString());
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 4,
            ),
            // Expanded(
            //   child: MediaQuery(
            //     data: mediaQueryData.copyWith(
            //         textScaleFactor: textSizeProvider.textSize),
            //     child: ScrollConfiguration(
            //       behavior:
            //           MyCustomScrollBehavior().copyWith(overscroll: false),
            //       child: SingleChildScrollView(
            //         child: Html(
            //           // data: DeltaToHTML.encodeJson(bibleData),
            //           data: DeltaToHTML.encodeJson(prayerData as List),

            //           style: {
            //             "body": Style(
            //               fontSize: FontSize(18.0),
            //               // fontWeight: FontWeight.bold,
            //               color: Theme.of(context).textTheme.bodySmall?.color,
            //             ),
            //           },
            //           onLinkTap: (url, attributes, element) async {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) =>
            //                     ReferencePage(param: url.toString()),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const Divider()
          ],
        ),
        isLoading
            ? Container(
                height: MediaQuery.sizeOf(context).height,
                width: double.infinity,
                child: Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
