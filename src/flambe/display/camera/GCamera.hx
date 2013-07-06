package flambe.display.camera;

import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.display.Sprite;
import flambe.Entity;
//import flambe.input.Pointer;
import flambe.input.PointerEvent;
import flambe.math.Rectangle;
import flambe.System;
import flambe.math.Point;
import flambe.input.MouseEvent;


/**
 * camera for game 
 * @author sonygod
 */
class GCamera extends Component {
    private var canvas:Entity;
    public var _bound:Rectangle;
    private var _lastX:Float;
    private var _lastY:Float;
    private var _lastZoomAmount:Float;
    private var tgtx:Float;
    private var tgty:Float;
    private var duration:Float;
    private var readyToX:Float;
    private var readyToY:Float;
    public var drag(get, set):Bool;
    private var _drag:Bool;
	private var convertPoint:Point;


/**
	 * initialize the camera for game 
	 * @param	canvas  the main container of game 
	 * @param	bound    the viewport of the game 
	 */

    public function new(canvas:Entity, bound:Rectangle) {
        this.canvas = canvas;
        this._bound = bound;


        tgtx = 0;
        tgty = 0;
        _lastX = 0;
        _lastY = 0;
        _drag = false;
convertPoint = new Point();

    }
/**
	 * moving your camera to destination location 
	 * @param	toX  destination x
	 * @param	toY   destination y
	 * @param	zoomAmount  destination zoom
	 * @param	duration  same as tweenlite's duration
	 */
    public function to(toX:Float, toY:Float, zoomAmount:Float, duration:Float):Void{
				var xx:Float = (toX * zoomAmount);
				var yy:Float = (toY * zoomAmount);
				var hx:Float = (System.stage.width / 2);
				var hy:Float = (System.stage.height / 2);
				if ((xx - (getBoundLeft(_bound) * zoomAmount)) < hx){
				xx = ((getBoundLeft(_bound) * zoomAmount) + hx);
				} else {
				if (((getBoundRight(_bound) * zoomAmount) - xx) < hx){
				xx = ((getBoundRight(_bound) * zoomAmount) - hx);
				};
				};
				if ((yy - (getBoundTop(_bound) * zoomAmount)) < hy){
				yy = ((getBoundTop(_bound) * zoomAmount) + hy);
				} else {
				if (((getBoundBottom(_bound) * zoomAmount) - yy) < hy){
				yy = ((getBoundBottom(_bound) * zoomAmount) - hy);
				};
				};
				tgtx = ((System.stage.width * 0.5) - xx);
				tgty = ((System.stage.height * 0.5) - yy);


				var child :Sprite = cast canvas.componentList.head.val;

				if (child!=null) {
				child.x.animateTo(tgtx, duration);
				child.y.animateTo(tgty, duration);
				child.scaleX.animateTo(zoomAmount, duration);
				child.scaleY.animateTo(zoomAmount, duration);
				}


				this._lastX = toX;
				this._lastY = toY;
				this._lastZoomAmount = zoomAmount;
}


private function getBoundLeft(r:Rectangle):Float {
return r.x;
}
private function getBoundRight(r:Rectangle):Float {
return r.x + r.width;
}
private function getBoundTop(r:Rectangle):Float {
return r.y;
}
private function getBoundBottom(r:Rectangle):Float {
return r.y + r.height;
}
public function onScreen(target:Sprite):Bool {

var child :Sprite = cast canvas.componentList.head.val;

if (child != null) {

return child.x._ + tgtx<=target.x._ || child.x._+ tgtx + System.stage.width>=target.x._;
}

return false;

}


public function toPoint(p:Point, ?toCamara:Bool = true):Point{

		var child :Sprite = cast canvas.componentList.head.val;

		if (child != null) {

		if (toCamara) {

	      return new Point(p.x - child.x._, p.y - child.y._);

		} else {

			convertPoint .x = p.x + child.x._ ;
			convertPoint.y = p.y + child.y._;
			convertPoint.multiply(child.scaleX._);
		return convertPoint;
		}
}

return null;
}


function set_drag(value:Bool):Bool {


_drag = value;
var downPoint:Point;
var mouseDown:Bool;
var downScreenPoint:Point;


System.pointer.down.connect(function (e:PointerEvent):Void {

if (!_drag) {
return;
}
downPoint = new Point(e.viewX, e.viewY);

var point:Point = toPoint(new Point(e.viewX, e.viewY), true);
mouseDown = true;
downScreenPoint = point;

});


System.pointer.up.connect(function (e:PointerEvent):Void {


mouseDown = false;
downPoint = null;

});

System.pointer.move.connect(function (e:PointerEvent):Void {
if (mouseDown && _drag) {

var dx:Float = e.viewX - downPoint.x;
var dy:Float = e.viewY - downPoint.y;

//var toPoint = new Point(downScreenPoint.x + dx, downScreenPoint.y + dy);

to(downScreenPoint.x - dx, downScreenPoint.y - dy, 1, 1);

}
});
return value;
}


function get_drag():Bool {
return _drag;

}
}