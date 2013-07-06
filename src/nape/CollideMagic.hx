package nape;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.PreListener;
import nape.callbacks.InteractionType;
import nape.phys.Body;
import nape.space.Space;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
/**
 * ...
 * @author sonygod
 */
class CollideMagic
{

	private var space:Space;
	private var zCheckType:CbType;
	public function new(space:Space) 
	{
	
		this.space = space;
		zCheckType = new CbType();
		 space.listeners.add(new PreListener(
            InteractionType.COLLISION,
            zCheckType,
            zCheckType,
            onZCheck,
            /*precedence*/ 0,
            /*pure*/ true
        ));
		
	}
	
	
	
	public function addBody(body:Body):Void {
		
		//body.type = zCheckType;
		body.cbTypes.add(zCheckType);
		
	}
	//you may override this 
	public function onZCheck(cb:PreCallback):PreFlag {
		 
	   var b1:Body = cb.int1.castBody;
	   var b2:Body = cb.int2.castBody;
	   
	   if (Math.abs(b1.userData.z - b2.userData.z) < 30) {
		   return PreFlag.ACCEPT;
	   }else {
		   
		   return PreFlag.IGNORE;
	   }
	   
		
	 }
	
	
	
}