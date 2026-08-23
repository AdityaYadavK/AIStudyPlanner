class Subject {
  final String id;
  final String title;
  final int difficulty; // 1 (Easy) to 5 (Hard)

  Subject({required this.id, required this.title, required this.difficulty});

  Map<String, dynamic> toMap() {
    return {'title': title, 'difficulty': difficulty};
  }

  factory Subject.fromMap(String id, Map<String, dynamic> map) {
    return Subject(
      id: id,
      title: map['title'] ?? '',
      difficulty: map['difficulty'] ?? 1,
    );
  }
}
