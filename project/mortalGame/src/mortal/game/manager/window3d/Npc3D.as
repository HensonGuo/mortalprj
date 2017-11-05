package mortal.game.manager.window3d
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DClearMask;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import baseEngine.basic.RenderList;
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.primitives.FrQuad;
	import frEngine.shader.filters.fragmentFilters.UvScaleFilter;
	
	import mortal.component.window.Window;
	
	public class Npc3D
	{
		public var id:uint;
		private var newBgSizePoint:Point=new Point();
		private var oldBgSizePoint:Point=new Point();
		private static var _id:uint = 0;
		private var _hasDispose:Boolean = false;
		public var isHide:Boolean = true;

		private var _bgBitmapData:BitmapData;
		private var bgUVscaleFilter:UvScaleFilter = new UvScaleFilter();
		private var _modle3d:Mesh3D;
		private var _backImg3d:FrQuad;
		private var _bgGloblePos:Point=new Point();
		private var _modlelocalPos:Point=new Point();
		private var _window:Window;
		public var renderList:RenderList=new RenderList();
		public function Npc3D()
		{
			_backImg3d = new FrQuad();
			_backImg3d.materialPrams.depthWrite=false;
			_backImg3d.setMateiralBlendMode(Material3D.BLEND_ALPHA0);
			_backImg3d.materialPrams.addFilte(bgUVscaleFilter);
			id = _id++;
		}
		
		public function reInit($window:Window):void
		{
			_window=$window;
			_bgGloblePos=_window.localToGlobal(new Point());
		}
		
		public function render(_scene3d:Scene3D):void
		{
			if(_bgBitmapData)
			{
				_backImg3d.update();
				_backImg3d.draw(false, null);
			}
			
			if (_modle3d)
			{
				_scene3d.context.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.DEPTH)
				_modle3d.update();
				_modle3d.draw(false, null);
			}

		}
		
		public function setBackImg($bgBitmapData:BitmapData):void
		{
			if(_bgBitmapData)
			{
				disposeBgImg();
			}
			oldBgSizePoint.x=$bgBitmapData.width;
			oldBgSizePoint.y=$bgBitmapData.height
			newBgSizePoint=calculateBgWH(oldBgSizePoint.x,oldBgSizePoint.y);
			_bgBitmapData = new BitmapData(newBgSizePoint.x,newBgSizePoint.y,true,0x0);
			_bgBitmapData.draw($bgBitmapData);
			_backImg3d.setMaterial(_bgBitmapData, 0,"Npc3DBg");
			_backImg3d.setTo(_bgGloblePos.x,_bgGloblePos.y,oldBgSizePoint.x,oldBgSizePoint.y);
			_backImg3d.sceneRect=Device3D.scene.viewPort;
			bgUVscaleFilter.uvValue[0] = oldBgSizePoint.x/newBgSizePoint.x;
			bgUVscaleFilter.uvValue[1] = oldBgSizePoint.y/newBgSizePoint.y;

		}

		
		public function setTargetMesh(mesh:Mesh3D,$scale:Number,$atWindowX:int,$atWindowY:int,disposeOld:Boolean):void
		{
			if (_modle3d && disposeOld)
			{
				disposeModle3d();
			}
			_modle3d = mesh;
			_modle3d.scaleX =_modle3d.scaleZ =_modle3d.scaleY = 2;
			_modlelocalPos.x=$atWindowX;
			_modlelocalPos.y=$atWindowY;
			var rect:Rectangle=Device3D.scene.viewPort;
			_modle3d.x=_modlelocalPos.x+_bgGloblePos.x-rect.width/2;
			_modle3d.y=rect.height/2-(_modlelocalPos.y+_bgGloblePos.y);
			_modle3d.materialPrams.uvRepeat=false;
		}
		
		public function resize():void
		{
			var rect:Rectangle=Device3D.scene.viewPort;
			_bgGloblePos=_window.localToGlobal(new Point());
			if(_modle3d)
			{
				_modle3d.x=_modlelocalPos.x+_bgGloblePos.x-rect.width/2-rect.x;
				_modle3d.y=rect.height/2-(_modlelocalPos.y+_bgGloblePos.y)+rect.y;
			}
			if(_backImg3d)
			{
				_backImg3d.sceneRect=Device3D.scene.viewPort;
				_backImg3d.setTo(_bgGloblePos.x-rect.x,_bgGloblePos.y-rect.y,oldBgSizePoint.x,oldBgSizePoint.y);
			}
			
		}
		private function calculateBgWH(bmpWidth:int,bmpHeight:int):Point
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
		public function show():void
		{
			isHide = false;
		}
		
		public function hide():void
		{
			isHide = true;
		}
		

		private function disposeBgImg():void
		{
			var bgTexture3d:Texture3D = Resource3dManager.instance.hasTexture3d(_bgBitmapData,0);
			bgTexture3d && Resource3dManager.instance.disposeTexture3d(bgTexture3d, true);
			_bgBitmapData = null;
		}
		
		private function disposeModle3d():void
		{
			_modle3d.dispose();
			_modle3d = null;
		}
		
		public function dispose():void
		{
			hide();
			if (_bgBitmapData)
			{
				disposeBgImg();
			}

			if (_modle3d)
			{
				disposeModle3d();
			}
			
			_window=null;
			
			_hasDispose = true;
			
		}
	}
}