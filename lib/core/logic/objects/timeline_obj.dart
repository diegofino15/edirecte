class TimelineEvent {
  late DateTime date;
  late String type;
  late String title;
  late String content;

  TimelineEvent(Map jsonInformations) {
    date = DateTime.parse(jsonInformations["date"]);
    type = jsonInformations["typeElement"];
    title = jsonInformations["titre"];
    content = jsonInformations["contenu"];
  }
}