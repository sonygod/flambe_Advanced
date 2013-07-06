package flambe.display.atom;
import flambe.display.tileSheet.AnimSprite;
import flambe.display.tileSheet.AnimTextureSheet;
import haxe.ds.StringMap;
import flambe.display.tileSheet.TileSheetHelper;
import flambe.asset.AssetPack;
import flambe.Entity;
/**
 * you have to set Entity can be extend.not finally.
 */
class Avatar extends Entity  {
    private var pack:AssetPack;
    private var animationMap:StringMap<AnimSprite>;
    public var lastAs(default, null):AnimSprite;
	public var lastAsFrame(default, null):String;
	private var animationNameMap:StringMap<String>;


    public function new(pack:AssetPack) {
         super();
        animationMap = new StringMap<AnimSprite>();
		this.pack = pack;
		animationNameMap=new StringMap<String>();
		
	
    }

    public function appendAnimationSheet(name:String):AnimSprite {


        var ts:TileSheetHelper = new TileSheetHelper();
        var ats:AnimTextureSheet = ts.prepareShoesAnimTexture(pack.getFile(name + ".xml", true)) ;
        var as:AnimSprite = new AnimSprite(pack.getTexture(name));
        as.initialize(ats);
        as.centerAnchor();
        animationMap.set(name, as);
        return as;

    }

    public function removeAnimationSheet(name:String):Void{
        var as:AnimSprite = animationMap.get(name);
         as.dispose();
         animationMap.remove(name);

    }
    public function definedFrames(map:String, frameName:String, frames:Array<Int>, fps:Int):Void {

        var as:AnimSprite = animationMap.get(map);

        as.addSequence(frameName, frames, fps);
		
		animationNameMap.set(frameName, map);

    }

    public function play(frameName:String, ?map:String):AnimSprite{
        var as:AnimSprite ;//= animationMap.get(map);
		lastAsFrame = frameName;
		if (map == null) {
			map = animationNameMap.get(frameName);
		}
		 as= animationMap.get(map);
        if (lastAs != null) {
            remove(lastAs);
        }
        add(as);
        if (lastAs != null) {
			//lastAs.updateSinal.disconnect(onUpdate);
			lastAs.disposer.connect1(lastAs.updateSinal, onUpdate);
            as.setXY(lastAs.x._, lastAs.y._);
            as.rotation._ = lastAs.rotation._;
            as.setScaleXY(lastAs.scaleX._, lastAs.scaleY._);
            as.alpha._ = lastAs.alpha._;
            as.blendMode = lastAs.blendMode;
            

        }
        lastAs = as;
		lastAs.updateSinal.connect(onUpdate);
        as.play(frameName);
        return lastAs;

    }

	//binding body and animation.
	public function onUpdate(dt:Float):Void {
		
		
		
		
		
		
	}
    public function stop():Void {
        lastAs.stop();
    }




}
