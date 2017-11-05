package mortal.game.view.mount.panel
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import Message.DB.Tables.TModel;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.utils.MountUtil;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mount.data.MountData;
	import mortal.mvc.core.Dispatcher;

	public class Mount3DPanel extends MountBasePanel
	{
		private var _leftBtn:GLoadedButton;
		
		private var _rightBtn:GLoadedButton;
		
		private var _preBtn:GLoadedButton;
		
		private var _expanBtn:GLoadedButton;
		
		private var _name:GTextFiled;
		
		private var _bodyPlayer:ActionPlayer;
		
		protected var _rect3d:Rect3DObject;
		
		protected var _window:Window;
		
		private var _frameTimer:FrameTimer;
		
		public function Mount3DPanel(window:Window)
		{
			_window = window;
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(98,78,281,22,_window.contentTopOf3DSprite,ImagesConst.PetNameBg));
			
			_leftBtn = UIFactory.gLoadedButton(ImagesConst.TurnLeft_upSkin,309,262,40,36,_window.contentTopOf3DSprite);
			_leftBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			
			_rightBtn = UIFactory.gLoadedButton(ImagesConst.TurnRight_upSkin,127,262,40,36,_window.contentTopOf3DSprite);
			_rightBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,stopTurning);
		
			_preBtn = UIFactory.gLoadedButton(ImagesConst.petBloodPreBtn_upSkin,96,78,24,25,_window.contentTopOf3DSprite);
			_preBtn.configEventListener(MouseEvent.CLICK,selectMount);
			
			_expanBtn = UIFactory.gLoadedButton(ImagesConst.ShopExpansion_upSkin,359,78,24,25,_window.contentTopOf3DSprite);
			_expanBtn.configEventListener(MouseEvent.CLICK,selectMount);
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.CENTER;
			
			_name = UIFactory.gTextField("",197,80,80,20,_window.contentTopOf3DSprite,tf);
			
			add3DRole();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_leftBtn.dispose(isReuse);
			_rightBtn.dispose(isReuse);
			_preBtn.dispose(isReuse);
			_expanBtn.dispose(isReuse);
			_name.dispose(isReuse);
			
			_leftBtn = null;
			_rightBtn = null;
			_preBtn = null;
			_expanBtn = null;
			_name = null;
			
			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
				_img2d=null;
			}
			
			if(_bodyPlayer)
			{
				_bodyPlayer.dispose(true);
				_bodyPlayer = null;
			}
		
			if(_frameTimer)
			{
				_frameTimer.dispose(isReuse);
				_frameTimer = null;
			}
			
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stopTurning);
			
			super.disposeImpl(isReuse);
		}
		
		override public function setMountInfo(mountData:MountData):void
		{
			_mountData = mountData;
			
		}
		
		override public function clearWin():void
		{
			super.clearWin();
			
			_name.text = "";
			
			if(_bodyPlayer)
			{
				_bodyPlayer.dispose(true);
				_bodyPlayer = null;
			}
		}
		
		override public function setInfo():void
		{
			updateRoleModel();
			_name.htmlText = MountUtil.getItemName(_mountData);
		}
		
		private function selectMount(e:MouseEvent):void
		{
			if(e.target == _preBtn)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MountChangeSelceted,-1));
			}
			else if(e.target == _expanBtn)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MountChangeSelceted,1));
			}
				
		}
		
		private var bmpdata:BitmapData;
		private var _img2d:Img2D;
		protected function add3DRole():void
		{
			_rect3d = Rect3DManager.instance.registerWindow(new Rectangle(21, 71, 440, 300), _window);
			Rect3DManager.instance.windowShowHander(null, _window);
			bmpdata = GlobalClass.getBitmapData(ImagesConst.MountPanel);
			
			_rect3d.removeImg(_img2d);
			
			_img2d=new Img2D(null,bmpdata,new Rectangle(0, 0,440,300));
			_rect3d.addImg(_img2d);
			
			updateRoleModel();
		}
		
		protected function updateRoleModel():void
		{
			if(_rect3d && _mountData && _mountData.isOwnMount)
			{
				var model:TModel = ModelConfig.instance.getInfoByCode(_mountData.itemMountInfo.model);
				var meshUrl:String=model.mesh1 + ".md5mesh";
				var boneUrl:String=model.bone1 + ".skeleton";
				if(_bodyPlayer)
				{
					_rect3d.removeObj3d(_bodyPlayer);
				}
				_bodyPlayer = ObjectPool.getObject(ActionPlayer);
				_bodyPlayer.changeAction(ActionName.MountStand);
				_bodyPlayer.hangBoneName = "guazai001";
				_bodyPlayer.selectEnabled = true;
				_bodyPlayer.play();
				_bodyPlayer.setRotation(0, 0, 0);
				_bodyPlayer.scaleX = _bodyPlayer.scaleY = _bodyPlayer.scaleZ = 1;
				_bodyPlayer.load(meshUrl, boneUrl, model.texture1,_rect3d.renderList);
				_bodyPlayer.rotationY = 50;
				_rect3d.addObject3d(_bodyPlayer,220,210);
			}
		}
		
		private var turnValue:int;
		
		protected function onClickTurnBtn(e:MouseEvent):void
		{
			if(_bodyPlayer)
			{
				if(e.currentTarget == _leftBtn)
				{
					turnValue = 2;
				}
				if(e.currentTarget == _rightBtn)
				{
					turnValue = -2;
				}
				start();
				
			}
		}
		
		protected function stopTurning(e:MouseEvent = null):void
		{
			if(_frameTimer)
			{
				_frameTimer.stop();
			}
		}
		
		protected function onTurning(e:FrameTimer):void
		{
			if(_bodyPlayer)
			{
				_bodyPlayer.rotationY += turnValue;
			}
			
		}
		
		private function start():void
		{
			if(!_frameTimer)
			{
				_frameTimer = new FrameTimer(1, int.MAX_VALUE, true);
				_frameTimer.addListener(TimerType.ENTERFRAME,onTurning);
			}
			_frameTimer.start();
		}
	}
}