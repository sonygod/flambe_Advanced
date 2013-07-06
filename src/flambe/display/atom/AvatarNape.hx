package flambe.display.atom;
import flambe.display.tileSheet.AnimSprite;
import nape.callbacks.CbType;
import flambe.asset.AssetPack;
import nape.phys.Body;
import flambe.math.FMath;

/**
 * bind nape's body to anmiationSprite.
 * ...
 * @author sonygod
 */
class AvatarNape extends Avatar
{
	
	
    private var z(get, set):Float;
	private var x(get, set):Float;
	private var y(get, null):Float;
	
	private var _z:Float;
	
	private var _body:Body;
	private var _pause:Bool;
	
	
	public function new(body :Body,pack:AssetPack) 
	{
		super(pack);
		_z = 0;
		_body = body;
		_body.userData.z = z;
		_pause = false;
		
	
		
		
		
		
	}
	
	public function get_z():Float {
		return _z;
		
	}
	public function get_x():Float {
		return _body.position.x;
		
	}
	public function get_y():Float {
		return _body.position.y;
		
	}
	
	
	public function set_z(value:Float):Float {
		
		if (_body.velocity.y != 0) {
			throw "can't set z when _body.velocity.y!=0";
			return 0;
		}
		_body.position.y = _z;
		_z = value;
		return _z;
		
	}
	public function set_x(value:Float):Float {
		
		
		_body.position.x = value;
		
		return value;
		
	}
	
	override public function onUpdate(dt:Float):Void 
	{
		super.onUpdate(dt);
		if (_pause) {
			return;
		}
	    
		
      lastAs.x._ = _body.position.x;
	  lastAs.y._ = _body.position.y;
	  
	 lastAs.rotation._ = FMath.toDegrees(_body.rotation);
	  
	  //how to set scaleX to _body?
	}
	
	
	public function set_pause(value:Bool):Bool {
		_pause = value;
		return value;
	}
	
}