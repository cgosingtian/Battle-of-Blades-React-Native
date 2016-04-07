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
				<AttackButton ref='attackButton1' life={1} />
				<AttackButton ref='attackButton2' life={3} />
				<AttackButton ref='attackButton3' life={5} />
				<AttackButton ref='attackButton4' life={99} />
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
