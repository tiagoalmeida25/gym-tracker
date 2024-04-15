class Sport {
  final String name;
  final int duration;
  final int order;

  Sport({
    required this.name,
    required this.duration,
    this.order = 0,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      name: json['name'],
      duration: json['duration'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'order': order,
    };
  }
}
