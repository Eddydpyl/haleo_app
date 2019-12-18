import 'package:darter_base/darter_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'bodies/session_body.dart';
import '../../providers/application_provider.dart';
import '../../providers/session_provider.dart';

class SessionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SessionProvider(
      auth: ApplicationProvider.auth(context),
      database: ApplicationProvider.database(context),
      localization: ApplicationProvider.localization(context),
      child: SessionScaffold(
        resizeToAvoidBottomInset: false,
        body: SessionBody(),
      ),
    );
  }
}

class SessionScaffold extends BaseScaffold<SessionInherited> {
  SessionScaffold({
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