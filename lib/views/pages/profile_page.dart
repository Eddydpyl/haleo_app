import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:darter_base/darter_base.dart';

import 'bars/profile_bar.dart';
import 'bodies/profile_body.dart';
import '../../providers/application_provider.dart';
import '../../providers/state_provider.dart';
import '../../providers/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool editing = false;
  String path;

  @override
  Widget build(BuildContext context) {
    return ProfileProvider(
      stateBloc: StateProvider.stateBloc(context),
      database: ApplicationProvider.database(context),
      storage: ApplicationProvider.storage(context),
      localization: ApplicationProvider.localization(context),
      child: ProfileScaffold(
        appBar: ProfileBar(
          nameController: nameController,
          descriptionController: descriptionController,
          editing: editing,
          edit: edit,
          path: path,
        ),
        body: ProfileBody(
          nameController: nameController,
          descriptionController: descriptionController,
          editing: editing,
          upload: upload,
          path: path,
        ),
      ),
    );
  }

  void edit(bool editing) {
    setState(() {
      this.editing = editing;
      if (!editing) this.path = null;
    });
  }

  void upload(String path) {
    setState(() {
      this.path = path;
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }
}

class ProfileScaffold extends BaseScaffold<ProfileInherited> {
  ProfileScaffold({
    Key key,
    PreferredSizeWidget appBar,
    Widget body,
    Widget floatingActionButton,
    FloatingActionButtonLocation floatingActionButtonLocation,
    FloatingActionButtonAnimator floatingActionButtonAnimator,
    List<Widget> persistentFooterButtons,
    Widget drawer,
    Widget endDrawer,
    Widget bottomNavigationBar,
    Widget bottomSheet,
    Color backgroundColor,
    bool resizeToAvoidBottomPadding,
    bool resizeToAvoidBottomInset,
    bool primary = true,
    DragStartBehavior drawerDragStartBehavior = DragStartBehavior.start,
    bool extendBody = false,
    Color drawerScrimColor,
    double drawerEdgeDragWidth,
    ShowFunction showFunction,
  }) : super(
    key: key,
    appBar: appBar,
    body: body,
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: floatingActionButtonLocation,
    floatingActionButtonAnimator: floatingActionButtonAnimator,
    persistentFooterButtons: persistentFooterButtons,
    drawer: drawer,
    endDrawer: endDrawer,
    bottomNavigationBar: bottomNavigationBar,
    bottomSheet: bottomSheet,
    backgroundColor: backgroundColor,
    resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    primary: primary,
    drawerDragStartBehavior: drawerDragStartBehavior,
    extendBody: extendBody,
    drawerScrimColor: drawerScrimColor,
    drawerEdgeDragWidth: drawerEdgeDragWidth,
    showFunction: showFunction,
  );
}
