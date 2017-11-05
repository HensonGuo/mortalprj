/**
 * 2010-1-13
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.data
{
	import flash.geom.Point;
	
	public class AstarIIPoint
	{
		public function AstarIIPoint($row:int, $col:int, $endRow:int, $endCol:int)
		{
			this.row = $row;
			this.col = $col;
			this.endRow = $endRow;
			this.endCol = $endCol;
		}
		
		public var col:int;
		public var row:int;
		public var endCol:int;
		public var endRow:int;
		public var version:int;
		public var links:Array;
		
		///////////////////////////////////////////////以下是需要重置的///////////////////////////////////////////
		/**
		 * 通过此index来从parent.links中找到跟parent的link, :linkTM = linkFromParentToMe
		 */		
		public var linkTM:int;
		public var parent:AstarIIPoint;
		/**
		 * 跟parent连接的估算点 
		 */		
		//		public var inPoint:Point;
		public var inX:Number = 0;
		public var inY:Number = 0;
		public var f:Number = 0;
		public var g:Number = 0;
		public var h:Number = 0;
		
		public function reset():void
		{
			with(this)
			{
				//				f = 0;
				//				g = 0;
				//				h = 0;
				//				inPoint = null;
				parent = null;
				linkTM = -1;
			}
		}
		
		public function toString():String
		{
			return row.toString() + ", " + col.toString() + ", " + endRow.toString() + ", " + endCol.toString();
		}
	}
}