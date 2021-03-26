import 'package:SDD_Project/model/hotline.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'addHotline_screen.dart';

class NativeContacts extends StatefulWidget{

  static const routeName = '/signIn/homeScreen/hotlineScreen/nativeContacts/';

  @override
  State<StatefulWidget> createState() {
    return _NativeContactsState();
  }

}

class _NativeContactsState extends State<NativeContacts>{
  
  Iterable<Contact> contacts;
  List<Hotline> hotlines;
  FirebaseUser user;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  @override
  Widget build(BuildContext context) {

    Map arg = ModalRoute.of(context).settings.arguments;
    contacts ??= arg['contacts'];
    user ??= arg['user'];
    hotlines ??= arg['hotlines'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) => Card(
            margin: EdgeInsets.all(4),
            elevation: 8,
            child: PopupMenuButton(
              onSelected: (val){
                con.addHotline(contacts.elementAt(index).displayName, val);
              },
                    itemBuilder: (BuildContext context){
                      var list = List<PopupMenuEntry<Object>>();
                      for(var number in contacts.elementAt(index).phones){
                        list.add(
                          PopupMenuItem(
                            child:
                             Text("${number.value}"),
                             value: number.value,
                          )
                        );
                      }
                      return list;
                    },
                child: ListTile(
                contentPadding: EdgeInsets.all(8),
                leading: contacts.elementAt(0).avatar.length != 0 ? 
                  Image.memory(contacts.elementAt(0).avatar)  
                : 
                  Image.asset("static/images/default-user.png"),
                title: Text(contacts.elementAt(index).displayName, style: TextStyle(fontSize: 20),),
                subtitle: Text("Phone: ${contacts.elementAt(index).phones.elementAt(0).value}"),
                trailing: Icon(Icons.person_add_outlined),
              ),
            ),
        ),
        ),
    );
  }
}

class _Controller{
  _NativeContactsState _state;
  _Controller(this._state);

  void addHotline(String name, String number)async{

    await Navigator.pushNamed(_state.context, AddHotline.routeName, 
            arguments: {'hotlines' : _state.hotlines, 'user' : _state.user, "name" : name, "number" : number});

    Navigator.pop(_state.context);
  }

}