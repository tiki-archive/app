import 'package:app/src/slices/api/helper_api_rsp.dart';
import 'package:app/src/slices/blockchain/model/blockchain_model_address_req.dart';
import 'package:app/src/slices/blockchain/model/blockchain_model_address_rsp.dart';
import 'package:app/src/slices/blockchain/repository/blockchain_repository_address.dart';
import 'package:app/src/slices/keys/repository/secure_storage_repository_keys.dart';
import 'package:app/src/utils/crypto/helper_crypto.dart';
import 'package:app/src/utils/crypto/helper_crypto_ecdsa.dart';
import 'package:app/src/utils/crypto/helper_crypto_rsa.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'model/keys_model.dart';

class KeysService {
  SecureStorageRepositoryKeys _repoLocalSsKeys;

  KeysService()
      : _repoLocalSsKeys =
            SecureStorageRepositoryKeys(secureStorage: FlutterSecureStorage());

  /// Verify if credentials are valid
  ///
  /// Checks if any of the keys are null and if they have the correct length.
  bool isKeyValid(
      String? address, String? dataKeyPrivate, String? signKeyPrivate) {
    var addressValid = address != null && address.length == 64;
    var dataKeyValid = dataKeyPrivate != null && dataKeyPrivate.length == 1624;
    var signKeyValid = signKeyPrivate != null && signKeyPrivate.length == 92;
    return addressValid && dataKeyValid && signKeyValid;
  }

  Future<void> saveWitParams(String address, String? dataPrivate,
      String? signPrivate, String? dataPublicKey, String? signPublicKey) async {
    await _repoLocalSsKeys.save(
        address,
        KeysModel(
            address: address,
            dataPrivateKey: dataPrivate,
            dataPublicKey: dataPublicKey,
            signPrivateKey: signPrivate,
            signPublicKey: signPublicKey));
  }

  Future<void> save(KeysModel keys) async {
    await _repoLocalSsKeys.save(keys.address!, keys);
  }

  Future<KeysModel> issueAddress(BuildContext context, KeysModel keys) async {
    var repoApiBlockchainAddress = RepoApiBlockchainAddress.provide(context);
    HelperApiRsp<RepoApiBlockchainAddressRsp> rsp =
        await repoApiBlockchainAddress.issue(RepoApiBlockchainAddressReq(
            keys.dataPublicKey, keys.signPublicKey));
    if (rsp.code == 200 && rsp.data.address == keys.address) {
      await _repoLocalSsKeys.save(keys.address!, keys);
    } else {
      Sentry.captureMessage("Failed to register keys with blockchain",
          level: SentryLevel.error);
      print(rsp.data);
      throw Exception("issueAddress error " + rsp.data);
    }
    return keys;
  }

  String getAddress(String s) {
    List<String> raw = s.split(".");
    return raw[0];
  }

  String getDataKey(String s) {
    List<String> raw = s.split(".");
    return raw[1];
  }

  String getSignKey(String s) {
    List<String> raw = s.split(".");
    return raw[2];
  }

  //
  // Future<void> getLink() async {
  //   if (state.link == null) {
  //     AppModelCurrent current = await _secureStorageRepositoryCurrent
  //         .find(SecureStorageRepositoryCurrent.key);
  //     AppModelUser user = await _repoLocalSsUser.find(current.email!);
  //     if (user.referral == null) {
  //       final DynamicLinkParameters parameters = DynamicLinkParameters(
  //           uriPrefix: 'https://mytiki.app',
  //           link: Uri.parse(
  //               'https://mytiki.com/app/blockchain?ref=' + user.address!),
  //           dynamicLinkParametersOptions: DynamicLinkParametersOptions(
  //             shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
  //           ),
  //           androidParameters: AndroidParameters(
  //               packageName: 'com.mytiki.app',
  //               fallbackUrl: Uri.parse(
  //                   'https://play.google.com/store/apps/details?id=com.mytiki.app')),
  //           iosParameters: IosParameters(
  //             //appStoreId: '1560250866',
  //               bundleId: 'com.mytiki.app',
  //               fallbackUrl:
  //               Uri.parse('https://testflight.apple.com/join/pUcjaGK8')),
  //           socialMetaTagParameters: SocialMetaTagParameters(
  //               title: 'Welcome to TIKI!',
  //               description: "It's YOUR data. Take back control of it.",
  //               imageUrl: Uri.parse(
  //                   'https://mytiki.com/og-img-d9216d73be474034a8208d3c613f72a8.png')));
  //       final ShortDynamicLink shortLink = await parameters.buildShortLink();
  //       Uri referral = shortLink.shortUrl;
  //       user.referral = referral;
  //       await _repoLocalSsUser.save(user.email!, user);
  //       emit(KeysReferralSuccess(state.referer, referral, 0));
  //     } else
  //       emit(KeysReferralSuccess(state.referer, user.referral, 0));
  //   } else
  //     emit(KeysReferralSuccess(state.referer, state.link, 0));
  // }
  //
  // Future<void> getCount() async {
  //   AppModelCurrent current = await _secureStorageRepositoryCurrent
  //       .find(SecureStorageRepositoryCurrent.key);
  //   AppModelUser user = await _repoLocalSsUser.find(current.email!);
  //   HelperApiRsp<RepoApiBlockchainAddressReferRsp> apiRsp =
  //   await _repoApiBlockchainAddress.referCount(user.address);
  //   if (apiRsp.code == 200) {
  //     RepoApiBlockchainAddressReferRsp rsp = apiRsp.data;
  //     emit(KeysReferralSuccess(state.referer, state.link, rsp.count));
  //   }
  // }

  generateKeys() async {
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> dataKey =
        await HelperCryptoRsa.createRSA();
    AsymmetricKeyPair<ECPublicKey, ECPrivateKey> signKey =
        await HelperCryptoEcdsa.createECDSA();
    String dataPublic = HelperCryptoRsa.encodeRSAPublic(dataKey.publicKey);
    String dataPrivate = HelperCryptoRsa.encodeRSAPrivate(dataKey.privateKey);
    String signPublic = HelperCryptoEcdsa.encodeECDSAPublic(signKey.publicKey);
    String signPrivate =
        HelperCryptoEcdsa.encodeECDSAPrivate(signKey.privateKey);
    String address = HelperCrypto.sha3(signPublic);
    return KeysModel(
      dataPublicKey: dataPublic,
      dataPrivateKey: dataPrivate,
      signPublicKey: signPublic,
      signPrivateKey: signPrivate,
      address: address,
    );
  }
}