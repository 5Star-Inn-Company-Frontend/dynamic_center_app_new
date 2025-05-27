import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_center/constant/imports.dart';

class ContactInfo extends ISuspensionBean {
  String name;
  String? tagIndex;
  String? namePinyin;

  Color? bgColor;
  IconData ?iconData;

  String flag;
  String? assetImg;
  String id;
  String firstletter;

  ContactInfo({
    required this.name,
    this.tagIndex,
    required this.flag,
    required this.id,
    required this.firstletter,
  });

  ContactInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'] + "- " + json['Iso'],
        flag = "https://www.countryflags.io/${json['countryCode']}/flat/64.png",
        id = json['id'],
        firstletter = json['firstletter'];

  Map<String, dynamic> toJson() => {
//        'id': id,
        'name': name,
        'img': flag,
//        'firstletter': firstletter,
//        'tagIndex': tagIndex,
//        'namePinyin': namePinyin,
//        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex!;

  @override
  String toString() => json.encode(this);
}
