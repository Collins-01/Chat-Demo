// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FileUploadModel {
  final String mediaId;
  final String mediaUrl;
  final String mediaType;
  FileUploadModel({
    required this.mediaId,
    required this.mediaUrl,
    required this.mediaType,
  });

  FileUploadModel copyWith({
    String? mediaId,
    String? mediaUrl,
    String? mediaType,
  }) {
    return FileUploadModel(
      mediaId: mediaId ?? this.mediaId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'media_id': mediaId,
      'media_url': mediaUrl,
      'media_type': mediaType,
    };
  }

  factory FileUploadModel.fromMap(Map<String, dynamic> map) {
    return FileUploadModel(
      mediaId: map['media_id'] as String,
      mediaUrl: map['media_url'] as String,
      mediaType: map['media_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FileUploadModel.fromJson(String source) =>
      FileUploadModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FileUploadModel(mediaId: $mediaId, mediaUrl: $mediaUrl, mediaType: $mediaType)';

  @override
  bool operator ==(covariant FileUploadModel other) {
    if (identical(this, other)) return true;

    return other.mediaId == mediaId &&
        other.mediaUrl == mediaUrl &&
        other.mediaType == mediaType;
  }

  @override
  int get hashCode => mediaId.hashCode ^ mediaUrl.hashCode ^ mediaType.hashCode;
}
