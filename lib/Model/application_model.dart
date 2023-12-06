const String applicationTable = 'applications';

class ApplicationFields {
  static final List<String> values = [
    id, applicantId, jobId, status
  ];

  static const String id = 'id';
  static const String applicantId = 'applicantId';
  static const String jobId = 'jobId';
  static const String status = 'status';
}

class Application {
  final int? id;
  final int applicantId;
  final int jobId;
  final String status;


  const Application({
    this.id,
    required this.applicantId,
    required this.jobId,
    required this.status,
  });

  Application copy({
    int? id,
    int? applicantId,
    int? jobId,
    String? status,
  }) =>
      Application(
        id: id ?? this.id,
        applicantId: applicantId ?? this.applicantId,
        jobId: jobId ?? this.jobId,
        status: status ?? this.status,
      );


  static Application fromJson(Map<String, Object?> json) => Application(
      id: json[ApplicationFields.id] as int?,
      applicantId: json[ApplicationFields.applicantId] as int,
      jobId: json[ApplicationFields.jobId] as int,
      status: json[ApplicationFields.status] as String

  );

  Map<String, Object?> toJson() => {
    ApplicationFields.id: id,
    ApplicationFields.applicantId: applicantId,
    ApplicationFields.jobId: jobId,
    ApplicationFields.status: status
  };

}