package flambe.display;
import flambe.display.camera.GCamera;
import flambe.display.Graphics;
import flambe.math.Point;
import flambe.platform.flash.Stage3DTexture;
import flambe.System;
import flash.display.BitmapData;
import nape.phys.Body;
import nape.space.Space;
import nape.util.BitmapDebug;
import flash.display.Bitmap;
import flambe.platform.flash.FlashStage;
/**
 * ... only for flash
 * @author sonygod
 */
class Shape extends ImageSprite {

    public var graphics:BitmapDebug;
    private var t:Stage3DTexture;
    private var bit:BitmapData;
    public var space:Space;
	
	private var cam:GCamera;
	
	private var tempPoint:Point;

    public function new(cam:GCamera,space:Space) {
		
		this.cam = cam;
		var w = System.stage.width;
		var h = System.stage.height;
        t = cast System.createTexture(Std.int(w), Std.int(h));
        graphics = new BitmapDebug(Std.int(w), Std.int(h), 0, true);
        var bm:Bitmap = cast graphics.display;
       // bit = bm.bitmapData;
	   var stage :FlashStage =untyped System.stage;
	   
	   stage.nativeStage.addChild(bm);
		sort = false;
		tempPoint = new Point();
		this.space = space;
        super(t);
    }

    override public function draw(g:Graphics):Void {


        super.draw(g);

    }

    override public function onUpdate(dt:Float):Void {
        super.onUpdate(dt);

		
        if (space != null) {
            space.step(dt);
            graphics.clear();
			
			space.bodies.foreach(
			
			function (_body:Body) {
				 
				var x = _body.position.x;
				var y = _body.position.y;
				tempPoint .x = x;
				tempPoint.y = y;
				
				tempPoint = fix(tempPoint);
				var point:Point = cam.toPoint(tempPoint, false);
			
				_body.position.x = point.x;
				_body.position.y = point.y;
				graphics.draw(_body);
				
				_body.position.x = x;
				
				_body.position.y= y;
				
				
				
			}
			);
        //  graphics.draw(space);

        }
        graphics.flush();
       // t.uploadBitmapData(bit);
    }

	
	public function fix(point:Point):Point {
		   
		return point;
	}
   

}