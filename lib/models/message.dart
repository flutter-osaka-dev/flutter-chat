class Message {
  Message({
    required this.id,
    required this.profileId,
    required this.content,
    required this.createdAt,
    required this.isMine,
  });

  /// メッセージのID
  final String id;

  /// メッセージを送信した人のユーザーID
  final String profileId;

  /// メッセージの内容
  final String content;

  /// メッセージの送信日時
  final DateTime createdAt;

  /// このメッセージを送ったのが自分かどうか
  final bool isMine;

  /// [map]にSupabaseからのデータを渡し、[myUserId]には自分のauthのユーザーIDを渡すと[Message]のインスタンスを作成できる。
  Message.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  })  : id = map['id'],
        profileId = map['profile_id'],
        content = map['content'],
        createdAt = DateTime.parse(map['created_at']),
        isMine = myUserId == map['profile_id'];
}
