class Contacts{

  static const COLLECTION = 'contacts';

  static const FIRSTNAME = "firstName";
  static const LASTNAME = "lastName";
  static const PHONENUM = "phoneNum";

  String docID;
  String firstName;
  String lastName;
  String phoneNum;

  Contacts({
    this.firstName,
    this.lastName,
    this.phoneNum,
    this.docID,
  }){}

  Map<String, dynamic> serialize(){
    return {
      FIRSTNAME: firstName,
      LASTNAME: lastName,
      PHONENUM: phoneNum,
    };
  }
  
  static Contacts deserialize(Map<String, dynamic> data, String docID){
    return Contacts(
      docID: docID,
      firstName: data[FIRSTNAME],
      lastName: data[LASTNAME],
      phoneNum: data[PHONENUM],
    );

  }
  

}