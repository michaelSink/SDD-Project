class Contacts{
  static const COLLECTION = 'contacts';

  static const FIRSTNAME = "firstName";
  static const LASTNAME = "lastName";
  static const PHONENUM = "phoneNum";
  static const RELATION = "relation";
  static const OWNER = "owner";

  String docID;
  String firstName;
  String lastName;
  String phoneNum;
  String relation;
  String owner;

  Contacts({
    this.firstName,
    this.lastName,
    this.phoneNum,
    this.docID,
    this.relation,
    this.owner,
  }){}

  Map<String, dynamic> serialize(){
    return {
      FIRSTNAME: firstName,
      LASTNAME: lastName,
      PHONENUM: phoneNum,
      RELATION: relation,
      OWNER: owner,
    };
  }
  
  static Contacts deserialize(Map<String, dynamic> data, String docID){
    return Contacts(
      docID: docID,
      firstName: data[FIRSTNAME],
      lastName: data[LASTNAME],
      phoneNum: data[PHONENUM],
      relation: data[RELATION],
      owner: data[OWNER],
    );

  }
  

}