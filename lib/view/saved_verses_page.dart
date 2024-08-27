import 'package:flutter/material.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/saved_verses_provider/provider_saved_verses.dart';
import 'package:hudra/locale/database_helper.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/saved_verses_page/saved_verses_item.dart';
import 'package:provider/provider.dart';

class SavedVersesPage extends StatefulWidget {
  const SavedVersesPage({Key? key}) : super(key: key);

  @override
  State<SavedVersesPage> createState() => _SavedVersesPageState();
}

class _SavedVersesPageState extends State<SavedVersesPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await Provider.of<ProviderSavedVerses>(context, listen: false)
            .loadSavedVerses();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          Provider.of<ProviderGlobal>(context, listen: false).goBackAll(),
      child: ScrollConfiguration(
        behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children:
                  Provider.of<ProviderSavedVerses>(context).savedVersesChildren,
            ),
          ),
        ),
      ),
    );
  }
}
