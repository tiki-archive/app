/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/config_color.dart';
import '../../info_carousel_card_service.dart';

class InfoCarouselCardViewCoverBigText extends StatelessWidget {
  final Animation<double> _animationValue;

  const InfoCarouselCardViewCoverBigText(this._animationValue, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<InfoCarouselCardService>(context);
    var model = service.model.cover!;
    return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
            style: TextStyle(
                color: ConfigColor.blue,
                fontFamily: "Koara",
                fontSize: service.controller
                    .calculateAnimation(32.sp, _animationValue.value, 0.sp),
                fontWeight: FontWeight.bold),
            text: model.bigTextLight!,
            children: [
              TextSpan(
                  text: model.bigTextDark!,
                  style: TextStyle(
                      color: ConfigColor.tikiBlue,
                      fontFamily: "Koara",
                      fontSize: service.controller.calculateAnimation(
                          32.sp, _animationValue.value, 0.sp),
                      fontWeight: FontWeight.bold))
            ]));
  }
}
