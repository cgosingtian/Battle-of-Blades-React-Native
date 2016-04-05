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
    return (
      <View style={styles.container}>
        <HeaderView width={screenWidth} height={30} />
        <MainView width={screenWidth} height={400} />
        <FooterView 
          width={screenWidth} 
          height={30} 
          buttonFunction={this.confirmStart.bind(this)} />
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
    this.setState({
      startGame: true,
      difficulty: difficulty,
    });
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
