class MedicalHistory{
  
  static const COLLECTION = 'medicalHistory'; 
  static const CREATED_BY = 'createdBy';
  static const DIAGNOSIS = 'diagnosis';
  static const HEREDITARY = 'hereditary';
  static const MATERNAL = 'maternal';
  static const PATERNAL = 'paternal';
  static const MEMBERS_DIAGNOSED = 'membersDiagnosed';

  String docId;
  String createdBy;
  String diagnosis;
  bool hereditary;
  bool paternal;
  bool maternal;
  List<dynamic> membersDiagnosed;

  MedicalHistory({
    this.docId,
    this.createdBy,
    this.diagnosis,
    this.hereditary,
    this.paternal,
    this.maternal,
    this.membersDiagnosed,
  }){
    this.membersDiagnosed ??= [];
    this.paternal ??= false;
    this.maternal ??= false;
    this.hereditary ??= false;
  }

  Map<String, dynamic> serialize(){
    return <String, dynamic>{
      CREATED_BY: createdBy,
      DIAGNOSIS: diagnosis,
      HEREDITARY: hereditary,
      MATERNAL: maternal,
      PATERNAL: paternal,
      MEMBERS_DIAGNOSED: membersDiagnosed,
    };
  }

  static MedicalHistory deserialize(Map<String, dynamic> data, String docId){
    return MedicalHistory(
      docId: docId,
      createdBy: data[MedicalHistory.CREATED_BY],
      diagnosis: data[MedicalHistory.DIAGNOSIS],
      hereditary: data[MedicalHistory.HEREDITARY],
      maternal: data[MedicalHistory.MATERNAL],
      paternal: data[MedicalHistory.PATERNAL],
      membersDiagnosed: data[MedicalHistory.MEMBERS_DIAGNOSED],
    );
  }

}