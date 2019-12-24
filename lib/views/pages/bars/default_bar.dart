import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../../models/user.dart';
import '../../common_widgets.dart';

class DefaultBar extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final String userKey;
  final User user;

  DefaultBar({
    @required this.title,
    @required this.leading,
    @required this.userKey,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: leading,
      centerTitle: true,
      title: title,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            width: 32.0,
            height: 32.0,
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfffa6b40), Color(0xfffd1d1d)],
              ),
            ),
            child: GestureDetector(
              child: (user.image?.isNotEmpty ?? false)
                  ? CircleAvatar(
                      radius: 22.0,
                      backgroundColor: Colors.white,
                      child: TransitionToImage(
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(22.0),
                        placeholder: InitialsText(user.name),
                        loadingWidget: InitialsText(user.name),
                        image: AdvancedNetworkImage(
                          user.image,
                          useDiskCache: true,
                          timeoutDuration: Duration(seconds: 5),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 22.0,
                      backgroundColor: Colors.white,
                      child: InitialsText(user.name),
                    ),
              onTap: () {
                // TODO: Navigate to user profile.
              },
            ),
          ),
        ),
      ],
    );
  }
}
