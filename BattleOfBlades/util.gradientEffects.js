'use strict';

import React, {
	Component,
	StyleSheet,
	Image,
	Animated,
  View,
  InteractionManager,
} from 'react-native';

var blueGradient = require('./Resources/bluegradientbg.png');
var greenGradient = require('./Resources/greengradientbg.png');
var redGradient = require('./Resources/redgradientbg.png');

class GradientEffects extends Component {
  	constructor(props) {
  		  super(props);
    		this.state = {
      			width: props.width,
      			height: props.height,
      			fadeAnimation: new Animated.Value(0),
      			gradientColor: props.gradientColor,
      			onFinish: props.onFinish,
    		}
  	}

    componentDidMount() {
        InteractionManager.runAfterInteractions(() => {
            Animated.sequence([
      		      Animated.timing(this.state.fadeAnimation,
             		{
             			toValue: 1,
             			duration: 50,
             		}),
             		Animated.timing(this.state.fadeAnimation,
             		{
             			toValue: 0,
             			duration: 100,
             		})
  		      ])
            .start(this.state.onFinish);
        });
   	}

   	componentWillUnmount() {
      console.log('GRADIENT UNMOUNTED');
   	}

   	_returnGradientImageSource() {
   		switch(this.state.gradientColor) {
   			case 'red': return redGradient;
   			case 'green': return greenGradient;
   			case 'blue': return blueGradient;
   			//case 'white': return undefined;
   			default: return redGradient;
   		}
   	}

  	render() {
  		var gradientSource = this._returnGradientImageSource();
  		
     		return(
            <View 
                pointerEvents={'none'} 
                style={{
                    top: 0,
                    backgroundColor:'rgba(0,0,0,0)',
                    width:this.state.width,
                    height:this.state.height,
                    position:'absolute',
                }}>
           			<Animated.Image
                		source={gradientSource}
                    renderToHardwareTextureAndroid={true} // android
                		style={{
                  			top: 0,
                  			backgroundColor:'rgba(0,0,0,0)',
                  			width:this.state.width,
                  			height:this.state.height,
                  			opacity:this.state.fadeAnimation,
                  			position:'absolute',
                		}}>
                		{this.props.children}
               	</Animated.Image>
            </View>
     		);
    }
}

module.exports = GradientEffects;
