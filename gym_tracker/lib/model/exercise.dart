class Exercise {
  final String name;
  final String category;
  final String muscle;
  final int? time;
  final int? rest;
  final int? reps;
  final int? sets;
  final int? duration;
  final double? distance;
  final double? weight;
  int order;

  Exercise({
    required this.name,
    required this.category,
    required this.muscle,
    required this.order,
    this.time,
    this.rest,
    this.reps,
    this.sets,
    this.duration,
    this.distance,
    this.weight,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    int? order = json['order'];

    order ??= json['name'].hashCode;

    return Exercise(
      name: json['name'],
      category: json['category'],
      muscle: json['muscle'],
      time: json['time'],
      rest: json['rest'],
      reps: json['reps'],
      sets: json['sets'],
      duration: json['duration'],
      distance: json['distance'],
      weight: json['weight'],
      order: order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'muscle': muscle,
      'time': time,
      'rest': rest,
      'reps': reps,
      'sets': sets,
      'duration': duration,
      'distance': distance,
      'weight': weight,
      'order': order,
    };
  }
}
