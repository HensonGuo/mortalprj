/**
 * 2010-1-13
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.processor
{
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarIILink;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarIIPoint;
	

	public class MapGridLinker
	{
		public function MapGridLinker()
		{
		}
		
		public static function calcLink(v:Vector.<AstarIIPoint>):Vector.<AstarIIPoint>
		{
			processLeft(v);
			processRight(v);
			processTop(v);
			processBottom(v);
			return v;
		}
		
		/**
		 * 遍历左边的连接边 
		 * @param v
		 * 
		 */		
		private static function processLeft(v:Vector.<AstarIIPoint>):void
		{
			// 先左边排序
			var tV:Array = [];
			var p:AstarIIPoint;
			var pTest:AstarIIPoint;
			var arr:Array;
			var link:AstarIILink;
			
			sort(v, tV, "endCol");
			for each(p in v)
			{
				arr = tV[p.col];
				if(arr == null)
				{
					continue;
				}
				for each(pTest in arr)
				{
					if(pTest.row >= p.endRow)
					{
						continue;
					}
					if(p.row >= pTest.endRow)
					{
						continue;
					}
					// 找到连接AstarIIPoint
					link = new AstarIILink();
					link.otherNode = pTest;
					
					link.setCommon(p.row, p.endRow, pTest.row, pTest.endRow);
					link.minCol = link.maxCol = p.col - 0.5;
					//					if(link.minCol == link.maxCol && link.minRow == link.maxRow)
					//					{
					//						continue;
					//					}
					if(p.links == null)
					{
						p.links = [];
					}
					link.minRow -= 0.5;
					link.maxRow -= 0.5;
					p.links.push(link);//link.minCol == 64 && link.maxCol==64&&link.minRow==0&&link.maxRow==0
				}
			}
		}
		
		/**
		 * 遍历右边的连接边 
		 * @param v
		 * 
		 */		
		private static function processRight(v:Vector.<AstarIIPoint>):void
		{
			// 先左边排序
			var tV:Array = [];
			var p:AstarIIPoint;
			var pTest:AstarIIPoint;
			var arr:Array;
			var link:AstarIILink;
			
			sort(v, tV, "col");
			for each(p in v)
			{
				arr = tV[p.endCol];
				if(arr == null)
				{
					continue;
				}
				for each(pTest in arr)
				{
					if(pTest.row >= p.endRow)
					{
						continue;
					}
					if(p.row >= pTest.endRow)
					{
						continue;
					}
					// 找到连接AstarIIPoint
					link = new AstarIILink();
					link.otherNode = pTest;
					
					link.setCommon(p.row, p.endRow, pTest.row, pTest.endRow);
					link.minCol = link.maxCol = p.endCol - 0.5;
					
					if(p.links == null)
					{
						p.links = [];
					}
					link.minRow -= 0.5;
					link.maxRow -= 0.5;
					p.links.push(link);
				}
			}
		}
		
		/**
		 * 遍历顶边的连接边 
		 * @param v
		 * 
		 */		
		private static function processTop(v:Vector.<AstarIIPoint>):void
		{
			// 先左边排序
			var tV:Array = [];
			var p:AstarIIPoint;
			var pTest:AstarIIPoint;
			var arr:Array;
			var link:AstarIILink;
			
			sort(v, tV, "endRow");
			for each(p in v)
			{
				arr = tV[p.row];
				if(arr == null)
				{
					continue;
				}
				for each(pTest in arr)
				{
					if(pTest.col >= p.endCol)
					{
						continue;
					}
					if(p.col >= pTest.endCol)
					{
						continue;
					}
					// 找到连接AstarIIPoint
					link = new AstarIILink();
					link.otherNode = pTest;
					
					link.setCommon(p.col, p.endCol, pTest.col, pTest.endCol);
					link.minRow = link.maxRow = p.row - 0.5;
					
					link.minCol -= 0.5;
					link.maxCol -= 0.5;
					
					if(p.links == null)
					{
						p.links = [];
					}
					p.links.push(link);
				}
			}
		}
		
		
		/**
		 * 遍历底边的连接边 
		 * @param v
		 * 
		 */		
		private static function processBottom(v:Vector.<AstarIIPoint>):void
		{
			// 先左边排序
			var tV:Array = [];
			var p:AstarIIPoint;
			var pTest:AstarIIPoint;
			var arr:Array;
			var link:AstarIILink;
			sort(v, tV, "row");
			for each(p in v)
			{
				arr = tV[p.endRow];
				if(arr == null)
				{
					continue;
				}
				for each(pTest in arr)
				{
					if(pTest.col >= p.endCol)
					{
						continue;
					}
					if(p.col >= pTest.endCol)
					{
						continue;
					}
					// 找到连接AstarIIPoint
					link = new AstarIILink();
					link.otherNode = pTest;
					
					link.setCommon(p.col, p.endCol, pTest.col, pTest.endCol);
					link.minRow = link.maxRow = p.endRow - 0.5;
					
					link.minCol -= 0.5;
					link.maxCol -= 0.5;
					
					if(p.links == null)
					{
						p.links = [];
					}
					
					p.links.push(link);
				}
			}
		}
		
		private static function sort(v:Vector.<AstarIIPoint>, res:Array, attr:String):void
		{
			for each(var star:AstarIIPoint in v)
			{
				var value:int = int(star[attr]);
				if(res[value] == null)
				{
					res[value] = [];
				}
				res[value].push(star);
			}
		}
		
	}
}