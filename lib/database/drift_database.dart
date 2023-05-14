// private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:calendar_scheduler/model/category_color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// drift로 database를 연결할 코드를 작성하기 위해서 drift_database.dart파일을 생성했습니다.

// private 값까지 전부 불러올 수 있다.
// g: generate
// 연결할 데이터베이스를 생성을 할 때,
// part 선언을 해주어야 합니다.
// part '현재 파일의 이름.g.dart';라고 선언합니다.
// flutter pub run build_runner build
part 'drift_database.g.dart';

// decorator
@DriftDatabase(
  tables: [
    Schedules,
    CategoryColors,
  ],
)
// _$LocalDatabase : Drift가 만들어주는 클래스이며, drift_database.g.dart파일에 생성이 됩니다.
// _ (under score) : private을 의미합니다.
// _$LocalDatabase가 private임에도 불구하고 불러올 수 있는 이유는 import가 아니고 part로 불러왔기 때문입니다.
// class 클래스명 extends _$클래스명 { }
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // schemaVersion은 1부터 시작합니다.
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // 실제 데이터베이스 파일을 어떤 위치에 생성을 시킬 것인지 우리가 설정을 해주어야 합니다.
  // SQL은 보조기억장치에 저장을 하는데 연결을 해줍니다.
  // 보조기억장치(HDD)의 어떤 위치에 저장을 할지를 명시해주어야합니다.
  return LazyDatabase(() async {
    // 해당 앱 전용 폴더
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
