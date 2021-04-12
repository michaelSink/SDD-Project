class MentalHealth {
  static const COLLECTION = 'mentalHealth';

  static const ACUTE = 'acute';
  static const DESCRIPTION = 'description';
  static const CREATED_BY = 'createdBy';

  String docId;

  bool acute;
  String description;
  String createdBy;

  MentalHealth({
    this.docId,
    this.createdBy,
    this.acute,
    this.description,
  }) {
    this.description ??= "";
  }

  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      CREATED_BY: createdBy,
      ACUTE: acute,
      DESCRIPTION: description,
    };
  }

  static MentalHealth deserialize(Map<String, dynamic> data, String docId) {
    return MentalHealth(
      docId: docId,
      createdBy: data[MentalHealth.CREATED_BY],
      acute: data[MentalHealth.ACUTE],
      description: data[MentalHealth.DESCRIPTION],
    );
  }
}
