import 'package:flutter/material.dart';

class Results extends StatelessWidget {
  const Results(
      {super.key,
      required this.numberOfTotalAnswers,
      required this.numberOfCorrectAnswers});
  final int numberOfTotalAnswers;
  final int numberOfCorrectAnswers;
  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          children: [
            Text(
              'Quiz Finished!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Number of questions: $numberOfTotalAnswers',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            Text(
              'Number of correct answers: $numberOfCorrectAnswers',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            Text(
              'Number of wrong answers: ${numberOfTotalAnswers - numberOfCorrectAnswers}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
