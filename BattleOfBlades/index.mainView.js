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

var GradientEffects = require('./util.gradientEffects');

var willUnmount = false;

class MainView extends Component {
	constructor(props) {
		super(props);
		this.state = {
			width: props.width,
			height: props.height,
			startGame: false,
          	gameWon: undefined,
          	endGameMessage: '',
          	gradientColorQueue: [],
		}
	}

	// This function is applied to all this.state.gradientColorQueue elements.
	// Allows queueing of animations. See map() function on JavaScript arrays.
	// TODO: Code duplication; refactor this out somehow
	_renderGradient(gradientColor, key) {		
		if (gradientColor !== undefined) {
			return (
				<GradientEffects 
					key={key}
	          		gradientColor={gradientColor}
	          		onFinish={this._finishGradientRendering.bind(this)}
	          		width={this.state.width}
	          		height={this.state.height} />);
		} else {
			return (<View />);
		}
	}

	_finishGradientRendering() {
		if (!this.willUnmount) {
			console.log('_finishGradientRendering main');
			var gradientColorQueue = this.state.gradientColorQueue;
			gradientColorQueue.shift();
			this.setState({gradientColorQueue:gradientColorQueue});
		}
	}

	_renderVictory() {
		return (
			<View 
				justifyContent={'center'}
				style={{
					width: this.state.width,
					height: this.state.height,
				}}>
				<Image 
          			style={[styles.victoryImage, 
          				    {
          				    	width: this.state.width,
          				    	height: 400,
          				    	top: -50,
          				    }]}
          			source={victoryImage} 
          			position={'absolute'} />
        		<View 
        			backgroundColor={'rgba(0,0,0,0.5)'} 
        			justifyContent={'center'} 
        			style={{height:50}}>
		        	<Text
		        		allowFontScaling={true} 
		        		style={styles.experience}>{this.state.endGameMessage}</Text>
        		</View>
    		</View>);
	}

	_renderDefeat() {
		return (
			<View>
				<Text
					style={[styles.defeat, 
						    {
						    	width:this.state.width
						    }]}>DEFEAT</Text>
					<View
						backgroundColor={'rgba(0,0,0,0.5)'}
						top={80}>
					<Text
        				position={'absolute'}
        				allowFontScaling={true} 
        				numberOfLines={5}
        				style={styles.defeatMessage}>{this.state.endGameMessage}</Text>
        			</View>
	        </View>);
	}

	render() {
		var gameResult = this.state.gameWon ? this._renderVictory() : this._renderDefeat();

    	var endGame = (this.state.gameWon !== undefined) ? gameResult : <View />;

    	var gradients = this.state.gradientColorQueue.map(this._renderGradient.bind(this));

		return(
			<View 
				style={[styles.container, 
					    {
					    	width:this.state.width, 
					    	height: this.state.height,
					    }]}>
				<Image
					resizeMode={'stretch'}
					style={[styles.background,
						    {
						    	width: this.state.width,
								height:this.state.height,
						    }]}
					source={mainCover}>
				</Image>
				{endGame}
				{gradients}
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
	defeatMessage: {
	    textAlign: 'center',
	    fontSize: 17,
	    color: 'white',
	},
});

module.exports = MainView;
