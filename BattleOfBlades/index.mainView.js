'use strict';

import React, {
	Component,
	View,
	Image,
	Text,
	StyleSheet,
} from 'react-native';

var mainCover = require('./Resources/maincover.png');
var victoryImage = require('./Resources/victory.png');

class MainView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			startGame: false,
          	gameWon: undefined,
          	endGameMessage: props.endGameMessage,
		}
	}

	_renderVictory() {
		return (
			<View 
				width={this.state.width} 
				height={this.state.height} 
				justifyContent={'center'}>
				<Image 
      				width={this.state.width}
      				height={400}
      				top={-50}
          			style={styles.victoryImage}
          			source={victoryImage} 
          			position={'absolute'} />
        		<View backgroundColor={'rgba(0,0,0,0.5)'} height={50} justifyContent={'center'}>
        	<Text style={styles.experience}>{this.state.endGameMessage}</Text>
        </View></View>);
	}

	render() {
		var gameResult = this.state.gameWon ? 
        this._renderVictory() : 
        <Text 
          	style={styles.defeat}>DEFEAT</Text>

    	var endGame = (this.state.gameWon !== undefined) ? gameResult : <View />;

		return(
			<View 
				style={styles.container}
				width={this.state.width}
				height={this.state.height}>
				<Image
					width={this.state.width}
					height={this.state.height}
					resizeMode={'stretch'}
					style={styles.background}
					source={mainCover}>
				</Image>
				{endGame}
			</View>
		);
	}
}

const styles = StyleSheet.create({
	container: {
		backgroundColor: 'transparent',
	},
	background: {
		position: 'absolute',
	},
	victoryImage: {
    	resizeMode: 'contain',
  	},
  	experience: {
	    textAlign: 'center',
	    fontSize: 20,
	    fontWeight: 'bold',
	    color: 'white',
	},
  	defeat: {
	    textAlign: 'center',
	    fontSize: 40,
	    fontWeight: 'bold',
	    color: 'red',
	    top: 60,
	},
});

module.exports = MainView;