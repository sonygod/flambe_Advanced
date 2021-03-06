package flambe.display.tileSheet;
import flambe.math.Point;
import flambe.math.Rectangle;
import flambe.display.tileSheet.Format;
//
// AnimPack holds a single texture tile sheet, and can have
// multiple animation sequneces in it.
//
class AnimTextureSheet {
    public var name(get, never):String;
    public var maxRect(get, never):Rectangle;
    public var numFrames(get, never):Int;
    var mName:String;
    var mTextureRegions:Vector<Rectangle>;
    var mFrameOffsets:Vector<Point>;
    var mFrameRect:Rectangle;

    public function new() {
        mTextureRegions = new Vector<Rectangle>();
        mFrameRect = new Rectangle();
        mFrameOffsets = new Vector<Point>();
    }

    public function get_name():String {
        return mName;
    }

    public function get_maxRect():Rectangle {
        return mFrameRect;
    }

    public function get_numFrames():Int {
        return mTextureRegions.length;
    }

    public function get_frameWidth(fr:Int):Float {
        return (mTextureRegions[fr].width + mFrameOffsets[fr].x);
    }

    public function get_frameHeight(fr:Int):Float {
        return (mTextureRegions[fr].height + mFrameOffsets[fr].y);
    }
    public var arFrameData:Array<FrameData>;

    public function init(arFrameData:Array<FrameData>):Void {
        this.arFrameData = arFrameData;
        var rcFrame:Rectangle;
        var regPt:Point;
        var i:Int = 0;
        while (i < arFrameData.length) {
            rcFrame = new Rectangle();
            rcFrame.x = arFrameData[i].x;
            rcFrame.y = arFrameData[i].y;
            rcFrame.width = arFrameData[i].w;
            rcFrame.height = arFrameData[i].h;
            mTextureRegions.push(rcFrame);
            regPt = new Point();
            regPt.x = arFrameData[i].offX;
            regPt.y = arFrameData[i].offY;
            mFrameOffsets.push(regPt);
            mFrameRect.width = Math.max(mFrameRect.width, rcFrame.width + regPt.x);
            mFrameRect.height = Math.max(mFrameRect.height, rcFrame.height + regPt.y);
            i++;
        }
    }
/* public function drawFrame(frame:Int, destBmp:BitmapData):Void {
        destBmp.copyPixels(mTextureSheet, mTextureRegions[frame], mFrameOffsets[frame]);
    }*/

    public function getFrameData(frame:Int):FrameData {
        return arFrameData[frame];
    }
}

