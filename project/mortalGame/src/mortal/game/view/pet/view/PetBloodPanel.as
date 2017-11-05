/**
 * @heartspeak
 * 2014-3-5 
 */   	

package mortal.game.view.pet.view
{
	import Message.DB.Tables.TPetBloodTarget;
	import Message.DB.Tables.TPetBloodUp;
	import Message.Game.SPet;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.ToolTipSprite;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import frEngine.loaders.resource.info.ABCInfo;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.model.vo.pet.PetUpdateBloodVO;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.PetBloodTargetConfig;
	import mortal.game.resource.tableConfig.PetBloodUpConfig;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.effect.AttriAddEffect;
	import mortal.game.view.effect.type.AttributeTextType;
	import mortal.game.view.effect.type.AttributeValue;
	import mortal.mvc.core.Dispatcher;
	
	public class PetBloodPanel extends PetPanelBase
	{
		//背景
		protected var _bg:GBitmap;
		
		//顶部按钮 和 位置
		protected var _vcBloodButton:Vector.<GLoadingButton>;
		protected var _vcPosition:Vector.<Point>;
		protected var _selectBmp:GBitmap;
		protected var _vcBloodButtonSelectBMP:GBitmap;
		
		//中间部分
		protected var _bgBloodBg:GBitmap;
		protected var _lineBg:GBitmap;
		protected var _nameBg:ScaleBitmap;
		protected var _targetBmp:GBitmap;
		protected var _btnPre:GLoadedButton;
		protected var _btnNext:GLoadedButton;
		protected var _nameText:GTextFiled;
		protected var _toolTipSprite:ToolTipSprite;
		//中间的线 和 球
		protected var _lineSprite:GSprite;
		protected var _vcLevelBall:Vector.<GBitmap>;
		
		protected var _progress:BaseProgressBar;
		protected var _btnUpgrade:GButton;
		protected var _btnTenTimesUpgrade:GButton;
		protected var _maxLevelText:GTextFiled;
		protected var _checkBoxAutoBuyItem:GCheckBox;
//		protected var _needTongqianText:GTextFiled;
//		protected var _autoBuy:GCheckBox;
		
		//右边属性显示
		protected var _vcAttributeName:Vector.<String> = new Vector.<String>();
		protected var _vcAttributeNameText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		protected var _vcAttributeValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		protected var _vcAttributeAddValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _upgradeArrowArr:Vector.<GBitmap> = new Vector.<GBitmap>();
		
		//数据
		protected var _petBloodArray:Array;
		protected var _selectIndex:int;
		protected var _isLeft:Boolean = true;
		
		private static const BLOOD_COUNT:int = 8;
		
		public function PetBloodPanel(window:Window)
		{
			super(window);
		}
		
		override protected function configUI():void
		{
			var ary:Array = [{x:197,y:91}
							,{x:264,y:76}
							,{x:330,y:91}
							,{x:400,y:77}
							,{x:471,y:94}
							,{x:540,y:78}
							,{x:608,y:95}
							,{x:678,y:76}];
			_vcPosition = new Vector.<Point>();
			var i:int;
			for(i = 0;i < ary.length;i++)
			{
				_vcPosition.push(new Point(ary[i].x,ary[i].y));
			}
			super.configUI();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			//背景
			_bg = UIFactory.gBitmap("",185,68,this);
			_vcBloodButton = new Vector.<GLoadingButton>();
			//顶部按钮
			for(var i:int = 0;i < _vcPosition.length;i++)
			{
				_vcBloodButton[i] = UIFactory.gLoadingButton("petBlood" + (i + 1),_vcPosition[i].x,_vcPosition[i].y,60,60,this);
				_vcBloodButton[i].configEventListener(MouseEvent.CLICK,onClickBloodButton);
				_vcBloodButton[i].enabled = false;
			}
			_selectBmp = UIFactory.gBitmap("",0,0,this);
			_selectBmp.visible = false;
			
			//中间部分
			_bgBloodBg = UIFactory.gBitmap("",185,162,this);
			_lineBg = UIFactory.gBitmap("",185,162,this);
			_nameBg = UIFactory.bg(212,168,320,26,this,ImagesConst.PetNameBg);
			_toolTipSprite = UICompomentPool.getUICompoment(ToolTipSprite);
			_toolTipSprite.mouseEnabled = true;
			UIFactory.setObjAttri(_toolTipSprite,520,167,-1,-1,_window.contentTopOf3DSprite);
			_targetBmp = UIFactory.bitmap("",0,0,_toolTipSprite);
			_btnPre = UIFactory.gLoadedButton("",274,170,24,25,this);
			_btnNext = UIFactory.gLoadedButton("",457,170,24,25,this);
			_btnPre.configEventListener(MouseEvent.CLICK,onClickPreBtn);
			_btnNext.configEventListener(MouseEvent.CLICK,onClickNextBtn);
			_nameText = UIFactory.gTextField("东方神脉0/16",323,169,130,24,this,GlobalStyle.textFormatAnjin.setSize(14));
			
			_lineSprite = UICompomentPool.getUICompoment(GSprite);
			UIFactory.setObjAttri(_lineSprite,185,162,-1,-1,this);
			
			
			//血脉等级
			_vcLevelBall = new Vector.<GBitmap>();
			for(i = 0;i < 8;i++)
			{
				_vcLevelBall[i] = UIFactory.gBitmap("",0,0,this);
				_vcLevelBall[i].visible = false;
			}
			_vcBloodButtonSelectBMP = UIFactory.gBitmap("", 0, 0, this);
			_vcBloodButtonSelectBMP.visible = false;
			
			UIFactory.gTextField("提升进度",212,391,70,20,this,GlobalStyle.textFormatAnjin.setSize(13));
			_progress = UICompomentPool.getUICompoment(BaseProgressBar);
			_progress.setBg(ImagesConst.PetLifeBg,true,246,12);
			_progress.setProgress(ImagesConst.PetExp,true,1,1,244,10);
			_progress.setLabel(BaseProgressBar.ProgressBarTextNumber,65,-2,100,20);
			_progress.setValue(100,100);
			UIFactory.setObjAttri(_progress,280,397,-1,-1,this);
			
			_btnUpgrade = UIFactory.gButton("提    升",285,420,93,30,this,"RedButton");
			_btnUpgrade.configEventListener(MouseEvent.CLICK,onClickUpgrade);
			_btnTenTimesUpgrade = UIFactory.gButton("十次 提 升",396,420,93,30,this,"RedButton");
			_btnTenTimesUpgrade.configEventListener(MouseEvent.CLICK,onClickTenTimesUpgrade);
			_maxLevelText = UIFactory.gTextField("本血脉已提升到最高等级",320,420,200,20,this,GlobalStyle.textFormatItemGreen.setSize(13));
			_maxLevelText.visible = false;
			_checkBoxAutoBuyItem = UIFactory.checkBox("道具不足自动购买", 425, 450, 120, 20, this);
			_checkBoxAutoBuyItem.selected = true;
//			pushUIToDisposeVec(UIFactory.gTextField("本次提升费用:",218,456,90,20,this));
//			_needTongqianText = UIFactory.gTextField("1000",302,456,40,20,this,GlobalStyle.textFormatAnjin);
//			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.Jinbi,334,459,this));
//			_autoBuy = UIFactory.checkBox("道具不足自动购买",383,452,150,28,this);
//			_autoBuy.selected = true;
			
			//右边属性显示
			_vcAttributeName.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_upgradeArrowArr.length = 0;
			_vcAttributeName.push("attack", "maxLife", "physDefense","magicDefense","penetration","jouk","hit","crit","toughness","block","expertise","damageReduce");
			var tempTextField:GTextFiled;
			for(i = 0;i < _vcAttributeName.length;i++)
			{
				//属性名
				tempTextField = UIFactory.gTextField(GameDefConfig.instance.getAttributeName(_vcAttributeName[i]),585,195 + 24 * i,55,20,this,GlobalStyle.textFormatAnjin);
				_vcAttributeNameText.push(tempTextField);
				
				//属性数值
				tempTextField = UIFactory.gTextField("0",650,195 + 24 * i,60,20,this,GlobalStyle.textFormatPutong);
				_vcAttributeValueText.push(tempTextField);
				
				//属性提升标志图片
				var upgradeArrow:GBitmap = UIFactory.gBitmap("", 691, 199 + 24 * i, this);
				_upgradeArrowArr.push(upgradeArrow);
				
				//属性加成值
				tempTextField = UIFactory.gTextField("+0",706,195 + 24 * i,60,20,this,GlobalStyle.textFormatItemGreen);
				_vcAttributeAddValueText.push(tempTextField);
			}
			
			LoaderHelp.addResCallBack(ResFileConst.petBloodBg1,onResBgCompl);
			LoaderHelp.addResCallBack(ResFileConst.petBloodPanel,onResCompl);
		}
		
		/**
		 * 资源加载完成 
		 * 
		 */		
		protected function onResCompl():void
		{
			if(!isDisposed)
			{
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petBloodBg);
				_targetBmp.bitmapData = GlobalClass.getBitmapData(ImagesConst.petBloodTarget);
				_btnPre.styleName = ImagesConst.petBloodPreBtn_upSkin;
				_btnNext.styleName = ImagesConst.ShopExpansion_upSkin;
				_selectBmp.bitmapData = GlobalClass.getBitmapData(ImagesConst.petBloodSelect);
				_vcBloodButtonSelectBMP.bitmapData = GlobalClass.getBitmapData(ImagesConst.petBloodLevelSelect);
				
				for(var i:int = 0;i < 8;i++)
				{
					_vcLevelBall[i].bitmapData = GlobalClass.getBitmapData("petBloodLevel" + (i%8 + 1));
				}
				
				for (i = 0; i < _upgradeArrowArr.length; i++)
				{
					_upgradeArrowArr[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.upgradeArrow);
				}
			}
		}
		
		/**
		 * 点击升级 
		 * @param e
		 * 
		 */		
		protected function onClickUpgrade(e:MouseEvent):void
		{
			if(_petBloodArray && _pet)
			{
				var obj:Object = _petBloodArray[_selectIndex];
				var petUpdateBloodVO:PetUpdateBloodVO = new PetUpdateBloodVO(_pet.publicPet.uid,false,obj.b,_checkBoxAutoBuyItem.selected);
				Dispatcher.dispatchEvent( new DataEvent(EventName.PetUpdateBlood,petUpdateBloodVO));
			}
		}
		
		/**
		 * 点击升级十次
		 * @param e
		 * 
		 */		
		protected function onClickTenTimesUpgrade(e:MouseEvent):void
		{
			if(_petBloodArray && _pet)
			{
				var obj:Object = _petBloodArray[_selectIndex];
				var petUpdateBloodVO:PetUpdateBloodVO = new PetUpdateBloodVO(_pet.publicPet.uid,true,obj.b,_checkBoxAutoBuyItem.selected);
				Dispatcher.dispatchEvent( new DataEvent(EventName.PetUpdateBlood,petUpdateBloodVO));
			}
		}
		
		/**
		 * 点击上一页按钮 
		 * @param e
		 * 
		 */		
		protected function onClickPreBtn(e:MouseEvent):void
		{
			_isLeft = true;
			updateBloodMiddle();
		}
		
		/**
		 * 点击下一页按钮 
		 * @param e
		 * 
		 */		
		protected function onClickNextBtn(e:MouseEvent):void
		{
			_isLeft = false;
			updateBloodMiddle();
		}
		
		/**
		 * 点击顶上的按钮 
		 * @param e
		 * 
		 */		
		protected function onClickBloodButton(e:MouseEvent):void
		{
			var selectedIndex:int = 0;
			var btn:GLoadingButton = e.currentTarget as GLoadingButton;
			for(var i:int = 0;i < 8;i++)
			{
				if(_vcBloodButton[i] == btn)
				{
					selectedIndex = i;
				}
			}
			if(_selectIndex != selectedIndex)
			{
				updateSelectIndex(selectedIndex);
			}
		}
		
		/**
		 * 更新宠物信息 
		 * @param pet
		 * 
		 */		
		override public function updateMsg(pet:SPet):void
		{
			var isSamePet:Boolean = pet == _pet;
			super.updateMsg(pet);
			if(pet)
			{
				//更新血脉
				var petBloodArray:Array = JSON.parse(pet.publicPet.blood) as Array;
				_petBloodArray = petBloodArray;
				if(!petBloodArray)
				{
					MsgManager.showRollTipsMsg("该宠物血脉没有开通");
					_toolTipSprite.toolTipData = "该宠物血脉没有开通";
					clearMsg();
					return;
				}
				Log.error(petBloodArray.length > BLOOD_COUNT, "当前的血脉条数不对！pet.publicPet.blood = " + pet.publicPet.blood);
				
				for(var i:int = 0;i < _vcPosition.length;i++)
				{
					var bloodButtonOrgState:Boolean = _vcBloodButton[i].enabled;
					var bloodButtonNowState:Boolean = petBloodArray.length > i;
					if (bloodButtonNowState != bloodButtonOrgState)
						_selectIndex = i;
					_vcBloodButton[i].enabled = bloodButtonNowState;
				}
				
				if(isSamePet)
				{
					updateSelectIndex(_selectIndex);
				}
				else
				{
					//选择选中序号
					updateSelectIndex(petBloodArray.length - 1);
				}
			}
			else
			{
				clearMsg();
			}
		}
		
		private function clearMsg():void
		{
			for(var i:int = 0;i < _vcPosition.length;i++)
			{
				_vcBloodButton[i].enabled = false;
			}
			for(i = 0;i < _vcAttributeName.length;i++)
			{
				_vcAttributeValueText[i].text = "0";
				_vcAttributeAddValueText[i].text = "";
				_upgradeArrowArr[i].visible = false;
			}
			_selectBmp.visible = false;
			_vcBloodButtonSelectBMP.visible = false;
			_progress.setValue(0, 129);
			_lineSprite.graphics.clear();
			_nameText.text = "东方神脉0/16";
		}
		
		/**
		 * 更新选择的序号 
		 * @param index
		 * 
		 */
		public function updateSelectIndex(index:int):void
		{
			if(index >= 0 && _petBloodArray)
			{
				_selectIndex = index;
				_selectBmp.visible = true;
				_selectBmp.x = _vcBloodButton[index].x - 5;
				_selectBmp.y = _vcBloodButton[index].y - 4;
				
				//设置默认显示左还是右边
				var obj:Object = _petBloodArray[index];
				_isLeft = obj.bl < 8;
				
				updateBloodMiddle();
				
				//更新右边属性
				var petBloodUp:TPetBloodUp = PetBloodUpConfig.instance.getInfoByCodeLevel(obj.b,obj.bl + 1);
				var petBloodTarget:TPetBloodTarget = PetBloodTargetConfig.instance.getInfoByTarget(_selectIndex);
				var petBloodTargetDesc:String = "满级额外属性";
				for(var i:int = 0;i < _vcAttributeName.length;i++)
				{
					var baseAttri:int = _pet.baseFight[_vcAttributeName[i]];
					var fightAttri:int = _pet.extraFight[_vcAttributeName[i]];
					var currentPer:Number = 1 + int(_pet.addPercent[_vcAttributeName[i] + "Add"]) * 1.0/10000;
					_vcAttributeValueText[i].text = String((baseAttri + fightAttri) * currentPer);
					
					if(petBloodUp)
					{
						var levelUpAdd:Number = 0;
						if(_vcAttributeName[i] == "maxLife")
						{
							levelUpAdd = petBloodUp["life"] * currentPer;
						}
						else if(petBloodUp.hasOwnProperty(_vcAttributeName[i]))
						{
							levelUpAdd = petBloodUp[_vcAttributeName[i]] * currentPer;
						}
						_vcAttributeAddValueText[i].text = int(levelUpAdd).toString();
						if(levelUpAdd > 0)
						{
							_vcAttributeAddValueText[i].visible = true;
							_upgradeArrowArr[i].visible = true;
						}
						else
						{
							_vcAttributeAddValueText[i].visible = false;
							_upgradeArrowArr[i].visible = false;
						}
					}
					else
					{
						_vcAttributeAddValueText[i].visible = false;
						_upgradeArrowArr[i].visible = false;
					}
					if (petBloodTarget.hasOwnProperty(_vcAttributeName[i]) && petBloodTarget[_vcAttributeName[i]] > 0)
						petBloodTargetDesc += "\n" + GameDefConfig.instance.getAttributeName(_vcAttributeName[i]) + " +" + petBloodTarget[_vcAttributeName[i]];
					else
					{
						if (_vcAttributeName[i] == "maxLife" && petBloodTarget["life"] > 0)
							petBloodTargetDesc += "\n" + GameDefConfig.instance.getAttributeName(_vcAttributeName[i]) + " +" + petBloodTarget["life"];
					}
				}
				_toolTipSprite.toolTipData = petBloodTargetDesc;
			}
		}
		
		/**
		 * 更新中间部分的显示 
		 * 
		 */		
		public function updateBloodMiddle():void
		{
			if(!isDisposed && _petBloodArray)
			{
				var obj:Object = _petBloodArray[_selectIndex];
				if(obj)
				{
					var isMaxBlood:Boolean = obj.bl == 16;
					_nameText.text = GameDefConfig.instance.getBloodName(obj.b) + "(" + obj.bl + "/16)";
					if(isMaxBlood)
					{
						_progress.setValue(480,480);
						_maxLevelText.visible = true;
						_btnUpgrade.visible = false;
						_btnTenTimesUpgrade.visible = false;
					}
					else
					{
						_maxLevelText.visible = false;
						_btnUpgrade.visible = true;
						_btnTenTimesUpgrade.visible = true;
						_progress.setValue(obj.exp,PetBloodUpConfig.instance.getInfoByCodeLevel(int(obj.b),int(obj.bl) + 1).experience);
					}
					var postionArray:Array = GameDefConfig.instance.getBloodPostion(_selectIndex + 1,_isLeft);
					_lineSprite.graphics.clear();
					var showMax:int = _isLeft?Math.min(obj.bl,8):Math.max(0,obj.bl - 8);
					for(var i:int = 0;i < 8;i++)
					{
						var point:Point = postionArray[i] as Point;
						if(i < showMax)
//						if(i < 8)
						{
							_vcLevelBall[i].visible = true;
							_vcLevelBall[i].x = point.x + _bgBloodBg.x - 20;
							_vcLevelBall[i].y = point.y + _bgBloodBg.y - 20;
							if(i > 0)
							{
								var prePoint:Point = postionArray[i - 1] as Point;
								_lineSprite.graphics.lineStyle(5,GlobalStyle.blueUint);
								_lineSprite.graphics.moveTo(prePoint.x,prePoint.y);
								_lineSprite.graphics.lineTo(point.x,point.y);
								_lineSprite.graphics.endFill();
							}
						}
						else
						{
							_vcLevelBall[i].visible = false;
							if (i == showMax)
							{
								_vcBloodButtonSelectBMP.visible = true;
								_vcBloodButtonSelectBMP.x = point.x + _bgBloodBg.x - 20;
								_vcBloodButtonSelectBMP.y = point.y + _bgBloodBg.y - 20;
							}
						}
					}
					if (showMax == BLOOD_COUNT)
						_vcBloodButtonSelectBMP.visible = false;
					updateBtnPreNextEnabled();
				}
			}
		}
		
		/**
		 * 属性提升飘字
		 * 
		 */
		private var _flyCharsList:Vector.<String> = new Vector.<String>();
		
		public function flyChars():void
		{
			var orgObj:Object = _petBloodArray[_selectIndex];
			var orgExp:int = orgObj.exp;
			_petBloodArray = JSON.parse(_pet.publicPet.blood) as Array;
			var nowObj:Object = _petBloodArray[_selectIndex];
			var nowExp:int = nowObj.exp;
			var addedExp:int = nowExp - orgExp;
			if (addedExp <= 0)
				return;
			var addedCritMultiple:int = addedExp / ItemConfig.instance.getConfig(410131001).effect;
			var flyChars:String = addedCritMultiple + "倍暴击+" + addedExp;
			if (_flyCharsList.length == 0)
				setTimeout(delayFly, 1000, flyChars);
			_flyCharsList.push(flyChars);
			return;
		}
		
		private function delayFly(flychars:String):void
		{
			MsgManager.showRollTipsMsg(flychars);
			_flyCharsList.shift();
			if (_flyCharsList.length != 0)
				setTimeout(delayFly, 1000, _flyCharsList[0]);
		}
		
		
		/**
		 * 更新上一页下一页按钮的MouseEnable 
		 * 
		 */
		protected function updateBtnPreNextEnabled():void
		{
			if(_petBloodArray)
			{
				var obj:Object = _petBloodArray[_selectIndex];
				_btnPre.visible = !_isLeft;
				_btnNext.visible = _isLeft && obj.bl >= 8;
			}
		}
		
		/**
		 * 切换到标签后显示对应的底图 
		 * 
		 */		
		protected function onResBgCompl():void
		{
			if(!isDisposed)
			{
				_bgBloodBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petBloodBg1);
				_lineBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.petBloodLine1);
			}
		}
		
		/**
		 * 更新宠物属性 
		 * @param uid
		 * 
		 */		
		override public function updatePetAttribute(uid:String):void
		{
			if(_pet && uid == _pet.publicPet.uid)
			{
				updateMsg(_pet);
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_vcBloodButton.length = 0;
			_vcAttributeName.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_upgradeArrowArr.length = 0;
			_petBloodArray = null;
			_vcLevelBall.length = 0;
			_selectIndex = 0;
			_isLeft = true;
		}
	}
}