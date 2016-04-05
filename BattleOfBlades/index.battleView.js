'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

var easyBG = require('./Resources/enemyeasy.png');
var averageBG = require('./Resources/enemyaverage.png');
var hardBG = require('./Resources/enemyhard.png');

class BattleView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			difficulty: props.difficulty,
		}
	}

	render() {
		var backgroundSource;
		switch(this.state.difficulty) {
			case 0: {
				backgroundSource = easyBG;
			} break;
			case 1: {
				backgroundSource = averageBG;
			} break;
			case 2: {
				backgroundSource = hardBG;
			} break;
			default: {
				// Assume Easy difficulty
				backgroundSource = easyBG;
        		console.log('*** ERROR: BattleView difficulty property set with invalid difficulty, defaulting to Easy');
			}
		}

		return(
			<View 
				style={styles.container}
				width={this.state.width}
				height={this.state.height}>
				<Image
					width={this.state.width}
					height={this.state.height}
					resizeMode={'stretch'}
					source={backgroundSource}>
				</Image>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		backgroundColor: 'transparent',
	},
});

module.exports = BattleView;