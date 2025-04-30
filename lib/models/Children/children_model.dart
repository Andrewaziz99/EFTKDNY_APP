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
  bool ? isSelected = false;

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
    this.isSelected,
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
    isSelected = false;
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

  // Helper method to toggle selection
  ChildrenModel copyWith({bool? isSelected}) {
    return ChildrenModel(
      childId: childId,
      name: name,
      birthDate: birthDate,
      phone: phone,
      AdditionalPhone: AdditionalPhone,
      address: address,
      className: className,
      image: image,
      lastVisit: lastVisit,
      isSelected: isSelected ?? this.isSelected,
    );
  }

}
