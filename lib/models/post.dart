import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable(explicitToJson: true)
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  @JsonKey(ignore: true)
  late final String previewText;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  }) {
    previewText = body.substring(0, body.indexOf('\n')) + '...';
  }

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
