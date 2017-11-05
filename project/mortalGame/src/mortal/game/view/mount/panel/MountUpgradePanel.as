package mortal.game.view.mount.panel
{
	import Message.DB.Tables.TMountUp;
	
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.manager.ToolTipSprite;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.utils.MountUtil;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapText;
	import mortal.game.view.common.display.NumberManager;
	import mortal.game.view.mount.data.CultureData;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.data.MountToolData;
	import mortal.mvc.core.Dispatcher;
	
	public class MountUpgradePanel extends Mount3DPanel
	{
		//右边
		private var _vcAttributeName:Vector.<String> = new Vector.<String>();
		private var _vcAttributeName2:Vector.<String> = new Vector.<String>();
		private var _vcAttributeNameText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeAddValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeAddValueBitMap:Vector.<GBitmap> = new Vector.<GBitmap>();
		
		private var _addSpeed:GTextFiled;
		private var _rideSpeed:GTextFiled;
		private var _addSpeedNext:GTextFiled;
		private var _rideSpeedNext:GTextFiled;
		
		private var _speedNextIcon:GBitmap;
		private var _rideSpeedNextIcon:GBitmap;
		
		private var _propBtn:GButton;
		private var _moneyBtn:GButton;
		
//		private var _autoBuyBox:GCheckBox;
		
		//左边
		private var _toolTipSp:ToolTipSprite;
		
		private var _qualityIcon:GBitmap;
		
		private var _expBar:BaseProgressBar;
		
		private var _level:BitmapText;
		
		private var _levelTips:BitmapText;
		
		public function MountUpgradePanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			//左边
//			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountPanel,0,0,this));
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.Mount_LV,53,302,_window.contentTopOf3DSprite));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30314),31,351,80,25,_window.contentTopOf3DSprite));
			
			_level = UICompomentPool.getUICompoment(BitmapText);
			_level.createDisposedChildren();
			_level.x = 79;
			_level.y = 295;
			_level.setFightNum(NumberManager.COLOR3,"0",5);
			_window.contentTopOf3DSprite.addChild(_level);
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.CENTER;
			
			_toolTipSp = UICompomentPool.getUICompoment(ToolTipSprite);
			_toolTipSp.x = 404;
			_toolTipSp.y = 100;
			_toolTipSp.mouseEnabled = true;
			_toolTipSp.buttonMode = true;
			_window.contentTopOf3DSprite.addChild(_toolTipSp);
			
			_qualityIcon = UIFactory.gBitmap("", 0, 0, _toolTipSp);
			
			_levelTips = UICompomentPool.getUICompoment(BitmapText);
			_levelTips.createDisposedChildren();
			_levelTips.x = 4;
			_levelTips.y = 8;
			_levelTips.mouseEnabled = false;
			_toolTipSp.addChild(_levelTips);
			
			_expBar = UICompomentPool.getUICompoment(BaseProgressBar);
			_expBar.createDisposedChildren();
			_expBar.setBg(ImagesConst.PetLifeBg,true,253,13);
			_expBar.setProgress(ImagesConst.PetExp,true,1,1,250,12);
			_expBar.setLabel(BaseProgressBar.ProgressBarTextNumber,93,-5,75,8);
			_expBar.x = 116;
			_expBar.y = 303;
			_window.contentTopOf3DSprite.addChild(_expBar);
			
			_propBtn = UIFactory.gButton(Language.getString(30311),152,322,80,28,_window.contentTopOf3DSprite,"RedButton");
			_propBtn.configEventListener(MouseEvent.CLICK,improveMount);
			
			_moneyBtn = UIFactory.gButton(Language.getString(30312),248,322,80,28,_window.contentTopOf3DSprite,"RedButton");
			_moneyBtn.configEventListener(MouseEvent.CLICK,improveMount);
			
