import 'package:flutter/material.dart';
import 'package:haleo_app/providers/user_events_provider.dart';

import '../../../models/event.dart';
import '../../common_widgets.dart';
import '../../pages/chat_page.dart';

class EventListingBody extends StatefulWidget {
  @override
  _EventListingBodyState createState() => _EventListingBodyState();
}

class _EventListingBodyState extends State<EventListingBody> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserEventsProvider.eventsBloc(context).eventsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          if (events.isNotEmpty) {
            return ListView(children: events.keys.map((String key) =>
                EventTile(eventKey: key, event: events[key])).toList());
          } else return EmptyWidget();
        } else return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}

class EventTile extends StatelessWidget {
  final String eventKey;
  final Event event;

  EventTile({
    @required this.eventKey,
    @required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        ListTile(
          title: Text(
            event.name,
            maxLines: 1,
          ),
          subtitle: Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CardImage(
            image: event.image,
            height: 64,
            width: 64,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChatPage(eventKey),
            ));
          },
        ),
        Divider(),
        SizedBox(
          height: 8.0,
        )
      ],
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No hay eventos",
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}

