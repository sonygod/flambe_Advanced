package flambe.display.tileSheet;


import flambe.display.tileSheet.Format;
//
// Helper VO for storing sequence data
//
class AnimSeqData {

// String name of the animation sequence (e.g. "walk")
    public var seqName:String;
// Seconds between frames (basically the framerate)
    public var delay:Float;
// Whether or not the animation is looped
    public var loop:Bool;
// A list of frames stored as Int objects
    public var arFrames:Array<Int>;

    public function new(name:String, frames:Array<Int>, ?frameRate:Float = 0, ?looped:Bool = true) {
        seqName = name;
        delay = 0;
        if (frameRate > 0)
            delay = 1.0 / frameRate;
        arFrames = frames;
        loop = looped;
    }

    function destroy():Void {
        arFrames = null;
    }

}

