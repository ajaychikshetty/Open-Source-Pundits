import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimatedButton extends StatelessWidget {
  bool correctpass = true;

  AnimationController controller;
  Animation<double> width;
  Animation<double> height;
  Animation<double> radius;
  Animation<double> opacityy;

  AnimatedButton({super.key, required this.controller})
      : width = Tween<double>(
          begin: 0,
          end: 500,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.0, 0.5),
          ),
        ),
        height = Tween<double>(
          begin: 0,
          end: 50,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.5, 0.7),
          ),
        ),
        radius = Tween<double>(
          begin: 0,
          end: 20,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.6, 1.0),
          ),
        ),
        opacityy = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.6, 0.8),
          ),
        );

  Widget _buildAnimation(BuildContext context, Widget? widget) {
    return InkWell(
      onTap: () {
        // if (correctpass == true) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => HomePage(),
        //     ),
        //   );
        // }
      },
      child: Container(
        width: width.value,
        height: height.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius.value),
          gradient: const LinearGradient(
            colors: [
              Color(0xff132137),
              Color(0xff132137),
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: opacityy,
            child: const Text(
              "Enter",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
