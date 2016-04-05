'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
	TouchableHighlight,
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
			buttonFunction: props.buttonFunction,
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
				<TouchableHighlight
					onPress={() => this.state.buttonFunction(0)}>
					<Image
						width={buttonWidth}
						height={buttonHeight}
						source={easyButtonImage}
						style={styles.left}>
					</Image>
				</TouchableHighlight>
				<TouchableHighlight
					onPress={() => this.state.buttonFunction(1)}>
					<Image
						width={buttonWidth}
						height={buttonHeight}
						source={averageButtonImage}
						style={styles.middle}>
					</Image>
				</TouchableHighlight>
				<TouchableHighlight
					onPress={() => this.state.buttonFunction(2)}>
					<Image
						width={buttonWidth}
						height={buttonHeight}
						source={hardButtonImage}
						style={styles.right}>
					</Image>
				</TouchableHighlight>
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