import 'package:flutter/material.dart';
import 'package:chuck_norris_tinder/model/user.dart';
import 'package:localization/localization.dart';

class JokeCard extends StatelessWidget {
  final Future<User> user;
  final String imageName;

  const JokeCard({super.key, required this.user, required this.imageName});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage(imageName),
              fit: BoxFit.cover,
              alignment: const Alignment(0, 0),
            )),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1],
              )),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Spacer(),
                  buildName(),
                  const SizedBox(height: 16),
                  buildDescription(context),
                ],
              ),
            )),
      );

  Widget buildName() => Row(
        children: [
          Text(
            "name".i18n(),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget buildDescription(BuildContext context) => Row(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: FutureBuilder<User>(
                future: user,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Text(
                          snapshot.data!.description,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        )
                      : const Text("...");
                },
              ))
        ],
      );
}
