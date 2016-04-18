'use strict';

var Utilities = require('./utilities');

var ENEMY_STAT_MODIFIER_EASY = 1; // 100%, no change
var ENEMY_STAT_MODIFIER_AVERAGE = 1.5; // 150%
var ENEMY_STAT_MODIFIER_HARD = 2; //200%

export function enemyWithDifficulty(difficulty) {
	this.difficulty = difficulty;

	var minimumLevel = 1;
	var maximumLevel = 2+difficulty;
	var level = Utilities.getRandomIntFromRange(minimumLevel, maximumLevel);
	console.log('LEVEL: ' +level);
	this.level = level;
	this.timeLeft = generateTimeLeftWithDifficulty(difficulty);
	this.health = generateHealthWithDifficulty(difficulty, level);

	switch(difficulty) {
		case 0: {
			this.name = 'Easy Guy';
		} break;
		case 1: {
			this.name = 'Average Guy';
		} break;
		case 2: {
			this.name = 'Hard Guy';
		} break;
		default: {
			this.name = 'Easy Guy';
		}
	}
}

function generateHealthWithDifficulty(difficulty, level) {
	var health = 40;
	health *= level;

	switch (difficulty) {
        case 0: {
            health *= ENEMY_STAT_MODIFIER_EASY;
        } break;
        case 1: {
            health *= Utilities.getRandomIntFromRange(ENEMY_STAT_MODIFIER_EASY,ENEMY_STAT_MODIFIER_AVERAGE);            
        } break;
        case 2: {
            health *= Utilities.getRandomIntFromRange(ENEMY_STAT_MODIFIER_EASY,ENEMY_STAT_MODIFIER_HARD);            
        } break;
        default: {
        	health *= ENEMY_STAT_MODIFIER_EASY;
        }
    }

	return health;
}

function generateTimeLeftWithDifficulty(difficulty) {
	var minimumTime = 20;

	var maximumTime = minimumTime + 5;
	switch (difficulty) {
        case 2: {
            maximumTime *= ENEMY_STAT_MODIFIER_EASY;
        } break;
        case 1: {
            maximumTime *= Utilities.getRandomIntFromRange(ENEMY_STAT_MODIFIER_EASY, ENEMY_STAT_MODIFIER_AVERAGE);            
        } break;
        case 0: {
            maximumTime *= Utilities.getRandomIntFromRange(ENEMY_STAT_MODIFIER_EASY, ENEMY_STAT_MODIFIER_HARD);            
        } break;
        default: {
        	maximumTime *= Utilities.getRandomIntFromRange(ENEMY_STAT_MODIFIER_EASY, ENEMY_STAT_MODIFIER_HARD);
        }
    }

	return Utilities.getRandomIntFromRange(minimumTime, maximumTime);
}

exports.EnemyCreator = this;
