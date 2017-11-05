package mortal.game.view.mainUI.avatar
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.manager.ToolTipSprite;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	
	public class BaseAvater extends GSprite
	{
		//entityInfo
		protected var _entityInfo:EntityInfo;
		
		//背景
		protected var _avatarBg:GBitmap;
		
		//等级
		protected var _level:GTextFiled;    //等级
		
		//名称
		protected var _name:GTextFiled;   //玩家名字
		
		//生命
		protected var _shengmingBar:BaseProgressBar;   //生命条
		
		//头像
		protected var _avatar:GBitmap;  //人物头像
		
		protected var _bgSprite:ToolTipSprite;
		
		public function BaseAvater()
		{
			super();
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		/**
		 * 移除舞台 
		 * @param e
		 * 
		 */		
		protected function onRemoveFromStage(e:Event):void
		{
			removeEntityEvent();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bgSprite = UICompomentPool.getUICompoment(ToolTipSprite);
			_bgSprite.createDisposedChildren();
			_bgSprite.width = 100;
			_bgSprite.height = 50;
			this.addChild(_bgSprite);
			_bgSprite.buttonMode = true;
			_bgSprite.mouseEnabled = true;
			
			addAvatar();
			addBg();
			addLifeBar();
			addName();
			addLevel();
		}
		
		/**
		 * 添加背景 
		 * 
		 */		
		protected function addBg():void
		{
			//血条背景
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.AvatarMonsterBg,0,0,this)); 
			addChild(_avatar);
		}
		
		/**
		 * 添加头像 
		 * 
		 */		
		protected function addAvatar():void
		{
			_avatar = UIFactory.gBitmap(null,2,7,this);
		}
		
		/**
		 * 添加生命条
		 * 
		 */		
		protected function addLifeBar():void
		{
			_shengmingBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_shengmingBar.createDisposedChildren();
			_shengmingBar.setProgress(ImagesConst.AvatarMonsterLife,false,2,0,151,13);
			_shengmingBar.x = 52;
			_shengmingBar.y = 24;
			this.addChild(_shengmingBar);
		}
		
		/**
		 * 添加名字
		 * 
		 */		
		protected function addName():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatBai;
			textFormat.size = 12;
			_name = UIFactory.gTextField("",75,1,100,20,this,textFormat,false);
		}
		
		/**
		 * 添加等级 
		 * 
		 */
		protected function addLevel():void
		{
			var textFormat:GTextFormat = GlobalStyle.textFormatHui;
			textFormat.size = 12;
			textFormat.color = GlobalStyle.yellowUint;
			textFormat.align = TextFormatAlign.CENTER;
			_level = UIFactory.gTextField("",27,34,50,50,this,textFormat,false);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_level.dispose(isReuse);
			_name.dispose(isReuse);
			_avatar.dispose(isReuse);
			_shengmingBar.dispose(isReuse);
			
			_level = null;
			_name = null;
			_avatar = null;
			_shengmingBar = null;
		}
		
		public function updateLevel(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_level.text = _entityInfo.entityInfo.level.toString();
		}
		
		public function updateName():void
		{
			if(!_entityInfo)
			{
				return;
			}
			_name.text = _entityInfo.entityInfo.name;
		}
		
		/**
		 * 更新生命 
		 * @param 传数值则更新剩余生命,传SFightAttribute则更新最大生命
		 * 
		 */		
		public function updateLife(e:Event = null):void
		{
			if(!_entityInfo)
			{
				return;
			}
			_shengmingBar.setValue(_entityInfo.entityInfo.life,_entityInfo.entityInfo.maxLife);
		}
		
		/**
		 * 更新头像 
		 * 
		 */		
		public function updateAvatar():void
		{
			_avatar.bitmapData = GlobalClass.getBitmapData(ImagesConst.AvatarMonsterHead);
		}
		
		/**
		 * 更新显示 
		 * @param entityInfo
		 * 
		 */		
		public function updateEntity(entityInfo:EntityInfo):void
		{
			removeEntityEvent();
			_entityInfo = entityInfo;
			updateAvatar();
			updateLevel();
			updateName();
			updateLife();
			addEntityEvent();
		}
		
		/**
		 * 停止更新实体状态 
		 * 
		 */		
		public function stopUpdateEntity():void
		{
			removeEntityEvent();
		}
		
		/**
		 * 添加Entity的事件监听 
		 * 
		 */		
		protected function addEntityEvent():void
		{
			if(_entityInfo)
			{
				_entityInfo.addEventListener(EntityInfoEventName.UpdateLife,updateLife);
				_entityInfo.addEventListener(EntityInfoEventName.UpdateLevel,updateLevel);
			}
		}
		
		/**
		 * 移除Entity的事件监听 
		 * 
		 */		
		protected function removeEntityEvent():void
		{
			if(_entityInfo)
			{
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateLife,updateLife);
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateLevel,updateLevel);
			}
		}
		
		
		public function get entityInfo():EntityInfo
		{
			return _entityInfo;
		}
	}
}