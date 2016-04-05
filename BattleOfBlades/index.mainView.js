'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

var mainCover = require('./Resources/maincover.png');

class MainView extends Component {
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
				width={this.state.width}
				height={this.state.height}>
				<Image
					width={this.state.width}
					height={this.state.height}
					resizeMode={'stretch'}
					source={mainCover}>
				</Image>
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