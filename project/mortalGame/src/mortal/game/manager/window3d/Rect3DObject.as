package mortal.game.manager.window3d
{
	import flash.display.Shape;
	import flash.display3D.Context3DClearMask;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import baseEngine.basic.Layer3DSort;
	import baseEngine.basic.RenderList;
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	
	import frEngine.TimeControler;
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.game.scene3D.object2d.Img2D;

	public class Rect3DObject
	{
		public var maskRect:Rectangle;
		public var id:uint; 
		public var rect:Rectangle;
		private var startPoint:Point=new Point();

		private static var _id:uint = 0;
		private var _hasDispose:Boolean = true;
		private var _layer:int = 0;
		private var modleUrl:*;

		private var _bg3dList:Vector.<Img2D>=new Vector.<Img2D>();
		private var _obj3dList:Vector.<Obj3dInfo>=new Vector.<Obj3dInfo>();
		

		public var maskShape:Shape = new Shape();
		public var maskShape2:Shape = new Shape();
		public var window:IWindow3D;
		public var hasClose:Boolean=true;
		public var allTimeIsTop:Boolean=false;
		public var renderList:RenderList=new RenderList();
		
		public function Rect3DObject($maskRect:Rectangle,$window:IWindow3D)
		{
			
			id = _id++;
			reInit($maskRect,$window);
		}

	
		public function get layer():int
		{
			return _layer;
		}

		public function set layer(value:int):void
		{
			_layer = value;
		}

		public function render(_scene3d:Scene3D):void
		{

			_scene3d.context.clear(0, 0, 0, 1, 1, 0, Context3DClearMask.DEPTH);
			
			for each(var obj3dInfo:Obj3dInfo in _obj3dList)
			{
				obj3dInfo.obj3d.update();
			}
			
			var layers:Vector.<Layer3DSort>=this.renderList.layers;
			var len:int=layers.length;
			for(var i:int=0;i<len;i++)
			{
				var layersort:Layer3DSort=layers[i];
				if(layersort.isActive)
				{
					layersort.sort();
				}
				
				var list:Vector.<Mesh3D>=layersort.list;
				var len2:int=list.length;
				if(len2>0)
				{
					for(var j:int=0;j<len2;j++)
					{
						var _mesh:Mesh3D=list[j];
						_mesh.draw(false);
					}
				}
			}
 
		}

	
		public function removeImg($img2d:Img2D):void
		{
			var index:int=_bg3dList.indexOf($img2d);
			if(index!=-1)
			{
				$img2d.dispose();
				_bg3dList.splice(index,1);
				
			}
		}
		/**
		 * 
		 * @param $bgBitmapData
		 * @param bitMapOffsetX，截取位图的偏移x
		 * @param bitMapOffsetY，截取位图的偏移y
		 * @param w，要显示的宽
		 * @param h，要显示的高
		 * @param winOffsetX，位图相对窗口，位移偏移x
		 * @param winOffsetY，位图相对窗口，位移偏移y
		 * 
		 */		
		public function addImg($img2d:Img2D,layer:int=Layer3DManager.backGroudImgLayer):void
		{
			var index:int=_bg3dList.indexOf($img2d);
			if(index==-1) 
			{
				this._bg3dList.push($img2d);
				
			}
			$img2d.renderList=this.renderList;
			$img2d.setLayer(layer,false);
			$img2d.addedToScene(Device3D.scene);
			moveImg($img2d);
			//moveAll3d();
		}

		public function removeObj3d(obj3d:Pivot3D):void
		{
			var info:Obj3dInfo=getMesh3dInfo(obj3d);
			if(info)
			{
				info.dispose();
				var index:int=_obj3dList.indexOf(info);
				_obj3dList.splice(index,1);
				
			}
			if(obj3d is Mesh3D)
			{
				Mesh3D(obj3d).renderList=null;
			}
			
		}
		
		private function getMesh3dInfo(obj3d:Pivot3D):Obj3dInfo
		{
			for each(var obj3dInfo:Obj3dInfo in _obj3dList)
			{
				if(obj3dInfo.obj3d==obj3d)
				{
					return obj3dInfo;
				}
			}
			return null;
		}

		/**
		 * 注册显示的3d对象 
		 * @param obj3d 要显示的3d对象
		 * @param $localX 相对于注册区域的x
		 * @param $localY 相对于注册区域的y
		 * 
		 */		
		public function addObject3d(obj3d:Pivot3D,$localX:int,$localY:int):void
		{
			var info:Obj3dInfo=getMesh3dInfo(obj3d);
			if(!info)
			{
				info=new Obj3dInfo(obj3d);
				_obj3dList.push(info);
			}
			info.modlelocalPos.x=$localX;
			info.modlelocalPos.y=$localY;
			if(obj3d is Mesh3D)
			{
				Mesh3D(obj3d).renderList=this.renderList;
			}
			
			obj3d.addedToScene(Device3D.scene);
			moveObj3d(info);
		}

		public function reInit($maskRect:Rectangle,$window:IWindow3D):void
		{
			
			_hasDispose = false;
			window=$window;
			rect = new Rectangle(int($maskRect.x)+1,int($maskRect.y)+1,int($maskRect.width/2)*2-2,int($maskRect.height/2)*2-2);
			startPoint.x=rect.x;
			startPoint.y=rect.y;

		}

		

		public function calculateRect():void
		{
			var p:Point=window.localToGlobal(startPoint);
			rect.x = int(p.x);
			rect.y = int(p.y);
		}

		private function moveImg(img2d:Img2D):void
		{
			var _viewport:Rectangle=Device3D.scene.viewPort;
			img2d.setOffsetXY(rect.x-1-_viewport.x,rect.y-1-_viewport.y);
		}
		private function moveObj3d(obj3dInfo:Obj3dInfo):void
		{
			var _viewport:Rectangle=Device3D.scene.viewPort;
			var _obj3d:Pivot3D=obj3dInfo.obj3d;
			_obj3d.x=obj3dInfo.modlelocalPos.x+rect.x-_viewport.width/2-_viewport.x;
			_obj3d.y=_viewport.height/2-(obj3dInfo.modlelocalPos.y+rect.y)+_viewport.y;
		}
		public function moveAll3d():void
		{
			var _viewport:Rectangle=Device3D.scene.viewPort;
			for each(var bg3dInfo:Img2D in _bg3dList)
			{
				bg3dInfo.setOffsetXY(rect.x-1-_viewport.x,rect.y-1-_viewport.y);
			}

			for each(var obj3dInfo:Obj3dInfo in _obj3dList)
			{
				var _obj3d:Pivot3D=obj3dInfo.obj3d;
				_obj3d.x=obj3dInfo.modlelocalPos.x+rect.x-_viewport.width/2-_viewport.x;
				_obj3d.y=_viewport.height/2-(obj3dInfo.modlelocalPos.y+rect.y)+_viewport.y;
			}

		}

		private function disposeAllBgImg():void
		{
			for each(var bg3dInfo:Img2D in _bg3dList)
			{
				bg3dInfo.dispose();
			}
			_bg3dList.length=0;
		}

		private function disposeAllModle3d():void
		{
			for each(var obj3dInfo:Obj3dInfo in _obj3dList)
			{
				obj3dInfo.dispose();
			}
			_obj3dList.length=0;
		}

		public function clear():void
		{
			disposeAllBgImg();
			disposeAllModle3d();
			rect.width=rect.height=0;
		}
		public function dispose():void
		{
			disposeAllBgImg();
			disposeAllModle3d();
			this.renderList.clear();
			maskRect = null;
			_hasDispose = true;
			window=null;

		}
	}
}

import flash.geom.Point;

import baseEngine.core.Pivot3D;

class Obj3dInfo
{
	public var obj3d:Pivot3D
	public var modlelocalPos:Point=new Point();
	public function Obj3dInfo($obj3d:Pivot3D)
	{
		obj3d=$obj3d;
		//obj3d.materialPrams.uvRepeat=false;
	}
	public function dispose():void
	{
		obj3d.dispose();
		obj3d.removedFromScene();
	}
}