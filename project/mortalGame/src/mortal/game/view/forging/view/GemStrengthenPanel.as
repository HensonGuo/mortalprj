package mortal.game.view.forging.view
{

	import Message.DB.Tables.TModel;
	import Message.Game.EOperType;
	import Message.Public.EJewelQuality;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import frEngine.Engine3dEventName;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.Window;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.player.WeaponPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.GLabelButton;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.game.view.forging.data.ForgingUtil;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 宝石强化面板
	 * @date   2014-3-27 上午11:17:13
	 * @author dengwj
	 */	 
	public class GemStrengthenPanel extends ForgingPanelBase
	{
		/** 底图 */
		private var _gemBg:GBitmap;
		/** 宝石格子 */
		private var _gemItemList:GTileList;
		/** 当前选中宝石 */
		private var _currSelGem:GemItem;
		/** 属性名 */
		private var _propName:GTextFiled;
		/** 属性值 */
		private var _propValue:GTextFiled;
		/** 提升箭头 */
		private var _upArrow:GBitmap;
		/** 提升值 */
		private var _upValue:GTextFiled;
		/** 进度条 */
		private var _progressBar:BaseProgressBar;
		/** 进度点 */
		private var _progressPoint:GBitmap;
		/** 普通强化按钮 */
		private var _commonStrengBtn:GLabelButton;
		/** 一键强化按钮 */
		private var _onKeyStrengBtn:GLabelButton;
		/** 提升费用文本 */
		private var _upCostLabel:GTextFiled;
		/** 提升费用 */
		private var _upCost:GTextFiled;
		/** 绑金图标 */
		private var _goldIcon:GBitmap;
		/** 自动购买道具checkBox */
		private var _autoBuyBox:GCheckBox;
		/** 是否可进行强化 */
		private var _canBeStrengthened:Boolean;
		/** 宝石等级图片文字 */
		private var _txtGemLevel:BitmapNumberText;
		/** 满级文本 */
		private var _maxLevelLabel:GTextFiled;
		/** 宝石当前等级 */
		private var _gemCurrLevel:int;
		
		
		//3D相关
		private var _leftImg2d:Img2D;
		
		private var _effectPlayer:EffectPlayer;
		
		private var _strengEffectPlayer:EffectPlayer;
		
		private var _gemPlayer:WeaponPlayer;
		
		private var _effectPath:String;
		
		private var _effectClickPath:String;
		
		public function GemStrengthenPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.addChild(_gemSpr);
			this._propName = UIFactory.gTextField("物    攻",99,258,44,20,this);
			this._propName.textColor = 0xffc293;
			this._propValue = UIFactory.gTextField("",155,258,40,20,this);
			this._upArrow = UIFactory.gBitmap(ImagesConst.upgradeArrow,202,261,this);
			this._upValue = UIFactory.gTextField("",214,258,40,20,this);
			this._upValue.textColor = 0x00ff00;
			
			this._progressBar = UICompomentPool.getUICompoment(BaseProgressBar);
			this._progressBar.setBg(ImagesConst.StrengthenBarBg, true, 214, 5);
			this._progressBar.setProgress(ImagesConst.StrengthenBar, true, 0, 0, 214, 5);
			this._progressBar.setLabel(BaseProgressBar.ProgressBarTextNone, 20, -2, 60, 12);
			this._progressBar.setValue(0, 10000);
			this._progressBar.x = 68;
			this._progressBar.y = 331-18;
			this.addChild(this._progressBar);
			
			this._progressPoint = UIFactory.gBitmap(ImagesConst.StrengthenBarPoint,0,-5,_progressBar);
			
			this._commonStrengBtn = UIFactory.gLabelButton(null, GLabelButton.gLoadedButton, ImagesConst.RedButton_upSkin, 80, 339, 93, 30, this);
			this._commonStrengBtn.label = ImagesConst.StrengCommon;
			this._onKeyStrengBtn = UIFactory.gLabelButton(null, GLabelButton.gLoadedButton, ImagesConst.RedButton_upSkin, 181, 339, 93, 30, this);
			this._onKeyStrengBtn.label = ImagesConst.StrengOneKey;
			this._commonStrengBtn.configEventListener(MouseEvent.CLICK,onClickHandler);
			this._onKeyStrengBtn.configEventListener(MouseEvent.CLICK,onClickHandler);
			
			this._upCostLabel = UIFactory.gTextField("本次提升费用：",27,387,87,20,this);
			this._upCost = UIFactory.gTextField("",111,387,40,20,this);
			this._upCost.textColor = 0xffc293;
			this._goldIcon = UIFactory.gBitmap(ImagesConst.Jinbi_bind,143,390,this);
			this._autoBuyBox = UIFactory.checkBox("道具不足，自动购买",194,383,140,28,this);
			this._autoBuyBox.configEventListener(MouseEvent.CLICK, onClickHandler);
			
			this._maxLevelLabel = UIFactory.gTextField("已满级",90,-8,50,20,this._progressBar);
			this._maxLevelLabel.textColor = GlobalStyle.colorHongUint;
			
			_txtGemLevel = UIFactory.bitmapNumberText(128, 38, "StrengthenNumber.png", ForgingConst.ArtWordCellWidth, ForgingConst.ArtWordCellHeight, ForgingConst.ArtWordGap, this);
			
			this.canBeStrengthened = false;
			
			createGemGrids();
			updateProgressBar(0,100);
			
			this._gemSpr.addEventListener(MouseEvent.CLICK, onGemClickHandler);
		}
		
		override public function updateUI():void
		{
			super.updateUI();
			
			if(ClientSetting.local.getIsDone(IsDoneType.AutoBuyGemProp))
			{
				this._autoBuyBox.selected = true;
			}
			else
			{
				this._autoBuyBox.selected = false;
			}
			
			update3DModel();
			
		}
		
		private function onGemClickHandler(e:MouseEvent):void
		{
			if(e.target is GemItem)
			{
				var gemItem:GemItem = e.target as GemItem;
			}
			
			if(!gemItem.itemData || gemItem == _currSelGem)
			{
				return;
			}
			
			if(gemItem.itemData)
			{
				if(_currSelGem)
				{
					_currSelGem.isSelected = false;
				}
				_currSelGem            = gemItem;
				gemItem.isSelected     = true;
				this.canBeStrengthened = true;
				this._gemCurrLevel     = this._currSelGem.itemData.itemInfo.itemLevel;
				updateGemInfo(gemItem.itemData);
				updatePropName();
				update3DModel();
			}
		}
		
		/**
		 * 更新宝石升级面板信息 
		 * @param itemData
		 */		
		public function updateGemInfo(gemItemData:ItemData):void
		{
			var itemInfo:ItemInfo  = ItemConfig.instance.getConfig(gemItemData.itemCode);
			var itemInfo2:ItemInfo = ItemConfig.instance.getConfig(gemItemData.itemCode + 1);
			var gemCurrLevel:int   = itemInfo.itemLevel;
			var currPropValue:int  = itemInfo.effect;// 当前等级的属性值
			if(itemInfo2)
			{
				var nextPropValue:int  = itemInfo2.effect;// 下一等级的属性值
			}
			var currExp:int;// 当前经验
			if(gemItemData.extInfo != null)
			{
				currExp = gemItemData.extInfo.jewelexper;
			}
			else
			{
				currExp = 0;
			}
			var nextLevelNeedExp:int  = itemInfo.effectEx;// 升级总经验
			
			if(gemCurrLevel == ForgingConst.GemMaxLevel)
			{
				nextPropValue = currPropValue;	
			}
			
			if(gemCurrLevel != this._gemCurrLevel)
			{
				MsgManager.showRollTipsMsg("宝石升级成功");
				this._gemCurrLevel = gemCurrLevel;
				addUpEffect();
				update3DModel();
			}
			
			updateProps(currPropValue,nextPropValue);
			updateProgressBar(currExp,nextLevelNeedExp);
			updateGemLevel(gemCurrLevel);
			updateFee(1000);
			
			addStrengEffect();
		}
		
		override public function updateGemList(gemList:Array):void
		{
			for(var i:int = 0; i < gemList.length; i++)
			{
				if(gemList[i] != null)
				{
					this._gemItemArr[i].itemData = gemList[i];
					this._gemItemArr[i].isSelected = false;
				}
				else
				{
					this._gemItemArr[i].clear();
				}
			}
		}
		
		/**
		 * 更新宝石属性名 
		 */		
		private function updatePropName():void
		{
			var type:int = _currSelGem.itemData.itemInfo.type;
			var propName:String = ForgingUtil.instance.getGemPropName(type);
			this._propName.text = propName;
		}
		
		/**
		 * 更新进度条 
		 * @param currValue
		 * @param totalValue
		 * 
		 */		
		public function updateProgressBar(currValue:Number,totalValue:Number):void
		{
			if(totalValue == 0)
			{
				totalValue = ForgingConst.TotalStrengProgress;
				this._maxLevelLabel.visible = true;
			}
			else
			{
				this._maxLevelLabel.visible = false;
			}
			this._progressBar.setValue(currValue,totalValue);
			this._progressPoint.x = this._progressBar.lastWidth - 3;// 设置进度点位置
		}
		
		/**
		 * 更新属性 
		 */		
		public function updateProps(currValue:int,nextValue:int):void
		{
			this._propValue.text = "" + currValue;
			this._upValue.text   = "" + nextValue;
			
			if(currValue == nextValue)// 最大等级时
			{
				this._upArrow.visible = false;
				this._upValue.visible = false;
				this._propName.x      = 99 + 30;
				this._propValue.x     = 155 + 30;
			}
			else
			{
				this._upArrow.visible = true;
				this._upValue.visible = true;
				this._propName.x      = 99;
				this._propValue.x     = 155;
			}
		}
		
		/**
		 * 更新宝石当前等级 
		 */		
		public function updateGemLevel(level:int):void
		{
			if(this._txtGemLevel.visible == false)
			{
				this._txtGemLevel.visible = true;
			}
			this._txtGemLevel.text = "+" + level;
			if(level == ForgingConst.GemMaxLevel)
			{
				canBeStrengthened = false;
				this._txtGemLevel.x = 128;
			}
			else
			{
				this._txtGemLevel.x = 150;
			}
			
			// TODO ======================升级成功缓动显示等级
//			this._gemBmpText.x = 148;
//			this._gemBmpText.y = 45;
//			var tm:TweenMax = TweenMax.to(_gemBmpText, 1, {
//				"x2d":66,
//				"y2d":138,
//				"frameInterval":1,
//				"bezier":[{"y2d":170}, {"y2d":70}],
//				"ease":Linear.easeIn});
		}
		
		/**
		 *　添加宝石升级特效 
		 */		
		private function addUpEffect():void
		{
			var timeLite:TimelineLite = new TimelineLite();
			var originX:int           = this._txtGemLevel.x;
			var originY:int           = this._txtGemLevel.y;
			var newX:int              = this._txtGemLevel.x - 80;
			var newY:int              = this._txtGemLevel.y - 80;
			timeLite.append( new TweenLite(this._txtGemLevel,0.17,{scaleX:5,scaleY:5,x:newX,y:newY}));
			timeLite.append( new TweenLite(this._txtGemLevel,0.17,{scaleX:1,scaleY:1,x:originX,y:originY}));
			timeLite.play();
		}
		
		/**
		 * 更新提示费用 
		 */		
		public function updateFee(value:int):void
		{
			if(value == 0)
			{
				this._upCost.text = "";
			}
			else
			{
				this._upCost.text = "" + value;
			}
		}
		
		public function clear():void
		{
			this._txtGemLevel.visible   = false;
			this._propValue.text        = "";
			this._upValue.text		    = "";
			canBeStrengthened           = false;
			if(this._currSelGem)
			{
				this._currSelGem.isSelected = false;
			}
			this.updateProgressBar(0,ForgingConst.TotalStrengProgress);
			updateFee(0);
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			var data:Object = {};
			if(_currSelGem && _currSelGem.itemData)
			{
				data.uid = this._currSelGem.itemData.serverData.uid;
				if(e.currentTarget == this._commonStrengBtn)
				{
					data.upgradeType = EOperType._EOperTypeSimple;
					Dispatcher.dispatchEvent(new DataEvent(EventName.UpgradeGem,data));
				}
				if(e.currentTarget == this._onKeyStrengBtn)
				{
					data.upgradeType = EOperType._EoperTypeBatch;
					Dispatcher.dispatchEvent(new DataEvent(EventName.UpgradeGem,data));
				}
			}
			if(e.target == this._autoBuyBox)
			{
				if(this._autoBuyBox.selected == true)
				{
					ClientSetting.local.setIsDone(true, IsDoneType.AutoBuyGemProp);
				}
				else
				{
					ClientSetting.local.setIsDone(false, IsDoneType.AutoBuyGemProp);
				}
			}
			
		}
		
		override protected function add3DModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d != null)
			{
				Rect3DManager.instance.windowShowHander(null, _window);
				if(!_leftImg2d)
				{
					if(!bg3d)
					{
						bg3d = GlobalClass.getBitmapData(ImagesConst.GemBgPurple);
					}
					_leftImg2d=new Img2D(null,bg3d,new Rectangle(0, 0,347,413));
				}
				rect3d.addImg(_leftImg2d);
			}	
		}
		
		private function remove3DModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d)
			{
				
				if(_effectPlayer)
				{
					rect3d.removeObj3d(this._effectPlayer);
					_gemPlayer && _effectPlayer.unHang(_gemPlayer,"parent1");
					this._effectPlayer = null;
				}
			
				rect3d.removeObj3d(this._strengEffectPlayer);
				this._strengEffectPlayer = null;
				
				rect3d.removeImg(_leftImg2d);
				this.bg3d        = null;
				this._leftImg2d  = null;
				
				rect3d.removeObj3d(_gemPlayer);
				_gemPlayer = null;
			}
		}
		
		private function addStrengEffect():void
		{
			
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			
			rect3d.removeObj3d(_strengEffectPlayer);
			
			_strengEffectPlayer = EffectPlayerPool.instance.getEffectPlayer(_effectClickPath,rect3d.renderList);

			_strengEffectPlayer.play(false);
			_strengEffectPlayer.addEventListener(Engine3dEventName.PLAYEND,playEndHander);

			rect3d.addObject3d(_strengEffectPlayer,180,215);
		}
		
		private function playEndHander(e:Event):void
		{
			var effect:EffectPlayer=e.currentTarget as EffectPlayer;
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			rect3d.removeObj3d(effect);
		}
		
		protected function updateMeshModel(itemData:ItemData):void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(itemData)
			{
				var gemLevel:int = itemData.itemInfo.itemLevel;
				if(rect3d)
				{
					if(gemLevel <= ForgingConst.GemEffectLevel1)
					{
						_effectPath      = ForgingConst.EffectPath1;
						_effectClickPath = ForgingConst.EffectClickPath1;
					}
					else if(gemLevel <= ForgingConst.GemEffectLevel2)
					{
						_effectPath      = ForgingConst.EffectPath2;
						_effectClickPath = ForgingConst.EffectClickPath2;
					}
					else if(gemLevel <= ForgingConst.GemEffectLevel3)
					{
						_effectPath      = ForgingConst.EffectPath3;
						_effectClickPath = ForgingConst.EffectClickPath3;
					}
					else if(gemLevel <= ForgingConst.GemEffectLevel4)
					{
						_effectPath      = ForgingConst.EffectPath4;
						_effectClickPath = ForgingConst.EffectClickPath4;
					}
					
					_effectPlayer = EffectPlayerPool.instance.getEffectPlayer(_effectPath,rect3d.renderList);
					_effectPlayer.play(true);
					
					var model:TModel = ModelConfig.instance.getInfoByType(itemData.itemInfo.type);
					var color:int    = itemData.itemInfo.color;
					var mesh:String;
					var texTure:String;
					if(model)
					{
						mesh    = model["mesh"+(color-1)];
						texTure = model["texture"+(color-1)];
					}
					_gemPlayer = ObjectPool.getObject(WeaponPlayer);
					_gemPlayer.load(mesh+".mesh",texTure,rect3d.renderList);
					_gemPlayer.hangBoneName = "guazai001";
					_effectPlayer.hang(_gemPlayer,"parent1");
					
					rect3d.addObject3d(_effectPlayer,180,210);
				}
			}
			else
			{
				if(rect3d)
				{
					_effectPlayer = EffectPlayerPool.instance.getEffectPlayer(ForgingConst.EffectPath1,rect3d.renderList);
					_effectPlayer.play(true);
					
					rect3d.addObject3d(_effectPlayer,180,210);
				}
			}
		}

		/**
		 * 更新宝石模型 
		 * @param gemItemData
		 */		
		override public function update3DModel():void
		{
			remove3DModel();
			var gemData:ItemData;
			if(_currSelGem && _currSelGem.itemData)
			{
				gemData = _currSelGem.itemData;
				switch(_currSelGem.itemData.itemInfo.color)
				{
					case EJewelQuality._EJewelQuality1 : 
						bg3d = GlobalClass.getBitmapData(ImagesConst.GemBgGreen);
						break;
					case EJewelQuality._EJewelQuality2 : 
						bg3d = GlobalClass.getBitmapData(ImagesConst.GemBgBlue);
						break;
					case EJewelQuality._EJewelQuality3 : 
						bg3d = GlobalClass.getBitmapData(ImagesConst.GemBgPurple);
						break;
					case EJewelQuality._EJewelQuality4 : 
						bg3d = GlobalClass.getBitmapData(ImagesConst.GemBgOrange);
						break;
				}
				
			}
			add3DModel();
			updateMeshModel(gemData);
		}
		
		/**
		 * 强化按钮是否可用 
		 * @param value
		 */		
		public function set canBeStrengthened(value:Boolean):void
		{
			this._canBeStrengthened = value;
			if(value)
			{
				this._commonStrengBtn.mouseChildren = true;
				this._commonStrengBtn.mouseEnabled  = true;
				this._commonStrengBtn.filters       = null;
				
				this._onKeyStrengBtn.mouseChildren = true;
				this._onKeyStrengBtn.mouseEnabled  = true;
				this._onKeyStrengBtn.filters       = null;
			}
			else
			{
				this._commonStrengBtn.mouseChildren = false;
				this._commonStrengBtn.mouseEnabled  = false;
				this._commonStrengBtn.filters       = [FilterConst.colorFilter2];
				
				this._onKeyStrengBtn.mouseChildren = false;
				this._onKeyStrengBtn.mouseEnabled  = false;
				this._onKeyStrengBtn.filters       = [FilterConst.colorFilter2];
			}
		}
		
		public function set currSelGem(gem:GemItem):void
		{
			this._currSelGem = gem;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			for each(var item:GemItem in _gemItemArr)
			{
				item.dispose(isReuse);
				item = null;
			}
			this._propName.dispose(isReuse);
			this._propValue.dispose(isReuse);
			this._upArrow.dispose(isReuse);
			this._upValue.dispose(isReuse);
			_progressBar.dispose(isReuse);
			_progressPoint.dispose(isReuse);
			this._commonStrengBtn.dispose(isReuse);
			this._onKeyStrengBtn.dispose(isReuse);
			this._upCostLabel.dispose(isReuse);
			this._upCost.dispose(isReuse);
			this._goldIcon.dispose(isReuse);
			this._autoBuyBox.dispose(isReuse);
			_maxLevelLabel.dispose(isReuse);
			_txtGemLevel.dispose(isReuse);
			
			this._propName = null;
			this._propValue = null;
			this._upArrow = null;
			this._upValue = null;
			_progressBar = null;
			_progressPoint = null;
			this._commonStrengBtn = null;
			this._onKeyStrengBtn = null;
			this._upCostLabel = null;
			this._upCost = null;
			this._goldIcon = null;
			this._autoBuyBox = null;
			_maxLevelLabel = null;
			_txtGemLevel = null;
			_currSelGem = null;
			remove3DModel();
		}
	}
}