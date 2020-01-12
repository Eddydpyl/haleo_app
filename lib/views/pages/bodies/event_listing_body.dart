import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:haleo_app/models/user.dart';
import 'package:haleo_app/views/custom_icons.dart';
import 'package:share/share.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/user_events_provider.dart';
import '../../../blocs/user_events_bloc.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';
import '../../pages/chat_page.dart';
import '../../../utility.dart';
import '../../../localization.dart';

class EventListingBody extends StatefulWidget {
  @override
  _EventListingBodyState createState() => _EventListingBodyState();
}

class _EventListingBodyState extends State<EventListingBody> {
  @override
  Widget build(BuildContext context) {
    final Localization localization = ApplicationProvider.localization(context);
    return StreamBuilder(
      stream: UserEventsProvider.eventsBloc(context).eventsStream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          final List<String> sorted = List.from(events.keys)
            ..sort((String a, String b) =>
                events[b].lastMessage?.compareTo(events[a].lastMessage ?? "") ??
                -1);
          if (sorted.isNotEmpty) {
            return ListView(
                children: sorted
                    .map((String key) => EventTile(
                          localization: localization,
                          eventKey: key,
                          event: events[key],
                        ))
                    .toList());
          } else
            return EmptyWidget(localization);
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
  final Localization localization;
  // TODO: we need to show the users here too
  //final Map<String, User> users;
  final String eventKey;
  final Event event;

  EventTile({
    @required this.localization,
    //@required this.users,
    @required this.eventKey,
    @required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final String lastRead =
        ApplicationProvider.preferences(context).lastRead(eventKey).getValue();
    final bool hasMessages = event.lastMessage?.isNotEmpty ?? false;
    final bool unread = hasMessages &&
        (lastRead.isEmpty ||
            DateUtility.parseDate(lastRead)
                .isBefore(DateUtility.parseDate(event.lastMessage)));
    final UserEventsBloc userEventsBloc =
        UserEventsProvider.eventsBloc(context);

// TODO: maybe move Tile ui when hooked up to a function for open and closed events
    return (event.count >= event.slots)
        ? Column(
            children: <Widget>[
              SizedBox(height: 4.0),
              ExpansionTile(
                  backgroundColor: Colors.white,
                  leading: CardImage(
                    image: event.image,
                    asset: randomImage(event.name),
                    height: 64,
                    width: 64,
                  ),
                  title: Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      !unread
                          ? Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(width: 0.0),
                      FlatButton(
                        padding: EdgeInsets.only(left: 16.0),
                        shape: CircleBorder(),
                        child: PaintGradient(
                          child: Icon(CustomIcons.chat),
                          colorA: Color(0xfffa6b40),
                          colorB: Color(0xfffd1d1d),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChatPage(eventKey),
                          ));
                        },
                      ),
                    ],
                  ),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            event.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color(0xFF424242),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              event.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                  // TODO: add users
                  /*..addAll(event.attendees
                .map((String key) => userTile(context, users[key])))
            ..add(SizedBox(height: 16.0)),*/
                  ),
              //TODO: this would go inside the expansion tile
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  shape: CircleBorder(),
                  child: PaintGradient(
                    child: Icon(Icons.exit_to_app),
                    colorA: Color(0xfffa6b40),
                    colorB: Color(0xfffd1d1d),
                  ),
                  onPressed: () {
                    leaveDialog(context, eventKey, event, userEventsBloc);
                  },
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
            ],
          )
        : Column(
            children: <Widget>[
              SizedBox(height: 4.0),
              ExpansionTile(
                  backgroundColor: Colors.white,
                  leading: CardImage(
                    image: event.image,
                    asset: randomImage(event.name),
                    height: 64,
                    width: 64,
                  ),
                  title: Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        event.count.toString() + " / " + event.slots.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      FlatButton(
                        padding: EdgeInsets.only(left: 16.0),
                        shape: CircleBorder(),
                        child: PaintGradient(
                          child: Icon(Icons.share),
                          colorA: Color(0xff7474bf),
                          colorB: Color(0xff348ac7),
                        ),
                        onPressed: () {
                          Share.share(localization.shareText(event.name,
                              event.description)); // TODO: Google Play link.
                        },
                      ),
                    ],
                  ),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            event.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Color(0xFF424242),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              event.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                  //TODO:
                  /*..addAll(event.attendees
                      .map((String key) => userTile(context, users[key])))
                  ..add(SizedBox(height: 16.0)),*/
                  ),
              SizedBox(
                height: 4.0,
              ),
            ],
          );

    /*    
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
              unread
                  ? Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(width: 0.0),
              FlatButton(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(Icons.cancel, color: Colors.redAccent),
                onPressed: () =>
                    leaveDialog(context, eventKey, event, userEventsBloc),
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
    );*/
  }

  Widget userTile(BuildContext context, User user) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: (user.image?.isNotEmpty ?? false)
              ? TransitionToImage(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(24.0),
                  placeholder: InitialsText(user.name),
                  loadingWidget: InitialsText(user.name),
                  image: AdvancedNetworkImage(
                    user.image,
                    useDiskCache: true,
                    timeoutDuration: Duration(seconds: 5),
                  ),
                )
              : InitialsText(user.name),
        ),
        title: Text(user.name ?? ""),
        subtitle: Text(user.description ?? ""),
      ),
    );
  }

  String randomImage(String eventName) {
    int assetNumber = eventName.length % 6;
    String asset = "assets/images/event_" + assetNumber.toString() + ".png";
    return asset;
  }

  void leaveDialog(BuildContext context, String key, Event event,
      UserEventsBloc userEventsBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            localization.eventExitText(event.name),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          content: Text(localization.exitPromtText()),
          actions: <Widget>[
            FlatButton(
              child: Text(
                localization.exitNoText(),
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
                localization.exitYesText(),
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
  final Localization localization;

  EmptyWidget(this.localization);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/having_fun.png"),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              localization.eventEmptyFilledText(),
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
