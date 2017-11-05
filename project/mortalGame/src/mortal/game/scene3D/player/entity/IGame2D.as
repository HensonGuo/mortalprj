package mortal.game.scene3D.player.entity
{
	import com.gengine.core.IDispose;
	public interface IGame2D extends IDispose
	{
		function set x2d(value:Number):void;
		function get x2d():Number;
		function set y2d(value:Number):void;
		function get y2d():Number;
		function set direction(value:Number):void;
		function get direction():Number;
	}
}
