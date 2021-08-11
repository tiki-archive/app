/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

enum ApiAppDataKey {
  testCardsDone,
  fetchGmailLastRun,
  googleOauthModalComplete,
  decisionOverlayShown,
}

extension ApiAppDataKeyExtension on ApiAppDataKey {
  String? get value {
    switch (this) {
      case ApiAppDataKey.testCardsDone:
        return 'test_cards_done_bool';
      case ApiAppDataKey.fetchGmailLastRun:
        return 'gmail_last_fetch_epoch';
      case ApiAppDataKey.googleOauthModalComplete:
        return 'google_oauth_modal_complete_bool';
      case ApiAppDataKey.decisionOverlayShown:
        return 'decision_overlay_shown_bool';
      default:
        return null;
    }
  }
}
