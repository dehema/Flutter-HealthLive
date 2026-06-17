import 'package:equatable/equatable.dart';

class BenefitPoint extends Equatable {
  const BenefitPoint({
    required this.title,
    required this.description,
    this.icon,
  });

  final String title;
  final String description;
  final String? icon;

  @override
  List<Object?> get props => [title, description, icon];
}
