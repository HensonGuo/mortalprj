package mortal.game.view.palyer
{
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TPlayerModel;
	import Message.Game.SPlayer;
	import Message.Public.ECamp;
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.events.DragEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.PlayerModelConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.scene3D.player.entity.RoleModelPlayer;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.mvc.core.Dispatcher;
	
	public class EquipmentPart extends GSprite
	{
		//数据
		private var _entityInfo:SEntityInfo = Cache.instance.role.entityInfo;
		private var _splayer:SPlayer = Cache.instance.role.playerInfo; 
		private var _name:String;
		private var _level:String;
		private var _frameTimer:FrameTimer;
		
		//显示对象
		
		private var _title:GTextFiled;  //称号
	
		private var _equipPanel:EquipsPanel;
		
		private var _declaration:GTextInput; //宣言
	
		private var _addBtn:GLoadedButton;
		
		private var _fashionBtn:GLoadedButton;
		
		private var _leftBtn:GLoadedButton;
		
		private var _rightBtn:GLoadedButton;
		
		private var _roleModelPlayer:RoleModelPlayer;
		
		private var _WardrobeBtn:GButton;
		
		private var _showHideBtn:GButton;
		
		private var _vipIcon:GBitmap;
		
		//3D模型
		protected var _rect3d:Rect3DObject;
		
		protected var _window:Window;
		
		public function EquipmentPart(window:Window)
		{
			_window = window;
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.RoleBg3,35,64,this));
			this.pushUIToDisposeVec(UIFactory.bg(25,7,180,-1,this,ImagesConst.Call2Bg));
			
			_window.contentTopOf3DSprite.x = 7;
			_window.contentTopOf3DSprite.y = 60;
			
			_vipIcon = UIFactory.gBitmap(ImagesConst.VIP_1,15,9,this);
			
			var textFormat:GTextFormat = GlobalStyle.textFormatAnjin;
			textFormat.size = 12;
			textFormat.align = AlignMode.CENTER;
			
			_title = UIFactory.gTextField("",26,35,200,30,_window.contentTopOf3DSprite,textFormat,true);
			
			
			_addBtn = UIFactory.gLoadedButton(ImagesConst.sup3_upSkin,200,38,16,16,_window.contentTopOf3DSprite);
			
			_fashionBtn = UIFactory.gLoadedButton(ImagesConst.Fashion2_upSkin,80,370,98,33,_window.contentTopOf3DSprite);
			
			_leftBtn = UIFactory.gLoadedButton(ImagesConst.TurnLeft2_upSkin,177,340,40,36,_window.contentTopOf3DSprite);
			_leftBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			
			_rightBtn = UIFactory.gLoadedButton(ImagesConst.TurnRight2_upSkin,43,340,40,36,_window.contentTopOf3DSprite);
			_rightBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,stopTurning);
			
			_WardrobeBtn = UIFactory.gButton(Language.getString(30145),10,375,42,22,_window.contentTopOf3DSprite,"ButtonNew");
			_showHideBtn = UIFactory.gButton(Language.getString(30146),205,375,42,22,_window.contentTopOf3DSprite,"ButtonNew");
			
			createSkillList();
			
			_equipPanel = UICompomentPool.getUICompoment(EquipsPanel);
			_equipPanel.createDisposedChildren();
			_equipPanel.x = 2;
			_equipPanel.y = 20;
			_window.contentTopOf3DSprite.addChild(_equipPanel);
			this.configEventListener(DragEvent.Event_Move_In,moveInHandler);
			
			add3DRole();
			
//			_declaration = UIFactory.gTextInput(10,100,220,20,this);
//			_declaration.text = "这家伙很懒,什么都没写";
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_title.dispose(isReuse);
			_equipPanel.dispose(isReuse);
			_addBtn.dispose(isReuse);
			_fashionBtn.dispose(isReuse);
			_leftBtn.dispose(isReuse);
			_rightBtn.dispose(isReuse);
			_WardrobeBtn.dispose(isReuse);
			_showHideBtn.dispose(isReuse);
			_vipIcon.dispose(isReuse);
			
			_title = null;
			_equipPanel = null;
			_addBtn = null;
			_fashionBtn = null;
			_leftBtn = null;
			_rightBtn = null;
			_WardrobeBtn = null;
			_showHideBtn = null;
			_vipIcon = null;
			
			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
			}
			if(_roleModelPlayer)
			{
				_roleModelPlayer.dispose(isReuse);
				_roleModelPlayer = null;
			}
			
			stopTurning();
			
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,stopTurning);
			
			super.disposeImpl(isReuse);
		}
		private var _img2d:Img2D;
		protected function add3DRole():void
		{
			//63, 218, 145, 212
			_rect3d = Rect3DManager.instance.registerWindow(new Rectangle(62, 191, 145, 225), _window);
		
			Rect3DManager.instance.windowShowHander(null, _window);

			
			_rect3d.removeImg(_img2d);
			
			var bmpdata:BitmapData = GlobalClass.getBitmapData(ImagesConst.RoleBg3);
			_img2d=new Img2D(null,bmpdata,new Rectangle(8, 35,145,225));
			_img2d.x = -1;
//			_img2d.y = 70;
			_rect3d.addImg(_img2d);
			updateRoleModel();
			
		}
		
		protected function updateRoleModel():void
		{
			if(_rect3d)
			{
				_roleModelPlayer = ObjectPool.getObject(RoleModelPlayer);
				_roleModelPlayer.entityInfo = Cache.instance.role.roleEntityInfo;
				_roleModelPlayer.scaleAll = 1.4;
				_roleModelPlayer.setRenderList(_rect3d.renderList);
				
				_rect3d.addObject3d(_roleModelPlayer,70,223);
			}
		}
		
		private var turnValue:int;
		
		protected function onClickTurnBtn(e:MouseEvent):void
		{
			if(_roleModelPlayer)
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
			if(_roleModelPlayer)
			{
				_roleModelPlayer.rotationY += turnValue;
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
		
		private function moveInHandler(e:DragEvent):void
		{
			var dragItem:BaseItem = e.dragItem as BaseItem;
			var dropItem:BaseItem = e.dropItem as BaseItem;
			
			if(dragItem && dragItem.itemData.serverData.posType != EPlayerItemPosType._EPlayerItemPosTypeRole)
			{
				var vDragType:int = dragItem.itemData.itemInfo.type;
				var vDragCategory:int = dragItem.itemData.itemInfo.category;
				
				var vUid:String = "";
				var vIndex:int = -1;
				if(dropItem)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Equip,dragItem.itemData));
				}
				else
				{
					//如果直接放到人物窗口上面,不作处理，留后面根据类型判断位置
				}
				
//				this.dispatchEvent(new DataEvent(GModuleEvent.Event_Dress,{posType:dragItem.posType, uid:dragItem.itemData.uid, index:vIndex},false, true));
			}
		}
		
		
		
		private function createSkillList():void
		{
			
		}
		
		
		public function upDataAllInfo():void
		{
			upDateTitle();
		}
		
		
		
		public function upDateTitle():void
		{
			_title.htmlText = "<font color='#f8eacd'>" + Language.getString(30143) +"  </font>" + "<font color='#ffffff'>" + "田下第一刽子手" +"</font>";
		}
		
		public function upDateEquipByType(type:int):void
		{
			_equipPanel.upDateEquipByType(type);
		}
		
		public function upDateAllEquip():void
		{
			_equipPanel.upDateAllEquip();
		}
		
	}
}