import 'package:chuck_norris_tinder/widget/card.dart';
import 'package:chuck_norris_tinder/model/user.dart';
import 'package:flutter/material.dart';

enum Swipe { left, right, none }

class DragWidget extends StatefulWidget {
  final Future<User> user;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;
  final bool isLastCard;
  final String imageName;

  const DragWidget(
      {super.key,
      required this.user,
      required this.index,
      required this.swipeNotifier,
      this.isLastCard = false,
      required this.imageName});

  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);

  @override
  Widget build(BuildContext context) => Center(
        child: Draggable<int>(
          data: widget.index,
          feedback: Material(
            color: Colors.transparent,
            child: ValueListenableBuilder(
              valueListenable: swipeNotifier,
              builder: (context, swipe, _) {
                return RotationTransition(
                  turns: swipe != Swipe.none
                      ? swipe == Swipe.left
                          ? const AlwaysStoppedAnimation(-15 / 360)
                          : const AlwaysStoppedAnimation(15 / 360)
                      : const AlwaysStoppedAnimation(0),
                  child: Stack(
                    children: [
                      JokeCard(user: widget.user, imageName: widget.imageName),
                      swipe != Swipe.none
                          ? swipe == Swipe.right
                              ? Positioned(
                                  top: 40,
                                  left: 20,
                                  child: Transform.rotate(
                                    angle: 12,
                                  ),
                                )
                              : Positioned(
                                  top: 50,
                                  right: 24,
                                  child: Transform.rotate(
                                    angle: -12,
                                  ),
                                )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              },
            ),
          ),
          onDragUpdate: (DragUpdateDetails dragUpdateDetails) {
            // When Draggable widget is dragged right
            if (dragUpdateDetails.delta.dx > 0 &&
                dragUpdateDetails.globalPosition.dx >
                    MediaQuery.of(context).size.width / 2) {
              swipeNotifier.value = Swipe.right;
            }
            // When Draggable widget is dragged left
            if (dragUpdateDetails.delta.dx < 0 &&
                dragUpdateDetails.globalPosition.dx <
                    MediaQuery.of(context).size.width / 2) {
              swipeNotifier.value = Swipe.left;
            }
          },
          onDragEnd: (drag) {
            swipeNotifier.value = Swipe.none;
          },
          childWhenDragging: Container(
            color: Colors.transparent,
          ),
          child: JokeCard(user: widget.user, imageName: widget.imageName),
        ),
      );
}
