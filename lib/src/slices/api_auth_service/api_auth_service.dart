import 'package:flutter_appauth/flutter_appauth.dart';

import 'model/api_auth_service_account_model.dart';
import 'model/api_auth_service_provider_model.dart';
import 'repository/api_auth_service_repository.dart';

class ApiAuthService {
  final FlutterAppAuth _appAuth;
  final ApiAuthServiceRepository _apiAuthServiceRepository;

  ApiAuthService()
      : _appAuth = FlutterAppAuth(),
        _apiAuthServiceRepository = ApiAuthServiceRepository();

  Future<AuthorizationTokenResponse?> authorizeAndExchangeCode(
      {required String providerName, List<String>? scopes}) async {
    ApiAuthServiceProviderModel? provider = await getProvider(providerName);
    AuthorizationServiceConfiguration authConfig =
        AuthorizationServiceConfiguration(
            provider!.authorizationEndpoint, provider.tokenEndpoint);
    List<String> requestedScopes = scopes ?? List.empty(growable: false);
    return await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(provider.clientId, provider.redirectUri,
          serviceConfiguration: authConfig, scopes: requestedScopes),
    );
  }

  Future<TokenResponse?> refreshToken(
      ApiAuthServiceAccountModel account) async {
    try {
      ApiAuthServiceProviderModel? provider =
          await getProvider(account.provider!);
      return await _appAuth.token(TokenRequest(
          provider!.clientId, provider.redirectUri,
          discoveryUrl: provider.discoveryUrl,
          refreshToken: account.refreshToken,
          scopes: account.scopes));
    } catch (e) {
      print("Error in refreshToken");
    }
  }

  Future<ApiAuthServiceProviderModel?> getProvider(String provider) async {
    return await _apiAuthServiceRepository.getProvider('provider');
  }
}