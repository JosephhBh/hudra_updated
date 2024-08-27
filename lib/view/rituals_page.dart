import 'package:flutter/material.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/loaded_data/prayers_data.dart';
import 'package:hudra/controller/loaded_data/rituals_data.dart';
import 'package:hudra/view/prayer_detail_page.dart';
import 'package:hudra/view/ritual_detail_page.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/prayer_page/prayer_item.dart';
import 'package:hudra/widgets/prayer_page/ritual_item.dart';
import 'package:provider/provider.dart';

class RitualsPage extends StatefulWidget {
  const RitualsPage({Key? key}) : super(key: key);

  @override
  State<RitualsPage> createState() => _RitualsPageState();
}

class _RitualsPageState extends State<RitualsPage> {
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
                itemCount: RitualsData.listOfPrayers.length,
                itemBuilder: (c, index) {
                  return RitualItem(
                    ritualObject: RitualsData.listOfPrayers[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RitualDetailsPage(
                                  ritualObject:
                                      RitualsData.listOfPrayers[index],
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
