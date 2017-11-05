/**
 * @heartspeak
 * 2014-3-3 
 */   	

package mortal.game.view.pet.view
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.manager.ToolTipSprite;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import Message.DB.Tables.TModel;
	import Message.DB.Tables.TPetConfig;
	import Message.DB.Tables.TPetGrowth;
	import Message.Game.SPet;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.model.vo.pet.PetUpdateGrowthVO;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.resource.tableConfig.PetConfig;
	import mortal.game.resource.tableConfig.PetGrowthConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.utils.PetUtil;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;

	public class PetGrowingPanel extends PetPanelBase
	{
		protected var _bg:GBitmap;
		protected var _bg2:GBitmap;
		private var _frameTimer:FrameTimer;
		
		//左边
		protected var _levelText:GTextFiled;
		protected var _nameText:GTextFiled;
		protected var _toolTipSprite:ToolTipSprite;
		protected var _toolTipBmp:GBitmap;
		protected var _protectedLevelText:GTextFiled;
		protected var _successRateImage:GBitmap;
		protected var _successRateText:GTextFiled;
		protected var _rotationLeftBtn:GLoadedButton;
		protected var _rotationRightBtn:GLoadedButton;
		protected var _growthText:GTextFiled;
		protected var _btnUpgrade:GLoadingButton;
		protected var _upgradePropText:GTextFiled;
		protected var _needTongqianText:GTextFiled;
		protected var _autoBuy:GCheckBox;
		
		//右边属性
		protected var _currentLevelImage:GBitmap;
		protected var _currentLevelText:GTextFiled;
		protected var _nextLevelText:GTextFiled;
		protected var _vcAttributeName:Vector.<String> = new Vector.<String>();
		protected var _vcAttributeNameText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		protected var _vcAttributeValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		protected var _vcAttributeAddValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _upgradeArrowArr:Vector.<GBitmap> = new Vector.<GBitmap>();
		
		//上面加成显示
		protected var _growAddCell1:PetGrowAddCell;
		protected var _growAddCell2:PetGrowAddCell;
		protected var _growAddCell3:PetGrowAddCell;
		protected var _growAddCell4:PetGrowAddCell;
		protected var _progressBar:BaseProgressBar;
		protected var _growthBg:GBitmap;
		protected var _growthText2:GTextFiled;
		
		//3D
		protected var _rect3d:Rect3DObject;
		protected var _bodyPlayer:ActionPlayer;
		
		protected var _isResCompl:Boolean = false;
		
		public function PetGrowingPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			var i:int;
			_bg = UIFactory.gBitmap("",185,68,this);
			_bg2 = UIFactory.gBitmap("",185,150,this);
			ResourceConst.getScaleBitmap(ImagesConst.PetNameBg,234,156,264,26,_window.contentTopOf3DSprite);
			_levelText = UIFactory.gTextField("LV.1",288,160,50,20,_window.contentTopOf3DSprite);
			_nameText = UIFactory.gTextField("宠物名字",338,160,100,20,_window.contentTopOf3DSprite);
			
			_toolTipSprite = UICompomentPool.getUICompoment(ToolTipSprite);
			_toolTipSprite.mouseEnabled = true;
			_toolTipSprite.toolTipData = "成长等级保护";
			UIFactory.setObjAttri(_toolTipSprite,210,177,-1,-1,_window.contentTopOf3DSprite);
			_toolTipBmp = UIFactory.gBitmap("",0,0,_toolTipSprite);
			_protectedLevelText = UIFactory.gTextField("0",22,18,40,20,_toolTipSprite);
			
			_successRateImage = UIFactory.gBitmap("",189,212,_window.contentTopOf3DSprite);
			_successRateText = UIFactory.gTextField("100%",245,212,60,24,_window.contentTopOf3DSprite,GlobalStyle.textFormatLv.setSize(16).setBold(true));
			_growthText = UIFactory.gTextField("1",377,368,60,24,_window.contentTopOf3DSprite,GlobalStyle.textFormatLv.setSize(16).setBold(true));
			_rotationLeftBtn = UIFactory.gLoadedButton(ImagesConst.TurnLeft_upSkin,430,350,40,36,_window.contentTopOf3DSprite);
			_rotationRightBtn = UIFactory.gLoadedButton(ImagesConst.TurnRight_upSkin,270,350,40,36,_window.contentTopOf3DSprite);
			_btnUpgrade = UIFactory.gLoadingButton("",320,399,93,30,_window.contentTopOf3DSprite);
			_btnUpgrade.configEventListener(MouseEvent.CLICK,onClickUpgrade);
			_upgradePropText = UIFactory.gTextField("消耗宠物成长丹*1[剩余0个]",280,435,210,20,_window.contentTopOf3DSprite);
			UIFactory.gTextField("本次提升费用:",218,463,90,20,_window.contentTopOf3DSprite);
			_needTongqianText = UIFactory.gTextField("1000",302,463,40,20,_window.contentTopOf3DSprite,GlobalStyle.textFormatAnjin);
			UIFactory.gBitmap(ImagesConst.Jinbi,334,466,_window.contentTopOf3DSprite);
			_autoBuy = UIFactory.checkBox("道具不足自动购买",383,457,150,28,_window.contentTopOf3DSprite);
			_autoBuy.selected = true;
			
			//右边
			_currentLevelImage = UIFactory.gBitmap("",557,170,this);
			_currentLevelText = UIFactory.gTextField("1",620,165,100,20,this,GlobalStyle.textFormatBai.setSize(13));
			_nextLevelText = UIFactory.gTextField("下一级[2]",667,165,75,20,this,GlobalStyle.textFormatLv);
			_vcAttributeName.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_upgradeArrowArr.length = 0;
			_vcAttributeName.push("attack","physDefense","magicDefense","penetration","jouk","hit","crit","toughness","block","expertise","damageReduce");
			var tempTextField:GTextFiled;
			for(i = 0;i < _vcAttributeName.length;i++)
			{
				//属性名
				tempTextField = UIFactory.gTextField(GameDefConfig.instance.getAttributeName(_vcAttributeName[i]),558,200 + 24 * i,55,20,this,GlobalStyle.textFormatAnjin);
				_vcAttributeNameText.push(tempTextField);
				
				//属性数值
				tempTextField = UIFactory.gTextField("0",623,200 + 24 * i,60,20,this,GlobalStyle.textFormatPutong);
				_vcAttributeValueText.push(tempTextField);
				
				//属性提升标志图片
				var upgradeArrow:GBitmap = UIFactory.gBitmap("", 683, 204 + 24 * i, this);
				_upgradeArrowArr.push(upgradeArrow);
				
				//属性加成值
				tempTextField = UIFactory.gTextField("+0",698,200 + 24 * i,60,20,this,GlobalStyle.textFormatItemGreen);
				_vcAttributeAddValueText.push(tempTextField);
			}
			
			//下边
			_growAddCell1 = UICompomentPool.getUICompoment(PetGrowAddCell);
			_growAddCell1.updateGrowGrade(1);
			_growAddCell1.createDisposedChildren();
			_growAddCell1.selected = true;
			UIFactory.setObjAttri(_growAddCell1,215,76,-1,-1,this);
			_growAddCell2 = UICompomentPool.getUICompoment(PetGrowAddCell);
			_growAddCell2.updateGrowGrade(2);
			_growAddCell2.createDisposedChildren();
			UIFactory.setObjAttri(_growAddCell2,347,76,-1,-1,this);
			_growAddCell3 = UICompomentPool.getUICompoment(PetGrowAddCell);
			_growAddCell3.updateGrowGrade(3);
			_growAddCell3.createDisposedChildren();
			UIFactory.setObjAttri(_growAddCell3,479,76,-1,-1,this);
			_growAddCell4 = UICompomentPool.getUICompoment(PetGrowAddCell);
			_growAddCell4.updateGrowGrade(4);
			_growAddCell4.createDisposedChildren();
			UIFactory.setObjAttri(_growAddCell4,611,76,-1,-1,this);
			
			_progressBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_progressBar.setBg(ImagesConst.PetLifeBg,true,500,12);
			_progressBar.setLabel(BaseProgressBar.ProgressBarTextNone);
			UIFactory.setObjAttri(_progressBar,215,130,-1,-1,this);
			_growthBg = UIFactory.gBitmap("",206,124,this);
			_growthText2 = UIFactory.gTextField("0",207,125,22,20,this,GlobalStyle.textFormatLv.center());
			
			LoaderHelp.addResCallBack(ResFileConst.petGrowPanel,onRecCompl);
			NetDispatcher.addCmdListener(ServerCommand.BackpackDataChange,onPackChange);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemsChange,onPackChange);
			NetDispatcher.addCmdListener(ServerCommand.CoinUpdate,onCoinUpdate);
			_rotationLeftBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			_rotationRightBtn.configEventListener(MouseEvent.MOUSE_DOWN,onClickTurnBtn);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,stopTurning);
		}
		
		/**
		 * 点击旋转按钮 
		 * 
		 */		
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
		 * 资源加载完毕 
		 * 
		 */
		protected function onRecCompl():void
		{
			_isResCompl = true;
			_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowAddPerBg);
			_bg2.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowBg);
			_successRateImage.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowSuccessRate);
			_btnUpgrade.styleName = ResFileConst.PetUpgradeBtn;
			_currentLevelImage.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowCurrentLevel);
			_progressBar.setProgress(ImagesConst.petGrowTargetProgress,false,1,1,498,10);
			_growthBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowTargetNumberBg);
			updateResCompl();
			add3DPet();
			
			for (var i:int = 0; i < _upgradeArrowArr.length; i++)
			{
				_upgradeArrowArr[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.upgradeArrow);
			}
		}
		private var _img2d:Img2D;
		protected function add3DPet():void
		{
			
			_rect3d = Rect3DManager.instance.registerWindow(new Rectangle(187, 152, 356, 240), _window);
			
			Rect3DManager.instance.windowShowHander(null, _window);

			if (_bg2.bitmapData)
			{
				
				_rect3d.removeImg(_img2d);
					
				
				_img2d=new Img2D(null,_bg2.bitmapData,new Rectangle(0, 0,356,240));
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
				_bodyPlayer.load(meshUrl, boneUrl, model.texture1,_rect3d.renderList);
				_rect3d.addObject3d(_bodyPlayer,180,220);
			}
		}
		
		/**
		 * 点击upgrade 
		 * 
		 */
		protected function onClickUpgrade(e:MouseEvent):void
		{
			if(_pet)
			{
				var petGrowth:TPetGrowth = PetGrowthConfig.instance.getInfoByCode(_pet.publicPet.growth + 1);
				var itemNum:int = Cache.instance.pack.backPackCache.getItemCountByCode(new ItemData(petGrowth.itemCode));
				if(itemNum < petGrowth.amount && !_autoBuy.selected)
				{
					MsgManager.showRollTipsMsg("道具不足");
				}
				else
				{
					var vo:PetUpdateGrowthVO = new PetUpdateGrowthVO(_pet.publicPet.uid,_autoBuy.selected);
					Dispatcher.dispatchEvent( new DataEvent(EventName.PetUpdateGrowth,vo));
				}
			}
			else
			{
				MsgManager.showRollTipsMsg("请先选择宠物");
			}
		}
		
		protected function onPackChange(obj:*):void
		{
			updateItemText();
		}
		
		protected function updateItemText():void
		{
			if(_pet)
			{
				var petGrowth:TPetGrowth = PetGrowthConfig.instance.getInfoByCode(_pet.publicPet.growth + 1);
				var petGrowLevel:int = PetUtil.getGrowLevel(_pet.publicPet.growth);
				if(petGrowth)
				{
					var itemNum:int = Cache.instance.pack.backPackCache.getItemCountByCode(new ItemData(petGrowth.itemCode));
					_upgradePropText.htmlText = "消耗" + ItemsUtil.getItemName(new ItemData(petGrowth.itemCode),"{0}*" + petGrowth.amount) + "[剩余" + HTMLUtil.addColor(itemNum.toString(),GlobalStyle.colorChen)+ "个]";
				}
			}
		}
		
		/**
		 * 铜钱更新 
		 * @param obj
		 * 
		 */		
		protected function onCoinUpdate(obj:*):void
		{
			updateNeedCoinText();
		}
		
		/**
		 * 更新需要的铜钱 
		 * 
		 */
		protected function updateNeedCoinText():void
		{
			if(_pet)
			{
				var isMaxGrowth:Boolean = _pet.publicPet.growth == 40;
				var petGrowth:TPetGrowth = PetGrowthConfig.instance.getInfoByCode(_pet.publicPet.growth + 1);
				var isEnoughCoin:Boolean = petGrowth && Cache.instance.role.money.coin > petGrowth.coin;
				_needTongqianText.htmlText = isMaxGrowth?"1000":(isEnoughCoin?petGrowth.coin.toString():HTMLUtil.addColor(petGrowth.coin.toString(),GlobalStyle.colorHong));
			}
		}
		
		protected function updateResCompl():void
		{
			if(_pet && _isResCompl)
			{
				var petGrowLevel:int = PetUtil.getGrowLevel(_pet.publicPet.growthMax - 5);
				
				_progressBar.setValue(_pet.publicPet.growth,40);
				var per:Number = _pet.publicPet.growth * 1.0/40;
				_growthBg.x = per * 500 + 206;
				_growthText2.x = per * 500 + 207;
				_growthText2.text = _pet.publicPet.growth.toString();
				
				switch(petGrowLevel)
				{
					case 0:
						_toolTipBmp.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowTargetWhite);
						break;
					case 1:
						_toolTipBmp.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowTargetGreen);
						break;
					case 2:
						_toolTipBmp.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowTargetBlue);
						break;
					case 3:
						_toolTipBmp.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowTargetPurple);
						break;
					case 4:
						_toolTipBmp.bitmapData = GlobalClass.getBitmapData(ImagesConst.petGrowTargetPurple);
						break;
				}
			}
		}
		
		override public function updateMsg(pet:SPet):void
		{
			super.updateMsg(pet);
			if(pet)
			{
				var isMaxGrowth:Boolean = pet.publicPet.growth == 40;
				//中间显示
				var petGrowth:TPetGrowth = PetGrowthConfig.instance.getInfoByCode(pet.publicPet.growth + 1);
				_levelText.text = "LV." + pet.publicPet.level;
				_nameText.htmlText = PetUtil.getNameHtmlText(pet);
				_successRateText.text = isMaxGrowth?"已满级":petGrowth.showRate + "%";
				updateNeedCoinText();
				var petGrowLevel:int = PetUtil.getGrowLevel(pet.publicPet.growth);
				updateItemText();
				_growthText.text = pet.publicPet.growth.toString();
				updateResCompl();
				
				//右边属性显示
				_currentLevelText.text = pet.publicPet.growth.toString();
				if(!isMaxGrowth)
				{
					_nextLevelText.text = "下一级[" + (pet.publicPet.growth + 1) + "]";
					_btnUpgrade.enabled = true;
				}
				else
				{
					_nextLevelText.text = "已满级";
					_btnUpgrade.enabled = false;
				}
				
				for(var i:int = 0;i < _vcAttributeName.length;i++)
				{
					var baseAttri:int = pet.baseFight[_vcAttributeName[i]];
					var fightAttri:int = pet.extraFight[_vcAttributeName[i]];
					var currentPer:Number = 1 + int(pet.addPercent[_vcAttributeName[i] + "Add"]) * 1.0/10000;
					_vcAttributeValueText[i].text = String((baseAttri + fightAttri) * currentPer);
					
					var levelUpAdd:Number = isMaxGrowth ? 0 : (petGrowth.add - PetGrowthConfig.instance.getInfoByCode(pet.publicPet.growth).add) * 100.0/10000;
					var add:int = int((baseAttri + fightAttri) * levelUpAdd);
					if(!isMaxGrowth && add > 0)
					{
						_vcAttributeAddValueText[i].text = add.toString();
						_vcAttributeAddValueText[i].visible = true;
						_upgradeArrowArr[i].visible = true;
					}
					else
					{
						_vcAttributeAddValueText[i].visible = false;
						_upgradeArrowArr[i].visible = false;
					}
				}
				
				//下面成长的选择
				_growAddCell1.selected = false;
				_growAddCell2.selected = false;
				_growAddCell3.selected = false;
				_growAddCell4.selected = false;
				switch(petGrowLevel)
				{
					case 1:
						_growAddCell1.selected = true;
						break;
					case 2:
						_growAddCell2.selected = true;
						break;
					case 3:
						_growAddCell3.selected = true;
						break;
					case 4:
						_growAddCell4.selected = true;
						break;
				}
				var protectedLevel:int = pet.publicPet.growthMax - 6 > 0?pet.publicPet.growthMax - 6:0;
				_protectedLevelText.text = protectedLevel.toString();
				_toolTipSprite.toolTipData = "成长等级保护，低于<font color='#ff00ff'>" + protectedLevel + "</font>不掉级。";
//				_rect3d = Rect3DManager.instance.getRect3dByWindow(_window);
//				if (!_rect3d)
//					_rect3d = Rect3DManager.instance.registerWindow(new Rectangle(187, 152, 356, 240), _window);
//				Rect3DManager.instance.windowShowHander(null, _window);
//				updatePetModel();
				add3DPet();
			}
			else
				clearMsg();
		}
		
		private function clearMsg():void
		{
			for(var i:int = 0;i < _vcAttributeName.length;i++)
			{
				_vcAttributeValueText[i].text = "0";
				_vcAttributeAddValueText[i].text = "";
				_upgradeArrowArr[i].visible = false;
			}
			_nextLevelText.text = "";
			_currentLevelText.text = "1";
			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
			}
			_bodyPlayer = null;
			_progressBar.setValue(0, 40);
			_nameText.text = "宠物名字";
			_levelText.text = "lv1";
			_growthText.text = "";
			_successRateText.text = "";
			_growthBg.x = 206;
			_growthText2.x = 207;
		}
		
		/**
		 * 更新宠物属性 
		 * @param uid
		 * 
		 */
		override public function updatePetAttribute(uid:String):void
		{
			if(_pet && _pet.publicPet.uid == uid)
			{
				updateMsg(_pet);
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_vcAttributeName.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_upgradeArrowArr.length = 0;
			
			_isResCompl = false;
			
			NetDispatcher.removeCmdListener(ServerCommand.BackpackDataChange,onPackChange);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackItemsChange,onPackChange);
			NetDispatcher.removeCmdListener(ServerCommand.CoinUpdate,onCoinUpdate);
			
			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
			}
		}
	}
}