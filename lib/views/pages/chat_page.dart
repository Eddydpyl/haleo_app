import 'package:flutter/material.dart';
import 'package:darter_base/darter_base.dart';
import 'package:flutter/gestures.dart';

import 'bars/chat_bar.dart';
import 'bodies/chat_body.dart';
import '../../providers/application_provider.dart';
import '../../providers/events_provider.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: change to appropiate provider and scaffold
    return Scaffold(
      appBar: ChatBar(),
      body: ChatBody(),
    );
  }
}
