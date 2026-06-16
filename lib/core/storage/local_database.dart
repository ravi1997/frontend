import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'local_database.g.dart';

class CachedForms extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get rawJson => text()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedResponses extends Table {
  TextColumn get id => text()();
  TextColumn get formId => text()();
  TextColumn get dataJson => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class PendingUploads extends Table {
  TextColumn get id => text()();
  TextColumn get formId => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [CachedForms, CachedResponses, PendingUploads])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'fbp_local_db');
}
