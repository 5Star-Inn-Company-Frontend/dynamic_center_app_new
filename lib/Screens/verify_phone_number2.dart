import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:dynamic_center/general/component/CityModel.dart';
import 'package:dynamic_center/general/component/Utils.dart';
import 'package:dynamic_center/general/component/backnavigation.dart';
import 'package:dynamic_center/general/component/cardlayout.dart';
import 'package:dynamic_center/general/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';

class VerifyPhoneNumber2 extends StatefulWidget {
  VerifyPhoneNumber2({Key? key}) : super(key: key);

  @override
  _VerifyPhoneNumber2State createState() => _VerifyPhoneNumber2State();
}

class _VerifyPhoneNumber2State extends State<VerifyPhoneNumber2> {
  List<ContactInfo> contactList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    //加载联系人列表
    rootBundle.loadString('assets/json/country.json').then((value) {
      List list = json.decode(value);
      list.forEach((v) {
        contactList.add(ContactInfo.fromJson(v));
      });
      _handleList(contactList);
    });
  }

  void _handleList(List<ContactInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(contactList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(contactList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(scafoldcolour),
        elevation: 0.0,
        title: Text(
          "Choose Country Code",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 26, color: Colors.black),
        ),
        leading: Backnavigation(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(children: [
            SizedBox(height: 40),
            Cardlayout(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      height: size.height,
                      child: AzListView(
                        data: contactList,
                        itemCount: contactList.length,
                        itemBuilder: (BuildContext context, int index) {
                          ContactInfo model = contactList[index];
                          return Utils.getWeChatListItem(
                            context,
                            model,
                            defHeaderBgColor: Color(0xFFE5E5E5),
                          );
                        },
                        physics: BouncingScrollPhysics(),
                        susItemBuilder: (BuildContext context, int index) {
                          ContactInfo model = contactList[index];
                          if ('↑' == model.getSuspensionTag()) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            );
                          }
                          return Utils.getSusItem(
                              context, model.getSuspensionTag());
                        },
                        indexBarOptions: IndexBarOptions(
                          needRebuild: true,
                          ignoreDragCancel: true,
                          // downTextStyle: TextStyle(fontSize: 12, color: Colors.white),
                          selectTextStyle: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w500),
                          selectItemDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(primarycolour)),
                          // downItemDecoration:
                          // BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                          indexHintWidth: 120 / 2,
                          indexHintHeight: 100 / 2,
                          indexHintDecoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  Utils.getImgPath('ic_index_bar_bubble_gray')),
                              fit: BoxFit.contain,
                            ),
                          ),
                          indexHintAlignment: Alignment.centerRight,
                          indexHintChildAlignment: Alignment(-0.25, 0.0),
                          indexHintOffset: Offset(-20, 0),
                        ),
                      ),
                    ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
