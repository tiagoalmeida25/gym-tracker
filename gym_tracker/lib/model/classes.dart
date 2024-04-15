class Class {
  final String name;
  final int duration;
  final int order;

  Class({
    required this.name,
    required this.duration,
    this.order = 0,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
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
