package com.publicvar.pong;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSave;

/** MenuState Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 * 
 *  The main menu.
 *  **************************************************************************/
class MenuState extends FlxState {

/*  Flixel API
 *  =========================================================================*/
    override public function create() {
        lplayer = new HumanPlayer("W", "D", "S", "A");
        rplayer = new HumanPlayer("UP", "RIGHT", "DOWN", "LEFT");
        
        initInfo();
        
        playButton = new Button(0, 0, "Play!", play, 24);
        playButton.x = Std.int(FlxG.width / 2 - playButton.width / 2);
        playButton.y = 425;
        
        lpButtons = initPlayerOptions(Std.int(FlxG.width / 4) - 75, "W", "D", "S", "A", "lp_genetic", function(p:IPlayer) {
            lplayer = p;
        });
        
        rpButtons = initPlayerOptions(Std.int(3 * FlxG.width / 4) - 75, "UP", "RIGHT", "DOWN", "LEFT", "rp_genetic", function(p:IPlayer) {
            rplayer = p;
        });
        
        add(info);
        add(playButton);
        add(lpButtons);
        add(rpButtons);
        super.create();
    }
 
/*  Private Members
 *  =========================================================================*/
    private var info:FlxGroup;
    private var playButton:Button;
    private var lpButtons:FlxGroup;
    private var rpButtons:FlxGroup;
    
    private var lplayer:IPlayer;
    private var rplayer:IPlayer;
 
/*  Private Methods
 *  =========================================================================*/
    private function play():Void {
        FlxG.switchState(new PlayState(lplayer, rplayer));
    }
 
    private function initInfo():Void {
        info = new FlxGroup();
        
        var title = new FlxText(0, 20, FlxG.width, "Genetic Pong", 42);
        title.color = Config.COLOR_PRIMARY;
        title.alignment = "center";
        
        var subtitle = new FlxText(0, 80, FlxG.width, "by Timothy Foster", 24);
        subtitle.color = Config.COLOR_PRIMARY;
        subtitle.alignment = "center";
        
        var version = new FlxText(0, FlxG.height - 14, 0, Config.VERSION);
        version.color = Config.COLOR_PRIMARY;
        
        var lpText = new FlxText(0, 144, 0, "Player 1", 16);
        lpText.color = Config.COLOR_PRIMARY;
        lpText.x = Std.int(FlxG.width / 4 - lpText.width / 2);
        
        var rpText = new FlxText(0, 144, 0, "Player 2", 16);
        rpText.color = Config.COLOR_PRIMARY;
        rpText.x = Std.int(3 * FlxG.width / 4 - rpText.width / 2);
        
        info.add(title);
        info.add(subtitle);
        info.add(version);
        info.add(lpText);
        info.add(rpText);
    }
    
    private function initPlayerOptions(x:Int, up:String, right:String, down:String, left:String, trainerFile:String, setplayer:IPlayer->Void):FlxGroup {
        var g = new FlxGroup();
        var curY = 180;
        var yInc = 32;
        
        var hb = new Button(x, curY, "Human", setplayer.bind(new HumanPlayer(up, right, down, left)), 16);
        curY += yInc;
        var bb = new Button(x, curY, "Basic AI", setplayer.bind(new BasicAI()), 16);
        curY += yInc;
        var pb = new Button(x, curY, "Perfect AI", setplayer.bind(new PerfectAI()), 16);
        curY += yInc;
        var gb = new Button(x, curY, "Genetic AI", setplayer.bind(new GenotypeAI(GeneticTrainer.bestGenotypeFromSave(trainerFile))), 16);
        curY += yInc;
        var tb = new Button(x, curY, "Trainer", setplayer.bind(new GeneticTrainer(32, 3, trainerFile)), 16);
        curY += yInc;
        curY += Std.int(yInc / 3);
        var rb = new Button(x, curY, "Reset Genetic", function() {
            var s = new FlxSave();
            s.bind(trainerFile);
            s.erase();
        }, 16);
        
        g.add(hb);
        g.add(bb);
        g.add(pb);
        g.add(gb);
        g.add(tb);
        g.add(rb);
        
        return g;
    }
}