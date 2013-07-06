package flambe.script;
import de.polygonal.ds.SLL;
import de.polygonal.ds.SLL;
import de.polygonal.ds.SLLNode;
using Reflect;
/**
 * ...
 * @author sonygod
 */
class TaskScript implements Action {
    private var task:SLL<TaskVO>;
    private var currentNode:SLLNode<TaskVO>;

    public function new() {


        task = new SLL<TaskVO>();


    }


    public function addTask(aTask:TaskVO):Void {

        if (task.nodeOf(aTask) == null)
            task.append(aTask);
			start();

    }

    public function addInstantTask(aTask:TaskVO):Void {
        aTask.instant = true;
        if (task.nodeOf(aTask) == null)
            task.append(aTask);
			
			start();
    }

    public function addUrgentTask(aTask:TaskVO):Void {

        if (task.nodeOf(aTask) == null) {
            if (task.size() != 0)
                task.insertBefore(task.getNodeAt(0), aTask);
            else
                task.append(aTask);
        }
        else {

            var temp:SLLNode<TaskVO> = task.nodeOf(aTask);

            temp.unlink();
            if (task.size() != 0)
                task.insertBefore(task.getNodeAt(0), aTask);
            else
                task.append(aTask);
        }

        currentNode = task.head;
start();
    }

    public function addUrgentInstantTask(aTask:TaskVO):Void {
        aTask.instant = true;
        task.insertBefore(task.getNodeAt(0),aTask);
        currentNode = task.head;
		start();
    }

    public function addAction(action:Action, aIgnoreCycle:Bool = false):Void {

        var aTask:TaskVO = { fun:action, args:null, ignoreCycle:aIgnoreCycle, instant:false };

        task.append(aTask);
		start();

    }

    public function clear():Void {
        task.clear();
    }

    public function update(dt:Float, actor:Entity):Float {

        if (task.size() == 0 && _isStarted == true) {
            return 0;
        }

        if (currentNode == null) {
            currentNode = task.head;

        }


        if (Std.is(currentNode.val.fun, Action)) {

            var action:Action = cast currentNode.val.fun;

//if action was complete.
            if (action.update(dt, actor) > 0) {

                parseNext();
            }


        } else {

            var _result:Bool = cast Reflect.callMethod(null, currentNode.val.fun, currentNode.val.args);

            if (_result || currentNode.val.instant)
                parseNext();
            else {
				stop();
                return 0;
			}

        }


        return -1;
    }

    private function parseNext():Void {
        if (currentNode.val.ignoreCycle == true) {

            var temNode:SLLNode<TaskVO> = currentNode.next;

            task.unlink(currentNode);

            currentNode = temNode;

        } else {
            currentNode = currentNode.next;
        }
    }
    private var _isStarted:Bool = false;

    public function start():Void {
        _isStarted = true;
    }

    public function stop():Void {
        _isStarted = false;
    }
}