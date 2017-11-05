/**
 * @heartspeak
 * 2014-2-26
 */

package mortal.game.view.pet.view
{
	import Message.DB.Tables.TExperience;
	import Message.DB.Tables.TModel;
	import Message.DB.Tables.TPetConfig;
	import Message.Game.SPet;
	import Message.Public.EPetState;
	
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.PetConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.model.vo.pet.PetChangeNameVO;
	import mortal.game.model.vo.pet.PetOutOrInVO;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ConfigCenter;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.resource.tableConfig.PetConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.utils.PetUtil;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.panel.SkillItem;
	import mortal.mvc.core.Dispatcher;

	public class PetMainPanel extends PetPanelBase
	{
		private var _panelBg:GBitmap;
		private var _itemsBg:GBitmap;
		private var _frameTimer:FrameTimer;

		//中间部分
		private var _levelText:GTextFiled;
		private var _petName:GTextFiled;
		private var _petNameTextInput:GTextInput;
		private var _changeNameBtn:GLoadedButton;
		private var _huaBtn:GLoadedButton;
		private var _jianBtn:GLoadedButton;
		private var _rotationLeftBtn:GLoadedButton;
		private var _rotationRightBtn:GLoadedButton;
		private var _outBtn:GButton;
		private var _releaseBtn:GButton;
		private var _growTxt:GTextFiled;
		private var _bloodText:GTextFiled;
		private var _petSkillItemList:Array;

		//右边部分
		private var _petIntroText:GBitmap;
		private var _talentText:GTextFiled;
		private var _typeText:GTextFiled;
		private var _lifeBar:BaseProgressBar;
		private var _lifespanBar:BaseProgressBar;
		private var _expBar:BaseProgressBar;
		private var _btnUpdateTalent:GLoadedButton;
		private var _btnChange:GLoadedButton;
		private var _btnAddLife:GLoadedButton;
		private var _btnAddLifespan:GLoadedButton;
		private var _levelTextRight:GTextFiled;

		//右下
		private var _petTotalAttriText:GBitmap;
		private var _vcAttributeName:Vector.<String> = new Vector.<String>();
		private var _vcAttributeNameText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeAddValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _upgradeArrowArr:Vector.<GBitmap> = new Vector.<GBitmap>();

		//3D模型
		protected var _rect3d:Rect3DObject;
		protected var _bodyPlayer:ActionPlayer;
		
		private var _talentSkill:SkillItem;//天赋技能
		private var _skillCellList:Vector.<SkillItem> = new Vector.<SkillItem>();
		
		public function PetMainPanel(window:Window)
		{
			super(window);
		}

		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();

			var i:int;

			//中间部分
			_panelBg = UIFactory.bitmap("", 185, 68, this);
			_itemsBg = UIFactory.bitmap("", 185, 366, this);
			ResourceConst.getScaleBitmap(ImagesConst.PetNameBg, 234, 69, 264, 26, _window.contentTopOf3DSprite);
			_levelText = UIFactory.gTextField("LV.1", 288, 72, 40, 20, _window.contentTopOf3DSprite, GlobalStyle.textFormatAnjin);
			_petName = UIFactory.gTextField(Language.getString(70004), 340, 72, 90, 20, _window.contentTopOf3DSprite, GlobalStyle.textFormatAnjin);
			_petNameTextInput = UIFactory.gTextInput(333, 70, 100, 24, _window.contentTopOf3DSprite);
			_petNameTextInput.visible = false;
			_changeNameBtn = UIFactory.gLoadedButton("", 440, 70, 24, 25, _window.contentTopOf3DSprite);
			_changeNameBtn.toolTipData = Language.getString(70005);
			_huaBtn = UIFactory.gLoadedButton("", 192, 78, 21, 21, _window.contentTopOf3DSprite);
			_huaBtn.configEventListener(MouseEvent.CLICK, onClickBua);
			_jianBtn = UIFactory.gLoadedButton("", 192, 100, 21, 21, _window.contentTopOf3DSprite);
			_rotationLeftBtn = UIFactory.gLoadedButton(ImagesConst.TurnLeft_upSkin,416,269,40,36,_window.contentTopOf3DSprite);
			_rotationRightBtn = UIFactory.gLoadedButton(ImagesConst.TurnRight_upSkin,272,269,40,36,_window.contentTopOf3DSprite);
			_outBtn = UIFactory.gButton(Language.getString(70006), 300, 320, 52, 22, _window.contentTopOf3DSprite);
			_releaseBtn = UIFactory.gButton(Language.getString(70007), 370, 320, 52, 22, _window.contentTopOf3DSprite);
			_bloodText = UIFactory.gTextField(Language.getString(70008), 195, 313, 65, 20, _window.contentTopOf3DSprite, GlobalStyle.textFormatPutong.center());
			_growTxt = UIFactory.gTextField("1", 465, 313, 65, 20, _window.contentTopOf3DSprite, GlobalStyle.textFormatPutong.center());
			
			_talentSkill = UIFactory.getUICompoment(SkillItem,256.5,404,this);
			_talentSkill.setSize(42, 42);
			_talentSkill.setBg(ImagesConst.PackItemBg);
			for (i = 0; i < 8; i++)
			{
				var skillItem:SkillItem = UIFactory.getUICompoment(SkillItem, 340 + 47 * (i % 4), 381 + int(i / 4) * 47, this);
				skillItem.setSize(42, 42);
				skillItem.setBg(ImagesConst.PackItemBg);
				_skillCellList.push(skillItem);
			}

			//右边部分
			UIFactory.bg(546, 66, 207, 419, this);
			UIFactory.bg(548, 68, 203, 26, this, ImagesConst.RegionTitleBg);
			_petIntroText = UIFactory.bitmap("", 556, 74, this);
			UIFactory.gTextField(Language.getString(70009), 554, 100, 50, 20, this);
			UIFactory.gTextField(Language.getString(70010), 554, 123, 50, 20, this);
			UIFactory.gTextField(Language.getString(70011), 554, 146, 50, 20, this);
			UIFactory.gTextField(Language.getString(70012), 554, 169, 50, 20, this);
			UIFactory.gTextField(Language.getString(70013), 554, 192, 50, 20, this);

			_talentText = UIFactory.gTextField("0/1000", 598, 100, 100, 20, this);
			_typeText = UIFactory.gTextField(Language.getString(70014), 598, 123, 100, 20, this);
			_lifeBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_lifeBar.setBg(ImagesConst.PetLifeBg, true, 100, 12);
			_lifeBar.setProgress(ImagesConst.PetLife, false, 1, 1, 98, 10);
			_lifeBar.setLabel(BaseProgressBar.ProgressBarTextNumber, 20, -2, 60, 12);
			_lifeBar.setValue(100, 100);
			UIFactory.setObjAttri(_lifeBar, 598, 149, -1, -1, this);

			_lifespanBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_lifespanBar.setBg(ImagesConst.PetLifeBg, true, 100, 12);
			_lifespanBar.setProgress(ImagesConst.PetLifespan, false, 1, 1, 98, 10);
			_lifespanBar.setLabel(BaseProgressBar.ProgressBarTextNumber, 20, -2, 60, 12);
			_lifespanBar.setValue(100, 100);
			UIFactory.setObjAttri(_lifespanBar, 598, 171, -1, -1, this);

			_expBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_expBar.setBg(ImagesConst.PetLifeBg, true, 100, 12);
			_expBar.setProgress(ImagesConst.PetExp, false, 1, 1, 98, 10);
			_expBar.setLabel(BaseProgressBar.ProgressBarTextNumber, 20, -2, 60, 12);
			_expBar.setValue(100, 100);
			UIFactory.setObjAttri(_expBar, 598, 194, -1, -1, this);

			_btnUpdateTalent = UIFactory.gLoadedButton(ImagesConst.GroupBtn_upSkin,703, 98, 37, 21, this);
			_btnUpdateTalent.label = Language.getString(70015);
			_btnChange = UIFactory.gLoadedButton(ImagesConst.GroupBtn_upSkin, 703, 121, 37, 21, this);
			_btnChange.label = Language.getString(70016);
			_btnAddLife = UIFactory.gLoadedButton(ImagesConst.GroupBtn_upSkin, 703, 144, 37, 21, this);
			_btnAddLife.label = Language.getString(70017);
			_btnAddLifespan = UIFactory.gLoadedButton(ImagesConst.GroupBtn_upSkin, 703, 167, 37, 21, this);
			_btnAddLifespan.label = Language.getString(70018);
			_levelTextRight = UIFactory.gTextField("1级", 703, 192, 40, 20, this, GlobalStyle.textFormatItemOrange.center());

			//右下部分
			UIFactory.bg(548, 217, 203, 26, this, ImagesConst.RegionTitleBg);
			_petTotalAttriText = UIFactory.bitmap("", 556, 223, this);
			_vcAttributeName.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_upgradeArrowArr.length = 0;
			_vcAttributeName.push("attack", "physDefense", "magicDefense", "penetration", "jouk", "hit", "crit", "toughness", "block", "expertise", "damageReduce");
			var tempTextField:GTextFiled;
			for (i = 0; i < _vcAttributeName.length; i++)
			{
				//属性名
				tempTextField = UIFactory.gTextField(GameDefConfig.instance.getAttributeName(_vcAttributeName[i]), 555, 248 + 21 * i, 55, 20, this, GlobalStyle.textFormatAnjin);
				_vcAttributeNameText.push(tempTextField);

				//属性数值
				tempTextField = UIFactory.gTextField("0", 620, 248 + 21 * i, 60, 20, this, GlobalStyle.textFormatPutong);
				_vcAttributeValueText.push(tempTextField);
				
				//属性提升标志图片
				var upgradeArrow:GBitmap = UIFactory.gBitmap("", 680, 252 + 21 * i, this);
				_upgradeArrowArr.push(upgradeArrow);

				//属性加成值
				tempTextField = UIFactory.gTextField("(+0)", 695, 248 + 21 * i, 60, 20, this, GlobalStyle.textFormatItemGreen);
				_vcAttributeAddValueText.push(tempTextField);
			}

			LoaderHelp.addResCallBack(ResFileConst.petMainPanel, onResCompl);

			_outBtn.configEventListener(MouseEvent.CLICK, onClickOutBtn);
			_releaseBtn.configEventListener(MouseEvent.CLICK, onClickOutBtn);
			_changeNameBtn.configEventListener(MouseEvent.CLICK, onClickChangeName);
			_petNameTextInput.configEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			_rotationLeftBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			_rotationRightBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,stopTurning);
		}
		
		private var turnValue:int;

		protected function onClickTurnBtn(e:MouseEvent):void
		{
			if(_bodyPlayer)
			{
				if(e.currentTarget == _rotationLeftBtn)
				{
					turnValue = 2;
				}
				if(e.currentTarget == _rotationRightBtn)
				{
					turnValue = -2;
				}
				start();
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
		
		protected function onTurning(e:FrameTimer):void
		{
			if(_bodyPlayer)
			{
				_bodyPlayer.rotationY += turnValue;
			}
			
		}
		
		protected function stopTurning(e:MouseEvent = null):void
		{
			if(_frameTimer)
			{
				_frameTimer.stop();
			}
		}
		
		/**
		 * 资源加载完成
		 *
		 */
		protected function onResCompl():void
		{
			_panelBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetPanelBg);
			_itemsBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetItemsBg);

			_changeNameBtn.styleName = ImagesConst.PetBtnChangeName_upSkin;
			_huaBtn.styleName = ImagesConst.PetBtnHua_upSkin;
			_jianBtn.styleName = ImagesConst.PetBtnJian_upSkin;

			_petIntroText.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetIntroText);
			_petTotalAttriText.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetTotalAttriText);
			add3DPet();
			
			for (var i:int = 0; i < _upgradeArrowArr.length; i++)
			{
				_upgradeArrowArr[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.upgradeArrow);
			}
		}
		private var _img2d:Img2D;
		
		protected function add3DPet():void
		{
			
			_rect3d = Rect3DManager.instance.registerWindow(new Rectangle(187, 70, 356, 240), _window);
			
			Rect3DManager.instance.windowShowHander(null, _window);
			if (_panelBg.bitmapData)
			{
				
				_rect3d.removeImg(_img2d);
				_img2d=new Img2D(null,_panelBg.bitmapData,new Rectangle(0, 0,356,240));
				_rect3d.addImg(_img2d);
			}

			updatePetModel();
		}

		protected function updatePetModel():void
		{
			if(_rect3d && _pet)
			{
				var tpet:TPetConfig = PetConfig.instance.getInfoByCode(_pet.publicPet.code);
				var model:TModel = ModelConfig.instance.getInfoByCode(tpet.model);
				var meshUrl:String=model.mesh1 + ".md5mesh";
				var boneUrl:String=model.bone1 + ".skeleton";
				var textureUrl:String=model.texture1;
				
				if(_bodyPlayer && _bodyPlayer.meshUrl==meshUrl && _bodyPlayer.animUrl==boneUrl)
				{
					return;
				}
				_bodyPlayer = ObjectPool.getObject(ActionPlayer);
				_bodyPlayer.changeAction(ActionName.Stand);
				_bodyPlayer.hangBoneName = "guazai001";
				_bodyPlayer.selectEnabled = true;
				_bodyPlayer.play();
				_bodyPlayer.setRotation(0, 0, 0);
				_bodyPlayer.load(meshUrl, boneUrl, textureUrl,_rect3d.renderList);
				_rect3d.addObject3d(_bodyPlayer,180,220);
			}
		}

		override public function updateMsg(pet:SPet):void
		{
			var isSamePet:Boolean = pet == _pet;
			super.updateMsg(pet);
			if (pet)
			{
				if (!isSamePet)
				{
					_petName.visible = true;
					_petNameTextInput.visible = false;
				}

				_levelText.text = "LV." + pet.publicPet.level;
				_petName.htmlText = PetUtil.getNameHtmlText(pet);

				_growTxt.text = pet.publicPet.growth.toString();
				if (pet.publicPet.life == 0)
				{
					_outBtn.label = Language.getString(70019);
					_btnAddLife.label = Language.getString(70019);
				}
				else
				{
					_outBtn.label = pet.publicPet.state == EPetState._EPetStateIdle ? Language.getString(70006) : Language.getString(70020);
					_btnAddLife.label = Language.getString(70017);
				}
				

				//右边
				_talentText.text = pet.publicPet.talent + "/" + 1000;
				_typeText.text = Language.getString(70014);
				
				var baseLife:int = pet.baseFight["maxLife"];
				var fightLife:int = pet.extraFight["maxLife"];
				var currentPer:Number = 1 + int(pet.addPercent["maxLifeAdd"]) * 1.0/10000;
				var maxLife:int = (baseLife + fightLife) * currentPer;
				_lifeBar.setValue(pet.publicPet.life, maxLife);
				
				_lifespanBar.setValue(pet.publicPet.lifeSpan, pet.publicPet.maxLifeSpan);
				var tExperience:TExperience = ConfigCenter.getConfigs(ConfigConst.expLevel, "level", pet.publicPet.level, true) as TExperience;
				_expBar.setValue(pet.publicPet.experience, tExperience.petUpgradeNeedExperience);
				_levelTextRight.text = "LV." + pet.publicPet.level;

				//右下
				for (var i:int = 0; i < _vcAttributeName.length; i++)
				{
					_vcAttributeValueText[i].text = String((int(pet.baseFight[_vcAttributeName[i]]) + int(pet.extraFight[_vcAttributeName[i]])) * (1 + int(pet.addPercent[_vcAttributeName[i] + "Add"]) / 10000));
					if (pet.extraFight[_vcAttributeName[i]] > 0)
					{
						_upgradeArrowArr[i].visible = true;
						_vcAttributeAddValueText[i].visible = true;
						_vcAttributeAddValueText[i].text = pet.extraFight[_vcAttributeName[i]].toString();
					}
					else
					{
						_upgradeArrowArr[i].visible = false;
						_vcAttributeAddValueText[i].visible = false;
					}
				}
				
				//刷新天赋技能     天赋技能位置为0
				var talentSkillList:Vector.<SkillInfo> = Cache.instance.pet.getTalentSkillList(pet.publicPet.uid);
				var skillInfo:SkillInfo = talentSkillList.length > 0 ? talentSkillList[0] : null;
				_talentSkill.setSkillInfo(skillInfo);
				//刷新技能格子
				var openNum:int = Cache.instance.pet.getPassiveSkillOpenPosNum(_pet.publicPet.uid);
				for (i = 0; i < 8; i++)
				{
					var cell:SkillItem = _skillCellList[i];
					var index:int = i + 1;
					if (index > openNum)
					{
						cell.source = GlobalClass.getBitmap(ImagesConst.Locked);
					}
					else
					{
						skillInfo = Cache.instance.pet.getPetSkill(pet.publicPet.uid, i + PetConst.PASSIVE_SKILL_START_POS);
						cell.setSkillInfo(skillInfo);
					}
				}
				add3DPet();
			}
			else
				clearMsg();
			
		}
		
		private function clearMsg():void
		{
			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
			}
			for(var i:int = 0;i < _vcAttributeName.length;i++)
			{
				_vcAttributeValueText[i].text = "0";
				_vcAttributeAddValueText[i].text = "";
				_upgradeArrowArr[i].visible = false;
			}
			
			_talentSkill.setSkillInfo(null);
			//刷新技能格子
			for (i = 1; i <= 8; i++)
			{
				var cell:SkillItem = _skillCellList[i - 1];
				cell.setSkillInfo(null);
			}
			_bodyPlayer = null;
			_levelText.text = "lv.1";
			_petName.text = Language.getString(70004);
			_talentText.text = "0/1000";
			_typeText.text = Language.getString(70014);
			_lifeBar.setValue(100, 100);
			_lifespanBar.setValue(100, 100);
			_expBar.setValue(100, 100);
			_levelTextRight.text = "1级";
			_growTxt.text = "1";
		}

		/**
		 * 更新宠物属性
		 * @param uid
		 *
		 */
		override public function updatePetAttribute(uid:String):void
		{
			if (_pet && _pet.publicPet.uid == uid)
			{
				updateMsg(_pet);
			}
		}

		protected function onClickOutBtn(e:MouseEvent):void
		{
			if (_pet)
			{
				var type:int;
				if (e.currentTarget == _releaseBtn)
				{
					type = EPetState._EPetStateRelease;
				}
				else
				{
					type = _outBtn.label == Language.getString(70006) || _outBtn.label == Language.getString(70019) ? EPetState._EPetStateActive : EPetState._EPetStateIdle;
				}
				//如果是放生，弹确认面板
				if(type == EPetState._EPetStateRelease)
				{
					if(PetUtil.isGoodPet(_pet))
					{
						PetDeleteAlertWin.instance.showPet(_pet);
					}
					else
					{
						Alert.show(Language.getString(70021),null,Alert.OK|Alert.CANCEL,null,onSelect);
					}
				}
				else
				{
					var petOutOrInVO:PetOutOrInVO = new PetOutOrInVO(_pet.publicPet.uid, type);
					Dispatcher.dispatchEvent(new DataEvent(EventName.PetOutOrIn, petOutOrInVO));
				}
			}
			else
			{
				MsgManager.showRollTipsMsg(Language.getString(70022));
			}
		}
		
		/**
		 * 放生宠物 
		 * @param type
		 * 
		 */		
		protected function onSelect(type:int):void
		{
			if(type == Alert.OK)
			{
				var petOutOrInVO:PetOutOrInVO = new PetOutOrInVO(_pet.publicPet.uid, EPetState._EPetStateRelease);
				Dispatcher.dispatchEvent(new DataEvent(EventName.PetOutOrIn, petOutOrInVO));
			}
		}

		/**
		 * 修改名字
		 * @param e
		 *
		 */
		protected function onClickChangeName(e:MouseEvent):void
		{
			_petNameTextInput.visible = true;
			_petNameTextInput.setFocus();
			_petNameTextInput.text = _petName.text;
			_petNameTextInput.setSelection(0, _petNameTextInput.length);
			_petName.visible = false;
		}

		/**
		 * 光标移除
		 * @param e
		 *
		 */
		protected function onFocusOut(e:FocusEvent):void
		{
			_petName.visible = true;
			_petNameTextInput.visible = false;
			if (_pet && _pet.publicPet.name != _petNameTextInput.text)
			{
				var changeNameVO:PetChangeNameVO = new PetChangeNameVO(_pet.publicPet.uid, _petNameTextInput.text);
				Dispatcher.dispatchEvent(new DataEvent(EventName.PetChangeName, changeNameVO));
			}
		}

		/**
		 * 点击化按钮
		 * @param e
		 *
		 */
		private function onClickBua(e:MouseEvent):void
		{

		}

		override protected function disposeImpl(isReuse:Boolean = true):void
		{
			super.disposeImpl(isReuse);

			_vcAttributeName.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_upgradeArrowArr.length = 0;
			_skillCellList.length = 0;

			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
			}
		}
	}
}
