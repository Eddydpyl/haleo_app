import 'package:darter_base/darter_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'bars/events_create_bar.dart';
import 'bodies/events_create_body.dart';
import '../../providers/application_provider.dart';
import '../../providers/events_provider.dart';

class EventsCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EventsProvider(
      database: ApplicationProvider.database(context),
      preferences: ApplicationProvider.preferences(context),
      localization: ApplicationProvider.localization(context),
      child: EventsScaffold(
        appBar: EventsCreateBar(),
        body: EventsCreateBody(),
      ),
    );
  }
}

class EventsScaffold extends BaseScaffold<EventsInherited> {
  EventsScaffold({
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