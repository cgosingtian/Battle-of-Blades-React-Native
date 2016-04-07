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

var Dimensions = require('Dimensions');

var screenWidth = Dimensions.get('window').width;
var screenHeight = Dimensions.get('window').height;

class BattleOfBlades extends Component {
  constructor(props) {
    super(props);
    this.state = {
      startGame: false,
      difficulty: -1,
    };
  }

  render() {
    //enemy generator here
    var enemyName = 'Flame Knight';
    var enemyLevel = 2;
    //end enemy generator code
    //game stats generator here
    var playerHealth = 100;
    var timeLeft = 60;
    //end game stats generator code

    var mainView = (this.state.startGame && this.state.difficulty !== undefined) ? 
      <BattleView 
        width={screenWidth} 
        height={400} 
        difficulty={this.state.difficulty}
        enemyName={enemyName}
        enemyLevel={enemyLevel}
        playerHealth={playerHealth}
        timeLeft={timeLeft} /> : 
      <MainView width={screenWidth} height={400} />;

    return (
      <View style={styles.container}>
        <HeaderView width={screenWidth} height={30} />
        {mainView}
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
    function startGame(difficulty) {
        this.setState({
          startGame: true,
          difficulty: difficulty,
        });
    };

    startGame.call(this, difficulty);
    startGame.call(this.refs.footerView, difficulty);
  }
}

const styles = StyleSheet.create({
  container: {
    top: 20,
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'black',
  },
});

AppRegistry.registerComponent('BattleOfBlades', () => BattleOfBlades);
