'use strict';

import React, {
	Component,
	StyleSheet,
	Image,
	Text,
} from 'react-native';

var AttackButtonBGImage = require('./Resources/attackbutton2.png');

class AttackButton extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: 60,
			height: 60,
			life: props.life,
		};
	}

	render() {
		return(
			<Image 
				width={this.state.width}
				height={this.state.height}
				style={styles.container}
				source={AttackButtonBGImage}>
				<Text style={styles.lifeText}>{this.state.life}</Text>
			</Image>
		);
	}
}

var styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent:'center',
		resizeMode:'contain',
	},
	lifeText: {
		top: 6.5,
		textAlign: 'center',
		fontWeight: 'bold',
		fontSize: 30,
		textShadowColor: 'white',
		textShadowOffset: {width: 1, height: 1},
	},
});

module.exports = AttackButton;
