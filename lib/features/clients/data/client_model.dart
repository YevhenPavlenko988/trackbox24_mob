import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackbox24_mob/core/model/channel.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

enum ClientType { PRIVATE_PERSON, ORGANIZATION, unknown }

@freezed
abstract class Client with _$Client {
  const factory Client({
    required int id,
    @JsonKey(unknownEnumValue: ClientType.unknown) ClientType? type,
    String? firstName,
    String? lastName,
    String? middleName,
    String? organizationName,
    String? phone,
    String? email,
    String? city,
    String? address,
    String? notes,
    @JsonKey(unknownEnumValue: Channel.unknown) Channel? channel,
    String? channelDetails,
  }) = _Client;
  const Client._();

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Same rule as the web: organization name for organizations, "Прізвище Ім'я По батькові" otherwise.
  String get displayName {
    if (type == ClientType.ORGANIZATION &&
        (organizationName?.isNotEmpty ?? false)) {
      return organizationName!;
    }
    final person = [
      lastName,
      firstName,
      middleName,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' ');
    return person.isNotEmpty ? person : (organizationName ?? '—');
  }
}
