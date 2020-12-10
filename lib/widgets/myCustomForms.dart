import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:order_management/service/mainService.dart';
import 'package:order_management/service/utilsService.dart';

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  Map<String, dynamic> targetModel = {};
  dynamic refModel = {};
  var forms;
  var args;
  var fref;
  var srv;
  String title = "";
  var parent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context).settings.arguments;
    srv = MyInheritedWidget.of(context);
    forms = srv.config["FORMS"];
    fref = forms[args["formType"]];

    title = fref["title"];
  }

  @override
  Widget build(BuildContext context) {
    var keyboardType = TextInputType.text;
    List<TextInputFormatter> inputFormatters = [];
    var onSaved;
    var validator;

    Widget buildInput(fieldDef) {
      switch (fieldDef["type"]) {
        case "K_FIELD_NUMBER":
          keyboardType = TextInputType.number;
          inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
          validator = (value) {
            if (value.isEmpty) {
              return 'This field is required.';
            }
            return null;
          };
          onSaved = (value) => targetModel[fieldDef['name']] = int.parse(value);
          break;
        default:
          validator = (value) {
            if (value.isEmpty) {
              return 'This field is required.';
            }
            return null;
          };
          onSaved = (value) => targetModel[fieldDef['name']] = int.parse(value);
      }

      return TextFormField(
        decoration: InputDecoration(labelText: fieldDef["label"]),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters, // Only numbers can be entered
        validator: validator,
        onSaved: onSaved,
      );
    }

    Widget buildTypeAhead(fieldDef) {
      var label = fieldDef["label"];
      var datasrc = fieldDef["datasrc"];
      var src;

      if (datasrc["srctype"] == "model") {
        src = datasrc["src"];
      }

      return TypeAheadFormField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: this._typeAheadController,
            decoration: InputDecoration(labelText: label)),
        suggestionsCallback: (pattern) async {
          return await srv.getTypeAhead(src, pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion[datasrc["value"]]),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (suggestion) {
          if (fieldDef["parent"] != null) {
            parent = getShortForm()[datasrc["handler"]](suggestion);
            targetModel[fieldDef["parent"]] = parent;
          }

          this._typeAheadController.text = suggestion[datasrc["key"]];
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please select';
          }
          return null;
        },
        onSaved: (value) {
          targetModel[fieldDef['name']] = value;
          // targetModel[fieldDef[]]
        },
      );
    }

    Widget addActionButtons(formRef) {
      List<Widget> buttons = [];
      var onPressed;
      fref["actions"].forEach((k, v) {
        switch (v["action"]) {
          case "K_ACTION_SUBMIT":
            onPressed = () {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a Snackbar.
                _formKey.currentState.save();
                relatedModelsUpdate(k);
                print(targetModel);
                // Scaffold.of(context)
                //     .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            };
            break;
          case "K_ACTION_CANCEL":
            onPressed = () {
              Navigator.of(context).pop();
            };
            break;
          default:
        }

        buttons.add(FlatButton(
          child: Text(v["label"]),
          color: Colors.blue,
          onPressed: onPressed,
        ));
      });
      return ButtonBar(children: buttons);
    }

    List<Widget> formBuilder() {
      List<Widget> fb = [];
      fref = forms[args["formType"]];

      for (var i = 0; i < fref["fields"].length; i++) {
        print(fref["fields"][i]["type"]);
        switch (fref["fields"][i]["type"]) {
          case "K_FIELD_TYPEAHEAD":
            fb.add(buildTypeAhead(fref["fields"][i]));
            break;
          case "K_FIELD_NUMBER":
            fb.add(buildInput(fref["fields"][i]));
            break;
          case "K_FIELD_CHECKBOX":
            break;
          default:
        }
      }
      print(fb);
      fb.add(addActionButtons(fref));
      return fb;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: formBuilder(),
          ),
        ),
      ),
    );
  }

  relatedModelsUpdate(formAction) async {
    var modelsToUpdate = fref["actions"][formAction]["modelsToUpdate"];

    await Future.forEach(modelsToUpdate, (element) async {
      if (element["refModel"] != null) {
        refModel = await srv.getRefModel(
            element["refModel"], targetModel[element["modelIdRef"]]["id"]);
        refModel = refModel[0];
        resolveFieldMap(element["fieldmap"], refModel);
        srv.saveForm(element["targetModel"], targetModel);
      } else {
        resolveFieldMap(element["fieldmap"], refModel);
        srv.saveForm(element["targetModel"], targetModel);
      }
    });
  }

  resolveFieldMap(fieldmap, refModel) {
    fieldmap.forEach((String k, v) {
      if (v is String) {
        var constRe = new RegExp(r'\$\$');
        var varRe = new RegExp(r'\$');
        if (v.startsWith(constRe)) {
          switch (v) {
            case "\$\$K_CURRENT_DATE":
              fieldmap[k] = new DateTime.now();
              break;
            default:
          }
        } else if (v.startsWith(varRe)) {
          fieldmap[k] = refModel[v.substring(1)];
        }
      }
    });
    targetModel.addAll(fieldmap);
  }
}
