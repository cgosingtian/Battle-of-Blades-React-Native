'use strict';

var Utilities = require('./utilities');

var DEFEAT_HINT_1 = 'The enemy will heal if you fail to stop his attacks! Tap on the attack icons before they disappear.';
var DEFEAT_HINT_2 = 'The enemy can defend his attacks with the blue shield icon, but it cannot be everywhere at once. Tapping the blue icon causes you to lose time.';

export function generateDefeatMessage() {
	var messages = [DEFEAT_HINT_1, DEFEAT_HINT_2];

	var hint = Utilities.getRandomIntFromRange(0,1);

	return messages[hint];
}

exports.EndMessageCreator = this;