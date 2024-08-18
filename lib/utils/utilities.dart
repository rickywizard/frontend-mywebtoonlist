class Utilities {
  String imageUrl(String path) {
    return 'http://localhost:3000/$path'.replaceAll('\\', '/');
  }

  String formatViews(int views) {
    if (views >= 1000000000) {
      return '${(views / 1000000000).toStringAsFixed(1)}B';
    } else if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }

  bool isAlphaNumeric(String char) {
    return (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) || // 0-9
        (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) || // A-Z
        (char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122); // a-z
  }
}
