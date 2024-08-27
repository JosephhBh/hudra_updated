import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool isRTL(BuildContext context) => Directionality.of(context)
    .toString()
    .contains(TextDirection.RTL.value.toLowerCase());
