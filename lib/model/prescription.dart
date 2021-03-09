class Prescription{

  static const COLLECTION = 'prescriptions';
  
  //Document Id
  String docId;

  //Who created it
  static const CREATED_BY = 'createdBy';
  String createdBy;

  //Pharmacy info
  static const PHARMACY_NAME = 'pharmacyName';
  static const PHARMACY_ADDRESS = 'pharmacyAddress';
  static const PHARMACY_NUMBER = 'pharmacyNumber';
  static const PRESCRIPTION_NUMBER = 'prescriptionNumber';

  String pharmacyName;
  String pharmacyAddress;
  String pharmacyNumber;
  String prescriptionNumber;

  //Drug info
  static const DRUG_NAME = 'drugName';
  static const DRUG_STRENGTH = 'drugStrength';
  static const DRUG_INSTRUCTIONS = 'drugInstructions';
  static const DRUG_DESCRIPTION = 'drugDescription';

  String drugName;
  String drugStrength;
  String drugInstructions;
  String drugDescription;

  //Prescription info
  static const PILL_COUNT = 'pillCount';
  static const REORDER_DATE = 'reorderDate';
  static const REFILL_AMOUNT = 'refillAmount';
  static const PRESCRIBER = 'prescriber';
  static const FILLED_DATE = 'filledDate';
  static const EXPIRATION = 'expiration';
  static const PRESCRIBED_ON = 'prescribedOn';

  int pillCount;
  int refillAmount;
  String prescriber;
  DateTime reorderDate;
  DateTime filledDate;
  DateTime expiration;
  DateTime prescribedOn;

  Prescription({
    this.docId,
    this.createdBy,
    this.pharmacyName,
    this.pharmacyAddress,
    this.pharmacyNumber,
    this.prescriptionNumber,
    this.drugName,
    this.drugStrength,
    this.drugInstructions,
    this.drugDescription,
    this.pillCount,
    this.reorderDate,
    this.refillAmount,
    this.prescriber,
    this.filledDate,
    this.expiration,
    this.prescribedOn,
  }){}

  Map<String, dynamic> serialize(){

    return <String, dynamic>{
      CREATED_BY: createdBy,
      PHARMACY_NAME: pharmacyName,
      PHARMACY_ADDRESS: pharmacyAddress,
      PHARMACY_NUMBER: pharmacyNumber,
      PRESCRIPTION_NUMBER: prescriptionNumber,
      DRUG_NAME: drugName,
      DRUG_STRENGTH: drugStrength,
      DRUG_INSTRUCTIONS: drugInstructions,
      DRUG_DESCRIPTION: drugDescription,
      PILL_COUNT: pillCount,
      REORDER_DATE: reorderDate,
      REFILL_AMOUNT: refillAmount,
      PRESCRIBER: prescriber,
      FILLED_DATE: filledDate,
      EXPIRATION: expiration,
      PRESCRIBED_ON: prescribedOn,
    };

  }

  static Prescription deserialize(Map<String, dynamic> data, String docId){

    return Prescription(

      docId:  docId,
      createdBy: data[Prescription.CREATED_BY],
      pharmacyName: data[Prescription.PHARMACY_NAME],
      pharmacyAddress: data[Prescription.PHARMACY_ADDRESS],
      pharmacyNumber: data[Prescription.PHARMACY_NUMBER],
      prescriptionNumber: data[Prescription.PRESCRIPTION_NUMBER],
      drugName: data[Prescription.DRUG_NAME],
      drugStrength: data[Prescription.DRUG_STRENGTH],
      drugInstructions: data[Prescription.DRUG_INSTRUCTIONS],
      drugDescription: data[Prescription.DRUG_DESCRIPTION],
      pillCount: data[Prescription.PILL_COUNT],
      reorderDate: data[Prescription.REORDER_DATE] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Prescription.REORDER_DATE].millisecondsSinceEpoch) : null,
      refillAmount: data[Prescription.REFILL_AMOUNT],
      prescriber: data[Prescription.PRESCRIBER],
      filledDate: data[Prescription.FILLED_DATE] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Prescription.FILLED_DATE].millisecondsSinceEpoch) : null,
      expiration: data[Prescription.EXPIRATION] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Prescription.EXPIRATION].millisecondsSinceEpoch) : null,
      prescribedOn: data[Prescription.PRESCRIBED_ON] != null ?
        DateTime.fromMillisecondsSinceEpoch(data[Prescription.PRESCRIBED_ON].millisecondsSinceEpoch) : null,

    );

  }

}