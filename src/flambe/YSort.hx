package flambe;
import flambe.display.Sprite;
import haxe.Timer;
import flambe.Component;
using Reflect;
/**
 * ...
 * @author ...
 */
class YSort extends Component {
    private var eachTime:Float ;//= 1;
    private var startTime:Float ;//= 0;

    public function new() {
        eachTime = 5;
        startTime = 0;

    }


    override public function onUpdate(dt:Float):Void {
        super.onUpdate(dt);

        this.owner.parent.childList.sort(sortChild, true);


    }

    private function sortChild(a:Entity, b:Entity):Int {

        if (Std.is(a.componentList.head.val, Sprite) && Std.is(b.componentList.head.val, Sprite)) {
            var ap:Sprite = cast a.componentList.head.val;
            var bp:Sprite = cast b.componentList.head.val;

            if (ap != null && bp != null && ap.sort && bp.sort) {


                if (ap.y._ > bp.y._) {
                    return 1;
                }
                if (ap.y._ < bp.y._) {
                    return -1;
                }
                return 0;

            }
        }
        return 0;

    }


}