package com.publicvar.pong;

import flixel.FlxG;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;

/** PerfectAI Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  Uses simple math to determine where the ball will be so the paddle always
 *  arrives before the ball gets there.  Isn't actually perfect, but pretty
 *  darned close.
 * 
 *  I made this to train the genetic AI more effectively.
 *  **************************************************************************/
class PerfectAI implements IPlayer {
    public static inline var MAGNITUDE = Config.PADDLE_MAX_VEL;
    
    public function new(){}
    
    public function calcVelocity(m:Paddle, o:Paddle, b:Ball):FlxPoint {
        var ballY = b.y;
        var ballVelX = Math.abs(b.velocity.x);
        if (m.x < FlxG.width / 2)
            ballVelX *= -1;
        if (b.velocity.x != 0)
        //  And this is why we learn physics
            ballY = Std.int((b.velocity.y / ballVelX) * (m.x - b.x) + b.y);
        
    //  There's probably a better way of doing this, but I was lazy
    //  Finds the ball's true y given the fact that it reflects off of walls
        while (ballY < 0 || ballY > FlxG.height) {
            if (ballY < 0)
                ballY = Std.int(Math.abs(ballY));
            else
                ballY = FlxG.height - (ballY % FlxG.height);
        }

        return FlxPoint.get(0, MAGNITUDE * FlxMath.signOf(ballY - m.y - m.height / 2));
    }
    
    public function outcome(point:Int):Void {}

}