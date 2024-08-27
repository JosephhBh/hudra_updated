import 'package:flutter/material.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/settings_provider/provider_notifications.dart';
import 'package:hudra/widgets/Other/MyCustomScrollBehavior.dart';
import 'package:hudra/widgets/notifications_page/notifications_item.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ProviderNotifications>(context, listen: false)
        .loadNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          Provider.of<ProviderGlobal>(context, listen: false).goBackAll(),
      child: Stack(
        children: [
          ScrollConfiguration(
            behavior: MyCustomScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Consumer<ProviderNotifications>(
                  builder: (context, providerNotification, _) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: providerNotification.notificationChildren,
                  ),
                );
              }),
            ),
          ),
          Consumer<ProviderNotifications>(
              builder: (context, providerNotification, _) {
            return providerNotification.notificationChildren.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).textTheme.bodySmall?.color),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
