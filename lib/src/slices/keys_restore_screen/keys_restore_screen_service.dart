/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/slices/api/api_service.dart';
import 'package:app/src/slices/app/app_service.dart';
import 'package:app/src/slices/app/model/app_model_user.dart';
import 'package:app/src/slices/keys/keys_service.dart';
import 'package:app/src/slices/keys/model/keys_model.dart';
import 'package:app/src/slices/keys_restore_screen/keys_restore_screen_controller.dart';
import 'package:app/src/slices/keys_restore_screen/keys_restore_screen_presenter.dart';
import 'package:app/src/slices/tiki_screen/tiki_screen_service.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/keys_restore_screen_model.dart';

class KeysRestoreScreenService extends ChangeNotifier {
  late KeysRestoreScreenPresenter presenter;
  late KeysRestoreScreenController controller;
  late KeysRestoreScreenServiceModel model;

  KeysRestoreScreenService() {
    model = KeysRestoreScreenServiceModel();
    presenter = KeysRestoreScreenPresenter(this);
    controller = KeysRestoreScreenController();
  }

  getUI() {
    return presenter.render();
  }

  scanQr(context) async {
    var keysService = KeysService();
    ScanResult result = await BarcodeScanner.scan();
    if (result.type == ResultType.Barcode) {
      KeysModel? keys = keysService.getKeysFromCombined(result.rawContent);
      if (keys != null) {
        saveAndLogin(keys, context);
      }
    }
  }

  saveAndLogin(KeysModel keys, BuildContext context) async {
    var keysService = KeysService();
    await keysService.save(keys);
    var apiService = ApiService();
    var appService = Provider.of<AppService>(context);
    String referral = await apiService.getReferalCode(keys.address!);
    AppModelUser user = AppModelUser(
      email: appService.model.current!.email,
      address: keys.address,
      isLoggedIn: true,
      code: referral,
    );
    appService.updateUser(user);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => TikiScreenService().getUI()),
        ModalRoute.withName('/home'));
  }
}
