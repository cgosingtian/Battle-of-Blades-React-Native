'use strict';

export function getRandomIntFromRange(minimum, maximum) {
	return Math.floor(Math.random() * (maximum - minimum + 1)) + minimum;
}

exports.Utilities = this;
