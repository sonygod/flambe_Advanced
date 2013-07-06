package flambe.script;
import flambe.display.camera.GCamera;

/**
 * ...
 * @author sonygod
 */
class CameraMove  implements Action
{
    private var moving:Bool;// = false;
	private var duration:Float;
	private var start:Float;
	private var camera:GCamera;
	private var tween:Bool;
	private var toX:Float;
	private var toY:Float;
	private var zoomAmout:Float;
    private var name:String;
	
	public function new(camera:GCamera,toX:Float, toY:Float, zoomAmount:Float, duration:Float) 
	{
		start = 0;
		this.duration = duration;
		moving = true;
		//camera.to(toX, toY, zoomAmount, duration);
		this.camera = camera;
		this.toX = toX;
		this.toY = toY;
		this.zoomAmout = zoomAmount;
		this.duration = duration;
		name = "camra" + Math.random() * 100;
		
	}
	
	public function update (dt :Float, actor :Entity) :Float
    {
		if (!tween) {
			camera.to(toX, toY, zoomAmout, duration);
			tween = true;
		}
		
		
			
			if (start < duration) {
				start += dt;
				
			}else {
				
				
				tween = false;
				start = 0;
				return 1;
			}
		
		
		return -1;
	}
	
}