import 'package:darter_base/darter_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'bars/event_admin_bar.dart';
import 'bodies/event_admin_body.dart';
import '../../providers/application_provider.dart';
import '../../providers/state_provider.dart';
import '../../providers/event_admin_provider.dart';
import '../../models/event.dart';

class EventAdminPage extends StatelessWidget {
  final String eventKey;
  final Event event;

  EventAdminPage({this.eventKey, this.event})
      : assert((eventKey != null && event != null)
      || (eventKey == null && event == null));

  @override
  Widget build(BuildContext context) {
    return EventAdminProvider(
      stateBloc: StateProvider.stateBloc(context),
      database: ApplicationProvider.database(context),
      messaging: ApplicationProvider.messaging(context),
      storage: ApplicationProvider.storage(context),
      localization: ApplicationProvider.localization(context),
      child: EventAdminScaffold(
        appBar: EventAdminBar(),
        body: EventAdminBody(eventKey, event),
      ),
    );
  }
}

class EventAdminScaffold extends BaseScaffold<EventAdminInherited> {
  EventAdminScaffold({
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