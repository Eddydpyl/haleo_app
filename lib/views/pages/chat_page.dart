import 'package:darter_base/darter_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'bars/chat_bar.dart';
import 'bodies/chat_body.dart';
import '../../providers/application_provider.dart';
import '../../providers/state_provider.dart';
import '../../providers/chat_provider.dart';

class ChatPage extends StatelessWidget {
  final String eventKey;

  ChatPage(this.eventKey);

  @override
  Widget build(BuildContext context) {
    return ChatProvider(
      stateBloc: StateProvider.stateBloc(context),
      database: ApplicationProvider.database(context),
      eventKey: eventKey,
      child: Builder(
        builder: (BuildContext context) {
          return StreamBuilder(
            stream: ChatProvider.eventBloc(context).eventStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return ChatScaffold(
                  appBar: ChatBar(snapshot.data.value),
                  body: ChatBody(eventKey),
                );
              } else return Container();
            },
          );
        },
      ),
    );
  }
}

class ChatScaffold extends BaseScaffold<ChatInherited> {
  ChatScaffold({
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