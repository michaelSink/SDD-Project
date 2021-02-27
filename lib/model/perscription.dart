class Perscription{

  static const COLLECTION = 'perscriptions';
  
  //Document Id
  String docId;

  //Who created it
  static const CREATED_BY = 'createdBy';
  String createdBy;

  //Pharmacy info
  static const PHARMACY_NAME = 'pharmacyName';
  static const PHARMACY_ADDRESS = 'pharmacyAddress';
  static const PHARMACY_NUMBER = 'pharmacyNumber';
  static const PERSCRIPTION_NUMBER = 'perscriptionNumber';

  String pharmacyName;
  String pharmacyAddress;
  String pharmacyNumber;
  String perscriptionNumber;

  //Drug info
  static const DRUG_NAME = 'drugName';
  static const DRUG_STRENGTH = 'drugStrength';
  static const DRUG_INSTRUCTIONS = 'drugInstructions';
  static const DRUG_DESCRIPTION = 'drugDescription';

  String drugName;
  String drugStrength;
  String drugInstructions;
  String drugDescription;

  //Perscription info
  static const PILL_COUNT = 'pillCount';
  static const REORDER_DATE = 'reorderDate';
  static const REFILL_AMOUNT = 'refillAmount';
  static const PERSCRIBER = 'perscriber';
  static const FILLED_DATE = 'filledDate';
  static const EXPIRATION = 'expiration';
  static const PERSCRIBED_ON = 'perscribedOn';

  int pillCount;
  int refillAmount;
  String perscriber;
  DateTime reorderDate;
  DateTime filledDate;
  DateTime expiration;
  DateTime perscribedOn;

  Perscription({
    this.docId,
    this.createdBy,
    this.pharmacyName,
    this.pharmacyAddress,
    this.pharmacyNumber,
    this.perscriptionNumber,
    this.drugName,
    this.drugStrength,
    this.drugInstructions,
    this.drugDescription,
    this.pillCount,
    this.reorderDate,
    this.refillAmount,
    this.perscriber,
    this.filledDate,
    this.expiration,
    this.perscribedOn,
  }){}

  Map<String, dynamic> serialize(){

    return <String, dynamic>{
      CREATED_BY: createdBy,
      PHARMACY_NAME: pharmacyName,
      PHARMACY_ADDRESS: pharmacyAddress,
      PHARMACY_NUMBER: pharmacyNumber,
      PERSCRIPTION_NUMBER: perscriptionNumber,
      DRUG_NAME: drugName,
      DRUG_STRENGTH: drugStrength,
      DRUG_INSTRUCTIONS: drugInstructions,
      DRUG_DESCRIPTION: drugDescription,
      PILL_COUNT: pillCount,
      REORDER_DATE: reorderDate,
      REFILL_AMOUNT: refillAmount,
      PERSCRIBER: perscriber,
      FILLED_DATE: filledDate,
      EXPIRATION: expiration,
      PERSCRIBED_ON: perscribedOn,
    };

  }

  static Perscription deserialize(Map<String, dynamic> data, String docId){

    return Perscription(

      docId:  docId,
      createdBy: data[Perscription.CREATED_BY],
      pharmacyName: data[Perscription.PHARMACY_NAME],
      pharmacyAddress: data[Perscription.PHARMACY_ADDRESS],
      pharmacyNumber: data[Perscription.PHARMACY_NUMBER],
      perscriptionNumber: data[Perscription.PERSCRIPTION_NUMBER],
      drugName: data[Perscription.DRUG_NAME],
      drugStrength: data[Perscription.DRUG_STRENGTH],
      drugInstructions: data[Perscription.DRUG_INSTRUCTIONS],
      drugDescription: data[Perscription.DRUG_DESCRIPTION],
      pillCount: data[Perscription.PILL_COUNT],
      reorderDate: data[Perscription.REORDER_DATE] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Perscription.REORDER_DATE].millisecondsSinceEpoch) : null,
      refillAmount: data[Perscription.REFILL_AMOUNT],
      perscriber: data[Perscription.PERSCRIBER],
      filledDate: data[Perscription.FILLED_DATE] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Perscription.FILLED_DATE].millisecondsSinceEpoch) : null,
      expiration: data[Perscription.EXPIRATION] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Perscription.EXPIRATION].millisecondsSinceEpoch) : null,
      perscribedOn: data[Perscription.PERSCRIBED_ON] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Perscription.PERSCRIBED_ON].millisecondsSinceEpoch) : null,

    );

  }

}