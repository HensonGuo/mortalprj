package mortal.game.scene3D.model.player
{
	import flash.utils.Dictionary;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.effectEditTool.manager.Obj3dContainer;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.loaders.resource.info.EffectInfo;
	
	import mortal.GameScene3dConfig;
	import mortal.game.resource.ResConfig;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.scene3D.player.entity.IGame2D;
	import mortal.game.scene3D.player.entity.IHang;

	public class EffectPlayer extends Obj3dContainer implements IGame2D, IHang
	{
		protected var loadPriority:int = 2;
		protected var _curUrl:String;
		protected var _y2d:Number = 0;
		protected var _x2d:Number = 0;
		protected var _hangBoneName:String;
		protected var _direction:Number = 0;
		protected var _loaded:Boolean=false;
		
		protected static var _countId:uint=0;
		public function EffectPlayer($url:String,$renderList:RenderList,$loadPriority:int = 2)
		{
			super($url, _countId);
			_countId++;
			loadPriority = $loadPriority;
			renderList=$renderList;
			if ($url)
			{
				load($url);
			}
			//ContainerManager.instance.registerContainer(this);

		}
		
		protected var _hangList:Dictionary=new Dictionary(false);
		public function hang(obj:IHang,targetUid:String):void
		{
			if(_loaded)
			{
				hangImp(obj,targetUid);
			}else
			{
				_hangList[obj]=targetUid;
			}
			
			
		}
		
		protected function hangImp(obj:IHang,targetUid:String):void
		{
			var md5:Md5Mesh=this.getObject3dByID(targetUid) as Md5Mesh;
			if(md5)
			{
				md5.targetMd5Controler.attachObjectToBone(obj.hangBoneName, obj.hangBody);
			}
		}
		
		public function unHang(obj:IHang,targetUid:String):void
		{
			if(_loaded)
			{
				var md5:Md5Mesh=this.getObject3dByID(targetUid) as Md5Mesh;
				if(md5)
				{
					md5.targetMd5Controler.removeHang(obj.hangBody);
				}
			}else
			{
				delete _hangList[obj]
			}
			
			
		}
		
		public function get curUrl():String
		{
			return _curUrl;
		}

		public function set direction(value:Number):void
		{
			_direction = value;
			this.setRotation(0, Scene3DUtil.change2Dto3DRotation(_direction), 0);
		}

		public function get direction():Number
		{
			return _direction;
		}

		public function get hangBody():Pivot3D
		{
			return this;
		}

		public function get hangBoneName():String
		{
			return _hangBoneName;
		}

		public function set hangBoneName(value:String):void
		{
			_hangBoneName = value;
		}

		public function set x2d(value:Number):void
		{
			_x2d = value;
			x = Scene3DUtil.change2Dto3DX(value);
		}

		public function get x2d():Number
		{
			return _x2d;
		}

		public function set y2d(value:Number):void
		{
			_y2d = value;
			z = Scene3DUtil.change2Dto3DY(value);
		}

		public function get y2d():Number
		{
			return _y2d;
		}
		
		
		
		public function load(effectName:String):void
		{
			var targetUrl:String = GameScene3dConfig.instance.getEffectUrlById(effectName);
			
			var templeName:String=ResConfig.instance.getEffectTemplateByName(targetUrl);
			if(templeName)
			{
				setTempleByName(templeName);
			}
			
			if (_curUrl && _curUrl != effectName)
			{
				Resource3dManager.instance.unLoad(targetUrl, loadedHander);
			}

			if (_curUrl != effectName)
			{
				var arr:Array = this.getAllObject3d();
				for each (var p:Mesh3D in arr)
				{
					this.disposeChild(p);
				}
				_loaded = false;
				Resource3dManager.instance.load(targetUrl, loadedHander, loadPriority);
			}
			_curUrl = effectName;
			this.name=_curUrl;
		}

		protected function loadedHander(info:EffectInfo):void
		{
			_loaded = true;
			
			this.timerContorler.gotoFrame(0,0);
			this.setData(info.obj,false,false,renderList);
			this.timerContorler.duringFrame=this.maxKeyFrame;
			for(var obj:Object in _hangList)
			{
				hangImp(IHang(obj),_hangList[obj]);
			}
			_hangList=new Dictionary(false);
		}

		public override function update():void
		{
			if (_loaded)
			{
				super.update();
			}
		}

		public function set angle(value:Number):void
		{
			this.setRotation(0, value, 0);
		}


		public override function reset():void
		{
			x2d = y2d = 0;
			angle = 0;
			_hangBoneName = null;
			super.reset();
		}

		protected override function playEndHander():void
		{
			super.playEndHander();
			this.dispose(true);
		}
		
		public override function dispose(isReuse:Boolean = true):void
		{

			if (!isReuse)
			{
				_curUrl = null;
				_loaded = false;
				Resource3dManager.instance.unLoad(_curUrl, loadedHander);
				super.dispose(false);
			}
			else
			{
				EffectPlayerPool.instance.dispose(this);
				this.parent = null;
				this.temple.unHangAll();
			}
		}
	}
}
