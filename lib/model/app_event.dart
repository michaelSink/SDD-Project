import 'dart:convert';


class AppEvent {
  final String title;
  final String id;
  final String description;
  final DateTime date;
  final String userId;
  AppEvent({
    this.title,
    this.id,
    this.description,
    this.date,
    this.userId,
  });
  

  AppEvent copyWith({
    String title,
    String id,
    String description,
    DateTime date,
    String userId,
  }) {
    return AppEvent(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      userId: userId ?? this.userId,
    );
  }

  AppEvent merge(AppEvent model) {
    return AppEvent(
      title: model.title ?? this.title,
      id: model.id ?? this.id,
      description: model.description ?? this.description,
      date: model.date ?? this.date,
      userId: model.userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'date': date?.millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  factory AppEvent.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AppEvent(
      title: map['title'],
      id: map['id'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      userId: map['userId'],
    );
  }

    factory AppEvent.fromDS(String id, Map<String, dynamic> map) {
    if (map == null) return null;
  
    return AppEvent(
      title: map['title'],
      id: id,
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      userId: map['userId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppEvent.fromJson(String source) => AppEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppEvent(title: $title, id: $id, description: $description, date: $date, userId: $userId)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is AppEvent &&
      o.title == title &&
      o.id == id &&
      o.description == description &&
      o.date == date &&
      o.userId == userId;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      id.hashCode ^
      description.hashCode ^
      date.hashCode ^
      userId.hashCode;
  }
}
