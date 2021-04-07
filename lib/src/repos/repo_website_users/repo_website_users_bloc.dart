/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'dart:convert';

import 'package:app/src/configs/config_domains.dart';
import 'package:app/src/repos/repo_website_users/repo_website_users_model_rsp.dart';
import 'package:app/src/utilities/utility_functions.dart';
import 'package:http/http.dart' as http;

class RepoWebsiteUsersBloc {
  static final String _path = '/0-0-3/signup/count';

  Future<RepoWebsiteUsersRsp> get() async {
    http.Response rsp = await http.get(Uri.https(ConfigDomains.website, _path),
        headers: jsonHeaders());
    Map rspMap = jsonDecode(rsp.body);
    return RepoWebsiteUsersRsp.fromJson(rspMap);
  }
}
