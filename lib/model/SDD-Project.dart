class PersonalCare {
  static const COLLECTION = 'personalCare';
  static const IMAGE_FOLDER = 'personalcarePictures';
  static const TITLE = 'title';
  static const CREATED_BY = 'createdBy';
  static const UPDATED_AT = 'updatedAt';

  String docId; // Firestore doc id
  String createdBy;
  String title;
  DateTime updatedAt; // created or revised time

  PersonalCare({
    this.docId,
    this.createdBy,
    this.title,
    this.updatedAt,
  });

// convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      TITLE: title,
      CREATED_BY: createdBy,
      UPDATED_AT: updatedAt,
    };
  }
   // convert Firestore doc to Dart object
  static PersonalCare deserialize(Map<String, dynamic> data, String docId) {
    return PersonalCare(
      docId: docId,
      createdBy: data[PersonalCare.CREATED_BY],
      title: data[PersonalCare.TITLE],
      updatedAt: data[PersonalCare.UPDATED_AT] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[PersonalCare.UPDATED_AT].millisecondsSinceEpoch)
          : null,
    );
  }

  @override
  String toString() {
    return '$docId $createdBy $title';
  }

}
