class Contact {
  Contact({required this.name, required this.relationship});

  final String name;
  final String relationship;

  static List<Contact> contactList = [
    Contact(name: 'Mark Simmons', relationship: 'Husband'),
    Contact(name: 'Jane Simmons', relationship: 'Daughter'),
    Contact(name: 'James Simmons', relationship: 'Son'),
    Contact(name: 'Margaret Mitchell', relationship: 'Mother'),
    Contact(name: 'Leo Elon', relationship: 'Father'),
    Contact(name: 'Howard Mitchell', relationship: 'Brother'),
    Contact(name: 'Emma Mitchell', relationship: 'Sister'),
  ];
}
