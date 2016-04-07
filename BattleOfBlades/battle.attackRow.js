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
		};
	}
	render() {
		return(
			<View 
				width={this.state.width} 
				height={this.state.height}
				style={styles.container}>
				<AttackButton ref='attackButton1' />
				<AttackButton ref='attackButton2' />
				<AttackButton ref='attackButton3' />
				<AttackButton ref='attackButton4' />
			</View>
		);
	}
}

var styles = StyleSheet.create({
	container: {
		flexDirection: 'row',
		justifyContent: 'center',
	},
});

module.exports = AttackRow;
