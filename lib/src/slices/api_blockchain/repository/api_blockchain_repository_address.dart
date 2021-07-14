/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'dart:convert';

import 'package:app/src/config/config_domain.dart';
import 'package:app/src/config/config_sentry.dart';
import 'package:app/src/slices/api_blockchain/model/api_blockchain_model_address_req.dart';
import 'package:app/src/slices/api_blockchain/model/api_blockchain_model_address_rsp.dart';
import 'package:app/src/slices/api_blockchain/model/api_blockchain_model_address_rsp_code.dart';
import 'package:app/src/utils/api/helper_api_headers.dart';
import 'package:app/src/utils/api/helper_api_rsp.dart';
import 'package:http/http.dart';

class ApiBlockchainRepositoryAddress {
  static final String _pathAddress = '/api/latest/address';
  static final String _pathIssue = '/api/latest/address/issue';

  static Future<HelperApiRsp<ApiBlockchainModelAddressRsp>> issue(
      String? bearer, ApiBlockchainModelAddressReq req) async {
    Response rsp = await ConfigSentry.http.post(
        ConfigDomain.asUri(ConfigDomain.blockchain, _pathIssue),
        headers: HelperApiHeaders(auth: bearer).header,
        body: jsonEncode(req.toJson()));
    Map? rspMap = jsonDecode(rsp.body);
    return HelperApiRsp.fromJson(
        rspMap as Map<String, dynamic>?,
        (json) => ApiBlockchainModelAddressRsp.fromJson(
            json as Map<String, dynamic>?));
  }

  static Future<HelperApiRsp<ApiBlockchainModelAddressRspCode>> referCode(
      String? bearer, String address) async {
    Response rsp = await ConfigSentry.http.get(
        ConfigDomain.asUri(
            ConfigDomain.blockchain, _pathAddress + "/" + address + "/code"),
        headers: HelperApiHeaders(auth: bearer).header);
    Map? rspMap = jsonDecode(rsp.body);
    return HelperApiRsp.fromJson(
        rspMap as Map<String, dynamic>?,
        (json) => ApiBlockchainModelAddressRspCode.fromJson(
            json as Map<String, dynamic>?));
  }
}
