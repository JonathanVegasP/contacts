import 'dart:io';

import 'package:contacts/components/dismiss_keyboard.dart';
import 'package:contacts/model/Contact.dart';
import 'package:contacts/resources/images.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool _userEdited = false;
  Contact _editedContact;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact == null)
      _editedContact = Contact();
    else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _name.text = _editedContact.name;
      _email.text = _editedContact.email;
      _phone.text = _editedContact.phone;
    }
    _name.addListener(_nameListener);
    _email.addListener(_emailListener);
    _phone.addListener(_phoneListener);
  }

  void _nameListener() {
    _userEdited = true;
    setState(() {});
  }

  void _emailListener() {
    _userEdited = true;
  }

  void _phoneListener() {
    String text = _phone.text.replaceAll(
        RegExp(
          r'\D',
        ),
        '');
    text = text.replaceAllMapped(RegExp(r'^(\d+)'), (m) => '(${m[1]}');
    text = text.replaceAllMapped(
        RegExp(r'^(\(\d{2})(\d+)'), (m) => '${m[1]}) ${m[2]}');
    text = text.replaceAllMapped(
        RegExp(r'^(\(\d{2}\) \d{4})(\d{1,4})$'), (m) => '${m[1]}-${m[2]}');
    text = text.replaceAllMapped(
        RegExp(r'^(\(\d{2}\) \d{5})(\d{1,4})$'), (m) => '${m[1]}-${m[2]}');
    if (_phone.text != text)
      _phone.value = _phone.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
        composing: TextRange.empty,
      );
    _userEdited = true;
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Discard Changes?'),
              content: Text(
                  "If you get out to another screen you'll dicard the changes."),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else
      return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: DismissKeyboard(
        child: Scaffold(
          appBar: AppBar(
            title: Text(_name.text.isNotEmpty && _userEdited
                ? _name.text
                : _editedContact.name ?? 'New Contact'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _editedContact.name = _name.text;
                _editedContact.email = _email.text.toLowerCase();
                _editedContact.phone = _phone.text;
                Navigator.of(context).pop(_editedContact);
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      ImagePicker.pickImage(source: ImageSource.gallery)
                          .then((file) {
                        if (file != null) {
                          setState(() {
                            _editedContact.img = file.path;
                          });
                        }
                      });
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage(PERSON_IMAGE),
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    validator: (s) {
                      if (s.isEmpty) return 'Enter a name';
                    },
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (s) =>
                        FocusScope.of(context).requestFocus(_emailFocus),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      labelText: "Name",
                    ),
                  ),
                  TextFormField(
                    controller: _email,
                    onFieldSubmitted: (s) =>
                        FocusScope.of(context).requestFocus(_phoneFocus),
                    textInputAction: TextInputAction.next,
                    focusNode: _emailFocus,
                    validator: (s) {
                      if (s.isEmpty)
                        return 'Enter an e-mail';
                      else if (!RegExp(
                              r'[\w]+(\.[\w]+)*@[\w-]+(\.[a-z]{2,3})*(\.[a-z]{2,3})$',
                              caseSensitive: false)
                          .hasMatch(s)) return 'Enter a valid e-mail';
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      labelText: "E-mail",
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    validator: (s) {
                      if (s.isEmpty)
                        return 'Enter a pohne';
                      else if (s.length < 14) return 'Enter a valid phone';
                    },
                    keyboardType: TextInputType.phone,
                    controller: _phone,
                    focusNode: _phoneFocus,
                    maxLength: 15,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                      labelText: "Phone",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
