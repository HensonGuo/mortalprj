package mortal.game.scene3D.layer3D
{
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.map3D.MapBitmap3D;
	
	public class MapPiece3DDictionary
	{
		private var _map:Dictionary;
		public function MapPiece3DDictionary()
		{
			_map = new Dictionary(true);
		}
		
		public function addPiece(mapId:int, x:int,y:int,bitmap:MapBitmap3D,mapType:String):void
		{
			_map[ mapId*1000000 + x*1000 + y + mapType] = bitmap;
		}
		
		public function getPieceBitmap(mapId:int, x:int,y:int,mapType:String):MapBitmap3D
		{
			return _map[ mapId*1000000 + x*1000 + y + mapType];
		}
		
		public function removePiece( mapId:int,x:int,y:int,mapType:String,isDispose:Boolean = false ):MapBitmap3D
		{
			var bitmap:MapBitmap3D = getPieceBitmap(mapId,x,y,mapType);
			if( isDispose )
			{
				//Log.debug( "ObjectPool add" );
				bitmap.dispose();
				delete _map[mapId*1000000 + x*1000 + y + mapType];
			}
			return bitmap;
		}
		
		public function removeAll():void
		{
			var bitmap:MapBitmap3D;
			for( var key:String in _map)
			{
				bitmap = _map[key] as MapBitmap3D;
				bitmap.dispose();
				_map[key] = null;
			}
			_map = new Dictionary();
		}
		
		public function getMapBitmap():MapBitmap3D
		{
			//Log.debug( "ObjectPool delete" );
			return ObjectPool.getObject(MapBitmap3D);
		}
		
		public function hasBitmap(mapId:int,x:int,y:int,mapType:String):Boolean
		{
			return _map[mapId*1000000 + x*1000 + y + mapType] != null;
		}
		
		public function getMapPieceNum():int
		{
			var i:int;
			for each( var object:Object in _map  )
			{
				i++;
			}
			return i;
		}
		
		public function clearMap():void
		{
			for each( var bitmap:MapBitmap3D in _map  )
			{
				bitmap.dispose();
			}
			_map = new Dictionary(true);
		}
		
		public function disposeBitmap():void
		{
			var _bitmap:MapBitmap3D;
			for( var key:* in _map  )
			{
				_bitmap = _map[key] as MapBitmap3D;
				if( _bitmap.canDispose )
				{
					//Log.debug("disposeMapBitmap:"+key);
					_bitmap.dispose();
					delete _map[key];
				}
			}
		}
	}
}
