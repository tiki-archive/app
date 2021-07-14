/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../intro_screen_service.dart';

class IntroScreenTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var service = Provider.of<IntroScreenService>(context, listen: false);
    var titleSize = 34.sp;
    return Text(service.presenter.textTitle,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Koara',
            fontSize: titleSize,
            fontWeight: FontWeight.bold));
  }
}
