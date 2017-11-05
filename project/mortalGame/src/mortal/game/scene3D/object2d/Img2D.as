package mortal.game.scene3D.object2d
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Texture3D;
	
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.primitives.FrQuad;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.fragmentFilters.UvScaleFilter;
	
	public class Img2D extends FrQuad
	{
		public var oldBgBitmapData:BitmapData
		public var newBgBitmapData:BitmapData
		public var rect:Rectangle;
		public var uvScalePoint:Point;
		private static var bgUVscaleFilter:UvScaleFilter = new UvScaleFilter();
		private var _offsetX:Number=0;
		private var _offsetY:Number=0;
		public function Img2D($name:String,$bitmapdata:BitmapData,$rect:Rectangle)
		{
			super($name, 0, 0, $rect.width, $rect.height, false, null, null);
			materialPrams.depthWrite=false;
			materialPrams.addFilte(bgUVscaleFilter);
			this.bitmapData=$bitmapdata;
			this.initRect($rect);
		}
		
		public override function getPosition(_arg1:Boolean=true, _arg2:Vector3D=null):Vector3D
		{
			if (_arg2 == null)
			{
				_arg2 = new Vector3D();
			}
			_arg2.x=_offsetX+this.x;
			_arg2.y=_offsetY+this.y;
			return (_arg2);
		}

		public function setOffsetXY($x:Number,$y:Number):void
		{
			_offsetX=$x;
			_offsetY=$y;
			_toChange=true;
		}
		public function set bitmapData(value:BitmapData):void
		{
			oldBgBitmapData=value;
		}
		public function get bitmapData():BitmapData
		{
			return oldBgBitmapData;
		}
		public function initRect(value:Rectangle):void
		{
			rect=value;
			disposeTexture();
			var p:Point=calculateBgWH(rect.width,rect.height);
			newBgBitmapData=new BitmapData(p.x,p.y,false,0x0);
			var m:Matrix=new Matrix();
			m.translate(-rect.x,-rect.y);
			newBgBitmapData.draw(oldBgBitmapData,m);
			uvScalePoint=new Point(rect.width/p.x,rect.height/p.y);
			this.setMaterial(newBgBitmapData, 0,"Rect3dBg");
		}
		
		private function disposeTexture():void
		{
			if(newBgBitmapData)
			{
				var bgTexture3d:Texture3D = Resource3dManager.instance.hasTexture3d(newBgBitmapData,0);
				bgTexture3d && Resource3dManager.instance.disposeTexture3d(bgTexture3d, true);
				newBgBitmapData=null;
			}
			
		}
		public override function dispose(isReuse:Boolean=true):void
		{
			disposeTexture();
			renderList=null;
			removedFromScene();
			super.dispose(isReuse);
		}
		private static function calculateBgWH(bmpWidth:int,bmpHeight:int):Point
		{
			var _local7:int=1;
			while (_local7 < bmpWidth)
			{
				_local7=(_local7 << 1);
			}
			
			var _local8:int=1;
			while (_local8 < bmpHeight)
			{
				_local8=(_local8 << 1);
			}
			return new Point(_local7,_local8);
		}
		public override function draw(_arg1:Boolean=true, _arg2:ShaderBase=null):void
		{
			bgUVscaleFilter.uvValue[0]=uvScalePoint.x;
			bgUVscaleFilter.uvValue[1]=uvScalePoint.y;
			super.draw(_arg1,_arg2);
		}
		
	}
}