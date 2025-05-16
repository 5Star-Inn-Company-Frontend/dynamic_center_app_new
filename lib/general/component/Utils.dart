import 'package:flutter/material.dart';

import 'CityModel.dart';

class Utils {
  static String getImgPath(String name, {String format = 'png'}) {
    return 'assets/images/$name.$format';
  }

  String result = "Afghanistan: +93;https://www.countryflags.io/AF/flat/64.png";
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 40}) {
    if (tag == '★') {
      tag = '★ 热门城市';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  static Widget getWeChatListItem(
    BuildContext context,
    ContactInfo model, {
    double susHeight = 40,
    Color? defHeaderBgColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Offstage(
          offstage: !(model.isShowSuspension == true),
          child: getSusItem(context, model.getSuspensionTag(),
              susHeight: susHeight),
        ),
        getWeChatItem(context, model, defHeaderBgColor: defHeaderBgColor!),
      ],
    );
  }

  static Widget getWeChatItem(
    BuildContext context,
    ContactInfo model, {
    Color? defHeaderBgColor,
  }) {
    DecorationImage? image;
    //network image.
    if (model.flag != null && model.flag.isNotEmpty) {
      image = DecorationImage(
        image: NetworkImage(model.flag),
        fit: BoxFit.contain,
      );
    } else if (model.assetImg != null && model.assetImg!.isNotEmpty) {
      //aseet image.
      image = DecorationImage(
        image: AssetImage(model.assetImg!),
        fit: BoxFit.contain,
      );
    }
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(4.0),
          color: model.bgColor ?? defHeaderBgColor,
          image: image,
        ),
        child: model.iconData == null
            ? null
            : Icon(
                model.iconData,
                color: Colors.white,
                size: 20,
              ),
      ),
      title: Text(model.name),
      onTap: () {
        //LogUtil.e("onItemClick : $model");
        Navigator.pop(context, '${model.name};${model.flag}');
        Utils.showSnackBar(context, 'onItemClick : ${model.name}');
      },
    );
  }
}
