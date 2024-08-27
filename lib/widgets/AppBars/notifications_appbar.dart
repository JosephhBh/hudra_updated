import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/other/is_rtl.dart';
import 'package:provider/provider.dart';

class NotificationsAppbar extends AppBar {
  Color? primaryColor;
  Color? secondaryColor;
  BuildContext context;

  NotificationsAppbar({
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
                    child: Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.rotationY(isRTL(context) ? math.pi : 0),
                      child: SvgPicture.asset(
                        'Assets/Icons/Group 8.svg',
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          leadingWidth: 65,
          title: Center(
              child: Text(
            AppLocalizations.of(context)!.notifications, //'Notifications',
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
                child: SvgPicture.asset(
                  'Assets/Icons/search-normal.svg',
                  color: secondaryColor,
                ),
              ),
            ),
            // const SizedBox(width: 16.0),
            // InkWell(
            //   highlightColor: Colors.transparent,
            //   splashColor: Colors.transparent,
            //   hoverColor: Colors.transparent,
            //   onTap: () => debugPrint('notifications'),
            //   child: SizedBox(
            //     height: 25,
            //     width: 25,
            //     child: SvgPicture.asset(
            //       'Assets/Icons/notification.svg',
            //       color: secondaryColor,
            //     ),
            //   ),
            // ),
            const SizedBox(width: 30.0),
          ],
        );
}
