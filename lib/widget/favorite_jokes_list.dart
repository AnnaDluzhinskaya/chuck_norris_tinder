import 'package:chuck_norris_tinder/widget/favorite_joke_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import '../services/services_assembly.dart';

class FavoriteJokesListScreen extends ConsumerWidget {
  const FavoriteJokesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jokesStream = ref.read(firestoreProvider).getJokes();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "favorite-jokes".i18n(),
            style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 25.0,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: const IconThemeData(
            color: Colors.orangeAccent,
          ),
        ),
        body: StreamBuilder(
          stream: jokesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Error occurred");
            } else if (snapshot.hasData) {
              final jokes = snapshot.data!;
              return SizedBox(
                height: double.infinity,
                child: ListView.separated(
                  padding: const EdgeInsets.only(top: 12),
                  shrinkWrap: true,
                  itemCount: jokes.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [FavoriteJokeCard(info: jokes[index])],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 12,
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
