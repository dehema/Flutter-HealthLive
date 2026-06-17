import 'package:equatable/equatable.dart';

class DailyTip extends Equatable {
  const DailyTip({
    required this.contentId,
    required this.title,
    required this.summary,
  });

  final String contentId;
  final String title;
  final String summary;

  @override
  List<Object?> get props => [contentId, title, summary];
}
