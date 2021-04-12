class WarningSign{

  static const COLLECTION = 'warningSigns';

  static const CREATED_BY = 'createdBy';
  static const DESCRIPTION = 'description';
  static const RANK = 'rank';

  String docId;

  String createdBy;

  String description;
  int rank;

  WarningSign({
    this.docId,
    this.createdBy,
    this.description,
    this.rank,
  }){}

  Map<String, dynamic> serialize(){
    return <String, dynamic>{
      CREATED_BY: createdBy,
      DESCRIPTION: description,
      RANK: rank,
    };
  }

  static WarningSign deserialize(Map<String, dynamic> data, String docId){
    return WarningSign(
      docId: docId,
      createdBy: data[WarningSign.CREATED_BY],
      description: data[WarningSign.DESCRIPTION],
      rank: data[WarningSign.RANK],
    );
  }

}