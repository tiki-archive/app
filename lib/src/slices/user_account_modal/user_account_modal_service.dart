/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/slices/api_signup/api_signup_service.dart';
import 'package:app/src/slices/user_account_modal/model/user_account_modal_model.dart';
import 'package:app/src/slices/user_account_modal/user_account_modal_controller.dart';
import 'package:app/src/slices/user_account_modal/user_account_modal_presenter.dart';
import 'package:app/src/slices/user_referral/user_referral_service.dart';
import 'package:flutter/widgets.dart';

class UserAccountModalService extends ChangeNotifier {
  late final UserAccountModalPresenter presenter;
  late final UserAccountModalController controller;
  late final UserAccountModalModel model;
  late final UserReferralService referralService;

  UserAccountModalService({UserReferralService? referralService}) {
    this.presenter = UserAccountModalPresenter(this);
    this.controller = UserAccountModalController(this);
    this.model = UserAccountModalModel();
    this.referralService = UserReferralService();
  }

  updateSignups(ApiSignupService apiSignupService) async {
    int? total = await apiSignupService.getTotal();
    if (total != null) {
      this.model.signupCount = total;
      notifyListeners();
    }
  }
}
