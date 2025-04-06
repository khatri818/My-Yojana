import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String? label;
  final void Function() onPressed;

  const CommonButton({super.key, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        // margin: const EdgeInsets.symmetric(horizontal: 20.0),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).hintColor,
        ),
        child: Text(
          label!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}



class CommonButton1 extends StatelessWidget {
  final String? label;
  final void Function() onPressed;

  const CommonButton1(
      {super.key, required this.label, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xff35b4fb)),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: SizedBox(
          width: 214,
          height: 43,
          child: Center(
            child: Text(
              label!,
              style: const TextStyle(
                color: Color(0xff35b4fb),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
