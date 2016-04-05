'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

class HeaderView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
		}
	}

	render() {
		return(
			<View 
				style={styles.container}
				width={this.state.width}>
				<View style={styles.left}>
					<Text>Left</Text>
				</View>
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
	left: {
		flex: 0.3,
		backgroundColor: 'purple',
	},
	middle: {
		flex: 0.3,
		backgroundColor: 'white',
	},
	right: {
		flex: 0.3,
		backgroundColor: 'green',
	},
});

module.exports = HeaderView;