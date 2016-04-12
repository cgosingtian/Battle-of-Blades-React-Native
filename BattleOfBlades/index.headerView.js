'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

var leftBackgroundImageSource = require('./Resources/headerbgleft.png');
var middleBackgroundImageSource = require('./Resources/playerbutton.png');
var rightBackgroundImageSource = require('./Resources/headerbgright.png');

var ENERGY_RECHARGE_TIME_MS = 30000; // X energy = 30 seconds
var ENERGY_GAIN_PER_CHARGE = 1; // 1 energy every X seconds
var ENERGY_RECHARGE_TIME_INTERVAL = 1000; // 1000 for 1 second

class HeaderView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			level: 1,
			xpNeeded: 10,
			energy: 10,
			maxEnergy: 10,
			playerName: 'Chase',
			energyRechargeTime: 0,
			energyRechargeTimeElapsed: 0,
		}
	}

	_verifyEnergyWithCost(energyCost) {
		var energySpend = this.state.energy - energyCost;

		return (energySpend >= 0);
	}

	spendEnergyWithCost(energyCost) {
		if (this._verifyEnergyWithCost(energyCost)) {
			var energySpent = this.state.energy - energyCost;
			var energyRechargeTime = ENERGY_RECHARGE_TIME_MS * energyCost;
			var energyRechargeTotal = this.state.energyRechargeTime + energyRechargeTime;
			this.setState({
				energy: energySpent,
				energyRechargeTime: energyRechargeTotal,
			});
			return true;
		} else {
	      	return false;
		}
	}

	componentDidMount() {
		this.timer = setInterval(() => {
			if (this.state.energyRechargeTime > 0) {
				var newEnergyRechargeValue = this.state.energyRechargeTime - ENERGY_RECHARGE_TIME_INTERVAL;
				if (newEnergyRechargeValue <= 0) {
					newEnergyRechargeValue = 0;
				}

				var newEnergy = this.state.energy;
				var newEnergyRechargeTimeElapsed = this.state.energyRechargeTimeElapsed + ENERGY_RECHARGE_TIME_INTERVAL;
				if (newEnergyRechargeTimeElapsed >= ENERGY_RECHARGE_TIME_MS) {
					newEnergyRechargeTimeElapsed = 0;
					newEnergy += ENERGY_GAIN_PER_CHARGE;
				}

				this.setState({
					energyRechargeTime: newEnergyRechargeValue,
					energy: newEnergy,
					energyRechargeTimeElapsed: newEnergyRechargeTimeElapsed,
				});
			}
		}, 1000);
	}

	componentWillUnmount() {
		clearTimeout(this.timer);
	}

	_renderEnergyRechargeTime() {
		if (this.state.energyRechargeTime > 0) {
			var totalSeconds = this.state.energyRechargeTime / 1000;
			var minutes = Math.floor(totalSeconds / 60);
			var seconds = Math.floor(totalSeconds % 60);
			if (seconds < 10) {
				seconds = '0'+seconds;
			}
			return(
				<Text style={styles.rightRechargeText}>Recharge: {minutes}:{seconds}[{this.state.energyRechargeTimeElapsed/1000}]</Text>
			);
		}
	}

	render() {
		return(
			<View 
				style={styles.container}
				width={this.state.width}
				height={this.state.height}>
				<Image 
					source={leftBackgroundImageSource} 
					style={styles.left}>
					<Text style={styles.leftLevelText}>Level: {this.state.level}</Text>
					<Text style={styles.leftXPText}>XP Needed: {this.state.xpNeeded}</Text>
				</Image>
				<Image 
					height={this.state.height}
					source={middleBackgroundImageSource} 
					style={styles.middle}>
						<View style={styles.middleNameTextBG}>
							<Text style={styles.middleNameText}>{this.state.playerName}</Text>
						</View>
				</Image>
				<Image 
					source={rightBackgroundImageSource} 
					style={styles.right}>
					<Text style={styles.rightEnergyText}>Energy: {this.state.energy}/{this.state.maxEnergy}</Text>
					{this._renderEnergyRechargeTime()}
				</Image>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		flexDirection: 'row',
		height: 30,
		backgroundColor: 'transparent',
	},

	// ----- LEFT HEADER
	left: {
		flex: 0.3,
		// The backgroundColor setting of the parent affects the views on top of it
		backgroundColor: 'transparent',
	},
	leftLevelText: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 15,
	},
	leftXPText: {
		color: 'white',
		fontSize: 10,
	},

	// ----- MIDDLE HEADER
	middle: {
		flex: 0.3,
		justifyContent:'flex-end',
	},
	middleNameTextBG: {
		backgroundColor: 'rgba(0,0,0,0.5)',
	},
	middleNameText: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 15,
	},

	// ----- RIGHT HEADER
	right: {
		flex: 0.3,
		backgroundColor: 'transparent',
	},
	rightEnergyText: {
		color: 'white',
		fontWeight: 'bold',
		fontSize: 15,
		textAlign: 'right',
	},
	rightRechargeText: {
		color: 'white',
		fontSize: 10,
		textAlign: 'right',
	},
});

module.exports = HeaderView;