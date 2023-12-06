const String companyTable = 'companies';

class CompanyFields {
  static final List<String> values = [
    id, name, email, location, phoneNo, techRating, softRating
  ];

  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String location = 'location';
  static const String phoneNo = 'phoneNo';
  static const String techRating = 'techRating';
  static const String softRating = 'softRating';
}

class Company {
  final int? id;
  final String name;
  final String email;
  final String location;
  final String phoneNo;
  final int techRating;
  final int softRating;

  const Company({
    this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.phoneNo,
    required this.techRating,
    required this.softRating,
  });

  Company copy({
    int? id,
    String? name,
    String? email,
    String? location,
    String? phoneNo,
    int? techRating,
    int? softRating,
  }) =>
      Company(
        id: id ?? this.id,
        name: email ?? this.name,
        email: email ?? this.email,
        location: location ?? this.location,
        phoneNo: phoneNo ?? this.phoneNo,
        techRating: techRating ?? this.techRating,
        softRating: softRating ?? this.softRating,
      );

  static Company fromJson(Map<String, Object?> json) => Company(
      id: json[CompanyFields.id] as int?,
      name: json[CompanyFields.name] as String,
      email: json[CompanyFields.email] as String,
      location: json[CompanyFields.location] as String,
      phoneNo: json[CompanyFields.phoneNo] as String,
    techRating: json[CompanyFields.techRating] as int,
    softRating: json[CompanyFields.softRating] as int,
  );

  Map<String, Object?> toJson() => {
    CompanyFields.id: id,
    CompanyFields.name: name,
    CompanyFields.email: email,
    CompanyFields.location: location,
    CompanyFields.phoneNo: phoneNo,
    CompanyFields.techRating: techRating,
    CompanyFields.softRating: softRating,
  };

}