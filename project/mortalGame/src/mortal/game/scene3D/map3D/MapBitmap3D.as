package mortal.game.scene3D.map3D
{
	import flash.utils.getTimer;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.loaders.resource.info.ABCInfo;
	
	import mortal.game.scene3D.layer3D.MapLayer3D;
	
	public class MapBitmap3D
	{
		private var _referenceCount:int = 0;  //引用数量
		
		public var disposeTime:Number = 0;
		
		private var _isUpload:Boolean = false;
		
		public static const DisposeTime:Number = 60*1000; // 60S
		
		private var _info:ABCInfo;
		
		public var isDispose:Boolean = false;
		
		public var cellTexture:Texture3D;
		
		public var parentLayer:MapLayer3D
		
		public function MapBitmap3D()
		{
			super();
			//this.render = MapBitmap3DRender.instance;
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
				disposeTime = getTimer() + DisposeTime;
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
		
		public function get info():ABCInfo
		{
			return _info;
		}
		
		public var x:Number=0;
		public var y:Number=0;
		public var width:Number=0;
		public var height:Number=0;
		
		public function set info(value:ABCInfo):void
		{
			_info = value;
			isDispose  = false;
			this.x = value.extData.x * MapConst.pieceWidth;
			this.y = value.extData.y * MapConst.pieceHeight;
			width = value.bmpWidth
			height = value.bmpHeight;

			if(value.isATF)
			{
				if(!this.cellTexture)
				{
					this.cellTexture = new Texture3D(value.ATFByteArray,Texture3D.MIP_NONE,value.format);
				}
				//				else
				//				{
				//					this.cellTexture.request = value.ATFByteArray;
				//				}
			}
			else
			{
				if(!this.cellTexture)
				{
					this.cellTexture = new Texture3D(value.bitmapData,Texture3D.MIP_NONE);
				}
				//				else
				//				{
				//					this.cellTexture.request = value;
				//				}
			}
		}
		
		public function upload(_arg1:Scene3D, _arg2:Boolean=true):void
		{
			//zheli
			if(!_isUpload)
			{
				_isUpload =this.cellTexture.upload(Device3D.scene,true);
			}
		}
		
		/*public function removeToStage( mapLayer3D:Pivot3D ):void
		{
		if( mapLayer3D.contains(this) )
		{
		mapLayer3D.removeChild(this);
		disposeTime = getTimer() + DisposeTime;
		}
		}
		
		public function addToStage():void
		{
		upload(Device3D.scene);
		if( mapLayer3D.contains(this) == false )
		{
		mapLayer3D.addChild(this);
		disposeTime = -1;
		}
		}*/
		
		public function get canDispose():Boolean
		{
			if( disposeTime == -1 || getTimer() < disposeTime ) return false;
			return true;
		}
		
		public function dispose():void
		{
			if(parentLayer)
			{
				parentLayer.removeMap3dFromStage(this);
				parentLayer=null;
			}
			
			isDispose  = true;
			_isUpload = false;
			disposeTime = -1;
			if( _info )
			{
				_info.dispose();
				_info = null;
			}
			if (this.cellTexture != null)
			{
				this.cellTexture.dispose();
				this.cellTexture=null;
			}
			
			
		}
	}
}