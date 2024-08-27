import 'package:flutter/material.dart';

class BibleItem extends StatelessWidget {
  const BibleItem({
    super.key,
    required this.bibleName,
    required this.bibleNumber,
    required this.onPressed,
  });

  final String bibleName;
  final String bibleNumber;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        height: 68,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            Row(
              children: [
                Container(
                  width: 250,
                  child: Text(
                    bibleName + "($bibleNumber)",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ],
            ),
            Spacer(),
            Divider(
              height: 1,
              thickness: 0.6,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}
