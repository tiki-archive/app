/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/config_color.dart';
import '../../info_carousel_card_controller.dart';
import '../../info_carousel_card_service.dart';
import '../../model/info_carousel_card_model_content_text.dart';

class InfoCarouselCardViewScrollBodyExplain extends StatelessWidget {

  const InfoCarouselCardViewScrollBodyExplain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var service = Provider.of<InfoCarouselCardService>(context);
    List<InfoCarouselCardModelContentText> spans =
        service.model.content!.body!.explain!;
    TextSpan? childSpan;
    for (var spanContent in spans.reversed) {
      childSpan = _buildSpan(spanContent, childSpan, service.controller);
    }
    return RichText(text: childSpan ?? const TextSpan());
  }

  _buildSpan(InfoCarouselCardModelContentText content, TextSpan? child,
      InfoCarouselCardController controller) {
    return TextSpan(
        recognizer: TapGestureRecognizer()
          ..onTap = () => controller.openUrl(content.url),
        style: TextStyle(
            color: content.url == null ? Colors.white : ConfigColor.tikiOrange,
            fontWeight:
                content.url == null ? FontWeight.normal : FontWeight.w600,
            fontSize: 13.sp,
            fontFamily: "NunitoSans"),
        text: content.text,
        children: [child ?? const TextSpan()]);
  }
}
