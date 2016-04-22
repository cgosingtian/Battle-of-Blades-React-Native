'use strict';

import React, {
	Component,
	StyleSheet,
	Image,
	Text,
	View,
	TouchableHighlight,
} from 'react-native';

var AttackButtonBGImage = require('./Resources/attackbutton2.png');
var Utilities = require('./utilities');

var LIFE_DEFAULT = 9;
var COOLDOWN_MAX = 7;

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
		this.state.cooldown = Utilities.getRandomIntFromRange(0, COOLDOWN_MAX);
	}

	componentWillUnmount() {
		clearTimeout(this.timer);
	}

	render() {
		var attackButton = this.renderAttackButton();
		var emptyButton = this.renderEmptyButton();

		if (this.state.life > 0) {
			return attackButton;
		} else {
			return emptyButton;
		}
	}

	renderEmptyButton() {
		return(
				<View
					style={styles.container}>
				<Image 
					style={[styles.container, 
						    {
						    	width: this.state.width,
								height: this.state.height,
						    }]} />
				</View>
			);
	}

	renderAttackButton() {
		return(
			
				<Image 
					style={[styles.container, 
						    {
						    	width: this.state.width,
								height: this.state.height,
						    }]}
					resizeMode={'contain'}
					renderToHardwareTextureAndroid={true} // android
					onStartShouldSetResponder={()=>this._buttonAction.bind(this)()}
					source={AttackButtonBGImage}>
					<Text style={styles.lifeText}>{this.state.life}</Text>
				</Image>
			
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
	},
	lifeText: {
		top: 6.5,
		textAlign: 'center',
		fontWeight: 'bold',
		fontSize: 30,
		color:'black',
		textShadowColor: 'white',
		textShadowOffset: {width: 1, height: 1},
	},
	touchable: {
		flex: 1,
		justifyContent:'center',
	},
});

module.exports = AttackButton;
