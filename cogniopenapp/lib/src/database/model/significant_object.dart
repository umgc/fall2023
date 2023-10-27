import 'package:cogniopenapp/src/database/repository/significant_object_repository.dart';

class SignificantObject {
  final int? id;
  final String label;
  final String imageFileName;

  SignificantObject({
    this.id,
    required this.label,
    required this.imageFileName,
  });

  SignificantObject copy({
    int? id,
    String? label,
    String? imageFileName,
  }) =>
      SignificantObject(
        id: id ?? this.id,
        label: label ?? this.label,
        imageFileName: imageFileName ?? this.imageFileName,
      );

  Map<String, Object?> toJson() {
    return {
      SignificantObjectFields.id: id,
      SignificantObjectFields.label: label,
      SignificantObjectFields.imageFileName: imageFileName,
    };
  }

  static SignificantObject fromJson(Map<String, Object?> json) {
    try {
      return SignificantObject(
        id: json[SignificantObjectFields.id] as int?,
        label: json[SignificantObjectFields.label] as String,
        imageFileName: json[SignificantObjectFields.imageFileName] as String,
      );
    } catch (e) {
      throw FormatException('Error parsing JSON for SignificantObject: $e');
    }
  }
}
