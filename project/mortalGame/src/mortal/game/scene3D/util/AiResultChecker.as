/**
 * 2014-1-6
 * @author chenriji
 **/
package mortal.game.scene3D.util
{
	import mortal.game.scene3D.map3D.AstarAnyDirection.AstarAnyDirection;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;

	public class AiResultChecker
	{
		public function AiResultChecker()
		{
		}
		
		public static function check(res:Array):void
		{
			var maxX:int = -1;
			var maxY:int = -1;
			var minX:int = 1000000;
			var minY:int = 1000000;
			
			for(var i:int = 0; i < res.length; i++)
			{
				var p:AstarTurnPoint = res[i] as AstarTurnPoint;
				if(p._x < minX)
				{
					minX = p._x;
				}
				if(p._y < minY)
				{
					minY = p._y;
				}
				if(p._x > maxX)
				{
					maxX = p._x;
				}
				if(p._y > maxY)
				{
					maxY = p._y;
				}
				
				trace(p._x + ", " + p._y + " -> ");
			}
			
			var mapData:Array = AstarAnyDirection.mapData;
		}
	}
}