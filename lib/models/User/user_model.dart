class UserModel{
  String? uId;
  String? image;
  String? name;
  String? phone;
  String? className;
  String? address;
  String? email;
  bool? isEmailVerified;
  bool? isAdmin;

  UserModel({this.uId, this.image, this.name, this.phone, this.address, this.className, this.email, this.isEmailVerified = false, this.isAdmin = false});

  UserModel.fromJson(Map<String, dynamic> json){
    uId = json['uId'];
    image = json['image'];
    name = json['name'];
    phone = json['phone'];
    className = json['className'];
    email = json['email'];
    isEmailVerified = json['isEmailVerified'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toMap(){
    return {
      'uId': uId,
      'image': image,
      'name': name,
      'phone': phone,
      'className': className,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'isAdmin': isAdmin,
    };
  }
}