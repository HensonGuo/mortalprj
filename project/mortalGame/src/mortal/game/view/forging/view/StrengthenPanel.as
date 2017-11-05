package mortal.game.view.forging.view
{
	import Message.DB.Tables.TPlayerModel;
	import Message.Game.EOperType;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.PlayerModelConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.GLabelButton;
	import mortal.game.view.common.display.BitmapText;
	import mortal.game.view.common.display.NumberManager;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.game.view.palyer.PlayerEquipItem;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 左侧装备强化面板
	 * @date   2014-3-17 下午2:45:38
	 * @author dengwj
	 */	 
	public class StrengthenPanel extends ForgingPanelBase
	{
		/** 背景底图 */
		private var _strengthenBg:GBitmap;
		/** 极品框 */
		private var _bestGrid:GBitmap;
		/** 当前强化装备 */
		private var _equipItem:PlayerEquipItem;
		/** 极品预览文本 */
		private var _bestPreviewLabel:GBitmap;
		/** 装备评分文本 */
		private var _equipScoreLabel:GTextFiled;
		/** 装备评分 */
		private var _equipScore:GTextFiled;
		/** 装备排行文本 */
		private var _equipRankLabel:GTextFiled;
		/** 装备排行 */
		private var _equipRank:GTextFiled;
		/** 属性背景 */
		private var _propertyBg:GBitmap;
		
		// 属性部分
		/** 物攻文本 */
		private var _attackLabel:GTextFiled;
		/** 物攻值 */
		private var _attack:GTextFiled;
		/** 物攻提升箭头 */
		private var _attackArrow:GBitmap;
		/** 物攻每次强化提升值 */
		private var _attackPerUpValue:GTextFiled;
		/** 物攻总提升值 */
		private var _attackUpValue:GTextFiled;
		
		/** 物暴文本 */
		private var _critLabel:GTextFiled;
		/** 物暴值 */
		private var _crit:GTextFiled;
		/** 物暴提升箭头 */
		private var _critArrow:GBitmap;
		/** 物暴每次强化提升值 */
		private var _critPerUpValue:GTextFiled;
		/** 物暴总提升值 */
		private var _critUpValue:GTextFiled;
		
		/** 精准文本 */
		private var _accurateLabel:GTextFiled;
		/** 精准值 */
		private var _accurate:GTextFiled;
		/** 精准提升箭头 */
		private var _accurateArrow:GBitmap;
		/** 精准每次强化提升值 */
		private var _accuratePerUpValue:GTextFiled;
		/** 精准总提升值 */
		private var _accurateUpValue:GTextFiled;
		
		private var _propLabelArr:Array = [];
		private var _propValueArr:Array = [];
		private var _upValueArr:Array = [];
		
		/** 装备当前强化等级 */
		private var _currStrengLevel:BitmapText;
		/** 装备下级强化等级 */
		private var _nextStrengLevel:BitmapText;
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
		
		public function StrengthenPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			// 上边部分
			this._bestGrid = UIFactory.gBitmap("",8,8,this);
			this._equipItem = new PlayerEquipItem();
			this._equipItem.createDisposedChildren();
			_equipItem.isThrowAble = false;
			this._equipItem.x = 19;
			this._equipItem.y = 19;
			this.addChild(this._equipItem);
			this._bestPreviewLabel = UIFactory.gBitmap("",9,63,this);
			this._equipScoreLabel = UIFactory.gTextField("装备评分：",238,7,61,20,this);
			this._equipScoreLabel.textColor = 0xffc293;
			this._equipScore = UIFactory.gTextField("9999分",298,7,44,20,this);
			this._equipScore.textColor = 0x00ff00;
			this._equipRankLabel = UIFactory.gTextField("装备排行：",238,26,61,20,this);
			this._equipRankLabel.textColor = 0xffc293;
			this._equipRank = UIFactory.gTextField("9999分",298,26,44,20,this);
			this._equipRank.textColor = 0x00ff00;
			this._propertyBg = UIFactory.gBitmap("",15,251,this);
			
			// 属性部分
			this._attackLabel = UIFactory.gTextField("物    攻",99,255,50,20,this);
			this._attackLabel.textColor = 0xffc293;
			this._propLabelArr.push(_attackLabel);
			this._attack = UIFactory.gTextField("",154,255,60,20,this);
			this._propValueArr.push(_attack);
			this._attackArrow = UIFactory.gBitmap(ImagesConst.upgradeArrow,190,258,this);
			this._attackArrow.alpha = 0;
			_attackPerUpValue = UIFactory.gTextField("",200,255,30,20,this);
			_attackPerUpValue.alpha = 0;
			this._attackUpValue = UIFactory.gTextField("",226,255,60,20,this);
			this._attackUpValue.textColor = 0x00ff00;
			this._upValueArr.push(_attackUpValue);
			
			this._critLabel = UIFactory.gTextField("物    暴",99,274,50,20,this);
			this._critLabel.textColor = 0xffc293;
			this._propLabelArr.push(_critLabel);
			this._crit = UIFactory.gTextField("",154,274,60,20,this);
			this._propValueArr.push(_crit);
			_critPerUpValue = UIFactory.gTextField("",200,274,30,20,this);
			_critPerUpValue.alpha = 0;
			this._critArrow = UIFactory.gBitmap(ImagesConst.upgradeArrow,190,277,this);
			this._critArrow.alpha = 0;
			this._critUpValue = UIFactory.gTextField("",226,274,60,20,this);
			this._critUpValue.textColor = 0x00ff00;
			this._upValueArr.push(_critUpValue);
			
			this._accurateLabel = UIFactory.gTextField("精    准",99,292,50,20,this);
			this._accurateLabel.textColor = 0xffc293;
			this._propLabelArr.push(_accurateLabel);
			this._accurate = UIFactory.gTextField("",154,292,60,20,this);
			this._propValueArr.push(_accurate);
			_accuratePerUpValue = UIFactory.gTextField("",200,292,30,20,this);
			_accuratePerUpValue.alpha = 0;
			this._accurateArrow = UIFactory.gBitmap(ImagesConst.upgradeArrow,190,295,this);
			this._accurateArrow.alpha = 0;
			this._accurateUpValue = UIFactory.gTextField("",226,292,60,20,this);
			this._accurateUpValue.textColor = 0x00ff00;
			this._upValueArr.push(_accurateUpValue);
			// 属性部分end
			
			this._currStrengLevel = UICompomentPool.getUICompoment(BitmapText);
			this._currStrengLevel.createDisposedChildren();
			this._currStrengLevel.x = 20;
			this._currStrengLevel.y = 320;
			this._currStrengLevel.visible = false;
			this.addChild(this._currStrengLevel);
			
			this._nextStrengLevel = UICompomentPool.getUICompoment(BitmapText);
			this._nextStrengLevel.createDisposedChildren();
			this._nextStrengLevel.x = 288;
			this._nextStrengLevel.y = 320;
			this._nextStrengLevel.visible = false;
			this.addChild(this._nextStrengLevel);
			
			this._progressBar = UICompomentPool.getUICompoment(BaseProgressBar);
			this._progressBar.setBg(ImagesConst.StrengthenBarBg, true, 214, 5);
			this._progressBar.setProgress(ImagesConst.StrengthenBar, true, 0, 0, 214, 5);
			this._progressBar.setLabel(BaseProgressBar.ProgressBarTextNone, 20, -2, 60, 12);
			this._progressBar.setValue(0, 10000);
			this._progressBar.x = 68;
			this._progressBar.y = 331;
			this.addChild(this._progressBar);
			
			this._progressPoint = UIFactory.gBitmap(ImagesConst.StrengthenBarPoint,0,-5,_progressBar);
			updateProgressBar(0,100);
			
			this._commonStrengBtn = UIFactory.gLabelButton(null, GLabelButton.gLoadedButton, ImagesConst.RedButton_upSkin, 80, 349, 93, 30, this);
			this._onKeyStrengBtn = UIFactory.gLabelButton(null, GLabelButton.gLoadedButton, ImagesConst.RedButton_upSkin, 181, 349, 93, 30, this);
			this._commonStrengBtn.configEventListener(MouseEvent.CLICK,onClickHandler);
			this._onKeyStrengBtn.configEventListener(MouseEvent.CLICK,onClickHandler);
			
			this._upCostLabel = UIFactory.gTextField("本次提升费用：",27,387,87,20,this);
			this._upCost = UIFactory.gTextField("",111,387,40,20,this);
			this._upCost.textColor = 0xffc293;
			this._goldIcon = UIFactory.gBitmap(ImagesConst.Jinbi_bind,143,390,this);
			this._autoBuyBox = UIFactory.checkBox("道具不足，自动购买",194,383,140,28,this);
			this._autoBuyBox.configEventListener(MouseEvent.CLICK, onClickHandler);
			
			this.canBeStrengthened = false;
		}
		
		/** 更新界面 */
		override public function updateUI():void
		{
			super.updateUI();
			
			this._bestGrid.bitmapData         = GlobalClass.getBitmapData(ImagesConst.StrengSpecialGrid);
			this._bestPreviewLabel.bitmapData = GlobalClass.getBitmapData(ImagesConst.StrengBestPreview);
			this._propertyBg.bitmapData       = GlobalClass.getBitmapData(ImagesConst.StrengPropBg);
			this._commonStrengBtn.label       = ImagesConst.StrengCommon;
			this._onKeyStrengBtn.label        = ImagesConst.StrengOneKey;
			
			if(ClientSetting.local.getIsDone(IsDoneType.AutoBuyStrengProp))
			{
				this.autoBuyBox.selected = true;
			}
			else
			{
				this.autoBuyBox.selected = false;
			}
			
			add3DModel();
		}
		
		/**
		 * 更新进度条 
		 * @param currValue  当前进度值
		 * @param totalValue 总进度值
		 */
		public function updateProgressBar(currValue:Number,totalValue:Number):void
		{
			this._progressBar.setValue(currValue,totalValue);
			this._progressPoint.x = this._progressBar.lastWidth - 3;// 设置进度点位置
			
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			var data:Object = {};
			if(this._equipItem.itemData != null)
			{
				data.uid = this._equipItem.itemData.uid;
				if(e.currentTarget == this._commonStrengBtn)
				{
					data.strengType = EOperType._EOperTypeSimple;
					Dispatcher.dispatchEvent(new DataEvent(EventName.EquipStrengthen,data));
				}
				if(e.currentTarget == this._onKeyStrengBtn)
				{
					data.strengType = EOperType._EoperTypeBatch;
					Dispatcher.dispatchEvent(new DataEvent(EventName.EquipStrengthen,data));
				}
			}
			if(e.target == this._autoBuyBox)
			{
				if(this._autoBuyBox.selected == true)
				{
					ClientSetting.local.setIsDone(true, IsDoneType.AutoBuyStrengProp);
				}
				else
				{
					ClientSetting.local.setIsDone(false, IsDoneType.AutoBuyStrengProp);
				}
			}
		}
		
		/**
		 * 缓动显示提升值 
		 * @param value 要显示的提升值集合
		 */
		public function displayUpValue(value:Array):void
		{
			if(value != null)
			{
				
				if(value[0] != 0)
				{
					this._attackPerUpValue.text = value[0] + "";
					TweenLite.to(this._attackArrow, 0.5, {alpha:1, ease:Linear.easeNone,onComplete:onShowEnd,onCompleteParams:[0]});
					TweenLite.to(this._attackPerUpValue, 0.5, {alpha:1, ease:Linear.easeNone,onComplete:onShowEnd,onCompleteParams:[0]});
				}
				if(value[1] != 0)
				{
					this._critPerUpValue.text = value[1] + "";
					TweenLite.to(this._critArrow, 0.5, {alpha:1, ease:Linear.easeNone,onComplete:onShowEnd,onCompleteParams:[1]});
					TweenLite.to(this._critPerUpValue, 0.5, {alpha:1, ease:Linear.easeNone,onComplete:onShowEnd,onCompleteParams:[1]});
				}
				if(value[2] != 0)
				{
					this._accuratePerUpValue.text = value[2] + "";
					TweenLite.to(this._accurateArrow, 0.5, {alpha:1, ease:Linear.easeNone,onComplete:onShowEnd,onCompleteParams:[2]});
					TweenLite.to(this._accuratePerUpValue, 0.5, {alpha:1, ease:Linear.easeNone,onComplete:onShowEnd,onCompleteParams:[2]});
				}
			}
			
		}
		
		private function onShowEnd(value:int):void
		{
			switch(value)
			{
				case 0:
					TweenLite.to(this._attackArrow, 0.5, {alpha:0, ease:Linear.easeNone});
					TweenLite.to(this._attackPerUpValue, 0.5, {alpha:0, ease:Linear.easeNone});
					break;
				case 1:
					TweenLite.to(this._critArrow, 0.5, {alpha:0, ease:Linear.easeNone});
					TweenLite.to(this._critPerUpValue, 0.5, {alpha:0, ease:Linear.easeNone});
					break;
				case 2:
					TweenLite.to(this._accurateArrow, 0.5, {alpha:0, ease:Linear.easeNone});
					TweenLite.to(this._accuratePerUpValue, 0.5, {alpha:0, ease:Linear.easeNone});
					break;
			}
		}
		
		/**
		 * 添加装备到预览框 
		 * @param equip 角色装备
		 */		
		public function addStrengEquip(equip:PlayerEquipItem):void
		{
			this._equipItem.itemData = equip.itemData;
		}
		
		/**
		 * 更新装备属性 
		 * @param itemEquip 装备物品
		 */
		public function updateEquipProp(propArr:Array):void
		{
			for(var i:int = 0; i < propArr.length; i++)
			{
				_propLabelArr[i].text = propArr[i].propName;
				_propValueArr[i].text = propArr[i].propValue;
				_upValueArr[i].text   = "(" + propArr[i].propUpValue + ")";
			}
		}
		
		/**
		 * 更新强化等级显示
		 * @param level 当前强化等级
		 * 
		 */		
		public function updateStrengthenLevel(level:int):void
		{
			if(level == -1)// 重置强化UI
			{
				this._currStrengLevel.visible = false;
				this._nextStrengLevel.visible = false;
			}
			else if(level == 0)
			{
				this._currStrengLevel.visible = false;
				this._nextStrengLevel.visible = true;
				this._nextStrengLevel.setFightNum(NumberManager.COLOR3,"+" + 1,5);
			}
			else
			{
				if(level < 12)
				{
					var nextLevel:int = level + 1;
					this._currStrengLevel.visible = true;
					this._nextStrengLevel.visible = true;
					this._currStrengLevel.setFightNum(NumberManager.COLOR3,"+" + level,5);
					this._nextStrengLevel.setFightNum(NumberManager.COLOR3,"+" + nextLevel,5);
				}
				else
				{
					this._currStrengLevel.visible = true;
					this._nextStrengLevel.visible = false;
					this._currStrengLevel.setFightNum(NumberManager.COLOR3,"+" + level,5);
				}
			}
		}
		
		/**
		 * 更新本次强化费用 
		 * @param money 
		 */		
		public function updateStrengthenFee(money:int):void
		{
			if(money == 0)
			{
				this._upCost.text = "";				
			}
			else
			{
				this._upCost.text = "" + money;
			}
		}
		
		/**
		 * 更新装备评分 
		 */		
		public function updateEquipScore():void
		{
			// TODO =======================更新装备评分
		}

		/**
		 * 更新装备排行 
		 */		
		public function updateEquipRank():void
		{
			// TODO =======================更新装备排行
		}
		
		/**
		 * 强化按钮是否可用 
		 * @param value
		 */		
		public function set canBeStrengthened(value:Boolean):void
		{
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
		
		/**
		 * 重置UI 
		 */		
		public function clearUI():void
		{
			for each(var tf:GTextFiled in this._propValueArr)
			{
				tf.text = "";				
			}
			for each(tf in this._upValueArr)
			{
				tf.text = "";				
			}
			this._equipRank.text = "";
			this._equipScore.text = "";
			this.updateProgressBar(0,ForgingConst.TotalStrengProgress);
			this.updateStrengthenLevel(-1);
			this.updateStrengthenFee(0);
			this.canBeStrengthened = false;
		}
		
		private var _leftImg2d:Img2D;
		
		override protected function add3DModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d != null)
			{
				Rect3DManager.instance.windowShowHander(null, _window);
				
				rect3d.removeImg(_leftImg2d);
				
				var bmpdata:BitmapData = GlobalClass.getBitmapData(ImagesConst.forgingEquipBg);
				_leftImg2d=new Img2D(null,bmpdata,new Rectangle(0, 0,347,413));
				rect3d.addImg(_leftImg2d);
			}
		}
		
		private function remove3DModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d)
			{
				if(_leftImg2d)
				{
					rect3d.removeImg(_leftImg2d);
					this._leftImg2d  = null;
				}
				if(_bodyPlayer)
				{
					rect3d.removeObj3d(this._bodyPlayer);
					this._bodyPlayer = null;
				}
			}
		}
		
		private var _bodyPlayer:ActionPlayer;
		public function updateModel():void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(rect3d)
			{
				var model:TPlayerModel = PlayerModelConfig.instance.getClothesModel(0,Cache.instance.role.entityInfo.sex,Cache.instance.role.entityInfo.career);
				var meshUrl:String=model.mesh + ".md5mesh";
				var boneUrl:String=model.bone + ".skeleton";
				var textureUrl:String=model.texture;
				if(_bodyPlayer && _bodyPlayer.meshUrl==meshUrl && _bodyPlayer.animUrl==boneUrl)
				{
					return;
				}
				_bodyPlayer = ObjectPool.getObject(ActionPlayer);
				_bodyPlayer.changeAction(ActionName.FightRun);
				_bodyPlayer.hangBoneName = "guazai001";
				_bodyPlayer.selectEnabled = true;
				_bodyPlayer.play();
				_bodyPlayer.setRotation(0, 0, 0);
				_bodyPlayer.scaleX = _bodyPlayer.scaleY = _bodyPlayer.scaleZ = 1.7;
				_bodyPlayer.load(meshUrl, boneUrl, model.texture,rect3d.renderList);
//				rect3d.addObject3d(_bodyPlayer,180,330-45);
			}
		}
		
		public function get equipItem():PlayerEquipItem
		{
			return this._equipItem;
		}
		
		public function get autoBuyBox():GCheckBox
		{
			return this._autoBuyBox;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			this._bestGrid.dispose(isReuse);
			this._equipItem.dispose(isReuse);
			this._bestPreviewLabel.dispose(isReuse);
			this._equipScoreLabel.dispose(isReuse);
			this._equipScore.dispose(isReuse);
			this._equipRankLabel.dispose(isReuse);
			this._equipRank.dispose(isReuse);
			this._propertyBg.dispose(isReuse);
			this._attackLabel.dispose(isReuse);
			this._attack.dispose(isReuse);
			this._attackArrow.dispose(isReuse);
			this._attackUpValue.dispose(isReuse);
			this._critLabel.dispose(isReuse);
			this._crit.dispose(isReuse);
			this._critArrow.dispose(isReuse);
			this._critUpValue.dispose(isReuse);
			this._accurate.dispose(isReuse);
			this._accurateArrow.dispose(isReuse);
			this._accurateLabel.dispose(isReuse);
			this._accurateUpValue.dispose(isReuse);
			this._currStrengLevel.dispose(isReuse);
			this._nextStrengLevel.dispose(isReuse);
			this._progressBar.dispose(isReuse);
			this._progressPoint.dispose(isReuse);
			this._commonStrengBtn.dispose(isReuse);
			this._onKeyStrengBtn.dispose(isReuse);
			this._upCostLabel.dispose(isReuse);
			this._upCost.dispose(isReuse);
			this._goldIcon.dispose(isReuse);
			this._autoBuyBox.dispose(isReuse);
			_attackPerUpValue.dispose(isReuse);
			_critPerUpValue.dispose(isReuse);
			_accuratePerUpValue.dispose(isReuse);
			
			this._bestGrid = null;
			this._equipItem = null;
			this._bestPreviewLabel = null;
			this._equipScoreLabel = null;
			this._equipScore = null;
			this._equipRankLabel = null;
			this._equipRank = null;
			this._propertyBg = null;
			this._attackLabel = null;
			this._attack = null;
			this._attackArrow = null;
			this._attackUpValue = null
			this._critLabel = null;
			this._crit = null;
			this._critArrow = null;
			this._critUpValue = null;
			this._accurate = null;
			this._accurateArrow = null;
			this._accurateLabel = null;
			this._accurateUpValue = null;
			this._currStrengLevel = null;
			this._nextStrengLevel = null;
			this._progressBar = null;
			this._progressPoint = null;
			this._commonStrengBtn = null;
			this._onKeyStrengBtn = null;
			this._upCostLabel = null;
			this._upCost = null;
			this._goldIcon = null;
			this._autoBuyBox = null;
			_attackPerUpValue = null;
			_critPerUpValue = null;
			_accuratePerUpValue = null;
			this._propLabelArr = [];
			this._propValueArr = [];
			this._upValueArr = [];
			remove3DModel();
		}
	}
}