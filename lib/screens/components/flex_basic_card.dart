import 'package:flex/screens/components/flex_icon_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FlexBasicCard extends StatelessWidget {
  final bool hasBadge;
  final IconData icon;
  final String title;
  final Function morePress;
  final Function editPress;
  final Function deletePress;

  const FlexBasicCard(
      {Key key,
      this.hasBadge,
      this.icon,
      this.title,
      @required this.morePress,
      @required this.editPress,
      @required this.deletePress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Card(
        margin: EdgeInsets.only(top: 24, bottom: 8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Icon(
                this.icon,
                size: 60,
                color: Color(0XFF000000),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                this.title,
                style: TextStyle(overflow: TextOverflow.ellipsis),
              )
            ],
          ),
          Icon(
            Icons.more_vert,
            size: 35,
            color: Color(0XFF95989D),
          ),
        ]),
      ),
      endActionPane: ActionPane(motion: ScrollMotion(), children: [
        FlexIconButton(
          borderColor: Color(0XFFA2A2A2), // Could make this concrete since
          //its the same for all icons and is being repeated below
          iconColor: Color(0XFF00A500),
          icon: Icons.info,
        ),
        FlexIconButton(
          borderColor: Color(0XFF95989D),
          icon: Icons.edit,
          iconColor: Color.fromARGB(255, 24, 24, 24),
          scaleFactor: 35,
          press: editPress,
        ),
        // FlexIconButton(
        //   borderColor: Color(0XFFA2A2A2),
        //   iconColor: Color(0XFFA2A2A2),
        //   icon: Icons.near_me,
        // ),
        FlexIconButton(
          borderColor: Color(0XFF95989D),
          icon: Icons.delete,
          iconColor: Colors.red,
          scaleFactor: 35,
          press: deletePress,
        ),
      ]),
    );
  }
}
