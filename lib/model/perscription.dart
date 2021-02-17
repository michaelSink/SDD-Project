class Perscription{

  static const COLLECTION = 'perscriptions';
  
  //Document Id
  String docId;

  //Pharmacy info
  static const PHARMACY_NAME = 'pharmacyName';
  static const PHARMACY_ADDRESS = 'pharmacyAddress';
  static const PERSCRIPTION_NUMBER = 'perscriptionNumber';

  String pharmacyName;
  String pharmacyAddress;
  String perscriptionNumber;

  //Drug info
  static const DRUG_NAME = 'drugName';
  static const DRUG_STRENGTH = 'drugStrength';
  static const DRUG_INSTRUCTIONS = 'drugInstructions';
  static const DRUG_DESCRIPTIONS = 'drugDescriptions';

  String drugName;
  String drugStrength;
  String drugInstructions;
  String drugDescriptions;

  //Perscription info
  static const PILL_COUNT = 'pillCount';
  static const REORDER_DATE = 'reorderDate';
  static const REFILL_AMOUNT = 'refillAmount';
  static const PERSCRIBER = 'perscriber';
  static const FILLED_DATE = 'filledDate';
  static const EXPIRATION = 'expiration';
  static const PERSCRIBED_ON = 'perscribedOn';

  int pillCount;
  DateTime reorderDate;
  int refillAmount;
  String perscriber;
  DateTime filledDate;
  DateTime expiration;
  DateTime perscribedOn;

  Perscription({
    this.docId,
    this.pharmacyName,
    this.pharmacyAddress,
    this.perscriptionNumber,
    this.drugName,
    this.drugStrength,
    this.drugInstructions,
    this.drugDescriptions,
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
      PHARMACY_NAME: pharmacyName,
      PHARMACY_ADDRESS: pharmacyAddress,
      PERSCRIPTION_NUMBER: perscriptionNumber,
      DRUG_NAME: drugName,
      DRUG_STRENGTH: drugStrength,
      DRUG_INSTRUCTIONS: drugInstructions,
      DRUG_DESCRIPTIONS: drugDescriptions,
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
      pharmacyName: data[PHARMACY_NAME],
      pharmacyAddress: data[PHARMACY_ADDRESS],
      perscriptionNumber: data[PERSCRIPTION_NUMBER],
      drugName: data[DRUG_NAME],
      drugStrength: data[DRUG_STRENGTH],
      drugInstructions: data[DRUG_INSTRUCTIONS],
      drugDescriptions: data[DRUG_DESCRIPTIONS],
      pillCount: data[PILL_COUNT],
      reorderDate: data[REORDER_DATE],
      refillAmount: data[REFILL_AMOUNT],
      perscriber: data[PERSCRIBER],
      filledDate: data[FILLED_DATE],
      expiration: data[EXPIRATION],
      perscribedOn: data[PERSCRIBED_ON],

    );

  }

}