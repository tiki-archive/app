/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/config_color.dart';
import '../../info_carousel_card_service.dart';
import 'info_carousel_card_view_scroll_body_explain.dart';
import 'info_carousel_card_view_scroll_body_should_know.dart';
import 'info_carousel_card_view_scroll_body_they_say.dart';
import 'info_carousel_card_view_scroll_cta_button.dart';
import 'info_carousel_card_view_scroll_cta_explain.dart';
import 'info_carousel_card_view_scroll_cta_heading.dart';
import 'info_carousel_card_view_scroll_header.dart';

class InfoCarouselCardLayoutScroll extends StatelessWidget {
  final Animation<double> _animationValue;
  final AnimationController _animationController;

  const InfoCarouselCardLayoutScroll(this._animationValue, this._animationController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<InfoCarouselCardService>(context).controller;
    return Container(
        color: ConfigColor.greyFour,
        child: NotificationListener(
            onNotification: (notification) => controller.onScrollNotification(
                notification, _animationController),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                      color: ConfigColor.white,
                      padding: EdgeInsets.only(left: 4.w, top: 1.h, right: 4.w),
                      child: InfoCarouselCardViewScrollHeader(_animationValue)),
                  Container(
                      color: ConfigColor.tikiPurple,
                      child: Column(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 3.h),
                            child: const InfoCarouselCardViewScrollBodyExplain()),
                        const InfoCarouselCardViewScrollBodyTheySay(),
                        const InfoCarouselCardViewScrollBodyShouldKnow(),
                      ])),
                  Container(
                      color: ConfigColor.greyFour,
                      padding: EdgeInsets.only(left: 4.w, top: 3.h, right: 4.w),
                      child: Column(children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: const InfoCarouselCardViewScrollCtaHeading()),
                        Container(
                            padding: EdgeInsets.only(top: 2.h),
                            child: const InfoCarouselCardViewScrollCtaExplain()),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: const InfoCarouselCardViewScrollCtaButton()),
                      ])),
                ],
              ),
            )));
  }
}
