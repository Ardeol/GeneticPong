package com.publicvar.pong;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxMath;

/** GeneticTrainer Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  This AI is used to train the Genotype AI.  Its goal is to search for the
 *  best weights in an evaluation equation to achieve maximal performance.
 * 
 *  This is done using, obviously, a genetic algorithm.  Steps are as follows:
 *    * Start with an initial population of Genotypes that encode behavior
 *    * Try each one once and record its "fitness" when someone scores
 *    * Once each has been tried, repopulate with new Genotypes and try again
 * 
 *  Repopulation is not random but is instead divided into four parts.
 *    * The first part has the best Genotypes from the previous generation
 *    * The second part has combinations of Genotypes from the first part
 *    * The third part contains mutations of Genotypes from the first part
 *    * The fourth part contains completely random Genotypes
 * 
 *  Fitness evaluation considers three aspects:
 *    * Whether the Trainer scored
 *    * How long the ball has been in play
 *    * If the Trainer misses, how much it missed by
 * 
 *  Over time the Trainer will start to hone in on strategies it likes.
 *  Unfortunately, it seems prone to running into local maximums and will
 *  eventually get to a point where all genotypes are the same.  At that
 *  point, rather than finding new strategies, it seems to hone down its
 *  current strategy.
 *  **************************************************************************/
