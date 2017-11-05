/**
 * 2014-5-8
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.processor
{
	import flash.geom.Point;
	
	import mortal.game.Game;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarTurnPoint;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.Vector2f;

	/**
	 * 计算出路径跟最后2个格子交点， 这个交点替换最后一个格子的中点， 然后添加目标点
	 * @author hdkiller
	 * 
	 */	
	public class MapGridToTargetPoint
	{
		public function MapGridToTargetPoint()
		{
		}
		
		public static function work(path:Array, targetX:int, targetY:int):void
		{
			if(path == null || path.length == 0)
			{
				return;
			}
			var last:AstarTurnPoint = path[path.length - 1];
			if(path.length == 1)
			{
				last.x = targetX;
				last.y = targetY;
				return;
			}
			var target:AstarTurnPoint = new AstarTurnPoint();
			target._x = targetX;
			target._y = targetY;
			target.distance = last.distance;
			var sLast:AstarTurnPoint = path[path.length - 2];
			var cross:Point = new Point();
			var sp:Point = new Point(last._x, last._y);
			var ep:Point = new Point(sLast._x, sLast._y);
			var sp1:Point = new Point();
			var ep1:Point = new Point();
			
			sp1.x = last._x - 0.5 * Game.mapInfo.pieceWidth;
			sp1.y = last._y - 0.5 * Game.mapInfo.pieceHeight;
			ep1.x = last._x + 0.5 * Game.mapInfo.pieceWidth;
			ep1.y = last._y - 0.5 * Game.mapInfo.pieceHeight;
			if(GeomUtil.calcSegmentsCrossPoint(sp, ep, sp1, ep1, cross, false))
			{
				last._x = cross.x;
				last._y = cross.y;
				path.push(target);
				return;
			}
			sp1.x = last._x + 0.5 * Game.mapInfo.pieceWidth;
			sp1.y = last._y + 0.5 * Game.mapInfo.pieceHeight;
			if(GeomUtil.calcSegmentsCrossPoint(sp, ep, sp1, ep1, cross, false))
			{
				last._x = cross.x;
				last._y = cross.y;
				path.push(target);
				return;
			}
			ep1.x = last._x - 0.5 * Game.mapInfo.pieceWidth;
			ep1.y = last._y + 0.5 * Game.mapInfo.pieceHeight;
			if(GeomUtil.calcSegmentsCrossPoint(sp, ep, sp1, ep1, cross, false))
			{
				last._x = cross.x;
				last._y = cross.y;
				path.push(target);
				return;
			}
			sp1.x = last._x - 0.5 * Game.mapInfo.pieceWidth;
			sp1.y = last._y - 0.5 * Game.mapInfo.pieceHeight;
			if(GeomUtil.calcSegmentsCrossPoint(sp, ep, sp1, ep1, cross, false))
			{
				last._x = cross.x;
				last._y = cross.y;
				path.push(target);
				return;
			}
		}
	}
}