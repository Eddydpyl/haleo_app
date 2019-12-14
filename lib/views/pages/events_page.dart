import 'package:flutter/material.dart';

import 'bars/events_bar.dart';
import 'bodies/events_body.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EventsBar(),
      body: EventsBody(),
    );
  }
}
