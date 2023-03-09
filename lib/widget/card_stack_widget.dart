import 'package:chuck_norris_tinder/model/user.dart';
import 'package:chuck_norris_tinder/widget/drag_widget.dart';
import 'package:flutter/material.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({super.key});

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget> with SingleTickerProviderStateMixin {
  final List<User> items = [User(description: "4 Test test test test"),
    User(description: "3 Test test test test"), User(description: "2 Test test test test"), User(description: "1 Test test test test")
  ];
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;

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
        _animationController.reset();
        swipeNotifier.value = Swipe.none;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: buildLogo()
        ),
        Positioned(
          top: 65,
          left: 0,
          right: 0,
          child: buildCards()),
        Positioned(
          bottom: 26,
          left: 0,
          right: 0,
          child: buildButtons()
        ),
        Positioned(
          left: 0,
          child: buildDragTarget()
        ),
        Positioned(
          right: 0,
          child: buildDragTarget()
        ),
      ],
    );
  }

  Widget buildLogo() => Row(
    children: const [
      Spacer(),
      Text(
        "Chuck Norris's Jokes",
        style: TextStyle(
          fontSize: 30,
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      Spacer()
    ],
  );

  Widget buildCards() => ClipRRect(
    child: ValueListenableBuilder(
      valueListenable: swipeNotifier,
      builder: (context, swipe, _) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: List.generate(items.length, (index) {
          if (index == items.length - 1) {
            return PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                    const Rect.fromLTWH(0, 0, 580, 340),
                    const Size(580, 340)),
                end: RelativeRect.fromSize(
                    Rect.fromLTWH(
                        swipe != Swipe.none ? swipe == Swipe.left ? -300 : 300 : 0,
                        0,
                        580,
                        340),
                    const Size(580, 340)),
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOut
              )),
              child: RotationTransition(
                turns: Tween<double>(
                    begin: 0,
                    end: swipe != Swipe.none ? swipe == Swipe.left ? -0.1 * 0.3 : 0.1 * 0.3 : 0.0)
                    .animate(CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0, 0.4, curve: Curves.easeInOut),
                  ),
                ),
                child: DragWidget(
                  user: items[index],
                  index: index,
                  swipeNotifier: swipeNotifier,
                  isLastCard: true,
                ),
              ),
            );
          } else {
            return DragWidget(
              user: items[index],
              index: index,
              swipeNotifier: swipeNotifier,
            );
          }
        }),
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
          _animationController.forward();
        },
      )
    ],
  );

  Widget buildDragTarget() => DragTarget<int>(
    builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
        ) {
      return IgnorePointer(
        child: Container(
          height: 700.0,
          width: 130.0,
          color: Colors.transparent,
        ),
      );
    },
    onAccept: (int index) {
      setState(() {
        items.removeAt(index);
      });
    },
  );
}