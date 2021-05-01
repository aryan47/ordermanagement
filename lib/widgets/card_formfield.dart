import 'package:flutter/material.dart';
import 'package:order_management/controllers/utilService.dart';

class CardFormField extends FormField<String> {
  CardFormField(
      {Map<String, dynamic>? fieldDef,
      required BuildContext context,
      Widget? loadWidget,
      dynamic refId,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      String? initialValue,
      var originalValue,
      final ValueChanged? onChanged,
      bool autovalidate = false,
      GestureTapCallback? onTap})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autovalidate,
            builder: (FormFieldState<String> state) {
              if(refId == null){
                return Container();
              }
              return Card(
                // borderOnForeground: true,
                shape: state.hasError
                    ? new RoundedRectangleBorder(
                        side: new BorderSide(
                            color: Colors.redAccent[700]!, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0))
                    : new RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Row(
                        children: [
                          getI("content.icon", fieldDef, 20)!,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(getV("content.heading", fieldDef)),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          initialValue ?? fieldDef!["label"],
                          softWrap: true,
                        ),
                      ),
                      onTap: () async {
                        print(fieldDef);
                        if (fieldDef!['key'] != null &&
                            originalValue[fieldDef['key']] != null) {
                          originalValue = originalValue[fieldDef['key']];
                        }
                        dynamic result = await Navigator.pushNamed(
                            context, "/forms", arguments: {
                          "formType": "K_FORM_ADDRESS",
                          "values": originalValue ?? {},
                          "refId": refId
                        });
                        onChanged!(result);
                        // state.didChange(result);
                      },
                    ),
                  ],
                ),
              );
            });
}
