package flambe.script;

/**
 * ...
 * @author sonygod
 */
typedef TaskVO=
{

	fun:Dynamic,
	args:Array<Dynamic>,
	ignoreCycle:Bool,
	instant:Bool,
	
}
class TaskObj {
	
	  public var fun:Dynamic;
	  public var args:Array<Dynamic>;
	  public var ignoreCycle:Bool;
	  public var instant:Bool;
	  
	  public function new (a:Dynamic, b:Array<Dynamic>, c:Bool=false, d:Bool=false) {
		  
		  fun = a;
		  args = b;
		  ignoreCycle = c;
		  instant = d;
	  }
}