import 'package:edirecte/core/logic/objects/timeline_obj.dart';
import 'package:edirecte/core/logic/objects/grades_obj.dart';
import 'package:edirecte/core/logic/objects/homework_obj.dart';
import 'package:edirecte/core/logic/objects/schedule_obj.dart';
import 'package:edirecte/core/logic/objects/subject_obj.dart';

// This class stores data useful for different parts of the app //
class GlobalInfos {
  // Current period //
  static int currentPeriodIndex = 1;
  static String get currentPeriodCode => "A00$currentPeriodIndex";

  // Actual day //
  static DateTime actualDay_ = DateTime.now();
  static String get actualDayStr_ => GlobalInfos.actualDay_.toString().split(" ")[0];
  // static void updateActualDay() => GlobalInfos.actualDay = DateTime.now();
  // static DateTime actualDay = DateTime.now();
  // static String get actualDayStr => GlobalInfos.actualDay.toString().split(" ")[0];

  // List of all the timeline objects //
  static List<TimelineEvent> timelineEvents = [];
  static TimelineEvent addTimelineEvent(Map jsonInfos) {
    TimelineEvent event = TimelineEvent(jsonInfos);
    GlobalInfos.timelineEvents.add(event);
    return event;
  }

  // List of all the subjects //
  static Map<String, Subject> subjects = {};
  static Subject addSubject({required String subjectCode, required String subjectName, String professorName = ""}) {
    Subject subject = Subject(subjectCode, subjectName, professorName);
    GlobalInfos.subjects.addAll({subjectCode: subject});
    return subject;
  }

  // List of all the grades of the student //
  static List<Grade> grades = [];
  static Grade addGrade({required Map jsonInfos}) {
    Grade grade = Grade(jsonInfos);
    GlobalInfos.grades.add(grade);

    Subject gradeSubject;
    if (GlobalInfos.subjects.containsKey(grade.subjectCode)) { gradeSubject = GlobalInfos.subjects[grade.subjectCode]!; }
    else { gradeSubject = addSubject(subjectCode: grade.subjectCode, subjectName: grade.subjectName); }

    gradeSubject.addGrade(grade);

    return grade;
  }

  // General average of the student //
  static GeneralAverage generalAverage = GeneralAverage();

  // All homeworks of the student //
  static Map<String, HomeworkDay> homeworks = {};
  static HomeworkDay addHomeworkDay({required homeworkDayStr, required List jsonInfos}) {    
    HomeworkDay homeworkDay = HomeworkDay(DateTime.parse(homeworkDayStr), jsonInfos);
    homeworks.addAll({homeworkDayStr: homeworkDay});
    return homeworkDay;
  }

  // List of all the scheduled classes classified by day and hour //
  static Map<String, Map<String, List<ScheduledClass>>> scheduledClasses = {};
  static ScheduledClass addScheduledClass({required Map jsonInfos}) {
    Subject scheduledClassSubject;
    if (GlobalInfos.subjects.containsKey(jsonInfos["codeMatiere"])) { scheduledClassSubject = GlobalInfos.subjects[jsonInfos["codeMatiere"]]!; }
    else { scheduledClassSubject = GlobalInfos.addSubject(subjectCode: jsonInfos["codeMatiere"], subjectName: jsonInfos["matiere"], professorName: jsonInfos["prof"]); }

    ScheduledClass scheduledClass = ScheduledClass(scheduledClassSubject, jsonInfos["start_date"], jsonInfos["end_date"], jsonInfos["salle"], jsonInfos["text"]);
    
    if (!GlobalInfos.scheduledClasses.containsKey(scheduledClass.day)) {
      GlobalInfos.scheduledClasses.addAll({scheduledClass.day: {}});
    }
    if (!GlobalInfos.scheduledClasses[scheduledClass.day]!.containsKey(scheduledClass.beginHour)) {
      GlobalInfos.scheduledClasses[scheduledClass.day]!.addAll({scheduledClass.beginHour: []});
    }
    GlobalInfos.scheduledClasses[scheduledClass.day]![scheduledClass.beginHour]!.add(scheduledClass);
    return scheduledClass;
  }
  static void sortScheduledClasses() {
    for (String scheduledClassDay in GlobalInfos.scheduledClasses.keys) {
      var sortedByHour = Map.fromEntries(GlobalInfos.scheduledClasses[scheduledClassDay]!.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
      GlobalInfos.scheduledClasses[scheduledClassDay] = sortedByHour;
    }
  }
}

// This class stores all the needed student's informations //
class Infos {
  // Student ID, needed to parse data after login //
  static int studentID = 0;

  // Function to save all data received after login //
  static void saveLoginData(Map loginData) {
    Infos.studentID = loginData["id"];

    Infos.studentFirstName = loginData["prenom"];
    Infos.studentLastName = loginData["nom"];

    Infos.studentClass = loginData["profile"]["classe"]["libelle"];
    Infos.studentGender = loginData["profile"]["sexe"];
    
    Infos.studentPhoneNumber = loginData["profile"]["telPortable"];
    Infos.studentEmail = loginData["modules"][5]["params"]["mailPerso"];
  }

  // All used data in the app //
  static String studentGender = "";
  static String studentClass = "";

  static String studentFirstName = "";
  static String studentLastName = "";
  static String get studentFullName => "$studentFirstName $studentLastName";

  static String studentPhoneNumber = "";
  static String studentEmail = "";
}

// This class stores all the data that should be saved locally //
class StoredInfos {
  // Connection information //
  static String loginUsername = "";
  static String loginPassword = "";

  // If the user is logged-in or not //
  static bool isUserLoggedIn = false;

  // If the experimental features are on //
  static bool guessGradeCoefficient = true;

  // All the known subject coefficients //
  static bool subjectCoefficient = true;
  static const Map<String, double> subjectCoefficients = {
    "FRANC": 3.0,
    "HI-GE": 3.0,
    "AGL1": 3.0,
    "ESP2": 2.0,
    "SES": 2.0,
    "MATHS": 3.0,
    "PH-CH": 2.0,
    "SVT": 2.0,
    "SNTEC": 1.0,
    "EPS": 2.0
  };

  // Get the saved file infos //
  static Map get savedInfos => {
    "isUserLoggedIn": StoredInfos.isUserLoggedIn,
    "username": StoredInfos.loginUsername,
    "password": StoredInfos.loginPassword,
    "subject_coefficient": StoredInfos.subjectCoefficient,
    "guess_grade_coefficient": StoredInfos.guessGradeCoefficient,
  };
}






