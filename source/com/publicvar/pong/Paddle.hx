package com.publicvar.pong;

import openfl.display.BitmapData;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/** Paddle Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  A paddle on the field.  Their motion is entirely dependent on player
 *  actions.
 *  **************************************************************************/
class Paddle extends FlxSprite {

/**
 *  Make a new paddle instance.
 *  @param x
 *  @param y
 *  @param width
 *  @param height
 *  @param color
 */
    public function new(x:Int, y:Int, width:Int, height:Int, color:Int) {
        super(x, y, new BitmapData(width, height, false, color));
        immovable = true; // Important!  Prevents the physics from affecting the paddle.
    }
    
}