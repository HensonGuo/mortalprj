package com.fyGame.core.dataParser
{
	import com.fyGame.fyMap.FyMapInfo;
	
	import flash.utils.ByteArray;
	
	public class FyMapParser
	{
		public function FyMapParser()
		{
			
		}
		
		public static function read( bytes:ByteArray ):FyMapInfo
		{
			var mapInfo:FyMapInfo = new FyMapInfo();
			
			bytes.uncompress();
			
			mapInfo.mapId = bytes.readShort();
			
			mapInfo.pieceWidth = bytes.readShort();
			mapInfo.pieceHeight = bytes.readShort();
			
			mapInfo.gridXNum = bytes.readShort();
			mapInfo.gridYNum = bytes.readShort();
			
			mapInfo.gridWidth = bytes.readShort();
			mapInfo.gridHeight = bytes.readShort();
			
			mapInfo.connectedPointY = bytes.readShort();
			
			//扩展数据
			for(var i:int=0;i<10;i++)
			{
				bytes.readShort();
			}
			
			//菱形数据
			var mapArray:Array = new Array()
			var len:int = mapArray.length;
			var tempAry:Array;
			
			for(var y:int=0 ; y < mapInfo.gridYNum ; y++)
			{
				tempAry = mapArray[y];
				
				for(var x:int = 0 ; x < mapInfo.gridXNum ; x++ )
				{
					tempAry[x] = bytes.readByte();
				}
				
				mapArray.push(tempAry);
			}
			
			mapInfo.mapData = mapArray;
			
			return mapInfo;
		}
		
		
		
		public static function write( mapInfo:FyMapInfo ):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			
			bytes.writeShort(mapInfo.mapId);
			
			bytes.writeShort(mapInfo.pieceWidth);
			bytes.writeShort(mapInfo.pieceHeight);
			
			bytes.writeShort(mapInfo.gridXNum);
			bytes.writeShort(mapInfo.gridYNum);
			
			bytes.writeShort(mapInfo.gridWidth);
			bytes.writeShort(mapInfo.gridHeight);
			
			bytes.writeShort(mapInfo.connectedPointY);
			
			//扩展数据
			for(var i:int=0;i<10;i++)
			{
				bytes.writeInt(0);
			}
			
			//菱形数据
			var mapArray:Array = mapInfo.mapData;
			var len:int = mapArray.length;
			var tempAry:Array;
			
			for(var y:int=0 ; y < len ; y++)
			{
				tempAry = mapArray[y];
				
				for(var x:int = 0 ; x < tempAry.length ; x++ )
				{
					if( tempAry[x] == 9 ) // 9 表示地图外数据 转成不能走数据 1
					{
						bytes.writeByte(1);
					}
					else
					{
						bytes.writeByte(tempAry[x]);
					}
				}
			}
			
			bytes.compress();
			
			return bytes;
		}
	}
}