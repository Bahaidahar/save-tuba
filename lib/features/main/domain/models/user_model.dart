class UserModel {
  final String firstName;
  final String lastName;
  final int level;
  final String email;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.level,
    required this.email,
  });

  // Create a copy of the model with updated fields
  UserModel copyWith({
    String? firstName,
    String? lastName,
    int? level,
    String? email,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      level: level ?? this.level,
      email: email ?? this.email,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'level': level,
      'email': email,
    };
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      level: json['level'] as int,
      email: json['email'] as String,
    );
  }

  // Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.level == level &&
        other.email == email;
  }

  // Hash code
  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        level.hashCode ^
        email.hashCode;
  }

  // String representation
  @override
  String toString() {
    return 'UserModel(firstName: $firstName, lastName: $lastName, level: $level, email: $email)';
  }
}
