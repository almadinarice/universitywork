class Student {
  final int? id;
  final String name;
  final String course;
  final int creditHours;
  final int marks;

  Student({
    this.id,
    required this.name,
    required this.course,
    required this.creditHours,
    required this.marks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'creditHours': creditHours,
      'marks': marks,
    };
  }
}
