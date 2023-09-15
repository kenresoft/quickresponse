class ContactModel {
  ContactModel({
    required this.name,
    this.relationship,
    required this.phone,
    this.age,
    this.height,
    this.weight,
    this.imageFile,
  });

  final String? name;
  final String? relationship;
  final String? phone;
  final int? age;
  final int? height;
  final int? weight;
  final String? imageFile;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
      'age': age,
      'height': height,
      'weight': weight,
      'imageFile': imageFile,
    };
  }

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      name: json['name'],
      relationship: json['relationship'],
      phone: json['phone'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      imageFile: json['imageFile'],
    );
  }

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
