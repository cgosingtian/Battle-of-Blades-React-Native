'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

class MainView extends Component {
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
				<Text>MainView</Text>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		height: 400,
		backgroundColor: 'red',
	},
});

module.exports = MainView;