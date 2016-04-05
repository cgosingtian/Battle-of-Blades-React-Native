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

class HeaderView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			level: 0,
			xpNeeded: 100,
			energy: 10,
			maxEnergy: 10,
			playerName: 'Chase',
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
});

module.exports = HeaderView;