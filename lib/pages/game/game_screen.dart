import 'package:flutter/material.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/game/archived_nature_screen.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/game/game_quizz_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/game_background.png',
            fit: BoxFit.fill,
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArchivedNatureScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Archive",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFFFEFE00),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mini-game «Defining Your Nature»',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameQuizzScreen()),
                  );
                },
                child: Container(
                  width: 160,
                  height: 160,
                  child: Center(
                    child: Image.asset('assets/images/start_game_icon.png'),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }
}
