import 'package:equatable/equatable.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/features/home/domain/entities/daily_tip.dart';

class HomeData extends Equatable {
  const HomeData({
    required this.dailyTip,
    required this.recommended,
  });

  final DailyTip dailyTip;
  final List<BenefitContent> recommended;

  @override
  List<Object?> get props => [dailyTip, recommended];
}
