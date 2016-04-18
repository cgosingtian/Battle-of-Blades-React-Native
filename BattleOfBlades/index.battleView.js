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
var EndMessageCreator = require('./util.endMessageCreator.js');
var GradientEffects = require('./util.gradientEffects');

var Common = require('./common');
var screenWidth = Common.screenWidth;
var screenHeight = Common.screenHeight;

var willUnmount = false;

class BattleView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			difficulty: -1,
			enemyName: props.enemyName,
			enemyLevel: props.enemyLevel,
			enemyHealth: props.enemyHealth,
			timeLeft: props.timeLeft,
			endGameFunction: props.endGameFunction,
			gradientColorQueue: new Array,
		}
	}

	componentDidMount() {
		this.timer = setInterval(() => {
			this.state.timeLeft--;
			if (this.state.timeLeft <= 0) {
				this._endGameWithResult(false);
			} else {
				this.setState({});
			}
		}, 1000);
	}

	componentWillUnmount() {
		this.willUnmount = true;
		clearTimeout(this.timer);
	}

	_endGameWithResult(didWin) {
		clearTimeout(this.timer);
		var message = '';
		if (didWin == false) {
			message = EndMessageCreator.generateDefeatMessage();
		} else {
			message = 'Experience +';
		}
		this.state.endGameFunction(didWin, message);
	}

	// This function is applied to all this.state.gradientColorQueue elements.
	// Allows queueing of animations. See map() function on JavaScript arrays.
	// TODO: Code duplication; refactor this out somehow
	_renderGradient(gradientColor, key) {		
		if (gradientColor !== undefined) {
			return (
				<GradientEffects 
					key={key}
	          		gradientColor={gradientColor}
	          		onFinish={this._finishGradientRendering.bind(this)}
	          		width={this.state.width}
	          		height={this.state.height} />);
		} else {
			return (<View />);
		}
	}

	_finishGradientRendering() {
		if (!this.willUnmount) {
			console.log('_finishGradientRendering');
			var gradientColorQueue = this.state.gradientColorQueue;
			gradientColorQueue.shift();
			this.setState({gradientColorQueue:gradientColorQueue});
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

		var gradients = this.state.gradientColorQueue.map(this._renderGradient.bind(this));

		return(
			<View 
				width={this.state.width}
				height={this.state.height}
				style={styles.container}>
				<Image
					width={this.state.width}
					height={this.state.height}
					style={styles.battle}
					renderToHardwareTextureAndroid={true} // android
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
				{gradients}
			</View>
		);
	}

	_damageEnemy(amount) {
		var resultingHealth = this.state.enemyHealth - amount;
		if (resultingHealth <= 0) {
			resultingHealth = 0;
		} 

		// Queue red gradient animation
		this.state.gradientColorQueue.push('red');
		
		this.setState({
			enemyHealth:resultingHealth,
		});

		if (this.state.enemyHealth <= 0) {
			this._endGameWithResult(true);
		}
	}
}

const styles = StyleSheet.create({
	container: {
		backgroundColor: 'transparent',
	},
	battle: {
		justifyContent: 'space-between',
		alignItems: 'center',
		width: screenWidth,
		height: 400,
	},
	battleInfo: {
		height: 40,
		width: screenWidth,
		justifyContent: 'center',
	},
	enemyInfo: {
		alignSelf: 'flex-start',
		height: 50,
		backgroundColor: 'rgba(0,0,0,0.5)',
		bottom: 10,
	},
	enemyName: {
		flex: 0.5,
		textAlign: 'right',
		fontSize: 24,
		fontWeight: 'bold',
		color: 'white',
		right: 5,
	},
	enemyLevel: {
		flex: 0.5,
		textAlign: 'right',
		fontSize: 17,
		fontWeight: 'bold',
		color: 'white',
		right: 5,
	},
	enemyHealth: {
		flex: 0.5,
		textAlign: 'left',
		fontSize: 15,
		fontWeight: 'bold',
		color: 'white',
		left: 5,
	},
	timeLeft: {
		flex: 0.5,
		textAlign: 'left',
		fontSize: 15,
		fontWeight: 'bold',
		color: 'white',
		left: 5,
	},
});

module.exports = BattleView;
