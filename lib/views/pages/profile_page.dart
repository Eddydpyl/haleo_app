import 'package:flutter/material.dart';
import 'package:darter_base/darter_base.dart';
import 'package:flutter/gestures.dart';
import 'package:haleo_app/views/pages/bodies/profile_body.dart';

import 'bars/profile_bar.dart';
import '../../providers/application_provider.dart';
import '../../providers/state_provider.dart';
import '../../providers/user_events_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserEventsProvider(
      stateBloc: StateProvider.stateBloc(context),
      database: ApplicationProvider.database(context),
      child: EventListingScaffold(
        appBar: ProfileBar(),
        body: ProfileBody(),
      ),
    );
  }
}

class EventListingScaffold extends BaseScaffold<UserEventsInherited> {
  EventListingScaffold({
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
