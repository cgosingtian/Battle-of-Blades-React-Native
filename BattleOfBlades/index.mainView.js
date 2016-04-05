'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

class MainView extends Component {
	render() {
		return(
			<View style={styles.container}>
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