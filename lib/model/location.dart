class Location{

  static const COLLECTION = 'locations';

  static const NAME = "name";
  static const DESCRIPTION = 'description';
  static const CREATED_BY = 'createdBy';
  static const LOCATION = 'location';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_PATH = 'photoPath';
  static const IMAGE_FOLDER = 'locationImages';

  String docId;
  String name;
  String createdBy;
  String description;
  String location;
  String photoURL;
  String photoPath;

  Location({
    this.docId,
    this.name,
    this.createdBy,
    this.description,
    this.location,
    this.photoPath,
    this.photoURL,
  }){}

  Map<String, dynamic> serialize(){
    return <String, dynamic>{
      NAME: name,
      CREATED_BY: createdBy,
      DESCRIPTION: description,
      LOCATION: location,
      PHOTO_URL: photoURL,
      PHOTO_PATH: photoPath,
    };
  }

  static Location deserialize(Map<String, dynamic> data, String docId){

    return Location(
      docId: docId,
      createdBy: data[Location.CREATED_BY],
      name: data[Location.NAME],
      description: data[Location.DESCRIPTION],
      location: data[Location.LOCATION],
      photoPath: data[Location.PHOTO_PATH],
      photoURL: data[Location.PHOTO_URL],
    );

  }

}