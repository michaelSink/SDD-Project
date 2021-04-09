import 'package:SDD_Project/controller/event_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';


class AddEventPageScreen extends StatefulWidget {
  final DateTime selectedDate;
  static const routeName = '/homeScreen/addEventPageScreen';

  const AddEventPageScreen({Key key, this.selectedDate}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AddEventPageState();
  }
}

class _AddEventPageState extends State<AddEventPageScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // save event
                bool validated = _formKey.currentState.validate();
                if (validated) {
                  _formKey.currentState.save();
                  final data =
                      Map<String, dynamic>.from(_formKey.currentState.value);
                  data['date'] =
                      (data['date'] as DateTime).millisecondsSinceEpoch;
                  // data['userId'] = context.read(userRepoProvider).user.id;
                  await eventDBS.create(data);
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
                  name: "title",
                  decoration: InputDecoration(
                    hintText: "Add Title",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 48.0),
                  ),
                ),
                Divider(),
                FormBuilderTextField(
                  name: "description",
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add Details",
                    prefixIcon: Icon(Icons.short_text),
                  ),
                ),
                Divider(),
                FormBuilderDateTimePicker(
                  validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context)]),
                  name: "date",
                  initialValue: widget.selectedDate ?? DateTime.now(),
                  fieldHintText: "Add Date",
                  inputType: InputType.date,
                  format: DateFormat('EEEE, dd MMMM, yyyy'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.calendar_today_sharp),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
