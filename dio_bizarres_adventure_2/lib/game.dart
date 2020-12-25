import 'dart:async';
import 'dart:math';

class Game{
  double screenHeight;
  double screenWidth;
  int currLevel;
  Boxer player;
  Boxer opponent;
  Timer opponentTimer;
  int gameState;
  bool playerDelay = false;
  bool inPlayerDelay = false;
  int delayTime = 500;
  int currLevelMultiplier;
  String enemyAction;
  int currAnimation = 1;
  bool changeAnimation = true;
  bool attacking = false;
  Timer animationTimer;
  bool attackedEnd = false;
  bool evadedSuccess = false;
  int playerPortrait = 1;
  int opponentPortrait = 1;

  Game(){
    screenHeight = 400.0;
    screenWidth = 400.0;
    player = Boxer();
    opponent = Boxer();
    gameState = 0;
    currLevel = 1;
    player.name = "Player";
    opponent.name = "Opponent $currLevel";
    currLevelMultiplier = 1;
    enemyAction = "Enemy is trying to sleep!";
  }//end of constructor

  animationStand(){
    if(changeAnimation){
      changeAnimation = false;
      Future.delayed(Duration(milliseconds: 400), () {
        currAnimation = currAnimation % 3;
        currAnimation++;
        changeAnimation = true;
      });
    }
  }//end of animation

  animationAttacking() {
    if(changeAnimation) {
      changeAnimation = false;
      Future.delayed(Duration(milliseconds: 400), () {
        currAnimation = 4;
      });
      Future.delayed(Duration(milliseconds: 800), () {
        currAnimation = 5;
      });
      Future.delayed(Duration(milliseconds: 1200), () {
        currAnimation = 6;
      });
      Future.delayed(Duration(milliseconds: 1600), () {
        currAnimation = 7;
        attackedEnd = true;
      });
      Future.delayed(Duration(milliseconds: 2000), () {
        attacking = false;
        changeAnimation = true;
        attackedEnd = false;
      });
    }//end of if
  }

  calculateOpponentStats(){
    opponent.name = "Opponent $currLevel";
    opponent.hitRange = 10;
    if(currLevel % 5 == 0){
      currLevelMultiplier += 1;
      opponent.hitRange -= currLevelMultiplier;
      if(opponent.hitRange <= 0){
        opponent.hitRange = 1;
      }//end of if
    }//end of if
    opponent.criticalRange = 10 - currLevelMultiplier;
    if(opponent.criticalRange <= 0){
      opponent.criticalRange = 1;
    }//end of if
    opponent.evadeRange = 10 - currLevelMultiplier;
    if(opponent.evadeRange <= 0){
      opponent.evadeRange = 1;
    }//end of if
    opponent.life = 2 + currLevel.toDouble();
    opponent.criticalMultiplier = 1.2 * currLevel * 0.5;

    opponent.evadeRange = 10 - currLevel;
    if(opponent.evadeRange <= 1){
      opponent.evadeRange = 2;
    }//end of if
  }//end of calculateOpponentStats

  updatePlayerAction(int action){
    if(!playerDelay){
      playerAction(action);
      if(!inPlayerDelay){
        inPlayerDelay = true;
        Future.delayed(Duration(milliseconds: delayTime), () {
          playerDelay = false;
          inPlayerDelay = false;
        });
      }//end of if
    }//end of if
  }//end of updatePlayerAction

  playerAction(int action){
    evadedSuccess = false;
    switch(action){
      case 1:
        if(!opponent.calculateEvadeSuccess()) {
          double damage = player.calculateHit();
          opponent.life -= damage;
          print("Player gives $damage to opponent.");
          if(damage > 0) {
            opponentPortrait = 2;
            Future.delayed(Duration(milliseconds: 200), () {
              opponentPortrait = 1;
            });
          }//end of if
          if (opponent.life <= 0) {
            gameState = 1;
          } //end of if
        }//end of if
        playerDelay = true;
        delayTime = 1500;
        break;
      case 2:
        evadedSuccess = true;

        playerDelay = true;
        delayTime = 2000;
        break;
      default:
        // print("Player doing nothing");
    }//end of switch
  }//end of playerAction

  updateOpponentAction(){
    double damage;
    opponentTimer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) => {
      if(!attacking)
        opponentAction()
      else if(attackedEnd){
        if(!evadedSuccess){
          damage = opponent.calculateHit(),
          player.life -= damage,
          if(damage > 0){
            playerPortrait = 2,
            Future.delayed(Duration(milliseconds: 200), () {
              playerPortrait = 1;
            })
          }
        },

        if(player.life <= 0)
          gameState = 2
      }
    });
  }//end of updateOpponentAction

  opponentAction(){
    int enemyAction = opponent.calculateAction();
    switch (enemyAction) {
      case 1:
        this.enemyAction = "Enemy punched you!";
        break;
      case 2:
        attacking = true;
        break;
      default:
        this.enemyAction = "Enemy is trying to sleep!";
    } //end of switch
  }//end of opponentAction
}//end of Game

class Boxer{
  String name;
  double life;
  double damage;
  int action;
  double criticalMultiplier;
  int criticalRange;
  int hitRange;
  int evadeRange;
  int actionRange;
  Random random;

  Boxer(){
    life = 5.0;
    damage = 1.0;
    criticalMultiplier = 1.2;
    action = 0;
    criticalRange = 10;
    hitRange = 3;
    evadeRange = 5;
    actionRange = 3;
    random = Random();
  }//end of Boxer

  double calculateHit(){
    double damageGiven = 0;
    if(calculateHitSuccess()) {
      damageGiven = damage;
      if(calculateCriticalSuccess()) {
        damageGiven *= criticalMultiplier;
      }//end of if
    }//end of if
    return damageGiven;
  }//end of calculateHit

  int calculateAction(){
    return random.nextInt(3);
  }//end of calculateActions

  bool calculateHitSuccess(){
    int randomNumber = random.nextInt(hitRange);
    bool success = false;
    if(randomNumber % 2 == 0){
      success = true;
    }//end of if
    return success;
  }//end of calculateSuccess

  bool calculateCriticalSuccess(){
    int randomNumber = random.nextInt(criticalRange);
    bool success = false;
    if(randomNumber == 0){
      success = true;
    }//end of if
    return success;
  }//end of calculateCriticalSuccess

  bool calculateEvadeSuccess(){
    int randomNumber = random.nextInt(evadeRange);
    bool success = false;
    if(randomNumber % 2 == 0){
      success = true;
    }//end of if
    return success;
  }//end of calculateEvadeSuccess
}//end of Boxer