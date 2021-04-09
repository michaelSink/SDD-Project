import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDialog {

  static void circularProgressStart(BuildContext context){

    showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator()));

  }

  static void circularProgressEnd(BuildContext context){

    Navigator.pop(context);

  }

  static void info({BuildContext context, String title, String content}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context){

        return AlertDialog(

          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );

      }
    );
  }

  static List<Widget> buildWidget(BuildContext context, List<String> text){
    List<Widget> a = [];
    a.add(Text(
      "Recognized Text",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ));
    for(String t in text){
      a.add(Card(
        elevation: 4,
        child: ListTile(
          trailing: Icon(Icons.add),
          title: Text(t),
          onTap: () {
            Clipboard.setData(new ClipboardData(text: t));
            Navigator.of(context).pop();
          },
        ),
      ));
    }
    return a;
  }

  static void buildList({BuildContext context, List<String> text}){
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context){

        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: buildWidget(context, text),
            ),
          ),
        );

      }
    );
  }
}
