/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiki_decision/tiki_decision.dart';
import 'package:tiki_style/tiki_style.dart';
import 'package:tiki_user_account/tiki_user_account.dart';

import '../header/header_view_layout.dart';

class HomeViewLayoutDecision extends StatelessWidget {
  const HomeViewLayoutDecision({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Stack(children: [
      Container(color: ColorProvider.greyOne),
      SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(children: [
                HeaderViewLayout(
                  userAccount:
                      Provider.of<TikiUserAccount>(context, listen: false),
                ),
                Expanded(
                    child: Provider.of<TikiDecision>(context, listen: false)
                        .widget)
              ])))
    ])));
  }
}
