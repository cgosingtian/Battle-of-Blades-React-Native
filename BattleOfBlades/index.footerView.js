'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

var backgroundImage = require('./Resources/screenfooterbg.png');
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
			<Image 
				width={this.state.width}
				style={styles.container}
				source={backgroundImage}>
			</Image>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		height: 30,
		backgroundColor: 'black',
		flexDirection: 'row',
		alignItems: 'center',
	},
});

module.exports = FooterView;