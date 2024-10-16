import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/utils/custom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyleTitle1 = TextStyle(
      color: Theme.of(context).textTheme.bodySmall!.color,
      fontSize: 30,
      fontWeight: FontWeight.w700,
    );
    TextStyle textStyleBody1 = TextStyle(
      color: Theme.of(context).textTheme.bodySmall!.color,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    TextStyle textStyleCredit = TextStyle(
      color: Theme.of(context).textTheme.bodySmall!.color,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
    TextStyle textStyleTitle = TextStyle(
      color: Theme.of(context).textTheme.headlineSmall!.color,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
    TextStyle textStyleBody = TextStyle(
      color: Theme.of(context).textTheme.headlineSmall!.color,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    TextStyle textStyleImageDescription = TextStyle(
      color: Theme.of(context).textTheme.headlineSmall!.color,
      fontSize: 14,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w500,
    );
    TextStyle textStyleLink = const TextStyle(
      color: Colors.blue,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    return Scaffold(
      // appBar: AppBar(),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            // Credit
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 30.0),
                Text(
                  "Credits",
                  style: textStyleCredit,
                ),
              ],
            ),
            // Hudra Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hudra",
                  style: textStyleTitle1,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            // Hudra Description
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Breviary of the complete liturgical\ncycle according to the Holy\nChurch of the East\nChaldeans & Assyrians",
                  style: textStyleBody1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            // Concept, Direction and Copyright
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: CustomColors.brown2,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              child: Column(
                children: [
                  Text(
                    "Concept, Direction and Copyright:",
                    style: textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Image.asset("Assets/info/OAOC Logo.jpeg"),
                  const SizedBox(height: 8.0),
                  Text(
                    "Chaldean Antonian Order of Saint Hormizd (O.A.O.C.)",
                    style: textStyleImageDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => launchUrl(Uri.parse("https://oaoc.net/")),
                        child: Text(
                          "https://oaoc.net/",
                          style: textStyleLink,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        "© 2024",
                        style: textStyleBody,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Partner
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: CustomColors.brown2,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              child: Column(
                children: [
                  Text(
                    "Partner:",
                    style: textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Image.asset(
                      "Assets/info/Diocese of Baghdad of the Assyrian Church of the East.jpg"),
                  const SizedBox(height: 8.0),
                  Text(
                    "Diocese of Baghdad of the Assyrian Church of the East",
                    style: textStyleImageDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  InkWell(
                    onTap: () =>
                        launchUrl(Uri.parse("https://diocesesofbaghdad.com/")),
                    child: Text(
                      "https://diocesesofbaghdad.com/",
                      style: textStyleLink,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Funded by
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: CustomColors.brown2,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              child: Column(
                children: [
                  Text(
                    "Funded by:",
                    style: textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Image.asset("Assets/info/ELKB.jpg"),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ELKB, ",
                        style: textStyleBody,
                        textAlign: TextAlign.center,
                      ),
                      InkWell(
                        onTap: () => launchUrl(
                            Uri.parse("https://www.bayern-evangelisch.de/")),
                        child: Text(
                          "https://www.bayern-evangelisch.de/",
                          style: textStyleLink,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Supported by
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: CustomColors.brown2,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              child: Column(
                children: [
                  Text(
                    "Supported by:",
                    style: textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Image.asset("Assets/info/CAP.jpg"),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "CAPNI, ",
                        style: textStyleBody,
                        textAlign: TextAlign.center,
                      ),
                      InkWell(
                        onTap: () =>
                            launchUrl(Uri.parse("https://christians-aid.org/")),
                        child: Text(
                          "https://christians-aid.org/",
                          style: textStyleLink,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Production, Development and Graphic Design
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: CustomColors.brown2,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              child: Column(
                children: [
                  Text(
                    "Production, Development and Graphic Design:",
                    style: textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Image.asset("Assets/info/Beirut in.jpg"),
                  const SizedBox(height: 8.0),
                  Text(
                    "Beirut in",
                    style: textStyleImageDescription,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  InkWell(
                    onTap: () => launchUrl(Uri.parse("https://beirutin.com/")),
                    child: Text(
                      "https://beirutin.com/",
                      style: textStyleLink,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // Acknowledgments
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: CustomColors.brown2,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              ),
              child: Column(
                children: [
                  Text(
                    "Acknowledgments:",
                    style: textStyleTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    """The Syriac text of this breviary was taken from both:
1- Bedjan, P. and Khayyat, G.E. (eds.), 1886-1887. Breviarium Chaldaicum, (3 vols.) Paris, Repr. (1938 & 2002), Rome. (The digital format was provided by the courtesy of the Chaldean Archdiocese of Erbil).
2- Darmo, T. (ed.), 1962, Kthaba daQdam wadBathar wadHudra wadKashkul wadGazza wQala d‘udrane ‘am Kthaba dMazmore, Thrissur. (The digital format was provided by the courtesy of Mons. Emmanuel Youkhanna).

• The liturgical calendar was created depending on both:
1- Isaac, Ph., 2007, The Perpetual Calendar, Yohanna, S.S. (tr.), Nineveh. All the discrepancies were promptly adjusted according to the synodical measures taken in the Synod of the Chaldean Church of 1967.
2- Joseph, E.R., 1990, The Little Chronicle, Chicago.
• The Arabic translation was made by Mons. Dr. Behnam Soni, Qaraqosh 2023, supervised and edited by Abbott Dr. Samer Soreshow Yohanna for the (O.A.O.C.) ©.
• Contributors in data entry: Rev. Younan Dawood, Rev. Ameer Brikha, Rev. George Sulaiman, Rev. Sami Shamuel, Rev. Shmoel (Nihad) Maqdis, Rev. Tower Andrious.
                    """,
                    style: textStyleBody,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }
}
