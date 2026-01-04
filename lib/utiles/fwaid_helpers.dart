String generateSummary(String text) {
  final lines = text.split('\n');
  for (final line in lines) {
    if (line.trim().length > 40) {
      return line.trim();
    }
  }

  return text.length > 120
      ? text.substring(0, 120) + '...'
      : text;
}

String autoCategory(String text) {
  if (text.contains('القلب') || text.contains('القلوب')) {
    return 'تزكية';
  }
  if (text.contains('العلم') || text.contains('يعلم')) {
    return 'علم';
  }
  if (text.contains('الصلاة') || text.contains('العبادة')) {
    return 'عبادة';
  }
  if (text.contains('الله') || text.contains('الرب')) {
    return 'إيمان';
  }
  return 'فوائد عامة';
}

dynamic getDailyFwaid(List data) {
  final day = DateTime.now().day;
  return data[day % data.length];
}
