package mortal.game.manager.window3d
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.primitives.FrQuad;
	
	import mortal.component.window.BaseWindow;
	import mortal.component.window.Window;
	import mortal.component.window.WindowEvent;
	import mortal.game.scene3D.GameScene3D;
	
	public class Npc3DManager
	{
		public static const instance:Npc3DManager=new Npc3DManager();

		private var _findRect3dObjectByWindow:Dictionary=new Dictionary(false);
		private var _npc3dList:Array=new Array();
		private var _pool:Vector.<Npc3D>=new Vector.<Npc3D>();
		private var _curLen:int=0;
		private var _scene3d:Scene3D;
		private var _blackMask3d:FrQuad;
		private var _blackMask3dIsHide:Boolean=true;
		public function Npc3DManager()
		{
			
		}
		public function init(value:GameScene3D):void
		{
			_scene3d=value;
			_blackMask3d = new FrQuad("blackMask3d",0,0,100,100,true);
			_blackMask3d.setMaterial(0x66000000, 0,"blackMask3d");
			_blackMask3d.materialPrams.depthWrite=false;
			_blackMask3d.setMateiralBlendMode(Material3D.BLEND_ALPHA0);
		}
		
		public function resize(e:Event=null):void
		{
			
			_blackMask3d.setTo(0,0,100,100,true);
			_blackMask3d.sceneRect=Device3D.scene.viewPort;
			
			var len:int=_npc3dList.length;
			for(var i:int=0;i<len;i++)
			{
				var npc3d:Npc3D=_npc3dList[i];
				
				if(!npc3d.isHide)
				{
					npc3d.resize();
				}
			}
		}
		
		public function showBlackMask3d():void
		{
			_blackMask3dIsHide=false;
		}
		public function hideBlackMask3d():void
		{
			_blackMask3dIsHide=true;
		}
		private function renderRect3d(e:Event):void
		{
			if(_blackMask3dIsHide==false)
			{
				_blackMask3d.update();
				_blackMask3d.draw(false);
			}
			var len:int=_npc3dList.length;
			if(len>0)
			{
				for(var i:int=0;i<len;i++)
				{
					var npc3d:Npc3D=_npc3dList[i];
					if(!npc3d.isHide)
					{
						npc3d.render(_scene3d);
					}
				}
				
			}
			
		}
		
		public function hasRegisterWindow($window:BaseWindow):Boolean
		{
			if(getRect3dByWindow($window)!=null)
			{
				return true;
			}else
			{
				return false;
			}
		}
		public function getRect3dByWindow($window:Window):Npc3D
		{
			return _findRect3dObjectByWindow[$window];
		}
		
		public function registerWindow($window:Window):Npc3D
		{
			var npc3d:Npc3D=getRect3dByWindow($window)
			if(npc3d!=null)
			{
				return npc3d;
			}
			
			if(_pool.length>0)
			{
				npc3d=_pool.shift();
			}else
			{
				npc3d=new Npc3D();
			}
			
			npc3d.reInit($window);
			
			_npc3dList.push(npc3d);
			
			_findRect3dObjectByWindow[$window]=npc3d;
			
			$window.addEventListener(WindowEvent.SHOW,windowShowHander);
			$window.addEventListener(WindowEvent.CLOSE,unRegisterWindow);
			$window.addEventListener(WindowEvent.POSITIONCHANGE,resize);
			return npc3d;
		}
		public function unRegisterWindow(e:Event,$window:Window=null):void
		{
			
			if(e!=null)
			{
				$window=e.currentTarget as Window;
			}
			if(getRect3dByWindow($window)==null)
			{
				return;
			}
			
			windowHideHander(null,$window);
			
			var npc3d:Npc3D=getRect3dByWindow($window);
			if(!npc3d)
			{
				return;
			}
			_pool.push(npc3d);
			npc3d.dispose();
			
			delete _findRect3dObjectByWindow[$window];
			var index:int=_npc3dList.indexOf(npc3d);
			_npc3dList.splice(index,1);
			$window.removeEventListener(WindowEvent.SHOW,windowShowHander);
			$window.removeEventListener(WindowEvent.CLOSE,unRegisterWindow);
			$window.removeEventListener(WindowEvent.POSITIONCHANGE,resize);
		}
		
		public function windowShowHander(e:Event,$window:Window=null):void
		{
			if(e!=null)
			{
				$window=e.currentTarget as Window;
			}
			
			var npc3d:Npc3D=getRect3dByWindow($window);
			if(!npc3d)
			{
				return;
			}
			if(npc3d.isHide)
			{
				_curLen++;
				npc3d.show();
				if(_curLen==1)
				{
					_scene3d.addEventListener(Engine3dEventName.OVERLAY_RENDER_EVENT,renderRect3d,false,1000000,false);
				}
			}
			
			
		}
		public function windowHideHander(e:Event,$window:Window=null):void
		{
			if(e!=null)
			{
				$window=e.currentTarget as Window;
			}
			var npc3d:Npc3D=getRect3dByWindow($window);
			if(!npc3d)
			{
				return;
			}
			if(npc3d.isHide==false)
			{
				npc3d.hide();
				_curLen--;
				if(_curLen==0)
				{
					_scene3d.removeEventListener(Engine3dEventName.OVERLAY_RENDER_EVENT,renderRect3d);
					
				}
			}
		}
		
	}
}