import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:provider/provider.dart';

class CalendarAppBar extends AppBar {
  Color? primaryColor;
  Color? secondaryColor;
  BuildContext context;

  CalendarAppBar({
    required this.primaryColor,
    required this.secondaryColor,
    required this.context,
  }) : super(
          backgroundColor: primaryColor,
          elevation: 0.0,
          leading: Builder(
            builder: (context) => Row(
              children: [
                const SizedBox(width: 30.0),
                SizedBox(
                  height: 25,
                  width: 25,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: SvgPicture.asset('Assets/Icons/Group 8.svg'),
                  ),
                ),
              ],
            ),
          ),
          leadingWidth: 65,
          title: Center(
              child: Text(
            AppLocalizations.of(context)!.calendar, //'Calendar',
            style: TextStyle(
              color: secondaryColor,
            ),
          )),
          actions: [
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () => Provider.of<ProviderGlobal>(context, listen: false)
                  .goTo('DiscoverPage'),
              child: SizedBox(
                height: 25,
                width: 25,
                child: SvgPicture.asset('Assets/Icons/search-normal.svg'),
              ),
            ),
            const SizedBox(width: 16.0),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () => Provider.of<ProviderGlobal>(context, listen: false)
                  .goTo('NotificationsPage'),
              child: SizedBox(
                height: 25,
                width: 25,
                child: SvgPicture.asset('Assets/Icons/notification.svg'),
              ),
            ),
            const SizedBox(width: 30.0),
          ],
        );
}