class GeneticTrainer implements IPlayer {
    public static inline var MAGNITUDE = Config.PADDLE_MAX_VEL;
    public static inline var POINT_FITNESS = 9999;

/*  Constructor
 *  =========================================================================*/
/**
 *  Make a new trainer.  You can supply it with an initial population size.  Higher size means more variety but longer training time.
 *  @param populationSize Initial population size.  I recommend multiples of 2.
 *  @param range Range for the weights.  Should be greater than 1 for best performance.  2 is propably optimal, but I did not test this out so much.
 *  @param saveBinding Name of the save file to use.
 */
    public function new(populationSize:Int, range:Float, saveBinding:String) {
        this.range = range;
        this.counter = 0;
        this.cur = 0;
        this.ballHasCrossed = false;
        
        this.save = new FlxSave();
        this.saveName = saveBinding;
        
        initPopulation(populationSize);
    }
    
/*  Class Methods
 *  =========================================================================*/
/**
 *  Obtain the best genotype from a given save location.
 *  @param s
 *  @return Genotype with the best performance in a set of populations
 */
    public static function bestGenotypeFromSave(s:String):Genotype {
    //  It does in fact check ALL genotypes, not just in the current population
    //  This may be faulty.  It probably should only check the latest population.
        var save = new FlxSave();
        save.bind(s);
        if (save.data.genotypes == null)
            return Genotype.random(-3, 3);
            
        var data:SaveData = save.data.genotypes;
        var bestGenotype:Genotype = Genotype.random(0, 0);
        for (pop in data) {
            for (g in pop) {
                if (g.fitness > bestGenotype.fitness) {
                    bestGenotype = new Genotype(g.weights);
                    bestGenotype.fitness = g.fitness;
                }
            }
        }
        
        return bestGenotype;
    }
 
/*  Public Methods
 *  =========================================================================*/
/**
 *  Determining location is done purely through the genotype's evaluation functions.
 *  @param m
 *  @param o
 *  @param b
 *  @return
 */
    public function calcVelocity(m:Paddle, o:Paddle, b:Ball):FlxPoint {
    //  We afford it the start location due to the way evaluation was implemented
        if (b.velocity.x == 0 && b.velocity.y == 0)
            return returnToStart(m);
        
        ++counter;
        if (!ballHasCrossed)
            lastDistance = getCrossingDistance(m, b);
        
        return FlxPoint.get(population[cur].evalX(m, o, b), population[cur].evalY(m, o, b));
    }
    
/**
 *  This will evaluate the ball's fitness and store it into the genotype.  Once all members of the population have been checked, it repopulates.
 *  @param point
 */
    public function outcome(point:Int):Void {
        var fitness = 0;
        if (point > 0)
            fitness = POINT_FITNESS;
        fitness += counter;
        fitness += 480 - 3 * lastDistance;
        ballHasCrossed = false;
        
        if(population[cur].fitness != 0) {
            population[cur].fitness += fitness;
            population[cur].fitness /= 2;
        }
        else
            population[cur].fitness += fitness;
        
        counter = 0;
        ++cur;
        if (cur >= population.length) {
            writePopulation();
            repopulate();
            cur = 0;
        }
    }
 
/*  Private Members
 *  =========================================================================*/
    private var range:Float;
    private var population:Array<Genotype>;
    private var cur:Int;
    private var counter:Int;
    private var initPosition:FlxPoint;
    private var lastDistance:Int;
    private var ballHasCrossed:Bool;
    private var saveName:String;
    private var save:FlxSave;
 
/*  Private Methods
 *  =========================================================================*/
/**
 *  @private
 *  Initializes the population.  Uses the save file if possible, otherwise starts fresh.
 *  @param size Initial size of the population; only used if the save file does not exist.
 */
    private function initPopulation(size:Int):Void {
        population = new Array<Genotype>();
        
        save.bind(saveName);
        if (save.data.genotypes != null) {
        //  We only look at the last generation
            var data:SaveData = save.data.genotypes;
            for (w in (data[data.length - 1])) {
                var g = new Genotype(w.weights);
                g.fitness = w.fitness;
                population.push(g);
            }
            trace("data loaded");
        }
        else {
            for (i in 0...size)
                population.push(Genotype.random( -range, range));
        }
    }
    
/**
 *  @private
 *  Appends the generation to the file.  The file keeps a record of all generations for history's sake.
 */
    private function writePopulation():Void {
    //  @TODO Set a limit on the number of populations tracked.  We don't want file sizes to get bloated.
        save.bind(saveName);
        if (save.data.genotypes == null) 
            save.data.genotypes = new SaveData();

        var saveArray:SaveData = save.data.genotypes;
        saveArray.push(population.map(function(g:Genotype):{weights:Array<Float>, fitness:Float} {
            var value = {
                weights: new Array<Float>(),
                fitness: g.fitness
            };
            for (n in g.weights)
                value.weights.push(n);
            return value;
        }));
        save.data.genotypes = saveArray;
        save.flush();
    }
    
/**
 *  @private
 *  Changes the population into a new set of genotypes to test.
 */
    private function repopulate():Void {
    //  Sort by fitness
        population.sort(function(a:Genotype, b:Genotype):Int {
            if (a.fitness == b.fitness)
                return 0;
            else if (a.fitness < b.fitness)
                return 1;
            else
                return -1;
        });
        
        var oldPop = population.length;
        
    //  Remove the worse 3/4
        for (i in 0...(3*Std.int(population.length / 4)))
            population.pop();
            
    //  Cross the best with a random geneotype in the same generation
        var i = 0;
        var end = population.length;
        while (i < end / 2) {
            population.push(Genotype.cross(population[i], population[FlxRandom.intRanged(0, end - 1)]));
            ++i;
        }
        
    //  Add some random mutated genotypes
        for (j in 0...(Std.int(oldPop / 8)))
            population.push(Genotype.mutate(population[FlxRandom.intRanged(0, end - 1)]));
        
    //  Fill in the remaining with a pool of new randoms
        i = population.length;
        while (i < oldPop) {
            population.push(Genotype.random(-range, range));
            ++i;
        }
    }
    
/**
 *  @private
 *  Get the amount by which the paddle missed the ball.
 *  @param m
 *  @param b
 *  @return
 */
    private function getCrossingDistance(m:Paddle, b:Ball):Int {
        var dis = 0;
        if ((m.x >= Std.int(FlxG.width / 2) && b.x > m.x + 1) || (m.x < Std.int(FlxG.width / 2) && b.x < m.x - 1)) {
            ballHasCrossed = true;
            if (b.y > m.y)
                dis = Std.int(b.y - (m.y + m.height));
            else
                dis = Std.int(m.y - (b.y + b.height));
        }
        return dis;
    }
    
/**
 *  @private
 *  Returns the ball to its initial location
 *  @param m
 *  @return
 */
    private function returnToStart(m:Paddle):FlxPoint {
        if (initPosition == null)
            initPosition = FlxPoint.get(m.x, m.y);
        return FlxPoint.get(initPosition.x - m.x, initPosition.y - m.y);
    }
}

/**
 *  Data structure used for saves.  It is an array of populations.
 *  A Population is an array of Genotypes.
 *  A Genotype is an array of weights, with a fitness level.
 */
private typedef SaveData = Array<Array<{weights:Array<Float>, fitness:Float}>>;