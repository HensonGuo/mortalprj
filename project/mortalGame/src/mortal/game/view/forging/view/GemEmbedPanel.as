package mortal.game.view.forging.view
{
	import Message.DB.Tables.TModel;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemExInfo;
	import mortal.game.resource.tableConfig.EquipJewelMatchConfig;
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.player.WeaponPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.game.view.forging.renderer.GemEmbedCellRenderer;
	import mortal.game.view.palyer.PlayerEquipItem;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 宝石镶嵌面板
	 * @date   2014-3-27 上午11:20:30
	 * @author dengwj
	 */	 
	public class GemEmbedPanel extends ForgingPanelBase
	{
		/** 底图 */
		private var _gemBg:GBitmap;
		/** 镶嵌图标 */
		private var _embedIcon:GBitmap;
		/** 摘除图标 */
		private var _exciseIcon:GBitmap;
		/** 摘除费用文本 */
		private var _exciseLabel:GTextFiled;
		/** 摘除费用 */
		private var _exciseFee:GTextFiled;
		/** 绑金图标 */
		private var _goldIcon:GBitmap;
		/** 宝石栏底图 */
		private var _gemItemBg:GBitmap;
		/** 宝石列表 */
		private var _gemList:GTileList;
		/** 分页组件 */
		private var _pageSelecter:PageSelecter;
		
		//3D相关
		private var _leftImg2d:Img2D;
		
		private var _effectPlayer:EffectPlayer;
		
		private var _gemPlayer:WeaponPlayer;
		
		private var _effectPath:String;
		
		/** 当前展示的宝石 */
		private var _currShowGemData:ItemData;
		/** 当前镶嵌的宝石 */
		private var _currEmbedGem:GemItem;
		/** 当前摘除的宝石 */
		private var _currExciseGemData:ItemData;
		
		public function GemEmbedPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.addChild(_gemSpr);
			this._gemItemBg = UIFactory.gBitmap(ImagesConst.GemItemBg,5,280-30,this);
			this._embedIcon = UIFactory.gBitmap(ImagesConst.EmbedArrow,5,225,this);
			this._exciseIcon = UIFactory.gBitmap(ImagesConst.ExciseArrow,195,225,this);
			this._exciseLabel = UIFactory.gTextField("",120,256,87,20,this);
			this._exciseLabel.htmlText = "每次<font color='#00ff00'>摘除</font>费用：";
			this._exciseFee = UIFactory.gTextField("1000",202,256,35,20,this);
			this._goldIcon = UIFactory.gBitmap(ImagesConst.Jinbi,234,258,this);
			this._gemList = UIFactory.tileList(18,291,324,92,this);
			_gemList.columnWidth = 42;
			_gemList.rowHeight = 42;
			_gemList.horizontalGap = 4;
			_gemList.verticalGap = 4;
			_gemList.setStyle("skin", new Bitmap());
			_gemList.setStyle("cellRenderer", GemEmbedCellRenderer);
			_gemList.configEventListener(MouseEvent.CLICK, onEmbedClick);
			
			var fm:GTextFormat = GlobalStyle.textFormatBai;
			fm.align = AlignMode.CENTER;
			_pageSelecter = UIFactory.pageSelecter(123,383,this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg,fm);
			_pageSelecter.pageTextBoxSize = 50;
			_pageSelecter.maxPage = 1;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			createGemGrids();
			_gemSpr.addEventListener(MouseEvent.CLICK,onExciseClick);
		}
		
		override public function updateUI():void
		{
			super.updateUI();
			
			var gemList:Array = Cache.instance.pack.backPackCache.getGemByType();
			updateGemInfo(gemList);
			update3DModel();
		}
		
		/**
		 * 单击进行宝石镶嵌 
		 * @param e
		 */		
		private function onEmbedClick(e:MouseEvent):void
		{
			if(e.target is GemItem)
			{
				var gemItem:GemItem = e.target as GemItem;
				if(gemItem.itemData != null)
				{
					this._currEmbedGem = gemItem;
					// 判断是否可镶嵌
					if(judgeEmbed())
					{
						var uidArr:Array   = [gemItem.itemData.uid];
						Dispatcher.dispatchEvent(new DataEvent(EventName.EmbeGem,uidArr));
					}
				}
			}
		}
		
		/**
		 * 成功镶嵌宝石后的处理 
		 */		
		public function onEmbedSuccHandler():void
		{
			//添加镶嵌成功后的闪动滤镜
			if(_currEmbedGem && _currEmbedGem.itemData)
			{
				for each(var gemItem:GemItem in _gemItemArr)
				{
					if(gemItem && gemItem.itemData)
					{
						if(currEmbedGem.itemData.uid == gemItem.itemData.uid)
						{
							gemItem.addShakeLight();
							_currShowGemData = currEmbedGem.itemData;
							update3DModel();
							return;
						}
					}
				}
			}
		}
		
		/**
		 * 单击进行宝石摘除 
		 * @param e
		 */		
		private function onExciseClick(e:MouseEvent):void
		{
			if(e.target is GemItem)
			{
				var gemItem:GemItem = e.target as GemItem;
				if(gemItem.itemData != null)
				{
					_currExciseGemData = gemItem.itemData;
					if(Cache.instance.role.money.coin < ForgingConst.CoinCostOnExcise)
					{
						MsgManager.showRollTipsMsg("铜钱不足");
						return;
					}
					var uidArr:Array = [gemItem.itemData.uid];
					Dispatcher.dispatchEvent(new DataEvent(EventName.RemoveGem,uidArr));
				}
			}
		}
		
		/**
		 * 成功摘除宝石后的处理 
		 */		
		public function onExciseSuccHandler():void
		{
			if(_currExciseGemData && _currShowGemData)
			{
				if(_currExciseGemData.uid == _currShowGemData.uid)
				{
					_currShowGemData = null;
					update3DModel();
				}
			}
		}
		
		/**
		 * 判断宝石是否可镶嵌 
		 * @param gemItem
		 */	
		private function judgeEmbed():Boolean
		{
			var playerEquip:PlayerEquipItem = (GameController.forging.view as ForgingModule).equipDisplaySpr.currSelEquip;
			var gemType:int           		= _currEmbedGem.itemData.itemInfo.type;
			var typeArr:Array        		= EquipJewelMatchConfig.instance.getEquipTypeByJewelType(gemType);
			var equip:PlayerEquipItem 		= (GameController.forging.view as ForgingModule).equipDisplaySpr.getEquipByType(typeArr[0]);
			
			if(playerEquip && playerEquip.itemData)
			{
				if(_currEmbedGem.isUseable)
				{
					return true;
				}
				else
				{
					changeEquip(equip);
					return false;
				}
			}
			else
			{
				changeEquip(equip);
				return false;
			}
		}
		
		/**
		 * 根据宝石切换装备 
		 */		
		private function changeEquip(equip:PlayerEquipItem):void
		{
			(GameController.forging.view as ForgingModule).equipDisplaySpr.currSelEquip = equip;
			if(equip.itemData)
			{
				equip.setSelEffect(true);
				Dispatcher.dispatchEvent(new DataEvent(EventName.AddEquipEmbedGem,equip));	
			}
			else
			{
				MsgManager.showRollTipsMsg("没有此类装备");
			}
		}
		
		private function onPageChange(e:Event):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.GemPage));
		}
		
		/**
		 * 更新镶嵌面板背包中的宝石信息
		 * @param arr
		 */		
		public function updateGemInfo(gemList:Array):void
		{
			var dataProvider:DataProvider = new DataProvider();
			var totalPage:int             = Math.ceil(gemList.length / ForgingConst.PageSize);
			updatePageInfo(totalPage);
			
			var startIndex:int        = (this._pageSelecter.currentPage - 1) * ForgingConst.PageSize;
			var endIndex:int          = (this._pageSelecter.currentPage) * ForgingConst.PageSize;
			var currlist:Array        = gemList.slice(startIndex, endIndex);
			var equip:PlayerEquipItem = (GameController.forging.view as ForgingModule).equipDisplaySpr.currSelEquip;
			var obj:Object;
			var jeweltype:int;// 当前装备对应的宝石类型
			
			if(equip && equip.itemData)
			{
				jeweltype = EquipJewelMatchConfig.instance.getInfoByType(equip.itemData.itemInfo.type).jeweltype;
			}
			
			for each(var gemData:ItemData in currlist)
			{
				obj         = new Object();
				obj.gemData = gemData;
				obj.gemType = jeweltype;
				dataProvider.addItem(obj);
			}
			
			if(currlist.length < ForgingConst.PageSize)
			{
				for(var i:int = 0; i < ForgingConst.PageSize - currlist.length; i++)
				{
					obj = new Object();
					dataProvider.addItem(obj);
				}
			}
			
			_gemList.dataProvider = dataProvider;
			_gemList.drawNow();
		}
		
		/**
		 * 更新镶嵌宝石列表 
		 * @param gemList
		 */		
		override public function updateGemList(gemList:Array):void
		{
			for(var i:int = 0; i < gemList.length; i++)
			{
				if(gemList[i] != null)
				{
					this._gemItemArr[i].itemData = gemList[i];
				}
				else
				{
					this._gemItemArr[i].clear();
				}
			}
		}
		
		/**
		 * 更新分页信息 
		 */		
		public function updatePageInfo(page:int):void
		{
			_pageSelecter.maxPage = page;
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
					_leftImg2d = new Img2D(null,bg3d,new Rectangle(0, 0,347,413));
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

				rect3d.removeImg(_leftImg2d);
				this._leftImg2d = null;
				
				rect3d.removeObj3d(_gemPlayer);
				_gemPlayer = null;
				
			}
		}
		
		protected function updateMeshModel(gemData:ItemData):void
		{
			var rect3d:Rect3DObject = (_window as ForgingModule).rect3d;
			if(gemData)
			{
				var gemLevel:int = gemData.itemInfo.itemLevel;
				if(rect3d)
				{
					if(gemLevel <= ForgingConst.GemEffectLevel1)
					{
						_effectPath = ForgingConst.EffectPath1;
					}
					else if(gemLevel <= ForgingConst.GemEffectLevel2)
					{
						_effectPath = ForgingConst.EffectPath2;
					}
					else if(gemLevel <= ForgingConst.GemEffectLevel3)
					{
						_effectPath = ForgingConst.EffectPath3;
					}
					else if(gemLevel <= ForgingConst.GemEffectLevel4)
					{
						_effectPath = ForgingConst.EffectPath4;
					}
					_effectPlayer = EffectPlayerPool.instance.getEffectPlayer(_effectPath,rect3d.renderList);
					_effectPlayer.play(true);
					
					var model:TModel = ModelConfig.instance.getInfoByType(gemData.itemInfo.type);
					var color:int    = gemData.itemInfo.color;
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
			var equip:PlayerEquipItem = (GameController.forging.view as ForgingModule).equipDisplaySpr.currSelEquip;
			var jeweltype:int;
			
			remove3DModel();
			add3DModel();
			updateMeshModel(_currShowGemData);
			
		}
		
		public function clear():void
		{
			this._currEmbedGem      = null;
			this._currExciseGemData = null;
			this._currShowGemData   = null;
		}
		
		public function get pageSelecter():PageSelecter
		{
			return this._pageSelecter;
		}
		
		public function get currEmbedGem():GemItem
		{
			return this._currEmbedGem;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			for each(var item:GemItem in _gemItemArr)
			{
				item.dispose(isReuse);
				item = null;
			}
			this._embedIcon.dispose(isReuse);
			this._exciseIcon.dispose(isReuse);
			this._exciseLabel.dispose(isReuse);
			this._exciseFee.dispose(isReuse);
			this._goldIcon.dispose(isReuse);
			this._gemItemBg.dispose(isReuse);
			this._gemList.dispose(isReuse);
			_pageSelecter.dispose(isReuse);
			
			this._embedIcon = null;
			this._exciseIcon = null;
			this._exciseLabel = null;
			this._exciseFee = null;
			this._goldIcon = null;
			this._gemItemBg = null;
			this._gemList = null;
			_pageSelecter = null;
			_currShowGemData = null;
			_currEmbedGem = null;
			_currExciseGemData = null;
			remove3DModel();
		}
	}
}