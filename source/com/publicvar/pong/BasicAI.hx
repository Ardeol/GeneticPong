package com.publicvar.pong;

import flixel.util.FlxMath;
import flixel.util.FlxPoint;

/** BasicAI Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 * 
 *  Basic implementation of an AI.  All it does is follows the ball's y
 *  position, so it misses any time fast bounces occur.
 *  **************************************************************************/
class BasicAI implements IPlayer {
    public static inline var MAGNITUDE = Config.PADDLE_MAX_VEL;
    
/*  Constructor
 *  =========================================================================*/
    public function new(){}
    
/*  Class Methods
 *  =========================================================================*/
    public function calcVelocity(m:Paddle, o:Paddle, b:Ball):FlxPoint {
        return FlxPoint.get(0, MAGNITUDE * FlxMath.signOf(b.y - m.y - m.height / 2));
    }
    
    public function outcome(point:Int):Void {}
 
/*  Public Methods
 *  =========================================================================*/
    
 
/*  Private Members
 *  =========================================================================*/
    
 
/*  Private Methods
 *  =========================================================================*/
    
}