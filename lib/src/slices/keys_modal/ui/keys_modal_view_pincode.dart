import '../../../config/config_color.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

import '../keys_modal_service.dart';

class KeysModalViewPinCode extends StatelessWidget {
  final String question = "Enter a 6 digits Pin Code";

  @override
  Widget build(BuildContext context) {
    KeysModalService service = Provider.of<KeysModalService>(context);
    return Column(
      children: [
        Text(question),
        PinCodeTextField(
          autofocus: true,
          hideCharacter: true,
          highlight: true,
          highlightColor: ConfigColor.tikiBlue,
          defaultBorderColor: ConfigColor.tikiPurple,
          hasTextBorderColor: ConfigColor.green,
          highlightPinBoxColor: Colors.transparent,
          maxLength: 6,
          maskCharacter: "*",
          onDone: (text) => service.controller.submitPincode(text),
          pinBoxWidth: 50,
          pinBoxHeight: 64,
          hasUnderline: true,
          wrapAlignment: WrapAlignment.spaceAround,
          pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 22.0),
          pinTextAnimatedSwitcherTransition:
              ProvidedPinBoxTextAnimation.scalingTransition,
          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 100),
          highlightAnimationBeginColor: Colors.black,
          highlightAnimationEndColor: Colors.white12,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
