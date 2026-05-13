import 'package:equatable/equatable.dart';

class PaperEntity extends Equatable {
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

  const PaperEntity({
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

  PaperEntity copyWith({
    String? id,
    String? title,
    String? subject,
    String? grade,
    String? board,
    String? examType,
    int? year,
    String? fileUrl,
    String? thumbnailUrl,
    String? description,
    String? difficulty,
    int? downloadCount,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return PaperEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      grade: grade ?? this.grade,
      board: board ?? this.board,
      examType: examType ?? this.examType,
      year: year ?? this.year,
      fileUrl: fileUrl ?? this.fileUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      downloadCount: downloadCount ?? this.downloadCount,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subject,
        grade,
        board,
        examType,
        year,
        fileUrl,
        thumbnailUrl,
        description,
        difficulty,
        downloadCount,
        isFavorite,
        createdAt,
      ];
}
