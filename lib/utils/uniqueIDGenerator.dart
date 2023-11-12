int _nextId = 1;

int generateUniqueId() {
  DateTime now = DateTime.now();
  int uniqueId = now.microsecondsSinceEpoch;
  return uniqueId;
}
