/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/config/config_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../info_carousel_card_service.dart';

class InfoCarouselCardViewCoverText extends StatelessWidget {
  final Animation<double> _animationValue;

  InfoCarouselCardViewCoverText(this._animationValue);

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<InfoCarouselCardService>(context);
    return Opacity(
        opacity: _animationValue.value * 3 <= 1
            ? 1 - (_animationValue.value * 3)
            : 0,
        child: Text(service.model.cover!.text!,
            style: TextStyle(
                color: ConfigColor.tikiBlue,
                fontFamily: "NunitoSans",
                fontSize: 12.sp,
                fontWeight: FontWeight.w600)));
  }
}
