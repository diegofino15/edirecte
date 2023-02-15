import 'dart:convert';

import 'package:html/parser.dart' as html;

import 'package:edirecte/core/logic/objects/subject_obj.dart';
import 'package:edirecte/core/utils/network_utils.dart';
import 'package:edirecte/core/utils/infos.dart';


class HomeworkDay {
  late DateTime day;
  Map<int, Homework> homeworks = {};

  bool gotContent = false;
  bool isGettingContent = false;

  HomeworkDay(this.day, List jsonInfos) {
    for (Map homework in jsonInfos) {
      Subject homeworkSubject;
      if (GlobalInfos.subjects.containsKey(homework["codeMatiere"])) { homeworkSubject = GlobalInfos.subjects[homework["codeMatiere"]]!; }
      else { homeworkSubject = GlobalInfos.addSubject(subjectCode: homework["codeMatiere"], subjectName: homework["matiere"]); }
      
      Homework homeworkObj = Homework(day, homeworkSubject, homework);
      homeworks.addAll({homework["idDevoir"]: homeworkObj});
    }

    getContent();
  }

  Future<void> getContent() async {
    isGettingContent = true;

    dynamic response = await EcoleDirecteResponse.parse(
      EcoleDirectePath.specificHomeworkURL(day.toString().split(" ")[0]),
      {},
    );
    
    if (response != null) {
      for (Map homework in response["matieres"]) {
        Homework? homeworkObj = homeworks[homework["id"]];
        if (homeworkObj == null) continue;
        
        homeworkObj.setContent(homework["aFaire"]["contenu"]);
        if (homeworkObj.subject.professorName.isEmpty) homeworkObj.subject.professorName = homework["nomProf"].replaceAll(" Par ", "");
      }
    }

    isGettingContent = false;
  }
}


class Homework {
  late int id;

  bool isDone = false;
  bool isSettingDone = false;

  late Subject subject;
  late DateTime day;

  late bool isExam;
  String? content;

  Homework(this.day, this.subject, Map jsonInfos) {
    id = jsonInfos["idDevoir"];
    isDone = jsonInfos["effectue"];
    isExam = jsonInfos["interrogation"];
  }

  void setContent(String encodedData) {
    String htmlEncodedData = utf8.decode(base64.decode(encodedData));
    content = html.parse(htmlEncodedData).body!.text;
  }

  Future<void> setDone(bool done) async {
    isSettingDone = true;
    isDone = done;

    Map<String, dynamic> data = {
      "idDevoirsEffectues": [isDone ? id : null],
      "idDevoirsNonEffectues": [isDone ? null : id]
    };

    await EcoleDirecteResponse.parse(
      EcoleDirectePath.changeHomeworkStateURL,
      data
    );

    isSettingDone = false;
  }
}