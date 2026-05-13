import '../../domain/entities/paper_entity.dart';

class PaperModel {
  final String id;
  final String title;
  final String subject;
  final String? grade;
  final String? board;
  final String examType;
  final int year;
  final String fileUrl;
  final String? thumbnailUrl;
  final String? description;
  final String? difficulty;
  final int downloadCount;
  final bool isFavorite;
  final DateTime createdAt;

  const PaperModel({
    required this.id,
    required this.title,
    required this.subject,
    this.grade,
    this.board,
    required this.examType,
    required this.year,
    required this.fileUrl,
    this.thumbnailUrl,
    this.description,
    this.difficulty,
    this.downloadCount = 0,
    this.isFavorite = false,
    required this.createdAt,
  });

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    return PaperModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: json['subject'] as String,
      grade: json['grade'] as String?,
      board: json['board'] as String?,
      examType: json['exam_type'] as String,
      year: json['year'] as int,
      fileUrl: json['file_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as String?,
      downloadCount: json['download_count'] as int? ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'grade': grade,
      'board': board,
      'exam_type': examType,
      'year': year,
      'file_url': fileUrl,
      'thumbnail_url': thumbnailUrl,
      'description': description,
      'difficulty': difficulty,
      'download_count': downloadCount,
      'is_favorite': isFavorite,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PaperEntity toEntity() {
    return PaperEntity(
      id: id,
      title: title,
      subject: subject,
      grade: grade,
      board: board,
      examType: examType,
      year: year,
      fileUrl: fileUrl,
      thumbnailUrl: thumbnailUrl,
      description: description,
      difficulty: difficulty,
      downloadCount: downloadCount,
      isFavorite: isFavorite,
      createdAt: createdAt,
    );
  }

  factory PaperModel.fromEntity(PaperEntity entity) {
    return PaperModel(
      id: entity.id,
      title: entity.title,
      subject: entity.subject,
      grade: entity.grade,
      board: entity.board,
      examType: entity.examType,
      year: entity.year,
      fileUrl: entity.fileUrl,
      thumbnailUrl: entity.thumbnailUrl,
      description: entity.description,
      difficulty: entity.difficulty,
      downloadCount: entity.downloadCount,
      isFavorite: entity.isFavorite,
      createdAt: entity.createdAt,
    );
  }
}
