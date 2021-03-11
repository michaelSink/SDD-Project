class Journal {
  static const COLLECTION = 'journals';

  static const TITLE = "title";
  static const DATE = "date";
  static const ENTRY = "entry";
  static const OWNER = "owner";

  String docID;
  String title;
  String date;
  String entry;
  String owner;

  Journal({this.docID, this.title, this.date, this.entry, this.owner}) {}

  Map<String, dynamic> serialize() {
    return {TITLE: title, DATE: date, ENTRY: entry, OWNER: owner};
  }

  static Journal deserialize(Map<String, dynamic> data, String docID) {
    return Journal(
      docID: docID,
      title: data[TITLE],
      date: data[DATE],
      entry: data[ENTRY],
      owner: data[OWNER],
    );
  }
}
