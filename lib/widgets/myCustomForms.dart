import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:order_management/service/appConfigService.dart';
import 'package:order_management/service/loginService.dart';
import 'package:order_management/service/handlerService.dart';
import 'package:order_management/service/utilService.dart';
import 'package:order_management/widgets/card_formfield.dart';
import 'package:provider/provider.dart';

import 'checkbox_list_tile_formfield.dart';

// class LoadDataResponse {
//   Map<String, dynamic>? _shortForm;
//   List? _originalData;
//   LoadDataResponse();
//   LoadDataResponse.create(this._shortForm, this._originalData);
//   set shortForm(shortForm) => _shortForm = shortForm;
//   set originalData(originalData) => _originalData = originalData;
//   Map<String, dynamic>? get shortForm => _shortForm;
//   List? get originalData => _originalData;
// }

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
  var forms, args, fref, product, srv, loginSrv, parent, parentRefId;
  String? title = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)!.settings.arguments;

    /// Used to hold parent reference id, i.e child form keeps the parentRefId
    parentRefId = args!["refId"];
    srv = Provider.of<AppConfigService>(context, listen: false);
    loginSrv = Provider.of<LoginService>(context, listen: false);

    forms = srv.config["FORMS"];
    fref = forms[args["formType"]];
    // TODO: remove hardcoded value
    product = args["product"];
    title = fref["title"];
  }

  @override
  Widget build(BuildContext context) {
    var keyboardType = TextInputType.text;
    List<TextInputFormatter> inputFormatters = [];

    Widget buildCheckBox(fieldDef) {
      bool? initialValue = false;
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
        onSaved: (bool? value) {
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
          if (initialValue != null && initialValue != "")
            initialValue = initialValue.toString();
          keyboardType = TextInputType.number;
          inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
          if (fieldDef["required"])
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
        case "K_FIELD_TEXT":

          /// set initial value
          initialValue = getInitialValue(fieldDef);
          if (initialValue != null) initialValue = initialValue.toString();
          if (fieldDef["required"])
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
                targetModel[fieldDef['name']] = int.parse(value);
              });
            };
          }

          break;
        default:
          if (fieldDef["required"])
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
        inputFormatters: inputFormatters.length != 0 ? inputFormatters : null,
        validator: validator,
        onSaved: onSaved,
      );
    }

    Widget buildChildForm(fieldDef) {
      // var onSaved;
      // var onChanged;
      dynamic validator;
      var initialValue = "";
      var originalValue = {};

      Widget button = Container();

      if (fieldDef["required"] == true) {
        validator = (value) {
          if (value != null && value.toString().trim() != "") {
            return null;
          } else {
            return 'This field is required!';
          }
        };
      }

      Future<dynamic> loadDataForChildForm() async {
        List data;
        if (fieldDef["autoFillHandler"] != null &&
            fieldDef["autoFillHandler"]["handler"] != null) {
          data = await loadDataFromHandler(fieldDef);

          var res =
              await getShortForm()[fieldDef["autoFillHandler"]["handler"]]!(
                  data);
          return {
            "shortForm": res,
            "originalData": data.length > 0 ? data[0] : null
          };
        } else {
          return null;
        }
      }

      switch (fieldDef["type"]) {
        case "K_FIELD_FORM":
          button = FutureBuilder(
            builder: (context, AsyncSnapshot<dynamic> projectSnap) {
              if (projectSnap.data == null ||
                  projectSnap.connectionState == ConnectionState.none ||
                  projectSnap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (projectSnap.data != null) {
                initialValue = projectSnap.data["shortForm"] ?? "";
              }
              if (projectSnap.data != null) {
                originalValue = projectSnap.data["originalData"] ?? {};
              }

              /// Used to fetch refId from parent
              /// First get the refItem by checking `dependsOn`
              /// check if refItem contains `parent` attribute, if yes then take the `parent` id
              /// otherwise fetch `dependsOn` from targetModel
              var refItem = fref["fields"].singleWhere(
                  (eachfields) => eachfields["name"] == fieldDef['dependsOn']);
              var refId;
              if (targetModel.isNotEmpty) {
                if (refItem["parent"] != null) {
                  refId = targetModel[refItem["parent"]]["id"];
                } else {
                  refId = targetModel[fieldDef['dependsOn']];
                }
              }
              return CardFormField(
                context: context,
                fieldDef: fieldDef,
                refId: refId,
                initialValue: initialValue,
                originalValue: originalValue,
                onChanged: (value) async {
                  await loadDataForChildForm();
                  setState(() {});
                },
                validator: validator,
                onSaved: (value) {
                  // targetModel[fieldDef['name']] = value;
                  // targetModel[fieldDef[]]
                },
              );
            },
            future: loadDataForChildForm(),
          );

          break;
        default:
      }
      return button;
    }

    Widget buildTypeAhead(fieldDef) {
      var label = fieldDef["label"];
      var datasrc = fieldDef["datasrc"];
      var src;

      if (datasrc["srctype"] == "model") {
        src = datasrc["src"];
      }

      /// if role is K_USER then hide the customer typeahead and set the customer in form
      if (loginSrv.currentUser["role"] == "K_USER") {
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
        itemBuilder: (context, dynamic suggestion) {
          return ListTile(
            title: Text(suggestion[datasrc["value"]]),
          );
        },
        transitionBuilder: (context, suggestionsBox, controller) {
          return suggestionsBox;
        },
        onSuggestionSelected: (dynamic suggestion) {
          if (fieldDef["parent"] != null) {
            parent = getShortForm()[datasrc["handler"]]!(suggestion);
            targetModel[fieldDef["parent"]] = parent;
          }

          targetModel[fieldDef['name']] = suggestion[datasrc["key"]];
          this._typeAheadController.text = suggestion[datasrc["key"]];
          setState(() {});
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please select';
          }
          return null;
        },
        onSaved: (value) {
          targetModel[fieldDef['name']] = value;
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
          case "K_ACTION_CREATE":
            onPressed = () {
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a Snackbar.
                _formKey.currentState!.save();
                relatedModelsUpdate(k);
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
            // ignore: deprecated_member_use
            child: FlatButton(
              child: Text(v["label"]),
              color: Theme.of(context).primaryColor,
              //
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
          case "K_FIELD_TEXT":
            fb.add(buildInput(fref["fields"][i]));
            break;
          case "K_FIELD_CHECKBOX":
            fb.add(buildCheckBox(fref["fields"][i]));
            break;
          case "K_FIELD_FORM":
            fb.add(buildChildForm(fref["fields"][i]));

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
        title: Text(title!),
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
    var values = getV("values", args);
    if (targetModel[fieldDef['name']] != null)
      initialValue = targetModel[fieldDef['name']];
    else if (values != null &&
        values.isNotEmpty &&
        resolveFields(values[fieldDef["name"]]) != null &&
        resolveFields(values[fieldDef["name"]]).length > 0) {
      initialValue = resolveFields(values[fieldDef["name"]])[0];
    } else {
      initialValue = "";
    }
    return initialValue;
  }

  relatedModelsUpdate(formAction) async {
    var refId;
    var modelsToUpdate = fref["actions"][formAction]["modelsToUpdate"];
    targetModel["type"] = fref["type"];
    // If product is available then attach to the form; Make this generic, hardcoded for now.
    if (product != null) targetModel["product"] = product;
    await Future.forEach(modelsToUpdate, (dynamic element) async {
      if (element["refModel"] != null) {
        refModel = await srv.getModelByID(
            element["refModel"], targetModel[element["modelIdRef"]]["id"]);
        refModel = refModel[0];
        resolveFieldMap(element["fieldmap"], refModel);
        // if we have to update other collection then we have to provide targetModelRef
        // eg: update customer from address form
        if (element["targetModelRef"] != null) {
          refId = resolveFields(element["targetModelRef"])[0];
        }
        var result = await srv.saveForm(
            element["targetModel"], targetModel, refId, fref['key']);
        // update order list
        Navigator.of(context).pop(result);
      } else {
        // resolveFieldMap(element["fieldmap"], refModel);
        // if we have to update other collection then we have to provide targetModelRef
        // eg: update customer from address form
        if (element["targetModelRef"] != null) {
          if (loginSrv.currentUser["role"] != "K_ADMIN") {
            refId = loginSrv.currentUser["belongs_to_customer"]["id"];
          } else {
            /// fetch from child
            /// take refid and fill up
            refId = parentRefId;
          }
        }
        var result = await srv.saveForm(
            element["targetModel"], targetModel, refId, fref['key']);
        // update order list
        Navigator.of(context).pop(result);
      }
    });
  }

  // used to resolve reserved constants
  // todo: Move to service
  resolveFields(paramFields) {
    List resolvedValue = [];
    // if array
    if (paramFields.runtimeType != [].runtimeType) {
      paramFields = [paramFields];
    }
    paramFields.forEach((field) {
      switch (field) {
        case "\$\$K_LOGGED_IN_CUSTOMER":
          print("current user: ");
          print(loginSrv.currentUser);
          resolvedValue.add(loginSrv.currentUser["belongs_to_customer"]);
          break;
        case "\$\$K_LOGGED_IN_CUSTOMER_ID":
          print("current user: ");
          print(loginSrv.currentUser);
          resolvedValue.add(loginSrv.currentUser["belongs_to_customer"]["id"]);
          break;
        default:
          if (field != null) resolvedValue.add(field);
      }
    });

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

  /// Used to load data from handler configuration
  /// [config.autoFillHandler.datasrc.srctype] : model
  /// [config.autoFillHandler.datasrc.refKey] : id
  loadDataFromHandler(config) async {
    List data = [];
    var autofillHandler = config["autoFillHandler"];
    if (autofillHandler != null &&
        autofillHandler["datasrc"] != null &&
        autofillHandler["datasrc"]["srctype"] != null) {
      Map datasrc = autofillHandler["datasrc"];
      switch (datasrc["srctype"]) {
        case "model":
          if (datasrc["refKey"] == "id") {
            // TODO: check this remove user role from here
            if (loginSrv.currentUser["role"] != "K_ADMIN") {
              data = await srv.getModelByID(datasrc["src"],
                  loginSrv.currentUser["belongs_to_customer"]["id"]);
            } else {
              if (targetModel["belongs_to_customer"] != null &&
                  targetModel["belongs_to_customer"]["id"] != null) {
                data = await srv.getModelByID(
                    datasrc["src"], targetModel["belongs_to_customer"]["id"]);
              }
            }
          }
          break;
        default:
      }
    }
    return data;
  }
}
