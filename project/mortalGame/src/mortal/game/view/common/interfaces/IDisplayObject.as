package mortal.game.view.common.interfaces
{
	import flash.display.DisplayObjectContainer;

	public interface IDisplayObject
	{
		function set x(value:Number):void;
		function get x( ):Number;
		
		function set y(value:Number):void;
		function get y( ):Number;
		
		function set z(value:Number):void;
		function get z( ):Number;

		function get parent():DisplayObjectContainer;
	}
}