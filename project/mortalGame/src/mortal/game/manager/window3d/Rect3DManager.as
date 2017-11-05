package mortal.game.manager.window3d
{
	import com.gengine.global.Global;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.display.IGraphicsData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.WindowLayer;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;

	public class Rect3DManager
	{
		public static const instance:Rect3DManager=new Rect3DManager();
		
		private var _mask1:Shape=new Shape();
		private var _mask2:Shape=new Shape();
		private var _findRect3dObjectByWindow:Dictionary=new Dictionary(false);
		private var _rect3dList:Array=new Array();
		private var _pool:Vector.<Rect3DObject>=new Vector.<Rect3DObject>();
		private var _curLen:int=0;
		private var _scene3d:Scene3D;
		private var _updateMask:Boolean=true;
		private var drawingCommand:Vector.<int>=new Vector.<int>();

		public function Rect3DManager()
		{
			//_mask.y=150; 
			drawingCommand.push(GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO);
		}
		public function init(value:GameScene3D):void
		{
			_scene3d=value;
			
			if(!_mask1.parent)
			{
				Global.stage.addChild(_mask1);
			}
			
			if(!_mask2.parent)
			{
				Global.stage.addChild(_mask2);
			}
			
		}
		public function resize():void
		{
			var hasChange:Boolean=false;
			for (var win:* in _findRect3dObjectByWindow)
			{
				var rect3d:Rect3DObject=_findRect3dObjectByWindow[win];
				
				if(!rect3d.hasClose)
				{
					rect3d.calculateRect();
					rect3d.moveAll3d();
				}
				hasChange=true;
			}
			if(_updateMask || hasChange)
			{
				clearOldMask(null);
			}
		}
		private function renderRect3d(e:Event):void
		{

			if(_updateMask)
			{
				redrawMask();
				_updateMask=false;
			}
			var len:int=_rect3dList.length;
			if(len>0)
			{
				var _scene3d:Scene3D=Device3D.scene;
				var rect3d:Rect3DObject
				for(var i:int=0;i<len;i++)
				{
					rect3d=_rect3dList[i]; 
					if(!rect3d.hasClose)
					{
						rect3d.render(_scene3d);
					}
				}

			}
			
		}
		
		public function hasRegisterWindow($window:IWindow3D):Boolean
		{
			if(getRect3dByWindow($window)!=null)
			{
				return true;
			}else
			{
				return false;
			}
		}
		private function getRect3dByWindow($window:IWindow3D):Rect3DObject
		{
			return _findRect3dObjectByWindow[$window];
		}
		
		public function changeRect3dArea($window:IWindow3D,$areaRect:Rectangle):void
		{
			var rect3d:Rect3DObject=getRect3dByWindow($window)
			rect3d.reInit($areaRect,$window);
			windowMovingHander(null,$window);
		}
		public function registerWindow($maskRect:Rectangle,$window:IWindow3D,$allTimeIsTop:Boolean=false):Rect3DObject
		{
			//$window.contentTopOf3DSprite
			var rect3d:Rect3DObject=getRect3dByWindow($window)
			if(rect3d!=null)
			{
				rect3d.reInit($maskRect,$window);
			}else
			{
				if(_pool.length>0)
				{
					rect3d=_pool.shift();
					rect3d.reInit($maskRect,$window);
				}else
				{
					rect3d=new Rect3DObject($maskRect,$window);
				}
				_rect3dList.push(rect3d);
				_findRect3dObjectByWindow[$window]=rect3d;
			}
			rect3d.allTimeIsTop=$allTimeIsTop;
			rect3d.calculateRect();
			rect3d.moveAll3d();
			clearOldMask(rect3d);
			
			$window.addEventListener(WindowEvent.SHOW,windowShowHander);
			$window.addEventListener(WindowEvent.CLOSE,closeHander);
			$window.addEventListener(WindowEvent.POSITIONCHANGE,windowMovingHander);
			return rect3d;
		}
		private function closeHander(e:Event,$window:IWindow3D=null):void
		{
			if(e!=null)
			{
				$window=e.currentTarget as IWindow3D;
			}
			var rect3d:Rect3DObject=_findRect3dObjectByWindow[$window];
			if(!rect3d)
			{
				return;
			}
			/*var $window:Window=rect3d.window;
			if(!$window)
			{
				return;
			}*/
			
				
			if(rect3d.hasClose==false)
			{
				$window.contentContainer.mask=null;
				if(rect3d.allTimeIsTop)
				{
					Global.application.mask=null;
				}
				rect3d.hasClose=true;
				clearOldMask(rect3d);
				_curLen--;
				if(_curLen==0)
				{
					LayerManager.setWindowSpriteMask(null,null);
					
					LayerManager.windowLayer3D.removeEventListener(WindowEvent.WINDOWLEVELCHANGE,windowLayerChangeHander);
					
					_scene3d.removeEventListener(Engine3dEventName.OVERLAY_RENDER_EVENT,renderRect3d);
					
				}
			}
			
			_pool.push(rect3d);
			rect3d.dispose();
			
			delete _findRect3dObjectByWindow[$window];
			var index:int=_rect3dList.indexOf(rect3d);
			_rect3dList.splice(index,1);
			
			$window.removeEventListener(WindowEvent.SHOW,windowShowHander);
			$window.removeEventListener(WindowEvent.CLOSE,closeHander);
			$window.removeEventListener(WindowEvent.POSITIONCHANGE,windowMovingHander);
			
			
		}
		public function disposeRect3d(rect3d:Rect3DObject):void
		{
			rect3d.clear();
			clearOldMask(rect3d);
			if(rect3d.window)
			{
				rect3d.window.removeEventListener(WindowEvent.POSITIONCHANGE,windowMovingHander);
			}
			
		}

		public function windowShowHander(e:Event,$window:IWindow3D=null):void
		{
			if(e!=null)
			{
				$window=e.currentTarget as IWindow3D;
			}
			
			var rect3d:Rect3DObject=getRect3dByWindow($window);
			if(!rect3d)
			{
				return;
			}
			if(rect3d.hasClose)
			{
				_curLen++;
				rect3d.layer=_rect3dList.length;
				rect3d.hasClose=false;
				rect3d.moveAll3d();
				clearOldMask(rect3d);
				if(_curLen==1)
				{
					LayerManager.windowLayer3D.addEventListener(WindowEvent.WINDOWLEVELCHANGE,windowLayerChangeHander);
					_scene3d.addEventListener(Engine3dEventName.OVERLAY_RENDER_EVENT,renderRect3d);
				}
			}
			
			
		}
		
		private function clearOldMask(rect3d:Rect3DObject):void
		{
			_updateMask=true;//redrawMask();
			if(rect3d)
			{
				if(rect3d.allTimeIsTop)
				{
					Global.application.mask=null;
				}else
				{
					rect3d.window && (rect3d.window.contentContainer.mask=null);
				}
			}
			
			
		}
		
		private function windowLayerChangeHander(e:Event):void
		{
			var disObj:WindowLayer=LayerManager.windowLayer3D
			var len:int=disObj.numChildren;
			for(var i:int=0;i<len;i++)
			{
				var $window:IWindow3D=disObj.getChildAt(i) as IWindow3D;
				var rect3d:Rect3DObject=getRect3dByWindow($window)
				if(rect3d && !rect3d.hasClose)
				{
					rect3d.layer=i;
				}
				
			}
			_rect3dList.sortOn("layer");
			clearOldMask(null);

		}
		private function windowMovingHander(e:Event,$window:IWindow3D=null):void
		{
			if(e!=null)
			{
				$window=e.currentTarget as IWindow3D;
			}
			var rect3d:Rect3DObject=getRect3dByWindow($window);
			rect3d.calculateRect();
			rect3d.moveAll3d();
			clearOldMask(rect3d);
			
		}
		private function redrawMask():void
		{

			var data:Vector.<IGraphicsData>=new Vector.<IGraphicsData>();

			var resultRects:Array=new Array();
			var _stage:Stage=Global.stage;
			var stagew:Number=_stage.stageWidth;
			var stageh:Number=_stage.stageHeight;
			var rect:Rectangle=new Rectangle(0,0,stagew,stageh)
			resultRects.push(rect);
			
			data.push(getPath(rect));
			
			var len:int=_rect3dList.length;
			var isTop:Boolean=true;
			for (var i:int=len-1;i>=0;i--)
			{
				var rect3d:Rect3DObject=_rect3dList[i];
				if(!rect3d.hasClose)
				{
					spliteRect(rect3d.rect,resultRects,data); 
					drawGrphic(rect3d.maskShape.graphics,data);
					
					if(i>0)
					{
						var nextRect:Rect3DObject=_rect3dList[i-1]
						drawGrphic(rect3d.maskShape2.graphics,data);
						nextRect.window.contentTopOf3DSprite && (nextRect.window.contentTopOf3DSprite.mask=rect3d.maskShape2);
					}
					if(isTop)
					{
						rect3d.window.contentTopOf3DSprite && (rect3d.window.contentTopOf3DSprite.mask=null);
						isTop=false;
					}
					
					if(rect3d.allTimeIsTop)
					{
						Global.application.mask !=rect3d.maskShape && (Global.application.mask=rect3d.maskShape);
					}else
					{
						rect3d.window.contentContainer.mask!=rect3d.maskShape && (rect3d.window.contentContainer.mask=rect3d.maskShape);
					}
				}
			}
			
			drawGrphic(_mask1.graphics,data);
			drawGrphic(_mask2.graphics,data);

			LayerManager.setWindowSpriteMask(_mask1,_mask2);

		}

		private function drawGrphic(g:Graphics,command:Vector.<IGraphicsData>):void
		{
			g.clear();
			g.beginFill(0xff0000,0.4);
			g.drawGraphicsData(command);
			g.endFill();
		}
		private function getPath(rect:Rectangle):GraphicsPath
		{
			var drawingData:Vector.<Number>=new Vector.<Number>();
			var top:Number=rect.top;
			var left:Number=rect.left;
			var right:Number=rect.right;
			var bottom:Number=rect.bottom;
			drawingData.push(left,top,	right,top,	right,bottom,	left,bottom,	left,top);
			var path:GraphicsPath=new GraphicsPath(drawingCommand,drawingData);
			return path;
		}
		private function spliteRect(targetRect:Rectangle,resultList:Array,drawingData:Vector.<IGraphicsData>):void
		{
			var len:int=resultList.length;
			var newRect:Rectangle=null;
			for(var i:int=0;i<len;i++)
			{
				var rect:Rectangle=resultList[i];
				var crossrect:Rectangle=rect.intersection(targetRect);
				
				if(crossrect.width*crossrect.height > 0 )
				{
					var tx:Number=rect.x;
					var ty:int=rect.y;
					var cx:int=crossrect.x;
					var cy:int=crossrect.y;
					
					var tr:Number=rect.right;
					var tb:int=rect.bottom;
					var cr:int=crossrect.right;
					var cb:int=crossrect.bottom;
					
					newRect=null;
					
					if(cy>ty)
					{
						newRect=new Rectangle(tx,ty,rect.width,cy-ty);
						resultList[i]=newRect;
						drawingData[i]=getPath(newRect)
					}
					if(cx>tx)
					{
						if(!newRect)
						{
							newRect=new Rectangle(tx,cy,cx-tx,crossrect.height)
							resultList[i]=newRect;
							drawingData[i]=getPath(newRect)
						}else
						{
							newRect=new Rectangle(tx,cy,cx-tx,crossrect.height)
							resultList.push(newRect);
							drawingData.push(getPath(newRect));
						}
						
					}
					if(cr<tr)
					{
						if(!newRect)
						{
							newRect=new Rectangle(cr,cy,tr-cr,crossrect.height)
							resultList[i]=newRect;
							drawingData[i]=getPath(newRect)
						}else
						{
							newRect=new Rectangle(cr,cy,tr-cr,crossrect.height)
							resultList.push(newRect);
							drawingData.push(getPath(newRect));
						}
					}
					if(cb<tb)
					{
						if(!newRect)
						{
							newRect=new Rectangle(tx,cb,rect.width,tb-cb)
							resultList[i]=newRect;
							drawingData[i]=getPath(newRect)
						}else
						{
							newRect=new Rectangle(tx,cb,rect.width,tb-cb)
							resultList.push(newRect);
							drawingData.push(getPath(newRect));
						}
					}
				}
			}
		}
	}
}