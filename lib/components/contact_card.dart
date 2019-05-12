import 'dart:io';

import 'package:contacts/model/Contact.dart';
import 'package:contacts/resources/images.dart';
import 'package:flutter/material.dart';

Widget contactCard({
  @required BuildContext context,
  @required int index,
  @required List<Contact> contacts,
  @required Function showOptions,
}) {
  return GestureDetector(
    onTap: showOptions,
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 75.0,
              height: 75.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: contacts[index].img != null
                      ? FileImage(File(contacts[index].img))
                      : AssetImage(PERSON_IMAGE),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contacts[index].name ?? "",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    contacts[index].email ?? "",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    contacts[index].phone ?? "",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
