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
  View
} from 'react-native';

var HeaderView = require('./index.headerView');
var MainView = require('./index.mainView');
var FooterView = require('./index.footerView');
var Dimensions = require('Dimensions');

var screenWidth = Dimensions.get('window').width;
var screenHeight = Dimensions.get('window').height;

class BattleOfBlades extends Component {
  render() {
    return (
      <View style={styles.container}>
        <HeaderView width={screenWidth} />
        <MainView width={screenWidth} />
        <FooterView width={screenWidth} />
      </View>
    );
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
