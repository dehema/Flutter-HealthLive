class BenefitPointDto {
  const BenefitPointDto({
    required this.title,
    required this.description,
    this.icon,
  });

  final String title;
  final String description;
  final String? icon;

  factory BenefitPointDto.fromJson(Map<String, dynamic> json) {
    return BenefitPointDto(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String?,
    );
  }
}
