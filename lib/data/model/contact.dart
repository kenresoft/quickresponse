class ContactModel {
  ContactModel({
    required this.name,
    this.relationship,
    required this.phone,
  });

  final String? name;
  final String? relationship;
  final String? phone;

  static List<ContactModel> contactList = [
    ContactModel(name: 'Mark Simmons', relationship: 'Husband', phone: '+123456789'),
    ContactModel(name: 'Jane Simmons', relationship: 'Daughter', phone: '+123456789'),
    ContactModel(name: 'James Simmons', relationship: 'Son', phone: '+123456789'),
    ContactModel(name: 'Margaret Mitchell', relationship: 'Mother', phone: '+123456789'),
    ContactModel(name: 'Leo Elon', relationship: 'Father', phone: '+123456789'),
    ContactModel(name: 'Howard Mitchell', relationship: 'Brother', phone: '+123456789'),
    ContactModel(name: 'Emma Mitchell', relationship: 'Sister', phone: '+123456789'),
  ];
}
