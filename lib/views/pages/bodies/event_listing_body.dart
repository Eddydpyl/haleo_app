import 'package:flutter/material.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/user_events_provider.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';
import '../../pages/chat_page.dart';
import '../../../utility.dart';

class EventListingBody extends StatefulWidget {
  @override
  _EventListingBodyState createState() => _EventListingBodyState();
}

class _EventListingBodyState extends State<EventListingBody> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserEventsProvider.eventsBloc(context).eventsStream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          List<String> sorted = List.from(events.keys)
            ..sort((String a, String b) =>
                events[b].lastMessage?.compareTo(events[a].lastMessage ?? "") ??
                -1);
          if (sorted.isNotEmpty) {
            return ListView(
                children: sorted
                    .map((String key) =>
                        EventTile(eventKey: key, event: events[key]))
                    .toList());
          } else
            return EmptyWidget();
        } else {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
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

  String _randomImage(String eventName) {
    int assetNumber = eventName.length % 6;
    String asset = 'assets/images/event_' + assetNumber.toString() + ".png";
    return asset;
  }

  @override
  Widget build(BuildContext context) {
    final String lastRead =
        ApplicationProvider.preferences(context).lastRead(eventKey).getValue();
    final bool hasMessages = event.lastMessage?.isNotEmpty ?? false;
    final bool unread = hasMessages &&
        (lastRead.isEmpty ||
            DateUtility.parseDate(lastRead)
                .isBefore(DateUtility.parseDate(event.lastMessage)));
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
            asset: _randomImage(event.name),
            height: 64,
            width: 64,
          ),
          trailing: unread
              ? Container(
                  width: 16,
                  height: 16,
                  decoration: new BoxDecoration(
                    color: Colors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                )
              : Container(
                  width: 16,
                  height: 16,
                  decoration: new BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
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
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/having_fun.png'),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '¡Ooops! \n Aun no se ha llenado ningún evento. ¡Sigue haciendo swipe right!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
