/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */
import 'package:flutter/material.dart';
import 'package:tiki_style/tiki_style.dart';

class HeaderViewWidgetBadge extends StatelessWidget {
  final String label;

  const HeaderViewWidgetBadge(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      Image(
          width: SizeProvider.instance.width(120),
          image: ImgProvider.badgeHeader.image),
      SizedBox(
          width: SizeProvider.instance.width(116),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: TextProvider.familyNunitoSans,
                    fontWeight: FontWeight.w800,
                    color: ColorProvider.white,
                    fontSize: SizeProvider.instance.text(11)),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeProvider.instance.size(9)),
                  child: Icon(IconProvider.star,
                      size: SizeProvider.instance.size(12),
                      color: ColorProvider.white)),
            ],
          ))
    ]);
  }
}
