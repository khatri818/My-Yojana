class AppUtils {
  static String getInitials(String name) {
    if (name.isEmpty) {
      return "";
    }

    List<String> nameParts = name.split(" ");
    String initials = "";
    if (nameParts.length > 1) {
      initials = "${nameParts[0][0]}.${nameParts[1][0]}";
    } else if (nameParts.isNotEmpty) {
      initials = nameParts[0][0];
    }
    return initials.toUpperCase();
  }
}
