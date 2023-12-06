const String applicantTable = 'applicants';

class ApplicantFields {
  static final List<String> values = [
  id, name, email, address, phoneNo ,techRating, softRating
  ];

  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String address = 'address';
  static const String phoneNo = 'phoneNo';
  static const String techRating = 'techRating';
  static const String softRating = 'softRating';
}

class Applicant {
  final int? id;
  final String name;
  final String email;
  final String address;
  final String phoneNo;
  final int techRating;
  final int softRating;

  const Applicant({
    this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNo,
    required this.techRating,
    required this.softRating,
  });

  Applicant copy({
    int? id,
    String? name,
    String? email,
    String? address,
    String? phoneNo,
    int? techRating,
    int? softRating,
  }) =>
      Applicant(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        address: address ?? this.address,
        phoneNo: phoneNo ?? this.phoneNo,
        techRating: techRating ?? this.techRating,
        softRating: softRating ?? this.softRating,
      );

  static Applicant fromJson(Map<String, Object?> json) => Applicant(
    id: json[ApplicantFields.id] as int?,
    name: json[ApplicantFields.name] as String,
    email: json[ApplicantFields.email] as String,
    address: json[ApplicantFields.address] as String,
    phoneNo: json[ApplicantFields.phoneNo] as String,
    techRating: json[ApplicantFields.techRating] as int,
    softRating: json[ApplicantFields.softRating] as int,
  );

  Map<String, Object?> toJson() => {
    ApplicantFields.id: id,
    ApplicantFields.name: name,
    ApplicantFields.email: email,
    ApplicantFields.address: address,
    ApplicantFields.phoneNo: phoneNo,
    ApplicantFields.techRating: techRating,
    ApplicantFields.softRating: softRating,
  };

}