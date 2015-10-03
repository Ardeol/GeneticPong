package com.publicvar.pong;

import openfl.display.BitmapData;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;
import flixel.util.FlxPoint;

/** PlayState Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 * 
 *  The actual game itself.
 *  **************************************************************************/
class PlayState extends FlxState {

/**
 *  We require that the two players be given.
 *  @param lp
 *  @param rp
 */
    public function new(lp:IPlayer, rp:IPlayer) {
        super();
        lplayer = lp;
        rplayer = rp;
    }
    
/*  Flixel API
 *  =========================================================================*/
    override public function create():Void {
        var midX = Std.int(FlxG.width / 2);
        var midY = Std.int(FlxG.height / 2);
        
    //  Make Paddles
        lpaddle = new Paddle(100, midY - Std.int(Config.PADDLE_HEIGHT / 2), Config.PADDLE_WIDTH, Config.PADDLE_HEIGHT, Config.COLOR_PRIMARY);
        rpaddle = new Paddle(FlxG.width - 100, midY - Std.int(Config.PADDLE_HEIGHT / 2), Config.PADDLE_WIDTH, Config.PADDLE_HEIGHT, Config.COLOR_PRIMARY);
        
    //  Make Ball
        ball = new Ball(0, 0, Config.BALL_RADIUS, Config.COLOR_PRIMARY);
        ball.registerPaddle(lpaddle);
        ball.registerPaddle(rpaddle);
        ball.reset(0, 0);
        
    //  Make ceiling and floor
        walls = new FlxGroup();
        walls.add(makeWall(0, -10, FlxG.width, 10));
        walls.add(makeWall(0, FlxG.height, FlxG.width, 10));
        
    //  Centerline
        var centerline = makeWall(midX, 0, 1, FlxG.height);
        
    //  Scores
        lscore = 0;
        rscore = 0;
        lscoreText = new FlxText(midX - 48, 0, 0, "0", 24);
        rscoreText = new FlxText(midX + 48, 0, 0, "0", 24);
        lscoreText.alignment = "center";
        rscoreText.alignment = "center";
        lscoreText.x -= Std.int(lscoreText.width / 2);
        rscoreText.x -= Std.int(rscoreText.width / 2);
        
    //  Add to scene
        add(centerline);
        add(lscoreText);
        add(rscoreText);
        add(lpaddle);
        add(rpaddle);
        add(ball);
        
        new FlxTimer(3, function(t:FlxTimer) {  ball.serve(Std.int(Config.BALL_MAX_VEL / 2)); } , 1);
    }
    
    override public function update():Void {
    //  Determine paddle velocities
        var lVel = lplayer.calcVelocity(lpaddle, rpaddle, ball);
        var rVel = rplayer.calcVelocity(rpaddle, lpaddle, ball);
        lpaddle.velocity.set(lVel.x, lVel.y);
        rpaddle.velocity.set(rVel.x, rVel.y);
        clampPaddle(lpaddle, true);
        clampPaddle(rpaddle, false);
        
        checkForScore();
        
        FlxG.collide(ball, walls);
        
        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new MenuState());
        
        super.update();
    }
    
    override public function destroy():Void {
        super.destroy();
        lpaddle = null;
        rpaddle = null;
        ball = null;
        lplayer = null;
        rplayer = null;
        walls = null;
        lscoreText = null;
        rscoreText = null;
    }
 
/*  Private Members
 *  =========================================================================*/
    private var lpaddle:Paddle;
    private var rpaddle:Paddle;
    private var ball:Ball;
    
    private var lplayer:IPlayer;
    private var rplayer:IPlayer;
    
    private var walls:FlxGroup;
    
    private var lscore:Int;
    private var rscore:Int;
    private var lscoreText:FlxText;
    private var rscoreText:FlxText;
    
/*  Private Methods
 *  =========================================================================*/
    private function checkForScore():Void {
        var offscreen = ball.offscreen();
        if (offscreen != 0) {
            ball.reset(0, 0);
            ball.x += offscreen * ball.width;
            
            if (offscreen < 0)
                ++rscore;
            else
                ++lscore;
            lscoreText.text = Std.string(lscore);
            rscoreText.text = Std.string(rscore);
            
            lplayer.outcome(offscreen);
            rplayer.outcome(-offscreen);
                
            new FlxTimer(3, function(t:FlxTimer) {  ball.serve(Std.int(Config.BALL_MAX_VEL / 2 * offscreen)); } , 1);
        }
    }

/*  Private Class Methods
 *  =========================================================================*/
    private static function makeWall(x:Int, y:Int, w:Int, h:Int):FlxSprite {
        var s = new FlxSprite(x, y, new BitmapData(w, h, false, Config.COLOR_DARK));
        s.immovable = true;
        return s;
    }
    
    private static function clampPaddle(p:Paddle, toLeft:Bool):Void {
    //  Position
        p.y = FlxMath.bound(p.y, 0, FlxG.height - p.height);
        if (toLeft)
            p.x = FlxMath.bound(p.x, 0, FlxG.width / 2 - p.width);
        else
            p.x = FlxMath.bound(p.x, FlxG.width / 2, FlxG.width - p.width);
            
    //  Velocity
        p.velocity.x = FlxMath.bound(p.velocity.x, -Config.PADDLE_MAX_VEL, Config.PADDLE_MAX_VEL);
        p.velocity.y = FlxMath.bound(p.velocity.y, -Config.PADDLE_MAX_VEL, Config.PADDLE_MAX_VEL);
    }
}