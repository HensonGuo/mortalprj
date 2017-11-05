/**
 * @date	2011-3-4 下午03:30:29
 * @author  jianglang
 *
 *
 * 视图层
 */	


package mortal.mvc.interfaces
{
	import com.gengine.core.IDispose;
	import com.mui.core.IFrUIContainer;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	public interface IView extends IEventDispatcher,IDispose
	{
		function hide():void;					
		function show(x:int=0,y:int=0):void;
		function set layer( value:ILayer ):void;
		function get layer():ILayer;
		function get isHide():Boolean;
		function get x():Number;
		function get y():Number;
		function get height():Number;
		function get width():Number;
//		function dispose(isReuse:Boolean=true):void;
	}
}

