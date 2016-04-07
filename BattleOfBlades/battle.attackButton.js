'use strict';

import React, {
	Component,
	StyleSheet,
	Image,
	Text,
	TouchableHighlight,
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

	componentDidMount() {
		this.timer = setInterval(() => {
			this.state.life--;
			if (this.state.life <= 0) {
				this.state.life = 0;
			}
			this.setState({});
		}, 1000);
	}

	componentWillUnmount() {
		clearTimeout(this.timer);
	}

	render() {
		if (this.state.life > 0) {
			return this.renderAttackButton();
		} else {
			return(
				<Image 
					width={this.state.width}
					height={this.state.height}
					style={styles.container} />
			);
		}
	}

	renderAttackButton() {
		return(
			<TouchableHighlight
				width={this.state.width}
				height={this.state.height}
				style={styles.touchable}
				underlayColor={'transparent'}
				onPress={this.attackButtonTapped}>
				<Image 
					width={this.state.width}
					height={this.state.height}
					style={styles.container}
					source={AttackButtonBGImage}>
					<Text style={styles.lifeText}>{this.state.life}</Text>
				</Image>
			</TouchableHighlight>
		);
	}

	attackButtonTapped() {
		console.log('TAPPED');
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
	touchable: {
		flex: 1,
		justifyContent:'center',
	},
});

module.exports = AttackButton;
