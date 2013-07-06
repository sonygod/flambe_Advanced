package flambe.display;
import flambe.asset.AssetPack;
import flambe.Entity;
import flambe.input.MouseEvent;
import flambe.input.PointerEvent;
import flambe.math.FMath;
import flambe.System;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
/**
 * ...
 * @author sonygod
 */
class Joystick extends Sprite {

    private var shaft:ImageSprite;
    private var knob:ImageSprite;
    private var ring:ImageSprite;
    private var _drag:Bool;
    private var _initX:Float;
    private var _initY:Float;
    private var decay:Float;
    private var xSpeed:Float;
    private var tension:Float;
    private var h:Float;

    public function new(xx:Float, yy:Float, pack:AssetPack) {

        super();
        _drag = false;

        decay = 0.5;
        xSpeed = 0;
        tension = 0.5;
//sort = false;
        x._ = xx;
        y._ = yy;
        initChild(pack);

    }


    private function initChild(pack:AssetPack):Void {


        knob = new ImageSprite(pack.getTexture("knob"));
        ring = new ImageSprite(pack.getTexture("ring"));
        shaft = new ImageSprite(pack.getTexture("shaft"));
//knob.sort = false;
//ring.sort = false;
        knob.centerAnchor();
        ring.centerAnchor();
        shaft.setAnchor(0, shaft.getNaturalHeight() / 2);

        knob.userName = "knob";
        ring.userName = "ring";
        shaft.userName = "shaft";

        _initX = this.x._;
        _initY = this.y._;

        centerAnchor();

        this.alpha.animateTo(0.5, 0.1);

    }


    override public function onAdded():Void {

        System.pointer.move.connect(onPointMove);
//var owner:Entity=cast this.owner


        var e2 = new Entity();
        e2.name = "ring";
        e2.add(ring);
        var e = new Entity();
        e.name = "knob";
        e.add(knob);
        var e3 = new Entity();
        e3.name = "shaft";
        e3.add(shaft);

        trace("nothing");
        owner.addChild(e2);
        owner.addChild(e3);
        owner.addChild(e);
        h = shaft.getNaturalWidth();
        knob.pointerDown.connect(onPointDown);

        System.pointer.up.connect(onUp);
    }

    private function onPointDown(e:PointerEvent):Void {
        _drag = true;
        this.alpha.animateTo(0.9, 0.5);
    }


    private function onUp(e:PointerEvent):Void {
        _drag = false;
        this.alpha.animateTo(0.1, 0.5);
    }


    override public function onUpdate(dt:Float):Void {
        super.onUpdate(dt);

        if (!_drag && knob != null) {
            xSpeed = -knob.x._ * tension + (xSpeed * decay);
            knob.x._ += xSpeed;
            shaft.alpha._ = 0;
        }
    }

    private function onPointMove(e:PointerEvent):Void {

        if (_drag) {
            var angel = Math.atan2(System.pointer.y - _initY, System.pointer.x - _initX) / (Math.PI / 180);

//trace(angel, System.pointer.y, _initY);
            var rotation = angel;

            this.rotation._ = rotation;
            knob.rotation._ = -angel;
            knob.x._ = e.viewX;


            var h2:Float = (knob.x._ - shaft.x._) / h;
//shaft.scaleX._ =h/h2;
            shaft.alpha._ = 1;
            if (knob.x._ > 75 || knob.x._ < 75) {
                knob.x._ = 75;
            }
            trace(knob.x);

        }
    }


}