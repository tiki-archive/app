/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/slices/api_google/api_google_service.dart';
//import 'package:app/src/slices/background_schedule/background_schedule_service.dart';
import 'package:app/src/slices/info_carousel_card/model/info_carousel_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data_screen_controller.dart';
import 'data_screen_presenter.dart';
import 'model/data_screen_model.dart';

class DataScreenService extends ChangeNotifier {
  late final DataScreenModel model;
  late final DataScreenPresenter presenter;
  late final DataScreenController controller;
  final ApiGoogleService googleService;

  DataScreenService(this.googleService) {
    model = DataScreenModel();
    controller = DataScreenController(this);
    presenter = DataScreenPresenter(this);
    initializeGoogleRepo();
  }

  Future<void> initializeGoogleRepo() async {
    this.model.googleAccount = await googleService.getConnectedUser();
    notifyListeners();
  }

  Future<void> removeGoogleAccount() async {
    await googleService.signOut();
    this.model.googleAccount = null;
    notifyListeners();
  }

  Future<void> addGoogleAccount(context) async {
    this.model.googleAccount = await googleService.signIn();
    //BackgroundScheduleService(context).fetchGoogleEmails();
    notifyListeners();
  }

  Future<List<InfoCarouselCardModel>> getGmailCards() async {
    return await googleService.getInfoCards();
  }
}
