package com.publicvar.pong;

import flixel.FlxG;
import flixel.util.FlxPoint;

/** HumanPlayer Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 * 
 *  A human-controlled paddle.
 *  **************************************************************************/
class HumanPlayer implements IPlayer {
    public static inline var MAGNITUDE = Config.PADDLE_MAX_VEL;
    
/*  Constructor
 *  =========================================================================*/
/**
 *  Create a new player paddle.  Takes as parameters the keys to use for directional movement.
 *  @param up
 *  @param right
 *  @param down
 *  @param left
 */
    public function new(up:String, right:String, down:String, left:String) {
        this.up = [up];
        this.right = [right];
        this.down = [down];
        this.left = [left];
    }

/*  Public Methods
 *  =========================================================================*/
    public function calcVelocity(m:Paddle, o:Paddle, b:Ball):FlxPoint {
        var xComp = 0;
        var yComp = 0;
        if (FlxG.keys.anyPressed(up))
            yComp -= MAGNITUDE;
        if (FlxG.keys.anyPressed(right))
            xComp += MAGNITUDE;
        if (FlxG.keys.anyPressed(down))
            yComp += MAGNITUDE;
        if (FlxG.keys.anyPressed(left))
            xComp -= MAGNITUDE;
            
        return FlxPoint.get(xComp, yComp);
    }
    
    public function outcome(point:Int):Void {}
 
/*  Private Members
 *  =========================================================================*/
    private var up:Array<String>;
    private var right:Array<String>;
    private var down:Array<String>;
    private var left:Array<String>;
 
}