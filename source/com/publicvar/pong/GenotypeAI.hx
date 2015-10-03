package com.publicvar.pong;

import flixel.util.FlxPoint;

/** GenotypeAI Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  An AI that uses exactly one genotype for its strategy.  This will not
 *  train the AI.
 *  **************************************************************************/
class GenotypeAI implements IPlayer {

/*  Constructor
 *  =========================================================================*/
    public function new(genotype:Genotype) {
        this.genotype = genotype;
    }
 
/*  Public Methods
 *  =========================================================================*/
    public function calcVelocity(m:Paddle, o:Paddle, b:Ball):FlxPoint {
        if (initPosition == null)
            initPosition = FlxPoint.get(m.x, m.y);
        
        if (b.velocity.x == 0 && b.velocity.y == 0)
            return FlxPoint.get(initPosition.x - m.x, initPosition.y - m.y);
        
        return FlxPoint.get(genotype.evalX(m, o, b), genotype.evalY(m, o, b));
    }
 
    public function outcome(point:Int):Void {}
    
/*  Private Members
 *  =========================================================================*/
    private var genotype:Genotype;
    private var initPosition:FlxPoint;
 
/*  Private Methods
 *  =========================================================================*/
    
}