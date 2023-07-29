class Contact {
  Contact({
    required this.name,
    required this.relationship,
    this.phone,
  });

  final String? name;
  final String? relationship;
  final String? phone;

  static List<Contact> contactList = [
    Contact(name: 'Mark Simmons', relationship: 'Husband', phone: '+123456789'),
    Contact(name: 'Jane Simmons', relationship: 'Daughter', phone: '+123456789'),
    Contact(name: 'James Simmons', relationship: 'Son', phone: '+123456789'),
    Contact(name: 'Margaret Mitchell', relationship: 'Mother', phone: '+123456789'),
    Contact(name: 'Leo Elon', relationship: 'Father', phone: '+123456789'),
    Contact(name: 'Howard Mitchell', relationship: 'Brother', phone: '+123456789'),
    Contact(name: 'Emma Mitchell', relationship: 'Sister', phone: '+123456789'),
  ];
}
