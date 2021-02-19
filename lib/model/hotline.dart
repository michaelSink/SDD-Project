class Hotline{

  static const COLLECTION = 'hotlines';

  static const NAME = 'name';
  static const PURPOSE = 'purpose';
  static const DESCRIPTION = 'description';
  static const AVAILABILITY = 'availability';
  static const PHONE_NUMBER = 'phoneNumber';

  //Document ID for Firebase
  String docId;

  //Hotline elements
  String name;
  String purpose;
  String description;
  String availability;
  String phoneNumber;

  Hotline({
    this.docId,
    this.name,
    this.purpose,
    this.description,
    this.availability,
    this.phoneNumber,
  }){}

  static List<Hotline> defaultHotline = [
    Hotline(name: "National Suicide Prevention Lifeline", purpose: "Suicide", description: "The National Suicide Prevention Lifeline is a national network of local crisis centers that provides free and confidential emotional support to people in suicidal crisis or emotional distress 24 hours a day, 7 days a week.", availability: "24/7", phoneNumber: "1-800-273-8255",),
    Hotline(name: "Trevor Project Lifeline", purpose: "LGBTQ", description: "The mission of The Trevor Project is to end suicide among gay, lesbian, bisexual, transgender, queer & questioning young people.", availability: "24/7", phoneNumber: "1-866-488-7386",),
    Hotline(name: "NEDA Helpline", purpose: "Eating Disorder", description: "Support individuals and families affected by eating disorders, and serve as a catalyst for prevention, cures, and access to quality care.", availability: "Monday - Thursday 11am-9pm ET, Friday 11am-5pm ET.", phoneNumber: "800-931-2237",),
    Hotline(name: "SAMHSA National Helpline", purpose: "Substance Abuse", description: "SAMHSA's mission is to reduce the impact of substance abuse and mental illness on America's communities.", availability: "24/7", phoneNumber: "1-800-662-4357",),
    Hotline(name: "Veterans Crisis Line", purpose: "Veterans", description: "The Veterans Crisis Line is a toll-free, confidential resource that connects Veterans in crisis and their families and friends with qualified, caring Department of Veterans Affairs (VA) responders.", availability: "24/7", phoneNumber: "1-800-273-8255",),
    Hotline(name: "NAMI Helpline", purpose: "Mental Health", description: "NAMI provides advocacy, education, support and public awareness so that all individuals and families affected by mental illness can build better lives.", availability: "Monday - Friday, 10am-8pm ET", phoneNumber: "1-800-950-6264",),
  ]; 

  Map<String, dynamic> serialize(){
    return <String, dynamic>{
      NAME: name,
      PURPOSE: purpose,
      DESCRIPTION: description,
      AVAILABILITY: availability,
      PHONE_NUMBER: phoneNumber,
    };
  }

  static Hotline deserialize(Map<String, dynamic> data, String docId){

    return Hotline(
      docId: docId,
      name: data[Hotline.NAME],
      purpose: data[Hotline.PURPOSE],
      description: data[Hotline.DESCRIPTION],
      availability: data[Hotline.AVAILABILITY],
      phoneNumber: data[Hotline.PHONE_NUMBER],
    );

  }

}