/// ユーザーのプロフィール情報を保持するクラス
class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.createdAt,
  });

  /// ユーザーのID
  final String id;

  /// ユーザー名
  final String username;

  /// ユーザーの作成日時
  final DateTime createdAt;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        createdAt = DateTime.parse(map['created_at']);
}
