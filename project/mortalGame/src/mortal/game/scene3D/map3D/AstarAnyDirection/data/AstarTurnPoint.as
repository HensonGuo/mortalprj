/**
 * 2010-1-14
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.data
{
	import flash.geom.Point;
	

	public class AstarTurnPoint extends Vector2f
	{
		public function AstarTurnPoint()
		{
		}
		
		public function setValue(x:Number, y:Number):void
		{
			_x = x;
			_y = y;
		}
		
		public function from(t:Vector2f):void
		{
			this._x = t._x;
			this._y = t._y;
		}
		
		public function toString():String
		{
			return _x + "," + _y;
		}
		
		public var distance:Number;
		public var parent:AstarTurnPoint;
		public var value:int;
	}
}