String rem0(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2).replaceAll(".", ",");
}

const List<String> daysNames = [
  "",
  "Lundi",
  "Mardi",
  "Mercredi",
  "Jeudi",
  "Vendredi",
  "Samedi",
  "Dimanche"
];
const List<String> monthsNames = [
  "",
  "Janvier",
  "Février",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juillet",
  "Aout",
  "Septembre",
  "Octobre",
  "Novembre",
  "Décembre"
];

String dayToBeautifulStr(DateTime date) {
  return "${daysNames[date.weekday]} ${date.day} ${monthsNames[date.month]}";
}

String formatDuration(Duration duration) {
  if (duration.inMinutes < 60) {
    return '${duration.inMinutes}m';
  }

  if (duration.inHours < 24) {
    final minutes = duration.inMinutes % 60;
    return '${duration.inHours}h ${minutes > 0 ? '${minutes}m' : ''}';
  }

  final days = duration.inDays;
  if (days < 7) {
    final hours = duration.inHours % 24;
    return '${days}d ${hours > 0 ? '${hours}h' : ''}';
  }

  final weeks = days ~/ 7;
  final remainingDays = days % 7;
  return '${weeks}w ${remainingDays > 0 ? '${remainingDays}d' : ''}';
}


