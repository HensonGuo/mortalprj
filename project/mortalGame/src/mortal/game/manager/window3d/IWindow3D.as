package mortal.game.manager.window3d
{
	import flash.display.Sprite;
	import flash.geom.Point;

	public interface IWindow3D
	{
		function localToGlobal(p:Point):Point;
		function get contentContainer():Sprite;
		function get contentTopOf3DSprite():Sprite;
		
		function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
		function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void;
	}
}