//			_autoBuyBox = UIFactory.checkBox(Language.getString(30313),326,348,130,25,_window.contentTopOf3DSprite);
//			_autoBuyBox.configEventListener(Event.CHANGE,autoBuy);
			
			
			//右边
			//右边属性
			pushUIToDisposeVec(UIFactory.bg(443, -3, 208, 303, this));
			pushUIToDisposeVec(UIFactory.bg(443, -2, 208, 26, this, ImagesConst.TextBg2));
			pushUIToDisposeVec(UIFactory.bg(443, 66, 208, 26, this, ImagesConst.TextBg2));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText3,451,4,this));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText2,451,72,this));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText5,548,72,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30307),450,24,80,20,this,GlobalStyle.textFormatAnjin));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30308),450,44,80,20,this,GlobalStyle.textFormatAnjin));
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_vcAttributeAddValueBitMap.length = 0;
			_vcAttributeName.push("attack","life", "physDefense", "magicDefense", "penetration", "jouk", "hit", "crit", "toughness", "block", "expertise");
			_vcAttributeName2.push("attack","life", "physDefense", "magicDefense", "addPenetration", "addJouk", "addHit", "addCrit", "addToughness", "addBlock", "addExpertise");
			var tempTextField:GTextFiled;
			var tempBitmap:GBitmap;
			for (var i:int ; i < _vcAttributeName.length; i++)
			{
				//属性名
				tempTextField = UIFactory.gTextField(GameDefConfig.instance.getAttributeName(_vcAttributeName[i]), 451, 95 + 18 * i, 55, 20, this, GlobalStyle.textFormatAnjin);
				_vcAttributeNameText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性数值
				tempTextField = UIFactory.gTextField("0", 515, 95 + 18 * i, 60, 20, this, GlobalStyle.textFormatPutong);
				_vcAttributeValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性加成值
				tempTextField = UIFactory.gTextField("(+0)", 580, 95 + 18 * i, 60, 20, this, GlobalStyle.textFormatItemGreen);
				_vcAttributeAddValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性增加图标
				tempBitmap = UIFactory.gBitmap("",565,99 + 18 * i,this);
				_vcAttributeAddValueBitMap.push(tempBitmap);
				pushUIToDisposeVec(tempBitmap);
			}
			
			_addSpeed = UIFactory.gTextField("0", 538, 25 , 60, 20, this, GlobalStyle.textFormatPutong);
			
			_rideSpeed = UIFactory.gTextField("0", 538, 45 , 60, 20, this, GlobalStyle.textFormatPutong);
			
			_addSpeedNext = UIFactory.gTextField("", 585, 25 , 60, 20, this, GlobalStyle.textFormatItemGreen);
			
			_rideSpeedNext = UIFactory.gTextField("", 585, 45 , 60, 20, this, GlobalStyle.textFormatItemGreen);
			
			_speedNextIcon = UIFactory.gBitmap("",560,23,this);
			_rideSpeedNextIcon = UIFactory.gBitmap("",585,43,this);
		
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_toolTipSp.dispose(isReuse);
			_qualityIcon.dispose(isReuse);
			_expBar.dispose(isReuse);
			_propBtn.dispose(isReuse);
			_moneyBtn.dispose(isReuse);
//			_autoBuyBox.dispose(isReuse);
			_level.dispose(isReuse);
			_levelTips.dispose(isReuse);
			
			_addSpeed.dispose(isReuse);
			_rideSpeed.dispose(isReuse);
			_addSpeedNext.dispose(isReuse);
			_rideSpeedNext.dispose(isReuse);
			_speedNextIcon.dispose(isReuse);
			
			_toolTipSp = null;
			_qualityIcon = null;
			_expBar = null;
			_propBtn = null;
			_moneyBtn = null;
