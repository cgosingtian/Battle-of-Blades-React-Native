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
			enemyName: props.enemyName,
			enemyLevel: props.enemyLevel,
			enemyHealth: props.enemyHealth,
			timeLeft: props.timeLeft,
		}
	}

	componentDidMount() {
		this.timer = setInterval(() => {
			this.state.timeLeft--;
			if (this.state.timeLeft <= 0) {
				this._endGame();
			}
			this.setState({});
		}, 1000);
	}

	componentWillUnmount() {
		clearTimeout(this.timer);
	}

	_endGame() {
		clearTimeout(this.timer);
		console.log('GAME OVER');
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
						<Text style={styles.enemyHealth}>Health: {this.state.enemyHealth}</Text>
						<Text style={styles.timeLeft}>Time Left: {this.state.timeLeft}</Text>
					</Image>
					<AttackRow width={this.state.width*0.9} attackFunction={this._damageEnemy.bind(this)} />
					<AttackRow width={this.state.width*0.9} attackFunction={this._damageEnemy.bind(this)} />
					<AttackRow width={this.state.width*0.9} attackFunction={this._damageEnemy.bind(this)} />
					<AttackRow width={this.state.width*0.9} attackFunction={this._damageEnemy.bind(this)} />
					<View 
						width={this.state.width*0.75}
						style={styles.enemyInfo}>
						<Text style={styles.enemyName}>{this.state.enemyName}</Text>
						<Text style={styles.enemyLevel}>Level {this.state.enemyLevel}</Text>
					</View>
				</Image>
			</View>
		);
	}

	_damageEnemy(amount) {
		var resultingHealth = this.state.enemyHealth - amount;
		if (resultingHealth < 0) {
			resultingHealth = 0;
		}
		this.setState({enemyHealth:resultingHealth});
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
	enemyInfo: {
		alignSelf: 'flex-start',
		height: 50,
		backgroundColor: 'rgba(0,0,0,0.5)',
		bottom: 10,
	},
	enemyName: {
		textAlign: 'right',
		fontSize: 24,
		fontWeight: 'bold',
		color: 'white',
		right: 5,
	},
	enemyLevel: {
		textAlign: 'right',
		fontSize: 17,
		fontWeight: 'bold',
		color: 'white',
		right: 5,
	},
	enemyHealth: {
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
