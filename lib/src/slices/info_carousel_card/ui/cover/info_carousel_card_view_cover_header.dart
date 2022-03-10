/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/config_color.dart';
import '../../../../utils/helper_image.dart';
import '../../info_carousel_card_service.dart';

class InfoCarouselCardViewCoverHeader extends StatelessWidget {
  final Animation<double> _animationValue;

  const InfoCarouselCardViewCoverHeader(this._animationValue, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<InfoCarouselCardService>(context);
    var model = service.model.cover!.header!;
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          child: Row(children: [
        HelperImage(model.image!,
            width: service.controller
                .calculateAnimation(6.w, _animationValue.value, 0)),
        Padding(padding: EdgeInsets.only(right: 2.w)),
        Text(
          model.title!,
          style: TextStyle(
              fontFamily: "NunitoSans",
              fontSize: service.controller
                  .calculateAnimation(12.sp, _animationValue.value, 0),
              fontWeight: FontWeight.bold,
              color: ConfigColor.tikiBlue),
        )
      ])),
      service.model.cover?.header?.share?.message == null
          ? Container()
          : GestureDetector(
              onTap: () => service.controller.shareCard(
                  context, model.share!.message!, model.share!.image!),
              child: Icon(Icons.share,
                  color: ConfigColor.orange,
                  size: service.controller
                      .calculateAnimation(36.sp, _animationValue.value, 0)))
    ]);
  }
}
