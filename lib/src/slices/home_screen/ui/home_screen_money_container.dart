import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiki_money/tiki_money.dart';
import 'package:tiki_style/tiki_style.dart';
import 'package:tiki_user_account/tiki_user_account.dart';

import '../../../widgets/header_bar/header_bar.dart';

class HomeScreenMoneyContainer extends StatelessWidget {

  const HomeScreenMoneyContainer({Key? key}) : super(key: key);

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
                HeaderBar(userAccount: Provider.of<TikiUserAccount>(context, listen:false),),
                Expanded(child: TikiMoney().home(example: true))
              ])))
    ])));
  }
}
