extension StringExtension on String {

  String limit(int limit) => this.length > limit ? this.substring(0, limit) + '...' : this;

  String toHHMMSS() {
    var secNum = int.parse(this);
    var hours = (secNum / 3600).floor();
    var minutes = ((secNum - (hours * 3600)) / 60).floor();
    var seconds = secNum - (hours * 3600) - (minutes * 60);

    return "${hours.toString().padLeft(2, '0')}h " +
    "${minutes.toString().padLeft(2, '0')}m " +
    "${seconds.toString().padLeft(2, '0')}s";
  }

  String toHHMM() {
    var secNum = int.parse(this);
    var hours = (secNum / 3600).floor();
    var minutes = ((secNum - (hours * 3600)) / 60).floor();

    return "${hours.toString().padLeft(2, '0')}h " +
    "${minutes.toString().padLeft(2, '0')}m";
  }

  String toHH_MM() {
    var secNum = int.parse(this);
    var hours = (secNum / 3600).floor();
    var minutes = ((secNum - (hours * 3600)) / 60).floor();

    return "${hours.toString().padLeft(2, '0')}:" +
    "${minutes.toString().padLeft(2, '0')}";
  }

  String toDDMM() {
      var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      var date = DateTime.now();
      return "${monthNames[date.month - 1]} ${date.day}";
  }
}