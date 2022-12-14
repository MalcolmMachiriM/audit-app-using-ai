import 'package:flex/models/inventory.dart';
import 'package:flex/providers/project_provider.dart';
import 'package:flex/screens/components/flex_buttons.dart';
import 'package:flex/screens/components/flex_switch.dart';
import 'package:flex/themes/style.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

// import '../../providers/app_state.dart';

class BindingBox extends StatefulWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final BuildContext context;

  BindingBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
    this.context,
  );

  @override
  State<BindingBox> createState() => _BindingBoxState();
}

class _BindingBoxState extends State<BindingBox> {
  TextEditingController itemDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBox() {
      return widget.results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        var scaleW, scaleH, x, y, w, h;

        if (widget.screenH / widget.screenW >
            widget.previewH / widget.previewW) {
          scaleW = widget.screenH / widget.previewH * widget.previewW;
          scaleH = widget.screenH;
          var difW = (scaleW - widget.screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = widget.screenW / widget.previewW * widget.previewH;
          scaleW = widget.screenW;
          var difH = (scaleH - widget.screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 16),
                contentPadding: EdgeInsets.zero,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                content: Builder(
                  builder: (context) {
                    return buildNewProject(
                        "${re["detectedClass"]} (${(re["confidenceInClass"] * 100).toStringAsFixed(0)}% positive)?",
                        "${re["detectedClass"]}");
                  },
                ),
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 5.0, left: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: appTheme().primaryColor,
                  width: 3.0,
                ),
              ),
              child: Text(
                "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: appTheme().primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList();
    }

    return Stack(
      children: _renderBox(),
    );
  }

  Widget buildTextField(
      {String hintText, String labelText, TextEditingController controller}) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(this.widget.context).viewInsets.bottom),
      duration: Duration(milliseconds: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: TextFormField(
          enabled: false,
          readOnly: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            contentPadding: EdgeInsets.all(20),
            hintText: hintText,
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Field empty';
            }
            return null;
          },
        ),
      ),
    );
  }

  buildNewProject(String re, String reConfidence) {
    bool switchValue = false;
    int index;
    // Inventory inventory;

    return Container(
      width: MediaQuery.of(widget.context).size.width,
      decoration: BoxDecoration(),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(left: 120),
                child: Text(
                  'Confirm Item',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              IconButton(
                color: Theme.of(this.widget.context).primaryColor,
                onPressed: () {
                  Navigator.pop(this.widget.context);
                },
                icon: Icon(Icons.cancel_outlined),
              ),
            ],
          ),
          Divider(
            color: Colors.transparent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Is this a " + reConfidence + "?"),
              SizedBox(
                width: 20,
              ),
              Transform.scale(
                scale: 1,
                child: BottomSheetSwitch(
                  switchValue: switchValue,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.transparent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Define item"),
            ],
          ),
          Divider(
            color: Colors.transparent,
          ),
          buildTextField(hintText: re, labelText: re),
          // buildTextField(hintText: 'Fire Audit', labelText: 'Not Listed?'),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 120,
                height: 45,
                child: DefaultFlexButton(
                    displayText: 'CANCEL',
                    fillcolor: false,
                    press: () {
                      Navigator.pop(this.widget.context);
                    }),
              ),
              Container(
                width: 120,
                height: 45,
                child: DefaultFlexButton(
                  displayText: 'SUBMIT',
                  fillcolor: true,
                  press: () {
                    // var inventory =
                    //     Provider.of<AppState>(context, listen: false);
                    // inventory.appendInventory(new Inventory(name: reConfidence),
                    //     Provider.of<AppState>(context, listen: false).index);
                    // Navigator.of(context).pop();
                    // Consumer<Project>(
                    //     builder: ((context, project, child) =>
                    // Items(itemName: reConfidence, description: blue)));
                    Provider.of<Project>(widget.context, listen: false)
                        .addInventory(
                            Items(
                                itemName: reConfidence,
                                description: 'blue',
                                count: 1),
                            index)
                        .then(
                          Navigator.of(widget.context).pop(),
                        );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
