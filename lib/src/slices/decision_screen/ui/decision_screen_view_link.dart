/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/config/config_color.dart';
import 'package:app/src/config/config_font.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

class DecisionScreenViewLink extends StatelessWidget {
  static const String _add = "Add a Gmail account";
  static const String _choices = "to start making choices";
  static const num _fontSize = 15;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Image(
        image: AssetImage('res/images/pineapple-cry.png'),
        height: 17.h,
        fit: BoxFit.fitHeight,
      ),
      Padding(
          padding: EdgeInsets.only(top: 1.5.h),
          child: Text(_add,
              style: TextStyle(
                  fontFamily: ConfigFont.familyKoara,
                  fontSize: _fontSize.sp,
                  color: ConfigColor.orange,
                  fontWeight: FontWeight.bold))),
      Padding(
          padding: EdgeInsets.only(top: 0.3.h),
          child: Text(_choices,
              style: TextStyle(
                  fontFamily: ConfigFont.familyKoara,
                  fontSize: _fontSize.sp,
                  color: ConfigColor.tikiBlue,
                  fontWeight: FontWeight.bold)))
    ]));
  }
}
