import 'package:flutter/material.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/view/prayer_detail_page.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/prayer_page/prayer_item.dart';
import 'package:provider/provider.dart';

class PrayersPage extends StatefulWidget {
  const PrayersPage({Key? key}) : super(key: key);

  @override
  State<PrayersPage> createState() => _PrayersPageState();
}

class _PrayersPageState extends State<PrayersPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _back(),
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: PrayersData.listOfPrayers.length,
                itemBuilder: (c, index) {
                  return PrayerItem(
                    prayerObject: PrayersData.listOfPrayers[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrayerDetailsPage(
                                  prayerObject:
                                      PrayersData.listOfPrayers[index],
                                )),
                      );
                    },
                  );
                }),
          ),
          // child: Column(
          //   children: [
          //     RitualItem(
          //         title: 'Lorem Ipsum',
          //         text:
          //             'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy…'),
          //     RitualItem(
          //         title: 'Lorem Ipsum',
          //         text:
          //             'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy…'),
          //     RitualItem(
          //         title: 'Lorem Ipsum',
          //         text:
          //             'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy…'),
          //     RitualItem(
          //         title: 'Lorem Ipsum',
          //         text:
          //             'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy…'),
          //   ],
          // ),
        ),
      ),
    );
  }

  _back() {
    Provider.of<ProviderGlobal>(context, listen: false).goBackAll();
  }
}
