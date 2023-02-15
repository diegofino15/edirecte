import 'package:edirecte/core/logic/objects/grades_obj.dart';
import 'package:edirecte/core/utils/infos.dart';

class Subject {
  late String code;
  late String name;
  late String professorName;

  Subject(this.code, this.name, this.professorName);

  // Grade stuff //
  Map<String, List<Grade>> grades = {};
  Map<String, double> average = {};
  Map<String, double> averageClass = {};
  late double coefficient;

  void addGrade(Grade grade) {
    if (!grades.containsKey(grade.periodCode)) {
      grades.addAll({grade.periodCode: [grade]});
    } else {
      grades[grade.periodCode]!.add(grade);
    }
  }
  void calculateAverage() {
    for (String periodCode in grades.keys) {
      double sum = 0.0;
      double coef = 0.0;

      double sumClass = 0.0;
      double coefClass = 0.0;

      for (Grade grade in grades[periodCode]!) {
        if (grade.isEffective) {
          sum += grade.value * grade.coefficient;
          coef += grade.coefficient;

          sumClass += grade.classValue * grade.coefficient;
          coefClass += grade.coefficient;
        }
      }

      average[periodCode] = coef != 0.0 ? (sum / coef) : 0.0;
      average[periodCode] = (average[periodCode]! * 100.0).round() / 100.0;

      averageClass[periodCode] = coefClass != 0.0 ? (sumClass / coefClass) : 0.0;
      averageClass[periodCode] = (averageClass[periodCode]! * 100.0).round() / 100.0;
    }

    coefficient = calculateCoefficient(code);
  }
  double calculateCoefficient(String subjectCode) {
    if (!StoredInfos.subjectCoefficient) return 1.0;

    return StoredInfos.subjectCoefficients[subjectCode] ?? 1.0;
  }
}


