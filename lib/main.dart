import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // 빨강색
  'F44336',
  // 주황색
  'FF9800',
  // 노랑색
  'FFEB3B',
  // 초록색
  'FCAF50',
  // 파랑색
  '2196F3',
  // 남색
  '3F51B5',
  // 보라색
  '9C27B0',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final localDatabase = LocalDatabase();

  final colors = await localDatabase.getCategoryColors();

  if (colors.isEmpty) {
    print('실행!');
    for (String hexCode in DEFAULT_COLORS) {
      await localDatabase.createCategoryColor(
        CategoryColorsCompanion(
          hexCode: Value(hexCode),
        )
      );
    }
  }

  print('----------- GET COLORS -----------');
  print(await localDatabase.getCategoryColors());

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    ),
  );
}
