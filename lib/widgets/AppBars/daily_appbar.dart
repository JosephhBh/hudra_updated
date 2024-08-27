import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hudra/controller/global_provider/provider_global.dart';
import 'package:hudra/controller/other/is_rtl.dart';
import 'package:provider/provider.dart';

class DailyAppBar extends AppBar {
  Color primaryColor;
  BuildContext context;

  DailyAppBar({
    required this.primaryColor,
    required this.context,
  }) : super(
          backgroundColor: primaryColor,
          elevation: 0.0,
          leading: Builder(
            builder: (context) => Row(
              children: [
                Container(
                  width: 6,
                  color: Theme.of(context).primaryColorDark,
                ),
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
                      child: SvgPicture.asset('Assets/Icons/Group 8.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          leadingWidth: 65,
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
            Container(
              width: 6,
              color: Theme.of(context).primaryColorDark,
            ),
          ],
        );
}
