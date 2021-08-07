import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  @JsonKey(fromJson: _makeAddressString)
  final String address;
  final String phone;
  final String website;
  final _Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  static String _makeAddressString(data) {
    List<String> address = [
      data['zipcode'],
      data['city'],
      data['street'],
      data['suite'],
    ];
    return address.join(', ');
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class _Company {
  final String name;
  final String catchPhrase;
  final String bs;

  _Company({required this.name, required this.catchPhrase, required this.bs});

  factory _Company.fromJson(Map<String, dynamic> json) => _$_CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$_CompanyToJson(this);
}
