package flambe.display.tileSheet;

import flambe.display.Texture;

import flambe.display.Sprite;

import flambe.display.tileSheet.Format;
import flambe.display.Graphics;
import flambe.util.Signal1;
import flambe.Disposer;
using flambe.YSort;

// =============================  Created by: Amos Laber, Dec 2, 2011
//
// AnimSprite is a class to diplay an animated sprite sheet
// it is initialized with a sprite sheet and can hold multiple
// animation sequnces that can be switched anytime
//
class AnimSprite extends Sprite {
    public var tileSheet(get, never):AnimTextureSheet;
    public var numFrames(get, never):Int;
    public var numSequences(get, never):Int;
    public var seqFrame(get, never):Int;
    public var frame(get, set):Int;
	
	public var updateSinal:Signal1<Float>;
	public var disposer:Disposer;

    var mAnimSheet:AnimTextureSheet;
    var mSequences:Array<AnimSeqData>;
   public var curAnim(default,null):AnimSeqData;
// current sequence
    var dirty:Bool;
    var donePlaying:Bool;
    var curIndex:Int;
// Frame index into tile sheet
    var curFrame:Int;
// Frame index in a sequence (local)
// Internal, used to time each frame of animation.
    var frameTimer:Float;
    static public inline var LEFT:Int = 1;
    static public inline var RIGHT:Int = 2;

    public function new(texture:Texture) {

        super();
        fakeElapsed = 0.0167;

        frameTimer = 0;
        mSequences = [];


        this.texture = texture;

updateSinal = new Signal1<Float>();
disposer = new Disposer();
    }


    public function initialize(sheet:AnimTextureSheet):Void {
        if (sheet == null)
            return;
        mAnimSheet = sheet;

        curAnim = null;
        this.frame = 0;
        drawFrame(true);


    }


    public function isPlaying(index:Int = 0):Bool {
        return !donePlaying;
    }

    public function get_tileSheet():AnimTextureSheet {
        return mAnimSheet;
    }

    public function get_numFrames():Int {
        return mAnimSheet.numFrames;
    }

    public function get_numSequences():Int {
        return mSequences.length;
    }

    public function get_seqFrame():Int {
        return curFrame;
    }

    public function get_frame():Int {
        return curIndex;
    }

    public function set_frame(val:Int):Int {
        curFrame = val;
        if (curAnim != null)
            curIndex = curAnim.arFrames[curFrame]
        else curIndex = val;

        dirty = true;
        return val;
    }

    public function getSequenceData(seq:Int):AnimSeqData {
        return mSequences[seq];
    }

    public function getSequence(seq:Int):String {
        return mSequences[seq].seqName;
    }

    public function addSequence(name:String, frames:Array<Int>, ?frameRate:Float = 0, ?looped:Bool = true):Void {
        mSequences.push(new AnimSeqData(name, frames, frameRate, looped));
    }

    public function findSequence(name:String):AnimSeqData {
        return findSequenceByName(name);
    }

    function findSequenceByName(name:String):AnimSeqData {
        var aSeq:AnimSeqData;
        var i:Int = 0;
        while (i < mSequences.length) {
            aSeq = cast((mSequences[i]), AnimSeqData);
            if (aSeq.seqName == name) {
                return aSeq;
            }
            i++;
        }
        return null;
    }


    public function play(name:String = null):Void {

        if (name == null) {
            donePlaying = false;
            dirty = true;
            frameTimer = 0;
            return;
        }
        ;
        curFrame = 0;
        curIndex = 0;
        frameTimer = 0;
        curAnim = findSequenceByName(name);
        if (curAnim == null) {
            trace("play: cannot find sequence: " + name);
            return;
        }

        curIndex = curAnim.arFrames[0];
        donePlaying = false;
        dirty = true;

        if (curAnim.arFrames.length == 1)
            donePlaying = true;
    }


    public function stop():Void {
        donePlaying = true;
    }


    public function frameAdvance(next:Bool):Void {
        if (next) {
            if (Std.int(curFrame) < curAnim.arFrames.length - 1)
                ++curFrame;
        }

        else {
            if (curFrame > 0)
                --curFrame;
        }

        curIndex = curAnim.arFrames[curFrame];
        dirty = true;
    }

    public function drawFrame(force:Bool = false):Void {
        if (force || dirty)
            drawFrameInternal();
    }


    var fakeElapsed:Float;

    override public function onUpdate(dt:Float) {

        super.onUpdate(dt);

        updateAnimation();

       updateSinal.emit(dt);
    }

    override public function isOutScreen():Bool {
        return false;
    }

    public function updateAnimation():Void {
        if (isOutScreen())
            return;
        if (curAnim != null && curAnim.delay > 0 && !donePlaying) {

            frameTimer += fakeElapsed;
            while (frameTimer > curAnim.delay) {
                frameTimer = frameTimer - curAnim.delay;
                advanceFrame();
            }

        }
        if (dirty)
            drawFrameInternal();
    }


    function advanceFrame():Void {
        if (Std.int(curFrame) == curAnim.arFrames.length - 1) {
            if (curAnim.loop)
                curFrame = 0
            else donePlaying = true;
        }

        else ++curFrame;
        curIndex = curAnim.arFrames[curFrame];
        dirty = true;
    }

// Internal function to update the current animation frame

    var needDraw:Bool = false;

    function drawFrameInternal():Void {
        dirty = false;
// needDraw=true;
//  trace(curIndex);

        anchorY._ = getNaturalHeight();
    }


    public var texture:Texture;

    override public function draw(ctx:Graphics) {
//  var frame:FrameData=mAnimSheet.getFrameData(curIndex);

        if (isOutScreen())
            return;

        var data:FrameData = mAnimSheet.getFrameData(curIndex);


        ctx.drawSubImage(texture, data.offX, data.offY, data.x, data.y, data.w, data.h) ;

    }

    override public function getNaturalWidth():Float {
        return mAnimSheet.get_frameWidth(curIndex);//.getFrameWidth(curIndex);
    }

    override public function getNaturalHeight():Float {
        return mAnimSheet.get_frameHeight(curIndex);
    }

}

