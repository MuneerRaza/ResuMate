const String jobTable = 'jobs';

class JobFields {
  static final List<String> values = [
    id, title, companyId, description, requirements, pay, type, location, createdDate, lastDate
  ];

  static const String id = 'id';
  static const String title = 'title';
  static const String companyId = 'companyId';
  static const String description = 'description';
  static const String requirements = 'requirements';
  static const String pay = 'pay';
  static const String type = 'type';
  static const String location = 'location';
  static const String createdDate = 'createdDate';
  static const String lastDate = 'lastDate';
}

class Job {
  final int? id;
  final String title;
  final int companyId;
  final String description;
  final String requirements;
  final double pay;
  final String type;
  final String location;
  final DateTime createdDate;
  final DateTime lastDate;

  const Job({
    this.id,
    required this.title,
    required this.companyId,
    required this.description,
    required this.requirements,
    required this.pay,
    required this.type,
    required this.location,
    required this.createdDate,
    required this.lastDate
  });

  Job copy({
    int? id,
    String? title,
    int? companyId,
    String? description,
    String? requirements,
    double? pay,
    String? type,
    String? location,
    DateTime? createdDate,
    DateTime? lastDate
  }) =>
      Job(
        id: id ?? this.id,
        title: title ?? this.title,
        companyId: companyId ?? this.companyId,
        description: description ?? this.description,
        requirements: requirements ?? this.requirements,
        pay: pay ?? this.pay,
        type: type ?? this.type,
        location: location ?? this.location,
        createdDate: createdDate ?? this.createdDate,
        lastDate: lastDate ?? this.lastDate
      );

  static Job fromJson(Map<String, Object?> json) => Job(
      id: json[JobFields.id] as int?,
      title: json[JobFields.title] as String,
      companyId: json[JobFields.companyId] as int,
      description: json[JobFields.description] as String,
      requirements: json[JobFields.requirements] as String,
      pay: json[JobFields.pay] as double,
      type: json[JobFields.type] as String,
      location: json[JobFields.location] as String,
      createdDate: DateTime.parse(json[JobFields.createdDate] as String),
    lastDate: DateTime.parse(json[JobFields.lastDate] as String)
  );

  Map<String, Object?> toJson() => {
    JobFields.id: id,
    JobFields.title: id,
    JobFields.companyId: companyId,
    JobFields.description: description,
    JobFields.requirements: requirements,
    JobFields.pay: pay,
    JobFields.type: type,
    JobFields.location: location,
    JobFields.createdDate: createdDate.toIso8601String(),
    JobFields.lastDate: lastDate.toIso8601String()
  };

}