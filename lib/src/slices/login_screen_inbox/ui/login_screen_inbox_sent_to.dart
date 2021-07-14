/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/config/config_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../login_screen_inbox_service.dart';

class LoginScreenInboxSentTo extends StatelessWidget {
  static const num _fontSize = 14;
  static const String _text = "I sent an email with a link to";

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LoginScreenInboxService>(context).model;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_text,
          style: TextStyle(
              color: ConfigColor.greySix,
              fontSize: _fontSize.sp,
              fontWeight: FontWeight.w600)),
      Text(model.email ?? "",
          style: TextStyle(
              color: ConfigColor.greySix,
              fontSize: _fontSize.sp,
              fontWeight: FontWeight.bold))
    ]);
  }
}
