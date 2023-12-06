import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Model/user_model.dart';
import '../Model/applicant_model.dart';
import '../Model/company_model.dart';
import '../Model/application_model.dart';
import '../Model/job_model.dart';

class DatabaseUtil {
  static final DatabaseUtil instance = DatabaseUtil._init_();
  static Database? _database;
  DatabaseUtil._init_();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('resumate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $userTable (
          ${UserFields.email} TEXT PRIMARY KEY,
          ${UserFields.name} TEXT NOT NULL,
          ${UserFields.password} TEXT NOT NULL,
          ${UserFields.role} TEXT
        )
      ''');

    await db.execute('''
        CREATE TABLE $applicantTable (
          ${ApplicantFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${ApplicantFields.name} TEXT,
          ${ApplicantFields.email} TEXT,
          ${ApplicantFields.address} TEXT,
          ${ApplicantFields.phoneNo} TEXT,
          ${ApplicantFields.techRating} INTEGER,
          ${ApplicantFields.softRating} INTEGER
        )
      ''');

    await db.execute('''
        CREATE TABLE $applicationTable (
          ${ApplicationFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${ApplicationFields.applicantId} INTEGER,
          ${ApplicationFields.jobId} INTEGER,
          ${ApplicationFields.status} TEXT,
          FOREIGN KEY (${ApplicationFields.applicantId}) REFERENCES $applicantTable(${ApplicantFields.id}),
          FOREIGN KEY (${ApplicationFields.jobId}) REFERENCES $jobTable(${JobFields.id})
        )
      ''');

    await db.execute('''
        CREATE TABLE $companyTable (
          ${CompanyFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${CompanyFields.name} TEXT,
          ${CompanyFields.email} TEXT,
          ${CompanyFields.location} TEXT,
          ${CompanyFields.phoneNo} TEXT,
          ${ApplicantFields.techRating} INTEGER,
          ${ApplicantFields.softRating} INTEGER
        )
      ''');

    await db.execute('''
        CREATE TABLE $jobTable (
          ${JobFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${JobFields.companyId} INTEGER,
          ${JobFields.description} TEXT,
          ${JobFields.requirements} TEXT,
          ${JobFields.pay} REAL,
          ${JobFields.type} TEXT,
          ${JobFields.location} TEXT,
          ${JobFields.createdDate} TEXT,
          ${JobFields.lastDate} TEXT,
          FOREIGN KEY (${JobFields.companyId}) REFERENCES $companyTable(${CompanyFields.id})
        )
      ''');
  }

  // User
  Future<User> insertUser(User user) async {
    final db = await instance.database;
    final json = user.toJson();
    const columns = '${UserFields.email}, ${UserFields.name}, ${UserFields.password}, ${UserFields.role}';

    await db.rawInsert('INSERT INTO $userTable ($columns) VALUES (?, ?, ?, ?)',
        [json[UserFields.email], json[UserFields.name], json[UserFields.password], json[UserFields.role]]);
    return user;
  }

  Future<User?> getUser(String email) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $userTable WHERE ${UserFields.email} = ?', [email]);

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    const orderBy = '${UserFields.name} ASC';

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $userTable ORDER BY $orderBy');
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;

    return db.rawUpdate('UPDATE $userTable SET ${UserFields.name} = ?, ${UserFields.password} = ?, ${UserFields.role} = ? WHERE ${UserFields.email} = ?',
        [user.name, user.password, user.role, user.email]);
  }

  Future<int> deleteUser(String email) async {
    final db = await instance.database;

    return await db.rawDelete('DELETE FROM $userTable WHERE ${UserFields.email} = ?', [email]);
  }

  // Applicant
  Future<Applicant> insertApplicant(Applicant applicant) async {
    final db = await instance.database;
    final json = applicant.toJson();
    const columns = '${ApplicantFields.name}, ${ApplicantFields.email}, ${ApplicantFields.address}, ${ApplicantFields.phoneNo}, ${ApplicantFields.techRating}, ${ApplicantFields.softRating}';

    final id = await db.rawInsert('INSERT INTO $applicantTable ($columns) VALUES (?, ?, ?, ?, ?, ?)',
        [json[ApplicantFields.name], json[ApplicantFields.email], json[ApplicantFields.address], json[ApplicantFields.phoneNo], json[ApplicantFields.techRating], json[ApplicantFields.softRating]]);
    return applicant.copy(id: id);
  }

  Future<Applicant?> getApplicant(String email) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $applicantTable WHERE ${ApplicantFields.email} = ?', [email]);

    if (result.isNotEmpty) {
      return Applicant.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List<Applicant>> getAllApplicants() async {
    final db = await instance.database;
    const orderBy = '${ApplicantFields.id} ASC';

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $applicantTable ORDER BY $orderBy');
    return result.map((json) => Applicant.fromJson(json)).toList();
  }

  Future<int> updateApplicant(String email, Applicant applicant) async {
    final db = await instance.database;

    return db.rawUpdate('UPDATE $applicantTable SET ${ApplicantFields.name} = ?, ${ApplicantFields.email} = ?, ${ApplicantFields.address} = ?, ${ApplicantFields.phoneNo} = ?, ${ApplicantFields.techRating} = ?, ${ApplicantFields.softRating} = ? WHERE ${ApplicantFields.email} = ?',
        [applicant.name, applicant.email, applicant.address, applicant.phoneNo, applicant.techRating, applicant.softRating, email]);
  }

  Future<int> deleteApplicant(String email) async {
    final db = await instance.database;

    return await db.rawDelete('DELETE FROM $applicantTable WHERE ${ApplicantFields.email} = ?', [email]);
  }

  // Company
  Future<Company> insertCompany(Company company) async {
    final db = await instance.database;
    final json = company.toJson();
    const columns = '${CompanyFields.name}, ${CompanyFields.email}, ${CompanyFields.location}, ${CompanyFields.phoneNo}, ${CompanyFields.techRating}, ${CompanyFields.softRating}';

    final id = await db.rawInsert('INSERT INTO $companyTable ($columns) VALUES (?, ?, ?, ?, ?, ?)',
        [json[CompanyFields.name], json[CompanyFields.email], json[CompanyFields.location], json[CompanyFields.phoneNo], json[CompanyFields.techRating], json[CompanyFields.softRating]]);
    return company.copy(id: id);
  }

  Future<Company?> getCompany(String email) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $companyTable WHERE ${CompanyFields.email} = ?', [email]);

    if (result.isNotEmpty) {
      return Company.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List<Company>> getAllCompanies() async {
    final db = await instance.database;
    const orderBy = '${CompanyFields.name} ASC';

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $companyTable ORDER BY $orderBy');
    return result.map((json) => Company.fromJson(json)).toList();
  }

  Future<int> updateCompany(String email, Company company) async {
    final db = await instance.database;

    return db.rawUpdate('UPDATE $companyTable SET ${CompanyFields.name} = ?, ${CompanyFields.email} = ?, ${CompanyFields.location} = ?, ${CompanyFields.phoneNo} = ? , ${CompanyFields.techRating} = ? , ${CompanyFields.softRating} = ? WHERE ${CompanyFields.email} = ?',
        [company.name, company.email, company.location, company.phoneNo, company.techRating, company.softRating, email]);
  }

  Future<int> deleteCompany(String email) async {
    final db = await instance.database;

    return await db.rawDelete('DELETE FROM $companyTable WHERE ${CompanyFields.email} = ?', [email]);
  }

  // Application
  Future<Application> insertApplication(Application application) async {
    final db = await instance.database;
    final json = application.toJson();
    const columns = '${ApplicationFields.applicantId}, ${ApplicationFields.jobId}, ${ApplicationFields.status}';

    final id = await db.rawInsert('INSERT INTO $applicationTable ($columns) VALUES (?, ?, ?)',
        [json[ApplicationFields.applicantId], json[ApplicationFields.jobId], json[ApplicationFields.status]]);
    return application.copy(id: id);
  }

  Future<Application?> getApplication(int id) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $applicationTable WHERE ${ApplicationFields.id} = ?', [id]);

    if (result.isNotEmpty) {
      return Application.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List<Application>> getAllApplications() async {
    final db = await instance.database;
    const orderBy = '${ApplicationFields.applicantId} ASC';

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $applicationTable ORDER BY $orderBy');
    return result.map((json) => Application.fromJson(json)).toList();
  }

  Future<int> updateApplication(int id, Application application) async {
    final db = await instance.database;

    return db.rawUpdate('UPDATE $applicationTable SET ${ApplicationFields.applicantId} = ?, ${ApplicationFields.jobId} = ?, ${ApplicationFields.status} = ? WHERE ${ApplicationFields.id} = ?',
        [application.applicantId, application.jobId, application.status, id]);
  }

  Future<int> deleteApplication(int id) async {
    final db = await instance.database;

    return await db.rawDelete('DELETE FROM $applicationTable WHERE ${ApplicationFields.id} = ?', [id]);
  }

  // Job
  Future<Job> insertJob(Job job) async {
    final db = await instance.database;
    final json = job.toJson();
    const columns = '${JobFields.title}, ${JobFields.companyId}, ${JobFields.description}, ${JobFields.requirements}, ${JobFields.pay}, ${JobFields.type}, ${JobFields.location}, ${JobFields.createdDate}, ${JobFields.lastDate}';

    final id = await db.rawInsert('INSERT INTO $jobTable ($columns) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [json[JobFields.title], json[JobFields.companyId], json[JobFields.description], json[JobFields.requirements], json[JobFields.pay], json[JobFields.type], json[JobFields.location], json[JobFields.createdDate], json[JobFields.lastDate]]);
    return job.copy(id: id);
  }

  Future<Job?> getJob(int id) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $jobTable WHERE ${JobFields.id} = ?', [id]);

    if (result.isNotEmpty) {
      return Job.fromJson(result.first);
    } else {
      return null;
    }
  }

  Future<List<Job>> getAllJobs() async {
    final db = await instance.database;
    const orderBy = '${JobFields.createdDate} DESC';

    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM $jobTable ORDER BY $orderBy');
    return result.map((json) => Job.fromJson(json)).toList();
  }

  Future<int> updateJob(int id, Job job) async {
    final db = await instance.database;

    return db.rawUpdate('UPDATE $jobTable SET ${JobFields.title} = ?, ${JobFields.companyId} = ?, ${JobFields.description} = ?, ${JobFields.requirements} = ?, ${JobFields.pay} = ?, ${JobFields.type} = ?, ${JobFields.location}, ${JobFields.createdDate} = ?, ${JobFields.lastDate} = ? WHERE ${JobFields.id} = ?',
        [job.title, job.companyId, job.description, job.requirements, job.pay, job.type, job.location, job.createdDate, job.lastDate, id]);
  }

  Future<int> deleteJob(int id) async {
    final db = await instance.database;

    return await db.rawDelete('DELETE FROM $jobTable WHERE ${JobFields.id} = ?', [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}