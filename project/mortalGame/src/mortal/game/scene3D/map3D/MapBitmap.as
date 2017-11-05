package mortal.game.scene3D.map3D
{
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getTimer;
	
	/**
	 * 地图位图 
	 * @author jianglang
	 * 
	 */	
	public class MapBitmap extends Bitmap
	{
		
		private var _referenceCount:int = 0;  //引用数量
		
		private var _disposeTime:Number = 0;
		
		private static const DisposeTime:Number = 60*1000; // 60S
		
		private var _info:ImageInfo;
		
		public var isDispose:Boolean = false;
		/**
		 * 地图层 
		 */		
		public var mapLayer:DisplayObjectContainer;
		
		public function MapBitmap()
		{
			
		}
		
		public function get referenceCount():int
		{
			return _referenceCount;
		}
		
		public function removeReference():void
		{
			_referenceCount --;
			if( _referenceCount <= 0 )
			{
				_disposeTime = getTimer() + DisposeTime;
			}
		}
		
		public function addReference():void
		{
			if( _referenceCount < 0 )
			{
				_referenceCount = 0;
			}
			_referenceCount ++;
		}

		public function get info():ImageInfo
		{
			return _info;
		}

		public function set info(value:ImageInfo):void
		{
			_info = value;
			isDispose  = false;
			this.x = value.extData.x*MapConst.pieceWidth;
			this.y = value.extData.y*MapConst.pieceHeight;
			bitmapData = value.bitmapData;
		}
		
		public function removeToStage( container:DisplayObjectContainer ):void
		{
			if( container.contains(this) )
			{
				container.removeChild(this);
				_disposeTime = getTimer() + DisposeTime;
			}
		}
		public function addToStage(container:DisplayObjectContainer ):void
		{
			if( container.contains(this) == false )
			{
				container.addChild(this);
				_disposeTime = -1;
			}
		}
		
		public function get canDispose():Boolean
		{
			if( _disposeTime == -1 || getTimer() < _disposeTime ) return false;
			return true;
		}
		
		public function dispose():void
		{
			if( this.parent )
			{
				this.parent.removeChild(this);
			}
			this.bitmapData = null;
			isDispose  = true;
			ObjectPool.disposeObject(this,MapBitmap);
			_disposeTime = -1;
			if( _info )
			{
				_info.dispose();
				_info = null;
			}
		}

	}
}