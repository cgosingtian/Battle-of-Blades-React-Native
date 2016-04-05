'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

class FooterView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
		}
	}

	render() {
		return(
			<View 
				style={styles.container}
				width={this.state.width}>
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