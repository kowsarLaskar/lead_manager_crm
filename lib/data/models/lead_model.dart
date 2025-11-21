class LeadModel {
  final String id;
  final String name;
  final String contact;
  final String notes;
  final String status; // Stored as String in SQLite
  final String createdAt;

  LeadModel({
    required this.id,
    required this.name,
    required this.contact,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'notes': notes,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory LeadModel.fromMap(Map<String, dynamic> map) {
    return LeadModel(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      notes: map['notes'],
      status: map['status'],
      createdAt: map['createdAt'],
    );
  }

  LeadModel copyWith({
    String? name,
    String? contact,
    String? notes,
    String? status,
  }) {
    return LeadModel(
      id: this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: this.createdAt,
    );
  }
}
