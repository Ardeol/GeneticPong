package com.publicvar.pong;

import flixel.ui.FlxButton;

/** Button Class
 *  @author  Timothy Foster
 *  @version 0.00.151003
 *
 *  Small custom button class.
 *  **************************************************************************/
class Button extends FlxButton {

/*  Constructor
 *  =========================================================================*/
/**
 *  Create a new button
 *  @param x
 *  @param y
 *  @param txt
 *  @param cb Callback
 *  @param size Size of the text
 */
    public function new(x:Int, y:Int, txt:String, cb:Void->Void, size:Float) {
        super(x, y, txt, cb);
        makeGraphic(Std.int(9.0 * size), Std.int(1.75 * size), Config.COLOR_PRIMARY);
        label.size = size;
        label.color = Config.COLOR_DARK;
    }
    
/*  Class Methods
 *  =========================================================================*/
    
 
/*  Public Methods
 *  =========================================================================*/
    
 
/*  Private Members
 *  =========================================================================*/
    
 
/*  Private Methods
 *  =========================================================================*/
    
}