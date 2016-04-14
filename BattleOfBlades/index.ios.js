/**
 * React Native Study: Conversion from Objective-C
 * Objective-C version: https://github.com/cgosingtian/Battle-of-Blades
 * https://github.com/cgosingtian/Battle-of-Blades-React-Native
 */

import React, {
  AppRegistry,
  Component,
  StyleSheet,
  Text,
  View,
  Alert,
} from 'react-native';

var HeaderView = require('./index.headerView');
var MainView = require('./index.mainView');
var BattleView = require('./index.battleView');
var FooterView = require('./index.footerView');

var Common = require('./common');
var screenWidth = Common.screenWidth;
var screenHeight = Common.screenHeight;

var EnemyCreator = require('./util.enemyCreator');

var ENERGY_PER_BATTLE = 1;

class BattleOfBlades extends Component {
  constructor(props) {
    super(props);
    this.state = {
      startGame: false,
      difficulty: -1,
      activeEnemyLevel: 0,
    };
  }

  render() {
    var battleView = <BattleView 
        ref='battleView'
        width={screenWidth} 
        height={400} 
        endGameFunction={this._endGame.bind(this)} />;
    var mainView = <MainView 
        ref='mainView'
        width={screenWidth} 
        height={400} />;
    var shownView = (this.state.startGame && this.state.difficulty !== undefined) ? battleView : mainView;

    return (
      <View style={styles.container}>
        <HeaderView 
          ref='headerView'
          width={screenWidth}
          height={30} />
        {shownView}
        <FooterView 
          ref='footerView'
          width={screenWidth} 
          height={30} 
          buttonFunction={this.confirmStart.bind(this)}
          startGame={this.state.startGame}
          difficulty={this.state.difficulty} />
      </View>
    );
  }

  confirmStart(difficulty) {
    var title = 'Start Game?';
    var message = 'Easy Battle';

    switch(difficulty) {
      case 0: {
        message = 'Easy Battle';
      } break;
      case 1: {
        message = 'Average Battle';
      } break;
      case 2: {
        message = 'Hard Battle';
      } break;
      default: {
        // Assume Easy difficulty
        difficulty = 0;
        console.log('*** ERROR: startGame(difficulty) with invalid difficulty, defaulting to Easy');
      }
    }

    Alert.alert(
      title,
      message,
        [
          {text: 'Cancel', onPress: () => console.log('Cancel')},
          {text: 'Proceed', onPress: () => this._startGame(difficulty)},
        ]
      )
  }

  _startGame(difficulty) {
    if (!this.refs.headerView.spendEnergyWithCost(ENERGY_PER_BATTLE)) {
      Alert.alert(
        'Error',
        'Not enough energy. Please wait for it to recharge.',
        [
          {text: 'OK'},
        ]
      )
      return;
    }

    function startGame(difficulty) {
        this.setState({
          startGame: true,
          difficulty: difficulty,
        });
    };

    startGame.call(this, difficulty);
    startGame.call(this.refs.footerView, difficulty);

    var enemy = new EnemyCreator.enemyWithDifficulty(this.state.difficulty);
    function setEnemy() {
      this.setState({
        difficulty: difficulty,
        enemyName: enemy.name,
        enemyLevel: enemy.level,
        enemyHealth: enemy.health,
        timeLeft: enemy.timeLeft,
      });
    }

    setEnemy.call(this.refs.battleView);

    this.setState({
      activeEnemyLevel: enemy.level,
    });
  }

  _endGame(gameWon, message) {
    function endGame() {
        this.setState({
          startGame: false,
          gameWon: gameWon,
        });
    };

    endGame.call(this);
    endGame.call(this.refs.mainView);
    endGame.call(this.refs.footerView);


    if (gameWon) {
      this.refs.headerView.levelUpIfPossibleWithExperienceGained(this.state.activeEnemyLevel);
      message = message + this.state.activeEnemyLevel;
    }

    function updateEndMessage() {
      this.setState({
        endGameMessage: message,
      })
    }
    updateEndMessage.call(this.refs.mainView);

    this.setState({
        activeEnemyLevel: 0,
    });
  }

  _gainLevel() {
    // TODO
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'black',
  },
});

AppRegistry.registerComponent('BattleOfBlades', () => BattleOfBlades);
