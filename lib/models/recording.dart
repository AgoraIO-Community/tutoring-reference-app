import 'dart:convert';

class Recording {
  final String url;
  final String sessionId;
  final String date;

  Recording({
    required this.url,
    required this.sessionId,
    required this.date,
  });

  Recording copyWith({
    String? url,
    String? sessionId,
    String? date,
  }) {
    return Recording(
      url: url ?? this.url,
      sessionId: sessionId ?? this.sessionId,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'sessionId': sessionId,
      'date': date,
    };
  }

  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
      url: map['url'] ?? '',
      sessionId: map['sessionId'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Recording.fromJson(String source) =>
      Recording.fromMap(json.decode(source));

  @override
  String toString() =>
      'Recording(url: $url, sessionId: $sessionId, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Recording &&
        other.url == url &&
        other.sessionId == sessionId &&
        other.date == date;
  }

  @override
  int get hashCode => url.hashCode ^ sessionId.hashCode ^ date.hashCode;
}
