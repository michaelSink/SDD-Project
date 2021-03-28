class PersonalCare {
  static const COLLECTION = 'questionForm';
  static const IMAGE_FOLDER = 'personalPictures';
  static const NAME = 'name';
  static const AGE = 'age';
  static const RACE = 'race';
  static const SEX = 'sex';
  static const RELIGIOUS_AFFILIATION = 'religiousAffiliation';
  static const SEXUAL_ORIENTATION = 'sexualOrientation';
  static const MILITARY_HISTORY = 'militaryHistory';
  static const CREATED_BY = 'createdBy';
  static const UPDATED_AT = 'updatedAt';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';

  String docId; // Firestore doc id
  String createdBy;
  String name;
  String  age;
  String race;
  String sex;
  String religiousAffiliation;
  String sexualOrientation;
  String militaryHistory;
  DateTime updatedAt; // created or revised time
   String photoPath; // Firebase Storage; image file name
  String photoURL; // Firebase Storage; image URL for internet access

  PersonalCare({
    this.docId,
    this.createdBy,
    this.name,
    this.age,
    this.race,
    this.sex,
    this.religiousAffiliation,
    this.sexualOrientation,
    this.militaryHistory,
    this.photoPath,
    this.photoURL,
    this.updatedAt,
  });

// convert Dart object to Firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      NAME:name,
      AGE:age,
      RACE:race,
      SEX:sex,
      RELIGIOUS_AFFILIATION:religiousAffiliation,
      SEXUAL_ORIENTATION:sexualOrientation,
      MILITARY_HISTORY:militaryHistory,
      PHOTO_PATH: photoPath,
      PHOTO_URL: photoURL,
      UPDATED_AT: updatedAt,
      CREATED_BY: createdBy,
    };
  }
   // convert Firestore doc to Dart object
  static PersonalCare deserialize(Map<String, dynamic> data, String docId) {
    return PersonalCare(
      docId: docId,
      name: data[PersonalCare.NAME],
      age: data[PersonalCare.AGE],
      race: data[PersonalCare.RACE],
      sex: data[PersonalCare.SEX],
      religiousAffiliation: data[PersonalCare.RELIGIOUS_AFFILIATION],
      sexualOrientation: data[PersonalCare.SEXUAL_ORIENTATION],
      militaryHistory: data[PersonalCare.MILITARY_HISTORY],
      photoPath: data[PersonalCare.PHOTO_PATH],
      photoURL: data[PersonalCare.PHOTO_URL],
      createdBy: data[PersonalCare.CREATED_BY],
      updatedAt: data[PersonalCare.UPDATED_AT] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[PersonalCare.UPDATED_AT].millisecondsSinceEpoch)
          : null,
    );
  }

  @override
  String toString() {
    return '$docId $createdBy $name $age $race $sex $religiousAffiliation $sexualOrientation $militaryHistory \n $photoURL';
  }

}
