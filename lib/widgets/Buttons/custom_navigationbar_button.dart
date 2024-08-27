import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavigationBarButton extends StatelessWidget {
  String textString;
  String imageString;
  Function onTap;

  bool isWeb = false;

  CustomNavigationBarButton({
    Key? key,
    this.isWeb = false,
    required this.textString,
    required this.imageString,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: !isWeb
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: SvgPicture.asset(imageString),
                ),
                const SizedBox(height: 2),
                Text(
                  textString,
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
                )
              ],
            )
          : SizedBox(
        width: 130,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(imageString),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    textString,
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  )
                ],
              ),
          ),
    );
  }
}
