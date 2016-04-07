'use strict';

import React, {
	Component,
	StyleSheet,
	View,
} from 'react-native';

var AttackButton = require('./battle.attackButton');

class AttackRow extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			attackFunction: props.attackFunction,
		};
	}

	render() {
		return(
			<View 
				width={this.state.width} 
				height={this.state.height}
				style={styles.container}>
				<AttackButton ref='attackButton1' buttonFunction={this.handleAttack.bind(this)} />
				<AttackButton ref='attackButton2' buttonFunction={this.handleAttack.bind(this)} />
				<AttackButton ref='attackButton3' buttonFunction={this.handleAttack.bind(this)} />
				<AttackButton ref='attackButton4' buttonFunction={this.handleAttack.bind(this)} />
			</View>
		);
	}

	_handleAttack(attackAmount) {
		this.state.attackFunction(attackAmount);
	}
}

var styles = StyleSheet.create({
	container: {
		flexDirection: 'row',
		justifyContent: 'center',
	},
});

module.exports = AttackRow;
