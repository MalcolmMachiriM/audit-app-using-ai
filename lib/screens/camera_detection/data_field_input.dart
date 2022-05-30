import 'package:flutter/material.dart';

import '../../models/assessment_template_model.dart';
import '../assessments/form.dart';

class FlexDatafieldInput extends StatefulWidget {
  final Fields field;
  final TextEditingController controller;
  const FlexDatafieldInput(
      {Key key, @required this.field, @required this.controller})
      : super(key: key);

  @override
  _FlexDatafieldInputState createState() => _FlexDatafieldInputState();
}

class _FlexDatafieldInputState extends State<FlexDatafieldInput> {
  var visible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FlexTextFormField(
            labelText: widget.field.prompt,
            controller: widget.controller,
            onEditingComplete: () {
              if ("yes" == widget.controller.text) {
                setState(() {
                  visible = true;
                });
              } else {
                setState(() {
                  visible = false;
                });
              }
            },
          ),
          Visibility(
            visible: visible,
            child: FlexTextFormField(
              labelText: widget.field.prompt,
            ),
          ),
        ],
      ),
    );
  }
}
