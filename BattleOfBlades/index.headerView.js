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
			<View style={styles.container}
				width={this.state.width}>
				<Text>HeaderView</Text>
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		height: 30,
		backgroundColor: 'blue',
	},
});

module.exports = HeaderView;