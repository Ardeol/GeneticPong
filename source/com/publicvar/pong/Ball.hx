package com.publicvar.pong;

import openfl.display.BitmapData;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxMath;

/** Ball Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  Represents the ball.  The ball detects its own collisions between the
 *  paddles registered with it.  We use the HaxeFlixel engine in order to
 *  perform the collision physics but add our own modification to allow for
 *  some dynamicism.
 *  **************************************************************************/
class Ball extends FlxSprite {
    
/*  Constructor
 *  =========================================================================*/
/**
 *  Create a new ball.
 *  @param x
 *  @param y
 *  @param radius In pixels
 *  @param color
 */
    public function new(x:Int, y:Int, radius:Int, color:Int) {
        var w = Std.int(radius / 2);
        super(x, y, new BitmapData(w, w, false, color));
        velocity = FlxPoint.get(256, 0);
    //  No friction
        drag = FlxPoint.get(0, 0);
        maxVelocity = FlxPoint.get(Config.BALL_MAX_VEL, Config.BALL_MAX_VEL);
    //  Allows it to bounce
        elasticity = 1;
        
        paddles = new FlxTypedGroup<Paddle>();
    }
    
/*  Flixel API
 *  =========================================================================*/
/**
 *  Updates every frame.
 */
    override public function update():Void {
        if (ballActive) {
            FlxG.collide(this, paddles, paddleCollision);
        //  Emulates a minimum velocity; the ball cannot stop moving
            velocity.x = FlxMath.signOf(velocity.x) * FlxMath.bound(Math.abs(velocity.x), Config.BALL_MAX_VEL / 2, Config.BALL_MAX_VEL);
        }
        super.update();
    }
 
/*  Public Methods
 *  =========================================================================*/
/**
 *  Registers a paddle with the ball.  The ball will collide with registered paddles.
 *  @param p The Paddle object
 */
    public function registerPaddle(p:Paddle):Void {
        paddles.add(p);
    }
    
/**
 *  Returns whether the ball is offscreen, and to which side
 *  @return -1 if off left side, 1 if off right, 0 if on screen
 */
    public function offscreen():Int {
        var padding = 10;
        if (x + width + padding < 0)
            return -1;
        else if (x > FlxG.width + padding)
            return 1;
        else
            return 0;
    }
    
/**
 *  Moves the ball to the center of the screen with 0 velocity.
 *  @param x Does nothing
 *  @param y Does nothing
 */
    override public function reset(x:Float, y:Float):Void {
        this.x = FlxG.width / 2 - width / 2;
        this.y = FlxG.height / 2 - height / 2;
        velocity.set(0, 0);
        ballActive = false;
    }
    
/**
 *  Sends the ball in a direction given by vel.  Vel is the x-velocity.
 *  @param vel Speed in the x direction.
 */
    public function serve(vel:Int):Void {
        ballActive = true;
        velocity.x = vel;
    }
 
/*  Private Members
 *  =========================================================================*/
/**
 *  @private
 *  Registered paddles can be collided with
 */
    private var paddles:FlxTypedGroup<Paddle>;
    
/**
 *  @private
 *  Whether the ball can be hit
 */
    private var ballActive:Bool;
    
/*  Private Methods
 *  =========================================================================*/
/**
 *  @private
 *  Minor manipulation of the physics so that hitting the ball on a part of the paddle will alter its y-velocity.
 *  @param b The ball
 *  @param p The paddle
 */
    private function paddleCollision(b:FlxObject, p:FlxObject):Void {
    //  The farther from the paddle's center, the more effect PADDLE_BIAS has
        var dy = b.y - p.y - p.height / 2;
        b.velocity.y = b.velocity.y + Config.PADDLE_BIAS * dy;
    }
}