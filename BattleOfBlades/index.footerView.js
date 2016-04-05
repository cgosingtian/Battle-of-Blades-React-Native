'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

var backgroundImage = require('./Resources/screenfooterbg.png');
var easyButtonImage = require('./Resources/battlebuttoneasy.png')
var averageButtonImage = require('./Resources/battlebuttonaverage.png')
var hardButtonImage = require('./Resources/battlebuttonhard.png')

class FooterView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
		}
	}

	render() {
		var buttonWidth=this.state.width/3;
		var buttonHeight=this.state.height;

		return(
			<Image 
				width={this.state.width}
				style={styles.container}
				source={backgroundImage}>
				<Image
					width={buttonWidth}
					height={buttonHeight}
					source={easyButtonImage}
					style={styles.left}>
				</Image>
				<Image
					width={buttonWidth}
					height={buttonHeight}
					source={averageButtonImage}
					style={styles.middle}>
				</Image>
				<Image
					width={buttonWidth}
					height={buttonHeight}
					source={hardButtonImage}
					style={styles.right}>
				</Image>
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
	left: {
		flex: 0.33,
		borderWidth: 1,
		borderColor: 'black',
	},
	middle: {
		flex: 0.34,
		borderWidth: 1,
		borderColor: 'black',
	},
	right: {
		flex: 0.33,
		borderWidth: 1,
		borderColor: 'black',
	},
});

module.exports = FooterView;