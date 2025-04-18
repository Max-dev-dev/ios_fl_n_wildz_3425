import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/archive_cubit/archive_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/models/nature_model.dart';

class GameQuizzScreen extends StatefulWidget {
  const GameQuizzScreen({super.key});

  @override
  State<GameQuizzScreen> createState() => _GameQuizzScreenState();
}

class _GameQuizzScreenState extends State<GameQuizzScreen> {
  int _currentQuestion = 0;
  final Map<NatureModel, int> _scores = {};
  NatureModel? _result;
  AnswerOption? _selectedAnswer;

  final List<NatureModel> natures = [
    NatureModel(
      name: '🌳 Forest shadow',
      key: 'Key traits: Stability, solitude, connection to the earth',
      image: 'assets/images/natures/1.png',
    ),
    NatureModel(
      name: '🏜️ Dry Plain',
      key: 'Key traits: Freedom, minimalism, love of space',
      image: 'assets/images/natures/2.png',
    ),
    NatureModel(
      name: '🌫️ Foggy Peak',
      key: 'Key traits: Striving for heights, volatility, love of risk',
      image: 'assets/images/natures/3.png',
    ),
    NatureModel(
      name: '🌊 Sea Abyss',
      key: 'Key traits: Depth, emotionality, mystery',
      image: 'assets/images/natures/4.png',
    ),
  ];

  late final List<Question> questions = [
    Question(
      question: 'Where are you going if you dont think?',
      answers: [
        AnswerOption(
          text: 'Into the forest where the leaves rustle',
          nature: natures[0],
        ),
        AnswerOption(
          text: 'To a deserted road under the sun',
          nature: natures[1],
        ),
        AnswerOption(
          text: 'To the water where the waves splash',
          nature: natures[3],
        ),
        AnswerOption(
          text: 'To the mountains where the fog hides the peaks',
          nature: natures[2],
        ),
      ],
    ),
    Question(
      question: 'What sound soothes you?',
      answers: [
        AnswerOption(text: 'The rustling of trees', nature: natures[0]),
        AnswerOption(
          text: 'The dry whisper of wind on sand',
          nature: natures[1],
        ),
        AnswerOption(text: 'The echo in the mountains', nature: natures[2]),
        AnswerOption(text: 'The crashing of ocean waves', nature: natures[3]),
      ],
    ),
    Question(
      question: 'Which will you choose: the open horizon or the cozy shade?',
      answers: [
        AnswerOption(text: 'Cozy forest shade', nature: natures[0]),
        AnswerOption(text: 'Open plain horizon', nature: natures[1]),
        AnswerOption(text: 'High mountain path', nature: natures[2]),
        AnswerOption(text: 'Misty sea coast', nature: natures[3]),
      ],
    ),
    Question(
      question: 'Your perfect day?',
      answers: [
        AnswerOption(text: 'Reading in the woods', nature: natures[0]),
        AnswerOption(text: 'Wandering the desert alone', nature: natures[1]),
        AnswerOption(
          text: 'Climbing and conquering heights',
          nature: natures[2],
        ),
        AnswerOption(text: 'Swimming in deep waters', nature: natures[3]),
      ],
    ),
    Question(
      question: 'What’s more important: stability or movement?',
      answers: [
        AnswerOption(text: 'Stability and peace of forest', nature: natures[0]),
        AnswerOption(
          text: 'Freedom and movement in desert',
          nature: natures[1],
        ),
        AnswerOption(text: 'Constant striving for more', nature: natures[2]),
        AnswerOption(text: 'Inner flow and mystery', nature: natures[3]),
      ],
    ),
    Question(
      question: 'What element do you feel in yourself?',
      answers: [
        AnswerOption(text: 'Earth and roots', nature: natures[0]),
        AnswerOption(text: 'Air and sun', nature: natures[1]),
        AnswerOption(text: 'Stone and heights', nature: natures[2]),
        AnswerOption(text: 'Water and depth', nature: natures[3]),
      ],
    ),
    Question(
      question: 'Your state after a long day?',
      answers: [
        AnswerOption(text: 'Lying under the trees', nature: natures[0]),
        AnswerOption(
          text: 'Sitting in silence under the sun',
          nature: natures[1],
        ),
        AnswerOption(
          text: 'Looking at the peaks in the distance',
          nature: natures[2],
        ),
        AnswerOption(text: 'Listening to sea sounds', nature: natures[3]),
      ],
    ),
    Question(
      question: 'What will you leave behind on the trail?',
      answers: [
        AnswerOption(text: 'A carved tree symbol', nature: natures[0]),
        AnswerOption(text: 'Footprints on sand', nature: natures[1]),
        AnswerOption(text: 'Echoes from the rocks', nature: natures[2]),
        AnswerOption(text: 'A ripple on the water', nature: natures[3]),
      ],
    ),
  ];

  void _nextQuestion() {
    setState(() {
      if (_selectedAnswer != null) {
        _scores[_selectedAnswer!.nature] =
            (_scores[_selectedAnswer!.nature] ?? 0) + 1;
        if (_currentQuestion < questions.length - 1) {
          _currentQuestion++;
          _selectedAnswer = null;
        } else {
          _result =
              _scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
        }
      }
    });
  }

  void _restartGame() {
    setState(() {
      _currentQuestion = 0;
      _scores.clear();
      _result = null;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/game_background.png',
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _result == null ? _buildQuestion() : _buildResult(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    final question = questions[_currentQuestion];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_currentQuestion + 1}/${questions.length}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/images/leave_button_icon.png',
                width: 50,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          question.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 20),
        ...question.answers.map(
          (answer) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAnswer = answer;
                });
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF79A54E),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color:
                        _selectedAnswer == answer
                            ? Color(0xFFFEFE00)
                            : Colors.transparent,
                    width: 4,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                child: Text(
                  answer.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 70),
        Opacity(
          opacity: _selectedAnswer != null ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: _selectedAnswer == null,
            child: Container(
              height: 60.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFAFACB),
                    Color(0xFFFFFF8E),
                    Color(0xFFFFFF73),
                    Color(0xFFCCCC05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  minimumSize: const Size(180, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF412786),
                    fontSize: 16,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    final nature = _result!;
    return Column(
      children: [
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF5F813D),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Text(
                nature.name,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  nature.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                nature.key,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 60.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFAFACB),
                      Color(0xFFFFFF8E),
                      Color(0xFFFFFF73),
                      Color(0xFFCCCC05),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton(
                  onPressed: () => _saveToArchive(nature),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: const Size(180, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Save to archive',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF412786),
                      fontSize: 16,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                'assets/images/leave_button_icon.png',
                width: 70,
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: _restartGame,
              child: Image.asset(
                'assets/images/try_again_button_icon.png',
                width: 70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _saveToArchive(NatureModel nature) {
    context.read<ArchiveCubit>().addToArchive(nature);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Saved to archive',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF412786),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class Question {
  final String question;
  final List<AnswerOption> answers;

  Question({required this.question, required this.answers});
}

class AnswerOption {
  final String text;
  final NatureModel nature;

  AnswerOption({required this.text, required this.nature});
}
