/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/slices/api_knowledge/api_knowledge_service.dart';
import 'package:app/src/slices/data_push/data_push_service.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

import '../api_app_data/api_app_data_service.dart';
import '../api_company/api_company_service.dart';
import '../api_email_msg/api_email_msg_service.dart';
import '../api_email_sender/api_email_sender_service.dart';
import '../api_oauth/api_oauth_service.dart';
import '../api_oauth/model/api_oauth_model_account.dart';
import 'data_fetch_service_email.dart';

class DataFetchService extends ChangeNotifier {
  final _log = Logger('DataFetchService');
  final DataPushService _dataPushService;
  late final DataFetchServiceEmail email;

  DataFetchService(
      {required ApiOAuthService apiAuthService,
      required ApiAppDataService apiAppDataService,
      required ApiCompanyService apiCompanyService,
      required ApiEmailSenderService apiEmailSenderService,
      required ApiEmailMsgService apiEmailMsgService,
      required ApiKnowledgeService apiKnowledgeService,
      required DataPushService dataPushService})
      : this._dataPushService = dataPushService {
    this.email = DataFetchServiceEmail(
        apiAuthService: apiAuthService,
        apiAppDataService: apiAppDataService,
        apiEmailMsgService: apiEmailMsgService,
        apiEmailSenderService: apiEmailSenderService,
        apiCompanyService: apiCompanyService,
        apiKnowledgeService: apiKnowledgeService,
        dataPushService: _dataPushService,
        notifyListeners: notifyListeners);
  }

  Future<void> index(ApiOAuthModelAccount account) async {
    _log.fine('DataFetchService index');
    await email.index(account);
    notifyListeners();
  }
}