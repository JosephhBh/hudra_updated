import 'dart:convert';

import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hudra/model/prayer_model.dart';
import 'package:hudra/model/ritual_model.dart';

class RitualItem extends StatelessWidget {
  final RitualObject ritualObject;
  final Function() onTap;

  RitualItem({
    Key? key,
    required this.ritualObject,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var prayerData = jsonDecode(ritualObject.itemDesc);
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        // height: 100,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.headlineSmall?.color,
          borderRadius: const BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        constraints: BoxConstraints(
          maxHeight: 120,
          minHeight: 120,
        ),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text(
              ritualObject.itemName!,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headlineSmall?.color,
                  fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              child: Html(
                // data: DeltaToHTML.encodeJson(bibleData),
                data: DeltaToHTML.encodeJson(prayerData as List),
                style: {
                  "body": Style(
                    fontSize: FontSize(18.0),
                    // fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineSmall?.color,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                },
              ),
            )
            // Text(
            //   text,
            //   style: TextStyle(
            //       color: Theme.of(context)
            //           .textTheme
            //           .headlineSmall
            //           ?.color
            //           ?.withOpacity(0.4),
            //       fontSize: 17),
            // )
          ],
        ),
      ),
    );
  }
}
