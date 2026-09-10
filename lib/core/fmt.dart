String fmt(DateTime? d) {
  if (d == null) return 'Select date';
  return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}
