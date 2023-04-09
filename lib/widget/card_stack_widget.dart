import 'dart:async';
import 'package:chuck_norris_tinder/model/user.dart';
import 'package:chuck_norris_tinder/services/services_assembly.dart';
import 'package:chuck_norris_tinder/widget/drag_widget.dart';
import 'package:chuck_norris_tinder/widget/favorite_jokes_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'dart:math';

class CardsStackWidget extends ConsumerStatefulWidget {
  const CardsStackWidget({super.key});

  @override
  ConsumerState<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends ConsumerState<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  final List<Future<User>> items = [];
  final List<String> images = [];
  late DragWidget _first;
  late DragWidget _second;

  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;
  final _random = Random();

  void addCard() {
    if (items.length < 3) {
      for (int i = 0; i < 10; i++) {
        items.insert(
            0,
            ref.read(networkProvider).getUserData(
                Uri.parse('https://api.chucknorris.io/jokes/random')));
        images.insert(0, getRandomImageName());
      }
    }
  }

  String getRandomImageName() {
    int min = 1;
    int max = 4;
    int idx = min + _random.nextInt(max - min);
    return 'assets/chuck_norris$idx.jpg';
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        items.removeLast();
        images.removeLast();

        _first = DragWidget(
            user: items[items.length - 1],
            index: items.length - 1,
            swipeNotifier: swipeNotifier,
            imageName: images[images.length - 1]);
        _second = DragWidget(
            user: items[items.length - 2],
            index: items.length - 2,
            swipeNotifier: swipeNotifier,
            imageName: images[images.length - 2]);

        _animationController.reset();
        swipeNotifier.value = Swipe.none;
        addCard();
      }
    });
    // Add cards
    addCard();
  }

  @override
  Widget build(BuildContext context) {
    _first = DragWidget(
        user: items[items.length - 1],
        index: items.length - 1,
        swipeNotifier: swipeNotifier,
        imageName: images[images.length - 1]);
    _second = DragWidget(
        user: items[items.length - 2],
        index: items.length - 2,
        swipeNotifier: swipeNotifier,
        imageName: images[images.length - 2]);

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.orangeAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(top: 16, left: 0, right: 0, child: buildCards()),
                  Positioned(
                      bottom: 26, left: 0, right: 0, child: buildButtons()),
                  Positioned(left: 0, child: buildDragTarget(false)),
                  Positioned(right: 0, child: buildDragTarget(true)),
                ],
              )),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() => AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: buildLogo(),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return const FavoriteJokesListScreen();
                    },
                  ));
                },
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 26.0,
                  color: Colors.pinkAccent,
                ),
              ))
        ],
      );

  Widget buildLogo() => Text(
        "main-title".i18n(),
        style: const TextStyle(
          fontSize: 30,
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget buildCards() => ClipRRect(
        child: ValueListenableBuilder(
          valueListenable: swipeNotifier,
          builder: (context, swipe, _) => Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _second,
              PositionedTransition(
                rect: RelativeRectTween(
                  begin: RelativeRect.fromSize(
                      const Rect.fromLTWH(0, 0, 580, 340),
                      const Size(580, 340)),
                  end: RelativeRect.fromSize(
                      Rect.fromLTWH(
                          swipe != Swipe.none
                              ? swipe == Swipe.left
                                  ? -300
                                  : 300
                              : 0,
                          0,
                          580,
                          340),
                      const Size(580, 340)),
                ).animate(CurvedAnimation(
                    parent: _animationController, curve: Curves.easeInOut)),
                child: RotationTransition(
                    turns: Tween<double>(
                            begin: 0,
                            end: swipe != Swipe.none
                                ? swipe == Swipe.left
                                    ? -0.1 * 0.3
                                    : 0.1 * 0.3
                                : 0.0)
                        .animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0, 0.4, curve: Curves.easeInOut),
                      ),
                    ),
                    child: _first),
              )
            ],
          ),
        ),
      );

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            child: const Icon(
              Icons.clear_rounded,
              color: Colors.redAccent,
              size: 35,
            ),
            onPressed: () {
              swipeNotifier.value = Swipe.left;
              _animationController.forward();
            },
          ),
          ElevatedButton(
            child: const Icon(
              Icons.favorite_rounded,
              color: Colors.pinkAccent,
              size: 35,
            ),
            onPressed: () {
              swipeNotifier.value = Swipe.right;
              ref.read(firestoreProvider).saveInfo(user: _first.user);
              _animationController.forward();
            },
          )
        ],
      );

  Widget buildDragTarget(bool saveInfo) => DragTarget<int>(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return IgnorePointer(
            child: Container(
              height: 700.0,
              width: 300.0,
              color: Colors.transparent,
            ),
          );
        },
        onAccept: (int index) {
          setState(() {
            items.removeLast();
            images.removeLast();
            addCard();

            if (saveInfo) {
              ref.read(firestoreProvider).saveInfo(user: _first.user);
            }

            _first = DragWidget(
                user: items[items.length - 1],
                index: items.length - 1,
                swipeNotifier: swipeNotifier,
                imageName: images[images.length - 1]);
            _second = DragWidget(
                user: items[items.length - 2],
                index: items.length - 2,
                swipeNotifier: swipeNotifier,
                imageName: images[images.length - 2]);
          });
        },
      );
}
