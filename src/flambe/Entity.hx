//
// Flambe - Rapid game development
// https://github.com/aduros/flambe/blob/master/LICENSE.txt

package flambe;

#if macro
import de.polygonal.ds.SLLNode;
import haxe.macro.Expr;
#end

import de.polygonal.ds.DLL;
import de.polygonal.ds.ResettableIterator;
import de.polygonal.ds.SLL;
import flambe.util.Disposable;
import de.polygonal.ds.SLLNode;
import de.polygonal.ds.DLLNode;

using Lambda;

/**
 * <p>A node in the entity hierarchy, and a collection of components.</p>
 *
 * <p>To iterate over the hierarchy, use the parent, firstChild, next and firstComponent fields. For
 * example:</p>
 *
 * <pre>
 * // Iterate over entity's children
 * var child = entity.firstChild;
 * while (child != null) {
 *     var next = child.next; // Store in case the child is removed in process()
 *     process(child);
 *     child = next;
 * }
 * </pre>
 */
 class Entity
    implements Disposable
{
	public var name:String;
    /** This entity's parent. */
    public var parent (default, null) :Entity = null;



    public var childList(get,null):SLL<Entity>;

    public var componentList(get,null):DLL<Component>;

    private   var  _childList:SLL<Entity>;

   public   var  next(get,null):Entity;
    public   var  firstChild(get,null):Entity;
    private   var _componentList:DLL<Component> ;
	
	public var firstComponent(get, null):Component;
    public function new ()
    {
#if flash
        _compMap = cast new flash.utils.Dictionary();
#elseif js
        _compMap = {};
#end


        _childList=new SLL<Entity>() ;
        _componentList=new DLL<Component>();
    }

    /**
     * Add a component to this entity.
     * @returns This instance, for chaining.
     */
    public function add (component :Component) :Entity
    {
        // Remove the component from any previous owner
        component.dispose();

        var name = component.name;
        var prev = getComponent(name);
        if (prev != null) {
            // Remove the previous component under this name
            remove(prev);
        }

        untyped _compMap[name] = component;

         _componentList.append(component);

        component.init(this, null);
        component.onAdded();

        return this;
    }

    /**
     * Remove a component from this entity.
     */
     public function remove (component :Component)
    {

         var will:DLLNode<Component> = cast _componentList.nodeOf(component);
   if(will.next!=null&&will.prev !=null)
     will.prev.val.init(this, will.next.val);
	  _componentList.remove(component);
	  
	  #if flash
                untyped __delete__(_compMap, component.name);
#elseif js
                untyped __js__("delete")(_compMap[component.name]);
#end

                // Notify the component it was removed
                component.onRemoved();
                component.init(null, null);

       
    }

    /**
     * Gets a component of a given class from this entity.
     */
    macro public function get<A> (self :Expr, componentClass :ExprOf<Class<A>>) :ExprOf<A>
    {
        return macro $componentClass.getFrom($self);
    }

    /**
     * Checks if this entity has a component of the given class.
     */
    macro public function has<A> (self :Expr, componentClass :ExprOf<Class<A>>) :ExprOf<Bool>
    {
        return macro $componentClass.hasIn($self);
    }

    /**
     * Gets a component by name from this entity.
     */
    inline public function getComponent (name :String) :Component
    {
        return untyped _compMap[name];
    }

    /**
     * Adds a child to this entity.
     * @param append Whether to add the entity to the end or beginning of the child list.
     * @returns This instance, for chaining.
     */
    public function addChild (entity :Entity, append :Bool=true)
    {
        if (entity.parent != null) {
            entity.parent.removeChild(entity);
        }
        entity.parent = this;



      childList.append(entity);

        return this;
    }

    public function removeChild (entity :Entity)
    {

      childList.remove(entity);
    }

    /**
     * Dispose all of this entity's children, without touching its own components or removing itself
     * from its parent.
     */
   public function disposeChildren ()
    {
       var itr = _childList.head;
       
	   while (itr!=null) {
		    itr.val.dispose();
			itr = itr.next;
	   } 
    }

    /**
     * Removes this entity from its parent, and disposes all its components and children.
     */
     public function dispose ()
    {
        if (parent != null) {
            parent.removeChild(this);
			parent = null;
			
        }

       
		var currentCom = _componentList.head;
       
		if (currentCom!=null) {
		         currentCom.val.dispose();
				 currentCom = currentCom.next;
		}
       
        disposeChildren();
    }


    #if debug @:keep #end public function toString () :String
    {
        return "";
    }



    /**
     * Maps String -> Component. Usually you would use a Haxe Map here, but I'm dropping down to plain
     * Object/Dictionary for the quickest possible lookups in this critical part of Flambe.
     */
    private var _compMap :Dynamic<Component>;




  /*  public var childList(get,null):SLL<Entity>;

    public var componentList(get,null):SLL<Component>*/

     private function get_childList(): SLL<Entity>{
       return _childList;
     }

    private function get_componentList():DLL<Component>{
       return _componentList;
    }

    private function get_next():Entity {
	/*if(_childList.head!=null)		
        return _childList.head.next.val;
		return null;*/
		
		if (this.parent != null) {
			var e:SLL<Entity> =cast  this.parent.childList;
			var node:SLLNode<Entity> = e.nodeOf(this);
			if (node.next != null) {
				return node.next.val;
			}
			
		}
		return null;
    }
    private function get_firstChild():Entity {
	    if(_childList.head!=null)	
        return _childList.head.val;
		return null;
    }
	private function get_firstComponent():Component{
		if (_componentList.size() != 0) {
		   return _componentList.head.val;	
		}
		return null;
	}
}
