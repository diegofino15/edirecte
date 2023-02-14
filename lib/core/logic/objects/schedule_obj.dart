import 'package:edirecte/core/logic/objects/subject_obj.dart';

class ScheduledClass {
  late Subject subject;

  late DateTime beginDate;
  late DateTime endDate;
  late Duration duration;

  late String classroomFullStr;
  String get classroom => classroomFullStr.split(" ")[0];

  String get day => beginDate.toString().split(" ")[0];
  String get beginHour => "${beginDate.toString().split(" ")[1].split(":")[0]}:${beginDate.toString().split(" ")[1].split(":")[1]}";
  String get endHour => "${endDate.toString().split(" ")[1].split(":")[0]}:${endDate.toString().split(" ")[1].split(":")[1]}";

  ScheduledClass(this.subject, String beginDateStr, String endDateStr, this.classroomFullStr) {
    beginDate = DateTime.parse(beginDateStr);
    endDate = DateTime.parse(endDateStr);
    duration = endDate.difference(beginDate);
  }
}


