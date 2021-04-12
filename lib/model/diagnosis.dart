class Diagnosis {
  static const COLLECTION = 'diagnoses';

  static const DIAGNOSED_FOR = 'diagnosedFor';
  static const DIAGNOSED_ON = 'diagnosedOn';
  static const DIAGNOSED_BY = 'diagnosedBy';
  static const DIAGNOSED_AT = 'diagnosedAt';
  static const TREATMENTS = 'treatments';
  static const COPINGSTRATEGIES = 'copingStrategies';
  static const ADDITIONAL_COMMENTS = 'additionalComments';
  static const CREATED_BY = 'createdBy';

  String docId;

  String diagnosedFor;
  DateTime diagnosedOn;
  String diagnosedBy;
  String diagnosedAt;
  List<dynamic> treatments;
  List<dynamic> copingStrategies;
  String additionalComments;
  String createdBy;

  Diagnosis({
    this.docId,
    this.createdBy,
    this.diagnosedFor,
    this.diagnosedOn,
    this.diagnosedBy,
    this.diagnosedAt,
    this.treatments,
    this.copingStrategies,
    this.additionalComments,
  }) {
    this.treatments ??= [];
    this.copingStrategies ??= [];
    this.additionalComments ??= "";
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CREATED_BY: createdBy,
      DIAGNOSED_FOR: diagnosedFor,
      DIAGNOSED_AT: diagnosedAt,
      DIAGNOSED_ON: diagnosedOn,
      DIAGNOSED_BY: diagnosedBy,
      TREATMENTS: treatments,
      COPINGSTRATEGIES: copingStrategies,
      ADDITIONAL_COMMENTS: additionalComments,
    };
  }

  static Diagnosis deserialize(Map<String, dynamic> data, String docId) {
    return Diagnosis(
      docId: docId,
      createdBy: data[Diagnosis.CREATED_BY],
      diagnosedFor: data[Diagnosis.DIAGNOSED_FOR],
      diagnosedBy: data[Diagnosis.DIAGNOSED_BY],
      diagnosedAt: data[Diagnosis.DIAGNOSED_AT],
      diagnosedOn: data[Diagnosis.DIAGNOSED_ON] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              data[Diagnosis.DIAGNOSED_ON].millisecondsSinceEpoch)
          : null,
      treatments: data[Diagnosis.TREATMENTS],
      copingStrategies: data[Diagnosis.COPINGSTRATEGIES],
      additionalComments: data[Diagnosis.ADDITIONAL_COMMENTS],
    );
  }
}
