import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:order_management/service/DBService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/service/utilsService.dart';
import 'package:provider/provider.dart';

import 'checkbox_list_tile_formfield.dart';

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
  var loginSrv;

  String title = "";
  var parent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context).settings.arguments;
    srv = Provider.of<DBService>(context, listen: false);
    loginSrv = Provider.of<LoginService>(context, listen: false);

    forms = srv.config["FORMS"];
    fref = forms[args["formType"]];
    title = fref["title"];
  }

  @override
  Widget build(BuildContext context) {
    var keyboardType = TextInputType.text;
    List<TextInputFormatter> inputFormatters = [];

    Widget buildCheckBox(fieldDef) {
      bool initialValue = false;
      var validator;
      var onChanged;

      /// set initial value
      initialValue = targetModel[fieldDef['name']] != null
          ? targetModel[fieldDef['name']]
          : false;

      if (fieldDef["required"] == true) {
        validator = (value) {
          if (value) {
            return null;
          } else {
            return 'This field is required!';
          }
        };
      }

      if (fref["addWatchers"][fieldDef["name"]] == true) {
        onChanged = (value) {
          setState(() {
            targetModel[fieldDef['name']] = value;
          });
        };
      }
      return CheckboxListTileFormField(
        onChanged: onChanged,
        initialValue: initialValue,
        title: Text(fieldDef["label"]),
        onSaved: (bool value) {
          targetModel[fieldDef['name']] = value;
        },
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
        validator: validator,
      );
    }

    Widget buildInput(fieldDef) {
      var onSaved;
      var onChanged;
      var validator;
      var initialValue;

      // Add listener(watcher), which gets triggered in value change
      if (fref["addWatchers"][fieldDef["name"]] == true) {
        onChanged = (value) {
          setState(() {
            targetModel[fieldDef['name']] = value;
          });
        };
      }

      switch (fieldDef["type"]) {
        case "K_FIELD_NUMBER":

          /// set initial value
          initialValue = getInitialValue(fieldDef);
          if (initialValue != null) initialValue = initialValue.toString();
          keyboardType = TextInputType.number;
          inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
          validator = (value) {
            if (value.isEmpty) {
              return 'This field is required.';
            }
            return null;
          };
          onSaved = (value) => targetModel[fieldDef['name']] = int.parse(value);

          if (fref["addWatchers"][fieldDef["name"]] == true) {
            onChanged = (value) {
              setState(() {
                targetModel[fieldDef['name']] = int.parse(value);
              });
            };
          }

          break;
        default:
          validator = (value) {
            if (value.isEmpty) {
              return 'This field is required.';
            }
            return null;
          };
          onSaved = (value) => targetModel[fieldDef['name']] = value;

          if (fref["addWatchers"][fieldDef["name"]] == true) {
            onChanged = (value) {
              setState(() {
                targetModel[fieldDef['name']] = value;
              });
            };
          }
      }

      return TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
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

      /// if Navigated from products page then hide the typeahead
      if (srv.getV("redirectFrom", args) == "products") {
        if (fieldDef["parent"] != null) {
          // parent = getShortForm()[datasrc["handler"]](loginSrv.currentUser);
          parent = loginSrv.currentUser["belongs_to_customer"];
          targetModel[fieldDef["parent"]] = parent;
        }
        targetModel[fieldDef['name']] =
            loginSrv.currentUser["belongs_to_customer"]["name"] ??
                loginSrv.currentUser["phoneNumber"];
        return Container();
      }

      /// set initial value
      this._typeAheadController.text = getInitialValue(fieldDef);

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

    bool isCondSatisfied(src, cond) {
      if (cond == null) {
        return true;
      }
      if (cond["\$ne"] != null) {
        var key = cond["\$ne"][0].toString().substring(1);
        return src[key] == cond["\$ne"][1];
      } else if (cond.entries.first.key != null) {
        return src[cond.entries.first.key] == cond.entries.first.value;
      }
      return true;
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
        if (isCondSatisfied(targetModel, v["show_cond"])) {
          buttons.add(Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              child: Text(v["label"]),
              color: Colors.blue,
              onPressed: onPressed,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0),
              ),
            ),
          ));
        }
      });
      return ButtonBar(children: buttons);
    }

    List<Widget> formBuilder() {
      List<Widget> fb = [];
      // fref = forms[args["formType"]];

      for (var i = 0; i < fref["fields"].length; i++) {
        if (isCondSatisfied(targetModel, fref["fields"][i]["show_cond"]) ==
            false) {
          continue;
        }
        switch (fref["fields"][i]["type"]) {
          case "K_FIELD_TYPEAHEAD":
            fb.add(buildTypeAhead(fref["fields"][i]));
            break;
          case "K_FIELD_NUMBER":
            fb.add(buildInput(fref["fields"][i]));
            break;
          case "K_FIELD_CHECKBOX":
            fb.add(buildCheckBox(fref["fields"][i]));
            break;
          default:
        }
      }
      print(fb);

      // Add action buttons such as submit, cancel etc.
      fb.add(addActionButtons(fref));
      return fb;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        padding: EdgeInsets.all(2.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 5,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
              children: formBuilder(),
            ),
          ),
        ),
      ),
    );
  }

  dynamic getInitialValue(fieldDef) {
    var initialValue;
    var values = srv.getV("values", args);
    if (targetModel[fieldDef['name']] != null)
      initialValue = targetModel[fieldDef['name']];
    else if (values != null) {
      initialValue = resolveFields(values[fieldDef["name"]]);
    } else {
      initialValue = null;
    }
    return initialValue;
  }

  relatedModelsUpdate(formAction) async {
    var modelsToUpdate = fref["actions"][formAction]["modelsToUpdate"];
    targetModel["type"] = fref["type"];
    await Future.forEach(modelsToUpdate, (element) async {
      if (element["refModel"] != null) {
        refModel = await srv.getRefModel(
            element["refModel"], targetModel[element["modelIdRef"]]["id"]);
        refModel = refModel[0];
        resolveFieldMap(element["fieldmap"], refModel);
        srv.saveForm(element["targetModel"], targetModel);
        // update order list
        Navigator.of(context).pop();
      } else {
        resolveFieldMap(element["fieldmap"], refModel);
        srv.saveForm(element["targetModel"], targetModel);
        // update order list
        Navigator.of(context).pop();
      }
    });
  }

  resolveFields(field) {
    var resolvedValue;
    switch (field) {
      case "\$\$K_CURRENT_CUSTOMER_NAME":
        print(loginSrv.currentUser);
        resolvedValue = loginSrv.currentUser["belongs_to_customer"];
        break;
      default:
        resolvedValue = field;
    }
    return resolvedValue;
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
