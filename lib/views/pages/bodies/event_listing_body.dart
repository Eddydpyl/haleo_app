import 'package:flutter/material.dart';
import 'package:haleo_app/blocs/user_events_bloc.dart';

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
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          final List<String> sorted = List.from(events.keys)
            ..sort((String a, String b) => events[b].lastMessage
                ?.compareTo(events[a].lastMessage ?? "") ?? -1);
          if (sorted.isNotEmpty) {
            return ListView(children: sorted.map((String key) =>
                EventTile(eventKey: key, event: events[key])).toList());
          } else return EmptyWidget();
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

  @override
  Widget build(BuildContext context) {
    final String lastRead = ApplicationProvider
        .preferences(context).lastRead(eventKey).getValue();
    final bool hasMessages = event.lastMessage?.isNotEmpty ?? false;
    final bool unread = hasMessages && (lastRead.isEmpty || DateUtility
        .parseDate(lastRead).isBefore(DateUtility.parseDate(event.lastMessage)));
    final UserEventsBloc userEventsBloc = UserEventsProvider.eventsBloc(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 4.0,
        ),
        ListTile(
          title: Text(
            event.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CardImage(
            image: event.image,
            asset: randomImage(event.name),
            height: 64,
            width: 64,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              unread ? Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  shape: BoxShape.circle,
                ),
              ) : Container(width: 0.0),
              FlatButton(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(Icons.cancel, color: Colors.redAccent),
                onPressed: () => leaveDialog(context,
                    eventKey, event, userEventsBloc),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ChatPage(eventKey),
            ));
          },
        ),
        SizedBox(
          height: 4.0,
        ),
        Divider(),
      ],
    );
  }

  String randomImage(String eventName) {
    int assetNumber = eventName.length % 6;
    String asset = 'assets/images/event_' + assetNumber.toString() + ".png";
    return asset;
  }

  void leaveDialog(BuildContext context, String key,
      Event event, UserEventsBloc userEventsBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Salir de " + event.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          content: Text("¿Seguro que quieres abandonar este evento?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "¡NO!",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "¡SÍ!",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16.0,
                ),
              ),
              onPressed: () {
                userEventsBloc.leaveSink.add(eventKey);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