//			_autoBuyBox = null;
			_level = null;
			_levelTips = null;
			
			_addSpeed = null;
			_rideSpeed = null;
			_addSpeedNext = null;
			_rideSpeedNext = null;
			_rideSpeedNextIcon = null;
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_vcAttributeAddValueBitMap.length = 0;
		}
		
		override public function setMountInfo(mountData:MountData):void
		{
			super.setMountInfo(mountData);
			
			updateExp();
			
			setInfo();
		}
		
		override public function clearWin():void
		{
			super.clearWin();
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				_vcAttributeAddValueBitMap[i].bitmapData = null;
				_vcAttributeValueText[i].text = "0";
				_vcAttributeAddValueText[i].text = "(+0)";
			}
			
			_toolTipSp.visible = false;
			
			_expBar.setValue(0,0);
			
			_addSpeed.text = "0";
			_rideSpeed.text = "0";
			_addSpeedNext.text = "";
			_rideSpeedNext.text = "";
			_speedNextIcon.bitmapData = null;
			_speedNextIcon.bitmapData = null;
			
		}
		
		override public function setInfo():void
		{
			super.setInfo();
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				var extr:int = 0;
				var nextExtr:int = 0;
				var tmountUp:TMountUp = (MountConfig.instance.mountUpDec[_mountData.sPublicMount.level] as TMountUp);
				
				if(tmountUp.hasOwnProperty(_vcAttributeName[i]))
				{
					//计算本级属性
					extr += tmountUp[_vcAttributeName[i]];
					
					//计算下级属性
					var nextLevel:int = _mountData.sPublicMount.level < MountUtil.getMaxLevelByColor(_mountData.itemMountInfo.color)? _mountData.sPublicMount.level + 1:_mountData.sPublicMount.level;
					nextExtr = (MountConfig.instance.mountUpDec[nextLevel] as TMountUp)[_vcAttributeName[i]] - (MountConfig.instance.mountUpDec[_mountData.sPublicMount.level] as TMountUp)[_vcAttributeName[i]];
					if(nextExtr != 0)
					{
						_vcAttributeAddValueBitMap[i].bitmapData = GlobalClass.getBitmapData(ImagesConst.upgradeArrow);
					}
					else
					{
						_vcAttributeAddValueBitMap[i].bitmapData = null;
					}
				}
				
				for each(var n:MountToolData in _mountData.toolList)  //计算777属性加成
				{
					if(n.name.toLocaleLowerCase() == "add" + _vcAttributeName[i])
					{
						extr += (MountConfig.instance.getMountToolLevel(n.level).add / 10000)*_mountData.itemMountInfo[n.name];
					}
				}
				
				_vcAttributeValueText[i].text = String(_mountData.itemMountInfo[_vcAttributeName[i]] + extr);
				_vcAttributeAddValueText[i].text = String(nextExtr);
			}
			
			_qualityIcon.bitmapData = GlobalClass.getBitmapData("Mount_color" + _mountData.itemMountInfo.color);
			
			_levelTips.setFightNum(NumberManager.COLOR3,String(MountUtil.getMaxLevelByColor(_mountData.itemMountInfo.color)),5);
			
			_toolTipSp.visible = true;
			
			levelUpdate();
			
			getMaxValueByName();
		}
		
		private function levelUpdate():void
		{
			var nextLevel:int = _mountData.sPublicMount.level < MountUtil.getMaxLevelByColor(_mountData.itemMountInfo.color)? _mountData.sPublicMount.level + 1:_mountData.sPublicMount.level;
			var value:int = (MountConfig.instance.mountUpDec[nextLevel] as TMountUp).experience
			if(_mountData.sPublicMount.level == MountUtil.getMaxLevelByColor(_mountData.itemMountInfo.color))
			{
				_expBar.setValue(value,value);
			}
			else
			{
				_expBar.setValue(_mountData.sPublicMount.experience,value);
			}
			_level.setFightNum(NumberManager.COLOR3,String(_mountData.sPublicMount.level),5);
		}
		
		private function autoBuy(e:Event):void
		{
			
		}
		
		private function improveMount(e:MouseEvent):void
		{
			if(_mountData == null)
			{
				return ;
			}
			else if(MountUtil.isExistMount(_mountData))
			{
				MsgManager.showRollTipsMsg(Language.getString(30316));
				return;
			}
			
			
			var cultureData:CultureData = new CultureData();
			cultureData.uid = _mountData.sPublicMount.uid;
			
			if(e.target == _moneyBtn)
			{
				if(!MountUtil.isCanCultur(_mountData))
				{
					return ;
				}
				if(!MountUtil.isEnougthCulturMoney())
				{
					MsgManager.showRollTipsMsg("金钱不足");
					return ;
				}
				cultureData.type = 2;
				cultureData.goldCount = 1;
				Dispatcher.dispatchEvent(new DataEvent(EventName.CultureMount,cultureData));
			}
			else if(e.target == _propBtn)
			{
				if(!MountUtil.hasCurltureItemInPack())
				{
					MsgManager.showRollTipsMsg("道具不足");
					return;
				}
				if(MountUtil.isMaxLevel(_mountData))
				{
					MsgManager.showRollTipsMsg("坐骑已经满级");
					return ;
				}
				cultureData.type = 1;
				cultureData.itemCount = 1;
				Dispatcher.dispatchEvent(new DataEvent(EventName.CultureMount,cultureData));
			}
		}
		
		private function getMaxValueByName():void
		{
			var mounts:Vector.<MountData> = Cache.instance.mount.ownMountList;
			var maxAddSpeed:int;
			var maxRideSpeed:int;
			
			var maxNextSpeed:int;
			var maxNextRideSpeed:int;
		
			for each(var i:MountData in mounts)
			{
				var mountUp:TMountUp = (MountConfig.instance.mountUpDec[i.sPublicMount.level] as TMountUp);
				var nextLevel:int = i.sPublicMount.level < MountUtil.getMaxLevelByColor(i.itemMountInfo.color)? i.sPublicMount.level + 1:i.sPublicMount.level;
				var mountUpNext:TMountUp = (MountConfig.instance.mountUpDec[nextLevel] as TMountUp);
				
				var addSpeedValue:int = i.itemMountInfo.addSpeed + mountUp.addSpeed;
				if(addSpeedValue > maxAddSpeed)
				{
					maxAddSpeed = addSpeedValue;
				}
				
				var rideSpeed:int = i.itemMountInfo.speed + mountUp.speed;
				if(rideSpeed > maxRideSpeed)
				{
					maxRideSpeed = rideSpeed;
				}
				
				var nextAddSpeed:int = i.itemMountInfo.addSpeed + mountUpNext.addSpeed - mountUp.addSpeed;
				if(nextAddSpeed > maxNextSpeed)
				{
					maxNextSpeed = nextAddSpeed;
				}
				
				var nextRideSpeed:int = i.itemMountInfo.speed + mountUpNext.speed - mountUp.speed;
				if(nextRideSpeed > maxNextRideSpeed)
				{
					maxNextRideSpeed = nextRideSpeed;
				}
				
			}
			
			_addSpeed.text = maxAddSpeed.toString();
			_rideSpeed.text = maxRideSpeed.toString(); 
		
			if(maxAddSpeed == maxAddSpeed)
			{
				_addSpeedNext.text = "";
				_speedNextIcon.bitmapData = null;
			}
			else
			{
				_addSpeedNext.text = maxAddSpeed.toString();
				_speedNextIcon.bitmapData = GlobalClass.getBitmapData(ImagesConst.upgradeArrow);	
			}
			
			if(maxRideSpeed == maxRideSpeed)
			{
				_rideSpeedNext.text = "";
				_rideSpeedNextIcon.bitmapData = null;
			}
			else
			{
				_rideSpeedNext.text = maxRideSpeed.toString();
				_speedNextIcon.bitmapData = GlobalClass.getBitmapData(ImagesConst.upgradeArrow);	
			}
		}
		
		public function updateExp():void
		{
			var nextLevel:int = _mountData.sPublicMount.level < MountUtil.getMaxLevelByColor(_mountData.itemMountInfo.color)? _mountData.sPublicMount.level + 1:_mountData.sPublicMount.level;
			var value:int = (MountConfig.instance.mountUpDec[nextLevel] as TMountUp).experience
			
			if(_mountData.sPublicMount.level == MountUtil.getMaxLevelByColor(_mountData.itemMountInfo.color))
			{
				_expBar.setValue(value,value);
			}
			else
			{
				_expBar.setValue(_mountData.sPublicMount.experience,value);
			}
		}
		
	}
}