/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/config_color.dart';

class InfoCarouselCardViewScrollCtaHeading extends StatelessWidget {

  const InfoCarouselCardViewScrollCtaHeading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "What can you do about it?",
      style: TextStyle(
          color: ConfigColor.tikiBlue,
          fontWeight: FontWeight.w800,
          fontSize: 13.sp,
          fontFamily: "NunitoSans"),
    );
  }
}
