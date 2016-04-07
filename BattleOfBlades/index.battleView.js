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
var infoBG = require('./Resources/battleinfobg.png');

var AttackRow = require('./battle.attackRow');

class BattleView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			difficulty: props.difficulty,
			playerHealth: props.playerHealth,
			timeLeft: props.timeLeft,
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
					style={styles.battle}
					source={backgroundSource}>
					<Image
						width={this.state.width}
						style={styles.battleInfo}
						source={infoBG}>
						<Text style={styles.playerHealth}>Health: {this.state.playerHealth}</Text>
						<Text style={styles.timeLeft}>Time Left: {this.state.timeLeft}</Text>
					</Image>
					<AttackRow width={this.state.width*0.9} />
					<AttackRow width={this.state.width*0.9} />
					<AttackRow width={this.state.width*0.9} />
					<AttackRow width={this.state.width*0.9} />
				</Image>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		backgroundColor: 'transparent',
	},
	battle: {
		justifyContent: 'space-between',
		alignItems: 'center',
	},
	battleInfo: {
		height: 40,
		justifyContent: 'center',
	},
	playerHealth: {
		textAlign: 'left',
		fontSize: 15,
		fontWeight: 'bold',
		color: 'white',
		left: 5,
	},
	timeLeft: {
		textAlign: 'left',
		fontSize: 15,
		fontWeight: 'bold',
		color: 'white',
		left: 5,
	},
});

module.exports = BattleView;
