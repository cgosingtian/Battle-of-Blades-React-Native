'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

var leftBackgroundImageSource = require('./Resources/headerbgleft.png');

class HeaderView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			level: 0,
			xpNeeded: 100,
		}
	}

	render() {
		return(
			<View 
				style={styles.container}
				width={this.state.width}>
				<Image source={leftBackgroundImageSource} style={styles.left}>
					<Text style={styles.leftLevelText}>Level: {this.state.level}</Text>
					<Text style={styles.leftXPText}>XP Needed: {this.state.xpNeeded}</Text>
				</Image>
				<View style={styles.middle}>
					<Text>Middle</Text>
				</View>
				<View style={styles.right}>
					<Text>Right</Text>
				</View>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		flexDirection: 'row',
		height: 30,
		backgroundColor: 'blue',
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
		backgroundColor: 'white',
	},

	// ----- RIGHT HEADER
	right: {
		flex: 0.3,
		backgroundColor: 'green',
	},
});

module.exports = HeaderView;