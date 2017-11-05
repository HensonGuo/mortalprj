package com.fyGame.fyMap
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	/**
	 * 地图数据 
	 * @author jianglang
	 * 
	 */	
	
	public class FyMapInfo
	{
		public var mapId : int; //地图ID 地图唯一标识
		
		public var pieceWidth : int; //棱形格子的横向对角线的长度
		
		public var pieceHeight : int; //棱形格子的纵向对角线的长度
		
		public var gridXNum : int; // 网格 X 轴上的 格子数量
		
		public var gridYNum : int;//网格 y 轴上的 格子数量
		
		public var gridWidth : int;   //地图矩形宽度
		
		public var gridHeight : int;	//地图矩形高度
		
		public var connectedPointY : int; // 地图 矩形 (0,0) 点 在 菱形中的坐标，(0,connectedPointY)
		
		
		//双层地图需要的数据
		public var isDoubleMap:Boolean = true;//是否双层地图
		
		public var bgMapWidth : int =2000;   //底图原始矩形宽度
		
		public var bgMapHeight : int =2000;	//底图原始矩形高度
		
		//双层地图顶图切图数据
		public var mapPicDict:Dictionary;//双层地图顶层区域数据 0 代表 空白，1代表JPG 2代表PNG
		
		[ArrayElementType("Array")]
		public var mapData : Array; // 地图格子数据  
		public var v:Vector.<int>;// 切割之后的格子数据
		
		
		public function FyMapInfo()
		{
			mapData = new Array();
			v = new Vector.<int>();
		}
		
		public function getPicType(x:int,y:int):int
		{
			if(!isDoubleMap)
			{
				return MapPicType.JPG;
			}
			if(mapPicDict == null)
			{
				return MapPicType.JPG; 
			}
			if(mapPicDict[y * 1000 + x] == 0)
			{
				return MapPicType.BLANK;
			}
			if(mapPicDict[y * 1000 + x] == 1)
			{
				return MapPicType.JPG;
			}
			return MapPicType.PNG;
		}
		
		/**
		 * 赋值给 mapInfo 
		 * @param bytes
		 * 
		 */		
		
		public function read( bytes:ByteArray , isCompress:Boolean = true , isForServer:Boolean=false):void
		{
			if( isCompress )
			{
				bytes.uncompress();
			}
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			this.mapId = bytes.readInt();
			
			this.pieceWidth = bytes.readInt();
			this.pieceHeight = bytes.readInt();
			
			this.gridXNum = bytes.readInt();
			this.gridYNum = bytes.readInt();
			
			this.gridWidth = bytes.readInt();
			this.gridHeight = bytes.readInt();
			
			this.connectedPointY = bytes.readInt();
			
			// 客户端专用
			if(!isForServer)
			{
				this.isDoubleMap = bytes.readBoolean();
			}
			
			var size:int = readSize( bytes );
			for( var x : int = 0 ;x < size ; x ++ )
			{
				var array:Array = new Array();
				var size1 : int = readSize( bytes );
				for( var y : int = 0 ; y < size1 ; y++ )
				{
					array[y] = bytes.readByte();
				}
				mapData[x] = array;
			}	
			
			// 客户端专用
			if(!isForServer)
			{
				size = readSize(bytes);
				for(var i:int = 0; i < size; i++)
				{
					var value:int = bytes.readInt();
					var key:int = value%1000000;
					if(mapPicDict == null)
					{
						mapPicDict = new Dictionary();
					}
					mapPicDict[key] = int(value/1000000);
				}
			}
		}
		
		/**
		 * 从mapInfo 中把数据读取到 byteArray中 
		 * @return 
		 * 
		 */		
		
		public function write( isCompress:Boolean = true, isForServer:Boolean=false):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			bytes.writeInt(this.mapId);
			
			bytes.writeInt(this.pieceWidth);
			bytes.writeInt(this.pieceHeight);
			
			bytes.writeInt(this.gridXNum);
			bytes.writeInt(this.gridYNum);
			
			bytes.writeInt(this.gridWidth);
			bytes.writeInt(this.gridHeight);
			bytes.writeInt(this.connectedPointY);
			
			// 客户端专用
			if(!isForServer)
			{
				bytes.writeBoolean(this.isDoubleMap);
			}
			
			writeSize( bytes , mapData.length );
			
			var mapDataX:Array;
			for( var y : int=0 ; y < mapData.length ; y ++ )
			{
				mapDataX = mapData[y];
				writeSize( bytes , mapDataX.length );
				for( var x : int = 0 ; x < mapDataX.length; x ++ )
				{
					bytes.writeByte( mapDataX[x] );
				}
			}
			
			// 客户端专用
			if(!isForServer)
			{
				var num:int = 0;
				for each(var key:String in mapPicDict)
				{
					num++;
				}
				writeSize(bytes, num);
				var value:int;
				for(key in mapPicDict)
				{
					value = int(mapPicDict[key])*1000000 + int(key);
					bytes.writeInt(value);
				}
				
				if(isCompress)
				{
					bytes.compress();
				}
			}
			
			return bytes;
		}
		
		public function writeSize( bytes : ByteArray , v : int ) : void
		{
			if( v < 255 )
			{
				bytes.writeByte( v );
			}
			else
			{
				bytes.writeByte( 255 );
				bytes.writeInt( v );
			}
		}
		
		public function readSize( bytes : ByteArray ) : int
		{
			var size : int = bytes.readUnsignedByte();
			if( size == 255 )
			{
				return bytes.readInt();
			}
			return size;
		}
		
	}
}