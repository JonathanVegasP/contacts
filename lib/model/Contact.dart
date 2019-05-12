import 'package:contacts/database/columns.dart';

class Contact {
  int _id;
  String _name;
  String _email;
  String _phone;
  String _img;

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[ID];
    name = map[NAME];
    email = map[EMAIL];
    phone = map[PHONE];
    img = map[IMG];
  }

  Contact();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      NAME: name,
      EMAIL: email,
      PHONE: phone,
      IMG: img,
    };
    if (id != null) {
      map[ID] = id;
    }
    return map;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  String get img => _img;

  set img(String value) {
    _img = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  set name(String value) {
    _name = value;
  }

  @override
  String toString() {
    return 'Contact{_id: $_id, _name: $_name, _email: $_email, _phone: $_phone, _img: $_img}';
  }
}
