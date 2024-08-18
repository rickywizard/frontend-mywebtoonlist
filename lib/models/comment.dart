class Comment {
  final int id;
  final String lineId;
  final DateTime createdAt;
  final String content;

  Comment({
    required this.id,
    required this.lineId,
    required this.createdAt,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      lineId: json['line_id'],
      createdAt: DateTime.parse(json['created_at']),
      content: json['content'],
    );
  }

  String getFormattedCreatedAt() {
    // Extract the parts of the DateTime
    final hours = createdAt.hour.toString().padLeft(2, '0');
    final minutes = createdAt.minute.toString().padLeft(2, '0');
    final seconds = createdAt.second.toString().padLeft(2, '0');
    final year = createdAt.year;
    final month = createdAt.month.toString().padLeft(2, '0');
    final day = createdAt.day.toString().padLeft(2, '0');

    // Format the DateTime as 'yyyy-MM-dd HH:mm:ss'
    return '$year-$month-$day $hours:$minutes:$seconds';
  }
}
