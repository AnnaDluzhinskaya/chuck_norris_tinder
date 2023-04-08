import 'package:chuck_norris_tinder/model/user.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class FavoriteJokeCard extends StatelessWidget {
  final User info;

  const FavoriteJokeCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: kElevationToShadow[4],
        ),
        width: MediaQuery.of(context).size.width - 32,
        child: Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: IntrinsicHeight(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(),
                    const SizedBox(height: 6),
                    buildDescription()
                  ],
                ),
              )
            )
        )
    );
  }

  Widget buildTitle() {
    return Text(
      "name".i18n(),
      style: const TextStyle(
        color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w400
      )
    );
  }

  Widget buildDescription() {
    return Text(
      info.description,
      overflow: TextOverflow.ellipsis,
      maxLines: 5,
      style: const TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
          fontWeight: FontWeight.w400
      )
    );
  }
}
