import 'package:app/src/slices/decision_card_spam/decision_card_spam_service.dart';
import 'package:app/src/slices/decision_card_spam/model/decision_card_spam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';

import 'decision_card_spam_view_company.dart';
import 'decision_card_spam_view_data_info_row.dart';
import 'decision_card_spam_view_frequency.dart';
import 'decision_card_spam_view_header.dart';
import 'decision_card_spam_view_separator.dart';

class DecisionCardSpamLayoutContent extends StatelessWidget {
  final GlobalKey shareKey;

  final DecisionCardSpamModel cardSpamModel;
  final DecisionCardSpamService service;

  DecisionCardSpamLayoutContent(
      this.shareKey, this.service, this.cardSpamModel);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      DecisionCardSpamViewHeader(this.service, this.shareKey, "mensagem"),
      DecisionCardSpamViewCompany(
          logo: this.cardSpamModel.logoUrl,
          name: this.cardSpamModel.companyName,
          email: this.cardSpamModel.senderEmail),
      Padding(padding: EdgeInsets.only(top: 3.h)),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                  color: Color(0xFFF8F8F8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DecisionCardSpamViewFrequency(
                          this.cardSpamModel.frequency.toString(),
                          this.cardSpamModel.category.toString()),
                      DecisionCardSpamViewSeparator(),
                      DecisionCardSpamViewDataInfoRow(),
                      // DecisionCardSpamViewSecurity()
                    ],
                  ))))
    ]));
  }
}
