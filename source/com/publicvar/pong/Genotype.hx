package com.publicvar.pong;

import haxe.ds.Vector;

import flixel.util.FlxRandom;
import flixel.util.FlxMath;

/** Genotype Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  A set of weights used to determine where the paddle will move to.
 * 
 *  Evaluation is done on relevant dimensions.  In other words, the x-vel
 *  only depends on x-components, and the same with the y-vel.  This was only
 *  done to improve convergence time.  A real generic genetic algorithm
 *  will start off with as little information as possible and include weights
 *  on all components, including enemy position.
 *  **************************************************************************/
class Genotype {
    public var weights:Vector<Float>;
//  @TODO Move fitness evalutation into this class
    public var fitness:Float;
    
/**
 *  Make a genotype given an array of weights
 *  @param w Array of weights.  If not given, it will initialize to an all-0 array.
 */
    public function new(?w:Array<Float> = null) {
        if(w == null)
            weights = new Vector<Float>(6);
        else
            weights = Vector.fromArrayCopy(w);
        fitness = 0;
    }

/**
 *  Evaluates the x velocity of the paddle.
 *  @param m
 *  @param o
 *  @param b
 *  @return Velocity for the paddle.
 */
    public function evalX(m:Paddle, o:Paddle, b:Ball):Float {
        var w = weights;
        return w[4] * b.velocity.x + w[0] * b.x + w[1] * m.x;
    }
    
/**
 *  Evaluates the y velocity of the paddle.
 *  @param m
 *  @param o
 *  @param b
 *  @return Velocity for the paddle.
 */
    public function evalY(m:Paddle, o:Paddle, b:Ball):Float {
        var w = weights;
        return w[5] * b.velocity.y + w[2] * b.y + w[3] * m.y;
    }
    
/**
 *  Returns a random Genotype given a range of weights.
 *  @param low
 *  @param high
 *  @return
 */
    public static function random(low:Float, high:Float):Genotype {
        var w = new Genotype();
        for (i in 0...(w.weights.length))
            w.weights[i] = FlxRandom.floatRanged(low, high);
        return w;
    }
    
/**
 *  Crosses two parent Genotypes and produces a child.
 *  @param a
 *  @param b
 *  @return
 */
    public static function cross(a:Genotype, b:Genotype):Genotype {
    //  At the moment, a child is just the average of the weights.  It honestly seems to work well, perhaps unexpectedly.
        var g = new Genotype();
        for (i in 0...(g.weights.length)) {
            g.weights[i] = (a.weights[i] + b.weights[i]) / 2;
        }
        return g;
    }
    
/**
 *  Mutates a genotype and forms a new one.  A Mutation is a slight modification on the current genotype.  We use this to try and escape local maxima.
 *  @param a
 *  @return
 */
    public static function mutate(a:Genotype):Genotype {
        var g = new Genotype();
        for (i in 0...(g.weights.length))
            g.weights[i] = a.weights[i] + FlxRandom.floatRanged( -0.1, 0.1);
        return g;
    }
    
/**
 *  Converts genotype to a string.
 *  @return
 */
    public function toString():String {
        return weights.toArray().join(",") + ":" + Std.string(fitness);
    }
}