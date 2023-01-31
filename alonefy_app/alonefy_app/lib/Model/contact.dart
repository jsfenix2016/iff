import 'dart:typed_data';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
class ContactBD extends HiveObject {
  ContactBD({
    required this.id,
    required this.displayName,
    required this.photo,
    required this.thumbnail,
    required this.name,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String displayName;

  @HiveField(2)
  final Uint8List? photo;

  @HiveField(3)
  final Uint8List? thumbnail;

  @HiveField(4)
  final Name name;
}

class Contact {
  late String id;
  late String displayName;
  Uint8List? photo;
  Uint8List? thumbnail;
  late Name name;
  late List<Phone> phones;
  late List<Email> emails;
  late List<Address> addresses;
  late List<Organization> organizations;
  late List<Website> websites;
  late List<SocialMedia> socialMedias;
  late List<Event> events;
  late List<Note> notes;
  late List<Group> groups;
}

class Name {
  late String first;
  late String last;
}

class Phone {
  late String number;
  late PhoneLabel label;
}

class Email {
  late String address;
  late EmailLabel label;
}

class Address {
  late String address;
  late AddressLabel label;
}

class Organization {
  late String company;
  late String title;
}

class Website {
  late String url;
  late WebsiteLabel label;
}

class SocialMedia {
  late String userName;
  late SocialMediaLabel label;
}

class Event {
  int? year;
  late int month;
  late int day;
  late EventLabel label;
}

class Note {
  late String note;
}

class Group {
  late String id;
  late String displayName, givenName, middleName, prefix, suffix, familyName;
  late List<String> phones = [];
}
