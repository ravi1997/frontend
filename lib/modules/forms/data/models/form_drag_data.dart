class FormDragData {
  final String id;
  final String type;
  final Map<String, dynamic> data;

  FormDragData({
    required this.id,
    required this.type,
    required this.data,
  });

  factory FormDragData.fromJson(Map<String, dynamic> json) {
    return FormDragData(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      data: Map<String, dynamic>.from(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
    };
  }
}