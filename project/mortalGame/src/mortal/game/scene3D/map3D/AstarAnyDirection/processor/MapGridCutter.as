/**
 * 2010-1-12
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.processor
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.AstarIIPoint;
	

	public class MapGridCutter
	{
		public function MapGridCutter()
		{
		}
		
		public static var walkableMinValue:int = 0;
		public static const RegionSize:int = 200;
		
		public static function walkable(type:int):Boolean
		{
			return type < 0 || type >= walkableMinValue;
		}
		
		/**
		 * 将地图数据重新切割成大小不一的正方形格子 
		 * @param $walkableMinValue
		 * @param _mapData
		 * @return [x,y,size,x2,y2,size2]
		 * 
		 */		
		public static function cutMap(_mapData:Array, $walkableMinValue:int=0):Vector.<AstarIIPoint>
		{
			//			var time:int = getTimer();
			walkableMinValue = $walkableMinValue;
			var rowLen:int = _mapData.length;
			var colLen:int = _mapData[0].length;
			var res:Vector.<AstarIIPoint> = new Vector.<AstarIIPoint>();
			var openList:Vector.<int> = new Vector.<int>();
			var isChecked:Dictionary = new Dictionary();
			var row:int;
			var col:int;
			var i:int;
			var j:int;
			var sizeW:int;
			var sizeH:int;
			var rowSize:int = 1;
			var colSize:int = 1;
			var sizeP:Point;
			openList.push(0, 0);
			while(openList.length > 1)
			{
				row = openList.shift();
				col = openList.shift();
				var key:int = row*10000 + col;
				if(isChecked[key])
				{
					continue;
				}
				isChecked[key] = true;
				if(!walkable(_mapData[row][col]))
				{
					//查找本格子开始，不可走的最大区域
					//					addNewPoints(openList, row, col, 1, rowLen, colLen);
					sizeP = calcWalkabelArea(row, col, rowLen, colLen, isChecked, _mapData, false);
					addNewPoints(openList, row, col, sizeP.y, sizeP.x, rowLen, colLen);
					continue;
				}
				// 计算当前的格子的大小
				sizeP = calcWalkabelArea(row, col, rowLen, colLen, isChecked, _mapData, true);
				rowSize = sizeP.y;
				colSize = sizeP.x;
				
				res.push(new AstarIIPoint(row, col, row + rowSize, col + colSize));//(row, col, rowSize, colSize);
				addNewPoints(openList, row, col, rowSize, colSize, rowLen, colLen);
				// 标记已经使用
				sizeW = col + colSize;
				sizeH = row + rowSize;
				for(j = row; j < sizeH; j++)
				{
					for(i=col; i < sizeW; i++)
					{
						isChecked[j*10000 + i] = true;
					}
				}
			}
			//			trace("........................ 分区域切割，所用时间" + int(getTimer() - time).toString());
			return res;
		}
		
		private static var p:Point = new Point();
		public static function calcWalkabelArea(row:int, col:int, 
												rowLen:int, colLen:int, isChecked:Dictionary, mapData:Array, isWalkabel:Boolean=true):Point
		{
			// 计算当前的格子的大小
			var rowSize:int = 1;
			var colSize:int = 1;
			var i:int;
			var j:int;
			var isStopCol:Boolean = true;
			gotoWhile:while(true)
			{
				rowSize++;
				// 检查是否到边界了
				if(col + rowSize > colLen || row + rowSize > rowLen)
				{
					break;
				}
				
				var maxTmp:int = col + rowSize;
				var tmpRow:int = row + rowSize - 1;
				for(i = col; i < maxTmp; i++) // 底面一行判断
				{
					if(isChecked[tmpRow*10000 + i])
					{
						isStopCol = false;
						break gotoWhile;
					}
					if(walkable(mapData[tmpRow][i]) != isWalkabel)
					{
						isStopCol = false;
						break gotoWhile;
					}
				}
				maxTmp = row + rowSize - 1;
				var tmpCol:int = col + rowSize - 1;
				for(i = row; i < maxTmp; i++)
				{
					if(isChecked[i*10000 + tmpCol])
					{
						break gotoWhile;
					}
					if(walkable(mapData[i][tmpCol]) != isWalkabel)
					{
						break gotoWhile;
					}
				}
			}
			rowSize--;
			colSize = rowSize;
			
			
			var isShouldBreak:Boolean = false;
			var addSize:int = 0;
			if(!isStopCol)// 横向最大化
			{
				for(i = col + colSize; i < colLen; i++)
				{
					for( j = row; j < row + rowSize; j++)
					{
						if(isChecked[j*10000 + i])
						{
							isShouldBreak = true;
							break;
						}
						if(walkable(mapData[j][i]) != isWalkabel)
						{
							isShouldBreak = true;
							break;
						}
					}
					if(isShouldBreak)
					{
						break;
					}
					addSize++;
				}
				colSize = colSize + addSize;
			}
			else // 纵向最大化
			{
				//				addSize = 0;
				//				maxTmp = col + colSize;
				//				for(j = row + rowSize; j < rowLen; j++)
				//				{
				//					for(i = col; i < maxTmp; i++)
				//					{
				//						if(isChecked[j*10000 + i])
				//						{
				//							isShouldBreak = true;
				//							break;
				//						}
				//						if(walkable(mapData[j][i]) != isWalkabel)
				//						{
				//							isShouldBreak = true;
				//							break;
				//						}
				//					}
				//					if(isShouldBreak)
				//					{
				//						break;
				//					}
				//					addSize++;
				//				}
				//				rowSize = rowSize + addSize;
			}
			
			p.y = rowSize;
			p.x = colSize;
			return p;
		}
		
		/**
		 * 按逆时针添加本点之外的3个点 
		 * @param list
		 * @param row
		 * @param col
		 * @param size
		 * 
		 */		
		public static function addNewPoints(list:Vector.<int>, row:int, col:int, rowSize:int, colSize:int, rowLen:int, colLen:int):void
		{
			var isMaxRow:Boolean = (row + rowSize >= rowLen);
			var isMaxCol:Boolean = (col + colSize >= colLen);
			if(!isMaxRow)
			{
				list.push(row + rowSize, col);
				if(!isMaxCol)
				{
					list.push(row + rowSize, col + colSize);
				}
			}
			if(!isMaxCol)
			{
				list.push(row, col + colSize);
			}
		}
	}
}