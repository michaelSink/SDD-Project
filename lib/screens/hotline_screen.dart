import 'package:SDD_Project/model/hotline.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HotlineScreen extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/hotlineScreen/';

  @override
  State<StatefulWidget> createState() {
    return _HotlineState();
  }

}

class _HotlineState extends State<HotlineScreen>{

  Future<void> _showMyDialog(String number, String name) async {
    print(number);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to call the ${name}?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('Approve'),
              onPressed: () async {
                await launch("tel:${number.replaceAll('-', '')}");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Hotlines'),
      ),
      body: ListView.builder(
        itemCount: Hotline.defaultHotline.length,
        itemBuilder: (BuildContext context, int index) => Container(
          padding: EdgeInsets.all(8),
          child: Card(
            elevation: 8,
            child: InkWell(
              onTap: () => _showMyDialog(Hotline.defaultHotline[index].phoneNumber, Hotline.defaultHotline[index].name),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Hotline.defaultHotline[index].name}',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Purpose: ${Hotline.defaultHotline[index].purpose}',
                    style: TextStyle(fontSize: 20),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 15,
                    thickness: 2,
                  ),
                  Text(
                    '${Hotline.defaultHotline[index].description}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Available: ${Hotline.defaultHotline[index].availability}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Call at: ${Hotline.defaultHotline[index].phoneNumber}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        )),
    );
  }

}