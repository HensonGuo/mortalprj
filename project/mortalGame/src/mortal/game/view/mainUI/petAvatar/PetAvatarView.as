/**
 * @heartspeak
 * 2014-3-17 
 */   	

package mortal.game.view.mainUI.petAvatar
{
	import Message.Game.SPet;
	import Message.Public.EPetMode;
	import Message.Public.EPetState;
	
	import com.mui.controls.GLoadedButton;
	import com.mui.manager.ToolTipSprite;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.model.vo.pet.PetChangeModeVO;
	import mortal.game.model.vo.pet.PetOutOrInVO;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.mainUI.avatar.PetAvatar;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	public class PetAvatarView extends View
	{
		protected var _petAvatar:PetAvatar;
		
		protected var _outBtn:TimeButton;
		
		protected var _stateBtn:GLoadedButton;
		
		protected var _pet:SPet;
		
		protected var _toolTipSprite:ToolTipSprite;
		
		public function PetAvatarView()
		{
			super();
			layer = LayerManager.uiLayer;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_petAvatar = new PetAvatar();
			this.addChild(_petAvatar);
			
			_outBtn = UIFactory.timeButton("",9,43,17,17,this,Cache.instance.cd.PET_REBACk, "PetHeadCallbackBtn");
			_outBtn.isByClick = false;
			_outBtn.cdTime = 5000;
			_outBtn.type = TimeButton.CD;
			
			
			_toolTipSprite = UICompomentPool.getUICompoment(ToolTipSprite);
			_toolTipSprite.mouseEnabled = true;
			UIFactory.setObjAttri(_toolTipSprite,26,43,-1,100,this);
			_toolTipSprite.toolTipData = "xxxxxxxxxxxxxx";
			
			_stateBtn = UIFactory.gLoadedButton(ImagesConst.PetHeadFollow_upSkin,0,0,17,17,_toolTipSprite);
			
			_outBtn.addEventListener(MouseEvent.CLICK,onClickOutBtn);
			_stateBtn.addEventListener(MouseEvent.CLICK,onClickStateBtn);
		}
		
		/**
		 * 点击出战 
		 * @param e
		 * 
		 */
		protected function onClickOutBtn(e:MouseEvent):void
		{
			var petUid:String = _pet.publicPet.uid;
			var type:int = _outBtn.styleName == "PetHeadOutBtn" || _outBtn.styleName == "PetHeadReliveBtn" 
				? EPetState._EPetStateActive : EPetState._EPetStateIdle;
			var petOutOrInVO:PetOutOrInVO = new PetOutOrInVO(petUid,type);
			Dispatcher.dispatchEvent(new DataEvent(EventName.PetOutOrIn,petOutOrInVO));
		}
		
		/**
		 * 点击状态
		 * @param e
		 * 
		 */
		protected function onClickStateBtn(e:MouseEvent):void
		{
			var petUid:String = _pet.publicPet.uid;
			var type:int = EPetMode._EPetModeActive;
			switch(_stateBtn.styleName)
			{
				case ImagesConst.PetHeadFollow_upSkin:
					type = EPetMode._EPetModeDefense;
					break;
				case ImagesConst.PetHeadDefense_upSkin:
					type = EPetMode._EPetModeActive;
					break;
				case ImagesConst.PetHeadAttack_upSkin:
					type = EPetMode._EPetModeFollow;
					break;
			}
			var petChangeModeVO:PetChangeModeVO = new PetChangeModeVO(petUid,type);
			Dispatcher.dispatchEvent(new DataEvent(EventName.PetChangeMode,petChangeModeVO));
		}
		
		/**
		 * 更新宠物 
		 * @param pet
		 * 
		 */		
		public function updateEntityInfo(entityInfo:EntityInfo):void
		{
			_petAvatar.updateEntity(entityInfo);
		}
		
		/**
		 * 更新死亡
		 * @param pet
		 * 
		 */		
		public function onPetDead():void
		{
			_outBtn.styleName = "PetHeadReliveBtn";
			this.filters = [FilterConst.colorFilter]
		}
		
		/**
		 * 更新petInfo 
		 * @param pet
		 * 
		 */		
		private var _lastState:int = 0;
		private var _lastFightMode:int = 0;
		
		public function updatePet(pet:SPet):void
		{
			if (!_pet || pet.publicPet.state != _lastState)
			{
				switch(pet.publicPet.state)
				{
					case EPetState._EPetStateActive:
						this.filters = null;
						_outBtn.styleName = "PetHeadCallbackBtn";
						if (_pet)
							_outBtn.startCoolDown();
						break;
					case EPetState._EPetStateIdle:
						_outBtn.styleName = "PetHeadOutBtn";
						break;
				}
			}
			if (!_pet || Cache.instance.pet.fightMode != _lastFightMode)
			{
				switch(Cache.instance.pet.fightMode)
				{
					case EPetMode._EPetModeActive:
						_stateBtn.styleName = ImagesConst.PetHeadAttack_upSkin;
						_toolTipSprite.toolTipData = Language.getString(70001);
						break;
					case EPetMode._EPetModeDefense:
						_stateBtn.styleName = ImagesConst.PetHeadDefense_upSkin;
						_toolTipSprite.toolTipData = Language.getString(70002);
						break;
					case EPetMode._EPetModeFollow:
						_stateBtn.styleName = ImagesConst.PetHeadFollow_upSkin;
						_toolTipSprite.toolTipData = Language.getString(70003);
						break;
				}
			}
			_pet = pet;
			_lastState = pet.publicPet.state;
			_lastFightMode = Cache.instance.pet.fightMode;
		}
		
		/**
		 * 重设屏幕位置 
		 * 
		 */
		override public function stageResize():void
		{
			this.x = 220;
			this.y = 94;
		}
	}
}