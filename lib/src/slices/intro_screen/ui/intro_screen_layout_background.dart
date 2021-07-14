/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/utils/helper_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../intro_screen_service.dart';

class IntroScreenBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bgColor = Provider.of<IntroScreenService>(context)
        .model
        .getCurrentSlide()
        .backgroundColor;
    return Stack(children: [
      Center(child: Container(color: bgColor)),
      Align(
        alignment: Alignment.bottomLeft,
        child: HelperImage('intro-blob'),
      ),
      Container(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(bottom: 5.h),
          child: HelperImage('intro-pineapple'))
    ]);
  }
}
