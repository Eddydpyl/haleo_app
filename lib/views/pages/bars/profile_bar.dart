import 'package:flutter/material.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../blocs/user_admin_bloc.dart';
import '../../../blocs/user_bloc.dart';
import '../../../models/user.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';
import '../../../localization.dart';

class ProfileBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final void Function(bool) edit;
  final bool editing;
  final String path;

  ProfileBar({
    @required this.nameController,
    @required this.descriptionController,
    @required this.editing,
    @required this.edit,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    final Localization localization = ApplicationProvider.localization(context);
    final UserAdminBloc userAdminBloc = ProfileProvider.userAdminBloc(context);
    final UserBloc userBloc = ProfileProvider.userBloc(context);
    return StreamBuilder(
      stream: userBloc.userStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, User>> snapshot) {
        if (snapshot.data != null) {
          final String uid = snapshot.data.key;
          final User user = snapshot.data.value;
          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: leadingWidget(context),
            centerTitle: true,
            title: titleWidget(localization),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  child: editing
                      ? PaintGradient(
                          child: IconButton(
                            icon: Icon(Icons.save),
                            onPressed: () {
                              if (nameController.text?.isNotEmpty ?? false) {
                                userAdminBloc.updateSink.add(MapEntry(uid, User(
                                  name: nameController.text,
                                  description: descriptionController.text,
                                  image: path,
                                ))); edit(false);
                              }
                            },
                          ),
                          colorA: Color(0xfffa6b40),
                          colorB: Color(0xfffd1d1d),
                        )
                      : PaintGradient(
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => edit(true),
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

  Widget titleWidget(Localization localization) {
    return RichText(
        text: TextSpan(
        text: localization.profileText(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF424242),
          fontSize: 24.0,
        ),
      ),
    );
  }

  Widget leadingWidget(BuildContext context) {
    return PaintGradient(
      child: IconButton(
        icon: Icon(editing ? CustomIcons.cancel_1 : CustomIcons.left_big),
        onPressed: () => editing ? edit(false) : Navigator.of(context).pop(),
      ),
      colorA: Color(0xfffa6b40),
      colorB: Color(0xfffd1d1d),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
