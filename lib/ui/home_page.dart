import 'package:contacts/components/contact_card.dart';
import 'package:contacts/components/menu.dart';
import 'package:contacts/database/database_helper.dart';
import 'package:contacts/model/Contact.dart';
import 'package:contacts/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper helper = DatabaseHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllContacts();
  }

  void _showContactPage({Contact contact}) async {
    final receivedContact = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactPage(
              contact: contact,
            ),
      ),
    );
    if (receivedContact != null) {
      if (contact != null) {
        await helper.updateContact(receivedContact);
      } else {
        await helper.saveContact(receivedContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showOptions({@required BuildContext context, @required int index}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        launch('tel:${contacts[index].phone}');
                      },
                      child: Text(
                        'Call',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showContactPage(contact: contacts[index]);
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        helper.deleteContact(contacts[index].id);
                        setState(() {
                          contacts.removeAt(index);
                        });
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _orderList(Menu menu) {
    switch (menu) {
      case Menu.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case Menu.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Menu>(
            onSelected: _orderList,
            itemBuilder: (context) => <PopupMenuEntry<Menu>>[
                  const PopupMenuItem<Menu>(
                    value: Menu.orderaz,
                    child: Text('Order to A-Z'),
                  ),
                  const PopupMenuItem<Menu>(
                    value: Menu.orderza,
                    child: Text('Order to Z-A'),
                  ),
                ],
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactPage(),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) => contactCard(
              context: context,
              contacts: contacts,
              index: index,
              showOptions: () => _showOptions(
                    index: index,
                    context: context,
                  ),
            ),
      ),
    );
  }
}
