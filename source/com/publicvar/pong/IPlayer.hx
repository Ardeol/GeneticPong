package com.publicvar.pong;

import flixel.util.FlxPoint;

/** IPlayer Interface
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  Generic interface to be implemented by all entities that can play
 *  pong.
 *  **************************************************************************/
interface IPlayer {
/**
 *  Returns the velocity the paddle should move.  We give it the states of the two paddles and the ball.  Called once per frame.
 * 
 *  Note that this should not go about modifying the structures of the input parameters.  That would be cheating.
 *  @param myPaddle Owner's paddle.
 *  @param oppPaddle The opponent's paddle.
 *  @param ball The ball.
 *  @return
 */
    function calcVelocity(myPaddle:Paddle, oppPaddle:Paddle, ball:Ball):FlxPoint;
    
/**
 *  Called when someone scores.  An AI might use this information somehow.
 *  @param point Who received the point.  1 indicates the player did, -1 indicates the opponent did.
 */
    function outcome(point:Int):Void;
}