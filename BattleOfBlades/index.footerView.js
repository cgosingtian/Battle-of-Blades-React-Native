'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

class FooterView extends Component {
	render() {
		return(
			<View style={styles.container}>
				<Text>FooterView</Text>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		height: 30,
		backgroundColor: 'green',
	},
});

module.exports = FooterView;