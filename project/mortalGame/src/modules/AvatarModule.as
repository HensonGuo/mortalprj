package modules
{
	import Message.Public.ECamp;
	import Message.Public.ECareer;
	
	import com.gengine.global.Global;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import fl.data.DataProvider;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.cache.RoleCache;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapText;
	import mortal.game.view.common.display.NumberManager;
	import mortal.game.view.mainUI.avatar.BaseAvater;
	import mortal.game.view.mainUI.roleAvatar.BuffPanel;
	import mortal.game.view.mainUI.roleAvatar.FightModeCellRenderer;
	import mortal.game.view.mainUI.roleAvatar.RoleAvatar;
	import mortal.mvc.core.View;
	
	public class AvatarModule extends View
	{
		//数据
		private var _cache:RoleCache = Cache.instance.role;
		
		//显示对象
		private var _camp:GBitmap;    //阵营
		
		private var _capTainIcon:GBitmap //队长图标
		
		private var _vipBtn:GLoadedButton;  //vip按钮
		
		private var _avatar:RoleAvatar;
		
		private var _beiBtn:GLoadedButton; //备按钮
		
		private var _GMbtn:GLoadedButton;
		
		private var _fightModeBtn:GLoadedButton;
		
		private var _fightModePanel:GSprite;
		
		private var _fightModeList:GTileList;
		
		
		public function AvatarModule()
		{
			super();
			this.layer = LayerManager.uiLayer;
			this.setSize(270,95);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			UIFactory.gBitmap(ImagesConst.AvatarBg,12,29,this);  //血条背景
			
			UIFactory.gBitmap(ImagesConst.AvatarCombatBg,95,12,this);  //战斗力背景
			
			var textFormat:GTextFormat = GlobalStyle.textFormatHui;
			textFormat.size = 14;
			textFormat.align = TextFormatAlign.CENTER;
			
			textFormat.color = GlobalStyle.yellowUint;
			
			_vipBtn = UIFactory.gLoadedButton(ImagesConst.AvatarVIP_upSkin,202,32,46,18,this);  
			
			_avatar = new RoleAvatar();
			_avatar.isHideDispose = false;
			this.addChild(_avatar);
			
			_camp = UIFactory.gBitmap(null,3,60,this);
			
			_capTainIcon = UIFactory.gBitmap(ImagesConst.SmallCatain,3,2,null);
			
			_beiBtn = UIFactory.gLoadedButton(ImagesConst.Bei_upSkin,10,100,27,28,this);
			
			_GMbtn = UIFactory.gLoadedButton(ImagesConst.GM_upSkin,40,100,27,28,this);
			
			_fightModeBtn = UIFactory.gLoadedButton("FightMode" + (_cache.playerInfo.mode + 1) + "_upSkin",70,100,27,28,this);
			_fightModeBtn.addEventListener(MouseEvent.CLICK,showFightModeList);
			
			_fightModePanel = UICompomentPool.getUICompoment(GSprite);
			_fightModePanel.x = 95;
			_fightModePanel.y = 110;
			_fightModePanel.mouseEnabled = true;
			
			this.pushUIToDisposeVec(UIFactory.bg(0,0,300,104,_fightModePanel,ImagesConst.ToolTipBg));
			this.pushUIToDisposeVec(UIFactory.bg(0,34,300,2,_fightModePanel,ImagesConst.SplitLine));
			this.pushUIToDisposeVec(UIFactory.bg(0,66,300,2,_fightModePanel,ImagesConst.SplitLine));
			
			_fightModeList = UIFactory.tileList(4,4,280,94,_fightModePanel);
			_fightModeList.columnWidth = 280;
			_fightModeList.rowHeight = 30;
			_fightModeList.horizontalGap = 1;
			_fightModeList.verticalGap = 2;
			_fightModeList.setStyle("cellRenderer", FightModeCellRenderer);
			_fightModeList.dataProvider = getDataProvider();
			
			
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
		}
		
		private function getDataProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			
			for(var i:int ; i < 3 ; i ++)
			{
				var obj:Object = {"data":i};
				dataProvider.addItem(obj);
			}
			return dataProvider;
		}
		
		private function showFightModeList(e:MouseEvent):void
		{
			if(!_fightModePanel.parent)
			{
				LayerManager.toolTipLayer.addChild(_fightModePanel);
				_fightModeList.selectedIndex = _cache.playerInfo.mode;
				e.stopImmediatePropagation();
				Global.stage.addEventListener(MouseEvent.CLICK,hideHandler);
				_fightModePanel.configEventListener(MouseEvent.ROLL_OUT,hideHandler);
				_fightModePanel.configEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
				
				if(!_delayTimer)
				{
					_delayTimer = new Timer(3000);
					_delayTimer.addEventListener(TimerEvent.TIMER,delayTimerHandler);
					_delayTimer.start();
				}
				else
				{
					_delayTimer.reset();
					_delayTimer.start();
				}
			}
		}
		
		private function hideHandler(e:MouseEvent = null):void
		{
			LayerManager.toolTipLayer.removeChild(_fightModePanel);
			Global.stage.removeEventListener(MouseEvent.CLICK,hideHandler);
			_fightModePanel.removeEventListener(MouseEvent.ROLL_OUT,hideHandler);
			_fightModePanel.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			
			_delayTimer.stop();
			_delayTimer.removeEventListener(TimerEvent.TIMER,delayTimerHandler);
			_delayTimer = null;
		}
		
		private var _delayTimer:Timer;
		private function mouseOverHandler(e:MouseEvent):void
		{
			_delayTimer.stop();
			_fightModePanel.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
		}
		private function delayTimerHandler(e:TimerEvent):void
		{
			hideHandler();
		}
		
		public function setModeStyle(value:int):void
		{
			_fightModeBtn.styleName = "FightMode" + (value + 1) + "_upSkin"
		}
		
		/**
		 *根据传入的BuffInfo数组更新Buffer。用于更新玩家自身的BUFF。
		 * @param buffInfoArray 包含的是BuffInfo
		 * 
		 */		
		public function updateBufferByBuffInfoArray(buffInfoArray:Array):void
		{
			_avatar.updateBufferByBuffInfoArray(buffInfoArray);
		}
		
		/**
		 *根据传入的tStateId(BUFF的id)更新Buffer。用于更新所查看的实体的BUFF。
		 * @param stateIdArray 包含的是BUFF的id,即stateId
		 * 
		 */		
		public function updateBufferByTSateIdArray(stateIdArray:Array):void
		{
			_avatar.updateEntityBuffer();
		}
		
		public function updateFightMode():void
		{
//			_fightModeBtn.styleName = _cache.playerInfo.mode;
		}
		
		public function updateLevel(value:int):void
		{
			_avatar.updateLevel();
		}
		
		public function updateName(value:String):void
		{
			_avatar.updateName();
		}
		
		public function updateLife():void
		{
			_avatar.updateLife();
		}
		
		public function updateMana(value:Number,maxValue:Number):void
		{
			_avatar.updateMana();
		}
		
		public function updateCarrer(value:int):void
		{
			_avatar.updateCarrer();
		}
		
		public function updateCamp(value:int):void
		{
			var url:String;
			switch(value)
			{
				case ECamp._ECampNo:
					url = "";break;
				case ECamp._ECampA:
					url = ImagesConst.Camp_a;break;
				case ECamp._ECampB:
					url = ImagesConst.Camp_a;break;
				case ECamp._ECampC:
					url = ImagesConst.Camp_a;break;
			}
			
			_camp.bitmapData = GlobalClass.getBitmapData(url);
		}
		
		public function updateAvatar():void
		{
			_avatar.updateAvatar();
		}
		
		public function upDateAllInfo():void
		{
			updateAvatar();
			updateLevel(_cache.roleInfo.level);
			updateName(_cache.playerInfo.name);
			updateCarrer(_cache.roleInfo.career);
			updateCamp(_cache.playerInfo.camp);
			
			updateLife();
			updateMana(_cache.entityInfo.mana,_cache.entityInfo.maxMana);
		}
		
		public function updateEntity():void
		{
			_avatar.updateEntity(_cache.roleEntityInfo);
			
			updateCamp(_cache.playerInfo.camp);
			updateCarrer(_cache.roleInfo.career);
		}
		
		public function captainChange():void
		{
			if(Cache.instance.group.captain && Cache.instance.group.captain.id == Cache.instance.role.entityInfo.entityId.id)
			{
				this.addChild(_capTainIcon);
			}
			else
			{
				if(_capTainIcon.parent)
				{
					this.removeChild(_capTainIcon);
				}
			}
		}
		
		override public function stageResize():void
		{
			this.x = 0;
			this.y = 0;
		}
		
	}
}