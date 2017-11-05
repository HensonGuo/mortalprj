/**
 * @heartspeak
 * 2014-2-13 
 */   	

package mortal.game.view.mainUI.roleAvatar
{
	import Message.Public.ECareer;
	
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapText;
	import mortal.game.view.common.display.NumberManager;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.game.view.mainUI.avatar.PlayerAvatar;
	
	public class RoleAvatar extends PlayerAvatar
	{
		private var _comBat:BitmapText;   //战斗力
		
		public function RoleAvatar()
		{
			super();
			addComBat();
		}
		
		protected function addComBat():void
		{
			_comBat = UICompomentPool.getUICompoment(BitmapText);
			_comBat.createDisposedChildren();
			_comBat.x = 168;
			_comBat.y = 7;
			_comBat.setFightNum(NumberManager.COLOR3,"99999",5);
			addChild(_comBat);
		}
		
		/**
		 * 添加背景 
		 * 
		 */		
		override protected function addBg():void
		{
			//血条背景
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.AvatarBg,12,29,this)); 
		}
		
		/**
		 * 添加头像 
		 * 
		 */		
		override protected function addAvatar():void
		{
			_avatar = UIFactory.gBitmap(null,17,7,_bgSprite);
		}
		
		/**
		 * 添加职业 
		 * 
		 */		
		override protected function addCarrer():void
		{
			_carrer = UIFactory.gBitmap(null,0,26,this);
		}
		
		/**
		 * 添加buff 
		 * 
		 */		
		override protected function addBuff():void
		{
			_buffPanel = UICompomentPool.getUICompoment(BuffPanel);
			_buffPanel.createDisposedChildren();
			_buffPanel.x = 145;
			_buffPanel.y = 81;
			this.addChild(_buffPanel);
		}
		
		/**
		 * 添加生命条
		 * 
		 */		
		override protected function addLifeBar():void
		{
			_shengmingBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_shengmingBar.createDisposedChildren();
			_shengmingBar.setProgress(ImagesConst.AvatarXueBar,false,2,1,156,11);
			_shengmingBar.setLabel(BaseProgressBar.ProgressBarTextNone);
			_shengmingBar.x = 100;
			_shengmingBar.y = 53;
			this.addChild(_shengmingBar);
		}
		
		/**
		 * 添加魔法 
		 * 
		 */		
		override protected function addMana():void
		{
			_mofaBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_mofaBar.createDisposedChildren();
			_mofaBar.setProgress(ImagesConst.AvatarLanBar,false,2,1,156,11);
			_mofaBar.x = 100;
			_mofaBar.y = 65;
			this.addChild(_mofaBar);
		}
		
		/**
		 * 添加名字
		 * 
		 */		
		override protected function addName():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.size = 12;
			textFormat.align = TextFormatAlign.LEFT;
			_name = UIFactory.gTextField("",110,30,100,50,this,textFormat,false);
		}
		
		/**
		 * 添加等级 
		 * 
		 */		
		override protected function addLevel():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatHui;
			textFormat.size = 12;
			textFormat.color = GlobalStyle.yellowUint;
			textFormat.align = TextFormatAlign.CENTER;
			_level = UIFactory.gTextField("",85,78,50,50,this,textFormat,false);
		}
		
		/**
		 * 更新等级 
		 * @param e
		 * 
		 */		
		override public function updateLevel(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_level.text = "Lv." + _entityInfo.entityInfo.level;
		}
		
		/**
		 * 更新职业 
		 * @param value
		 * 
		 */		
		override public function updateCarrer():void
		{
			if(!_entityInfo)
			{
				return;
			}
			var value:int = _entityInfo.entityInfo.career;
			_carrer.bitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getECarrerPic(value));
		}
		
		/**
		 * 更新头像 
		 * 
		 */		
		override public function updateAvatar():void
		{
			if(!_entityInfo)
			{
				return;
			}
			_avatar.bitmapData = GlobalClass.getBitmapData(AvatarUtil.getPlayerAvatar(_entityInfo.entityInfo.career,_entityInfo.entityInfo.sex,AvatarUtil.Big));
		}
		
		public function updateComBat(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_comBat.setFightNum(NumberManager.COLOR3,_entityInfo.entityInfo.combat.toString(),5);
		}
		
		/**
		 * 更新显示 
		 * @param entityInfo
		 * 
		 */
		override public function updateEntity(entityInfo:EntityInfo):void
		{
			super.updateEntity(entityInfo);
			PlayerMenuRegister.UnRegister(_bgSprite);
			PlayerMenuRegister.Register(_bgSprite,entityInfo,PlayerMenuConst.GroupSelfOpMenu);
		}
		
		override protected function addEntityEvent():void
		{
			super.addEntityEvent();
			
			if(_entityInfo)
			{
				_entityInfo.addEventListener(EntityInfoEventName.UpdateComBat,updateComBat);
			}
		}
		
		override protected function removeEntityEvent():void
		{
			super.removeEntityEvent();
			
			if(_entityInfo)
			{
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateComBat,updateComBat);
			}
		}
	}
}