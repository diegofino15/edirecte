import 'package:edirecte/core/logic/objects/subject_obj.dart';
import 'package:edirecte/core/utils/infos.dart';

double? getVal(String str) => double.tryParse(str.replaceAll(",", "."));

class Grade {
  String title = "";
  
  double value = 0.0;
  double classValue = 0.0;

  late double valueOn;
  late double? initialValue;

  late String initialValueStr;
  late String initialValueOnStr;
  
  late double coefficient;
  bool isEffective = true;

  late String subjectCode;
  late String subjectName;

  late DateTime date;
  late DateTime dateEntered;
  late String periodCode;

  Grade(Map jsonInformations) {
    title = jsonInformations["devoir"];

    initialValueStr = jsonInformations["valeur"];
    initialValueOnStr = jsonInformations["noteSur"];

    initialValue = getVal(jsonInformations["valeur"]);
    valueOn = getVal(jsonInformations["noteSur"])!;

    coefficient = calculateCoefficient(title);

    // Try to calculate the real value //
    if (jsonInformations["nonSignificatif"] || initialValue == null) {
      isEffective = false;
    } else {
      value = initialValue! / valueOn * 20.0;
      // Round to value to 2 decimals //
      value = (value * 100.0).round() / 100.0;
    }

    classValue = (getVal(jsonInformations["moyenneClasse"]) ?? 0.0) / valueOn * 20.0;
    classValue = (classValue * 100.0).round() / 100.0;

    subjectCode = jsonInformations["codeMatiere"];
    subjectName = jsonInformations["libelleMatiere"];

    date = DateTime.parse(jsonInformations["date"]);
    dateEntered = DateTime.parse(jsonInformations["dateSaisie"]);
    periodCode = jsonInformations["codePeriode"];
  }

  double calculateCoefficient(String gradeTitle) {
    // Return 1 if the experimental features are off
    if (!StoredInfos.guessGradeCoefficient) return 1.0;

    // Else guess the coefficient //
    if (gradeTitle.toLowerCase().contains("dst") || gradeTitle.toLowerCase().contains("ds")) return 2;
    if (gradeTitle.toLowerCase().contains("dm")) return 0.5;
    return 1.0;
  }

  String get showableStr => valueOn == 20 ? initialValueStr : "$initialValueStr/$initialValueOnStr";
}

class GeneralAverage {
  Map<String, double> average = {};
  Map<String, double> averageClass = {};

  void calculateAverage(Map<String, Subject> subjects) {
    Map<String, Map<String, double>> sums = {};
    Map<String, double> sumsClass = {};
    
    for (String subjectCode in subjects.keys) {
      Subject subject = subjects[subjectCode]!;

      for (String periodCode in subject.average.keys) {
        if (!sums.containsKey(periodCode)) {
          sums.addAll({periodCode: {"sum": 0.0, "coef": 0.0}});
          sumsClass.addAll({periodCode: 0.0});
        }

        sums[periodCode]!["sum"] = sums[periodCode]!["sum"]! + subject.average[periodCode]! * subject.coefficient;
        sums[periodCode]!["coef"] = sums[periodCode]!["coef"]! + subject.coefficient;

        sumsClass[periodCode] = sumsClass[periodCode]! + subject.averageClass[periodCode]! * subject.coefficient;
      }
    }

    for (String periodCode in sums.keys) {
      average[periodCode] = sums[periodCode]!["coef"]! != 0.0 ? (sums[periodCode]!["sum"]! / sums[periodCode]!["coef"]!) : 0.0;
      average[periodCode] = (average[periodCode]! * 100.0).round() / 100.0;

      averageClass[periodCode] = sums[periodCode]!["coef"]! != 0.0 ? (sumsClass[periodCode]! / sums[periodCode]!["coef"]!) : 0.0;
      averageClass[periodCode] = (averageClass[periodCode]! * 100.0).round() / 100.0;
    }
  }
}


