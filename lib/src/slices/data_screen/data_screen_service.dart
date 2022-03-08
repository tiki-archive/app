/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:flutter/material.dart';

import '../api_oauth/api_oauth_service.dart';
import '../api_oauth/model/api_oauth_model_account.dart';
import '../data_fetch/data_fetch_interface_provider.dart';
import '../data_fetch/data_fetch_service.dart';
import '../info_carousel_card/model/info_carousel_card_model.dart';
import 'data_screen_controller.dart';
import 'data_screen_presenter.dart';
import 'model/data_screen_model.dart';

class DataScreenService extends ChangeNotifier {
  late final DataScreenModel _model;
  late final DataScreenPresenter presenter;
  late final DataScreenController controller;
  final DataFetchService _dataFetchService;
  final ApiOAuthService _apiAuthService;

  get account => _model.account;

  DataScreenService(this._dataFetchService, this._apiAuthService) {
    _model = DataScreenModel();
    controller = DataScreenController(this);
    presenter = DataScreenPresenter(this);

    _apiAuthService.getAccount().then((account) {
      _model.account = account;
      if (account != null) _dataFetchService.asyncIndex(account);
      notifyListeners();
    });
  }

  Future<void> linkAccount(String provider) async {
    ApiOAuthModelAccount? account = await _apiAuthService.signIn(provider);
    if (account != null) {
      _model.account = account;
      _dataFetchService.asyncIndex(account);
      notifyListeners();
    }
  }

  Future<void> saveAccount(dynamic data, String provider) async {
    ApiOAuthModelAccount account = await _apiAuthService.save(data, provider);
    _model.account = account;
    notifyListeners();
  }

  Future<void> removeAccount(String email, String provider) async {
    _apiAuthService.remove(email, provider);
    _model.account = null;
    notifyListeners();
  }

  Future<List<InfoCarouselCardModel>?> getInfoCards(int accountId) async {
    ApiOAuthModelAccount? account = _model.account;
    if (account != null) {
      DataFetchInterfaceProvider? provider = _apiAuthService
          .interfaceProviders[account.provider] as DataFetchInterfaceProvider?;
      if (provider?.email != null) return await provider!.getInfoCards(account);
    }
    return List<InfoCarouselCardModel>.empty();
  }

  fetchInbox(ApiOAuthModelAccount account){
    _dataFetchService.asyncIndex(account);
    notifyListeners();
  }
}
