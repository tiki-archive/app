/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:app/src/slices/keys/model/keys_model.dart';
import 'package:app/src/slices/secure_storage/secure_storage_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepositoryKeys extends SecureStorageRepository<KeysModel> {
  static const String _table = "keys";
  static const String _version = "0.0.1";

  SecureStorageRepositoryKeys({FlutterSecureStorage? secureStorage})
      : super(_table, _version, (KeysModel model) => model.toJson(),
            (Map<String, dynamic>? json) => KeysModel.fromJson(json),
            secureStorage: secureStorage);
}