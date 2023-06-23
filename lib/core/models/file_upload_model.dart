class FileUploadModel {
  final String mediaId;
  final String mediaUrl;
  final String mediaType;
  FileUploadModel({
    required this.mediaId,
    required this.mediaUrl,
    required this.mediaType,
  });

  // FileUploadModel copyWith({
  //   String? mediaId,
  //   String? mediaUrl,
  //   String? mediaType,
  // }) {
  //   return FileUploadModel(
  //     mediaId: mediaId ?? this.mediaId,
  //     mediaUrl: mediaUrl ?? this.mediaUrl,
  //     mediaType: mediaType ?? this.mediaType,
  //   );
  // }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'media_id': mediaId,
  //     'media_url': mediaUrl,
  //     'media_type': mediaType,
  //   };
  // }

  // static String convertToMediaType(int value) {
  //   if (value == 0) {
  //     return MediaType.image;
  //   }
  //   if (value == 1) {
  //     return MediaType.audio;
  //   }
  //   return '';
  // }

  // factory FileUploadModel.fromMap(Map<String, dynamic> map) {
  //   return FileUploadModel(
  //     mediaId: map['media_id'] as String,
  //     mediaUrl: map['media_url'] as String,
  //     mediaType: MediaType.image,
  //   );
  // }
}
