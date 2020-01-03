import 'package:flutter/material.dart';

import '../../../providers/user_events_provider.dart';
import '../../../models/user.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';

class ProfileBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserEventsProvider.userBloc(context).userStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, User>> snapshot) {
        if (snapshot.data != null) {
          final String userKey = snapshot.data.key;
          final User user = snapshot.data.value;
          bool isEditing = false;

          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: leadingWidget(context),
            centerTitle: true,
            title: titleWidget(),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  child: isEditing
                      ? PaintGradient(
                          child: IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () =>
                                {}, //TODO: save profile data, also we should save on exit perhaps ?
                          ),
                          colorA: Color(0xfffa6b40),
                          colorB: Color(0xfffd1d1d),
                        )
                      : PaintGradient(
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => {}, // TODO: turn isEditing mode on
                          ),
                          colorA: Color(0xfffa6b40),
                          colorB: Color(0xfffd1d1d),
                        ),
                ),
              ),
            ],
          );
        } else
          return Container();
      },
    );
  }

  Widget titleWidget() {
    return RichText(
        text: TextSpan(
      text: "¡Tu Cara!",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF424242),
        fontSize: 24.0,
      ),
    ));
  }

  Widget leadingWidget(BuildContext context) {
    return PaintGradient(
      child: IconButton(
        icon: Icon(CustomIcons.left_big),
        // TODO: this should always go back to main events screen overriding any other historic routes.
        onPressed: () => Navigator.of(context).pop(),
      ),
      colorA: Color(0xfffa6b40),
      colorB: Color(0xfffd1d1d),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
