class FirestorePath {
  static String users() => 'users/';
  static String user(String uid) => 'users/$uid';

  static String wheelchairs() => 'wheelchairs/';
  static String wheelchair(String uid) => 'wheelchairs/$uid';

  static String msgLogs() => 'msgLogs/';

  static String features(String group) => 'G' + group;
  static String group() => 'features/common';
  static String images(String uid, String id) => '$uid/$id';
}
