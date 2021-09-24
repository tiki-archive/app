/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'dart:convert';

import 'package:app/src/slices/api_app_data/api_app_data_key.dart';
import 'package:app/src/slices/api_oauth/model/api_oauth_model.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../config/config_sentry.dart';
import '../../utils/api/helper_api_headers.dart';
import '../../utils/api/helper_api_utils.dart';
import '../api_app_data/api_app_data_service.dart';
import '../api_google/api_google_service.dart';
import 'api_oauth_interface_provider.dart';
import 'model/api_oauth_model_account.dart';
import 'model/api_oauth_model_provider.dart';
import 'repository/api_oauth_repository_account.dart';
import 'repository/api_oauth_repository_provider.dart';

class ApiOAuthService {
  late final ApiOauthModel _model;
  final FlutterAppAuth _appAuth;
  final ApiOAuthRepositoryAccount _apiAuthRepositoryAccount;
  final ApiOAuthRepositoryProvider _apiAuthRepositoryProvider;
  final ApiAppDataService _apiAppDataService;

  Map<String, ApiOAuthInterfaceProvider> get interfaceProviders =>
      _model.interfaceProviders;

  ApiOAuthService(
      {required Database database,
      required ApiAppDataService apiAppDataService})
      : this._appAuth = FlutterAppAuth(),
        this._apiAuthRepositoryAccount = ApiOAuthRepositoryAccount(database),
        this._apiAuthRepositoryProvider = ApiOAuthRepositoryProvider(),
        this._model = ApiOauthModel(),
        this._apiAppDataService = apiAppDataService {
    _getProviders();
  }

  Future<ApiOAuthModelAccount?> signIn(String providerName) async {
    ApiOAuthModelAccount? account;
    AuthorizationTokenResponse? tokenResponse =
        await _authorizeAndExchangeCode(providerName: providerName);
    if (tokenResponse != null) {
      ApiOAuthModelAccount apiAuthServiceAccountModel = ApiOAuthModelAccount(
          provider: providerName,
          accessToken: tokenResponse.accessToken,
          accessTokenExpiration: tokenResponse
              .accessTokenExpirationDateTime?.millisecondsSinceEpoch,
          refreshToken: tokenResponse.refreshToken,
          shouldReconnect: 0);
      Map? userInfo = await this.getUserInfo(apiAuthServiceAccountModel);
      if (userInfo != null) {
        apiAuthServiceAccountModel.displayName = userInfo['name'];
        apiAuthServiceAccountModel.username = userInfo['id'];
        apiAuthServiceAccountModel.email = userInfo['email'];
        account = await _upsert(apiAuthServiceAccountModel);
        return account;
      }
    }
    return null;
  }

  Future<void> signOutAll() async {
    List<ApiOAuthModelAccount> accounts =
        await _apiAuthRepositoryAccount.getAll();
    accounts.forEach((account) async => await signOut(account));
  }

  Future<void> signOut(ApiOAuthModelAccount account) async {
    ApiOAuthInterfaceProvider? provider =
        _model.interfaceProviders[account.provider];
    if (provider != null) await provider.revokeToken(account);
    await _apiAuthRepositoryAccount.delete(account);
    await _apiAppDataService.delete(ApiAppDataKey.emailIndexEpoch);
    await _apiAppDataService.delete(ApiAppDataKey.emailIndexPage);
    await _apiAppDataService.delete(ApiAppDataKey.emailIndexLabel);
  }

  Future<Map?> getUserInfo(
      ApiOAuthModelAccount apiAuthServiceAccountModel) async {
    ApiOAuthModelProvider? providerModel = (await _apiAuthRepositoryProvider
        .providers)[apiAuthServiceAccountModel.provider];
    if (providerModel != null) {
      Response rsp = await proxy(
          () => ConfigSentry.http.get(Uri.parse(providerModel.userInfoEndpoint),
              headers:
                  HelperApiHeaders(auth: apiAuthServiceAccountModel.accessToken)
                      .header),
          apiAuthServiceAccountModel);
      if (HelperApiUtils.is2xx(rsp.statusCode)) {
        return jsonDecode(rsp.body);
      }
    }
    return null;
  }

  Future<ApiOAuthModelAccount?> getAccount() async {
    return await _apiAuthRepositoryAccount.getSingleAccount();
  }

  Future<dynamic> proxy(
      Future<dynamic> Function() request, ApiOAuthModelAccount account) async {
    Response rsp = await request();
    if (HelperApiUtils.isUnauthorized(rsp.statusCode)) {
      await _refreshToken(account);
      rsp = await request();
    }
    return rsp;
  }

  Future<AuthorizationTokenResponse?> _authorizeAndExchangeCode(
      {required String providerName}) async {
    ApiOAuthModelProvider? provider =
        (await _apiAuthRepositoryProvider.providers)[providerName];
    AuthorizationServiceConfiguration authConfig =
        AuthorizationServiceConfiguration(
            provider!.authorizationEndpoint, provider.tokenEndpoint);
    List<String> providerScopes = provider.scopes;
    return await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(provider.clientId, provider.redirectUri,
          serviceConfiguration: authConfig, scopes: providerScopes),
    );
  }

  Future<TokenResponse?> _refreshToken(ApiOAuthModelAccount account) async {
    try {
      ApiOAuthModelProvider? provider =
          (await _apiAuthRepositoryProvider.providers)[account.provider!];
      return await _appAuth.token(TokenRequest(
          provider!.clientId, provider.redirectUri,
          discoveryUrl: provider.discoveryUrl,
          refreshToken: account.refreshToken,
          scopes: provider.scopes));
    } catch (e) {
      print(e.toString());
      account.shouldReconnect = 1;
    }
  }

  Future<ApiOAuthModelAccount?> _upsert(ApiOAuthModelAccount account) async {
    String providerName = account.provider!;
    ApiOAuthModelAccount? dbAccount =
        account.provider != null && account.username != null
            ? await _apiAuthRepositoryAccount.getByProviderAndUsername(
                providerName, account.username!)
            : null;
    if (dbAccount != null) {
      account.accountId = dbAccount.accountId;
      return _apiAuthRepositoryAccount.update(account);
    }
    return _apiAuthRepositoryAccount.insert(account);
  }

  Future<void> _getProviders() async {
    Map<String, ApiOAuthModelProvider> repositoryProviders =
        await _apiAuthRepositoryProvider.providers;
    repositoryProviders.forEach((k, v) {
      switch (k) {
        case 'google':
          _model.interfaceProviders[k] = ApiGoogleService(
              apiAuthService: this, apiAppDataService: _apiAppDataService);
      }
    });
  }
}