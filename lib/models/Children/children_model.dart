class ChildrenModel {
  String? childId;
  String? name;
  String? birthDate;
  String? phone;
  String? AdditionalPhone;
  String? address;
  String? className;
  String? image;
  String? lastVisit;

  ChildrenModel({
    this.childId,
    this.name,
    this.birthDate,
    this.phone,
    this.AdditionalPhone,
    this.address,
    this.className,
    this.image,
    this.lastVisit,
  });

  ChildrenModel.fromJson(Map<String, dynamic> json) {
    childId = json['childId'];
    name = json['name'];
    birthDate = json['bDate'];
    phone = json['phone'];
    AdditionalPhone = json['AdditionalPhone'];
    address = json['address'];
    className = json['className'];
    image = json['image'];
    lastVisit = json['lastVisit'];
  }

  Map<String, dynamic> toMap() {
    return {
      'childId': childId,
      'name': name,
      'bDate': birthDate,
      'phone': phone,
      'AdditionalPhone': AdditionalPhone,
      'address': address,
      'className': className,
      'image': image,
      'lastVisit': lastVisit,
    };
  }
}
