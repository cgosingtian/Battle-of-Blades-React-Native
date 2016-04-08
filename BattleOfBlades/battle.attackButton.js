'use strict';

import React, {
	Component,
	StyleSheet,
	Image,
	Text,
	TouchableHighlight,
} from 'react-native';

var AttackButtonBGImage = require('./Resources/attackbutton2.png');

var LIFE_DEFAULT = 9;
var COOLDOWN_MAX = 7;

function getRandomIntFromRange(minimum, maximum) {
	return Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
}

class AttackButton extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: 60,
			height: 60,
			life: props.life,
			cooldown: props.cooldown,
			buttonFunction: props.buttonFunction,
		};
	}

	componentDidMount() {
		if (this.state.life == undefined) {
			this.state.life = 0;
			this._cooldownRegenerate();
		}

		this.timer = setInterval(() => {
			var isCooldown = this._lifeReduce();
			if (isCooldown === true) {
				this._cooldownReduce();
			}
			
		}, 1000);
	}

	_lifeReduce() {
		if (this.state.life <= 0) {
			this.state.life = 0;
			return true;
		} else {
			this.state.life--;
			return false;
		}
	}

	_cooldownReduce() {
		if (this.state.cooldown == undefined) {
			this._cooldownRegenerate();
		}

		if (this.state.cooldown <= 0) {
			this._lifeRegenerate();
			this._cooldownRegenerate();
		} else {
			this.state.cooldown--;
		}
	}

	_lifeRegenerate() {
		this.state.life = LIFE_DEFAULT;
	}

	_cooldownRegenerate() {
		this.state.cooldown = getRandomIntFromRange(0, COOLDOWN_MAX);
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
				onPress={() => {
					this._buttonAction.bind(this)()
				}}>
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

	_buttonAction() {
		var damage = this.state.life;
		this.setState({life:0});
		this.state.buttonFunction(damage);
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
