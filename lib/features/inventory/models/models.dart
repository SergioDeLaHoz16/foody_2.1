class Product {
  final String id;
  final String name;
  final String category;
  final DateTime entryDate; // Restored field
  final DateTime expiryDate; // Restored field
  final double? grams; // Restored field
  final int quantity; // Restored field
  final String? photoUrl; // Optional
  final String? notes; // Optional
  final List<Entry> entradas; // Field for tracking history
  final String createdBy;
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.entryDate,
    required this.expiryDate,
    this.grams,
    required this.quantity,
    this.photoUrl,
    this.notes,
    required this.entradas,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'category': category,
      'entryDate': entryDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'grams': grams,
      'quantity': quantity,
      'photoUrl': photoUrl,
      'notes': notes,
      'entradas': entradas.map((e) => e.toMap()).toList(),
      'createdBy': createdBy,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['_id'] as String,
      name: map['name'] as String? ?? 'Sin nombre',
      category: map['category'] as String? ?? 'Sin categoría',
      entryDate: DateTime.parse(map['entryDate'] as String),
      expiryDate: DateTime.parse(map['expiryDate'] as String),
      grams: map['grams'] != null ? (map['grams'] as num).toDouble() : null,
      quantity: map['quantity'] as int? ?? 0,
      photoUrl: map['photoUrl'] as String?,
      notes: map['notes'] as String?,
      entradas:
          (map['entradas'] as List<dynamic>?)
              ?.map((e) => Entry.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [], // Si es null, asignar una lista vacía
      createdBy: map['createdBy'] as String? ?? '',
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    DateTime? entryDate,
    DateTime? expiryDate,
    double? grams,
    int? quantity,
    String? photoUrl,
    String? notes,
    List<Entry>? entradas,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      entryDate: entryDate ?? this.entryDate,
      expiryDate: expiryDate ?? this.expiryDate,
      grams: grams ?? this.grams,
      quantity: quantity ?? this.quantity,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
      entradas: entradas ?? this.entradas,
      createdBy: this.createdBy,
    );
  }
}

class Entry {
  final DateTime entryDate;
  final DateTime expiryDate;
  final double? grams; // Optional
  final int quantity;

  Entry({
    required this.entryDate,
    required this.expiryDate,
    this.grams,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'entryDate': entryDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'grams': grams,
      'quantity': quantity,
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      entryDate: DateTime.parse(map['entryDate'] as String),
      expiryDate: DateTime.parse(map['expiryDate'] as String),
      grams: map['grams'] != null ? (map['grams'] as num).toDouble() : null,
      quantity: map['quantity'] as int,
    );
  }
}
