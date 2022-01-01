import 'package:intl/intl.dart';

class Retro {
  String id;
  String plus;
  String delta;
  String nextAction;
  DateTime createdAt;

  String getCreatedAt() {
    
    try {
      // 曜日を表示したいときは「'yyyy/MM/dd（E） HH:mm:ss'」
      var fomatter = DateFormat('yyyy/MM/dd HH:mm:ss', 'ja_JP');
      return fomatter.format(createdAt);
    } catch (e) {
      return '';
    }
  }

  Retro({
    required this.id,
    required this.plus,
    required this.delta,
    required this.nextAction,
    required this.createdAt,
  });
}