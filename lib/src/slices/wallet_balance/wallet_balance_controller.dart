/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/slices/api_signup/api_signup_service.dart';
import 'package:app/src/slices/login_flow/login_flow_service.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'wallet_balance_service.dart';

class WalletBalanceController {
  final WalletBalanceService service;

  WalletBalanceController(this.service);

  Future<void> updateBalance(BuildContext context) async {
    ApiSignupService apiSignupService =
        Provider.of<ApiSignupService>(context, listen: false);
    LoginFlowService loginFlowService =
        Provider.of<LoginFlowService>(context, listen: false);
    service.updateBalance(loginFlowService, apiSignupService);
  }
}
