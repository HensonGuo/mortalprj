package mortal.game.view.pet.view
{
	import Message.Public.ELotteryType;
	import Message.Public.SLotteryHistory;
	
	import com.gengine.core.IDispose;
	import com.gengine.debug.Log;
	import com.mui.controls.Alert;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class PetFreshSkillBookPanel extends BaseWindow
	{
		private static var _instance:PetFreshSkillBookPanel;
		private var _isLoadComplete:Boolean = false;
		
		private var _bg:GBitmap;
		
		private var _btnFreeFresh:GLoadingButton;
		private var _txtFreeFreshCost:GTextFiled;
		private var _bmpLabelFreeFresh:GBitmap;
		private var _btnSingleFresh:GLoadingButton;
		private var _txtSingleFresh:GTextFiled;
		private var _bmpLabelSingleFresh:GBitmap;
		private var _btnBatchFresh:GLoadingButton;
		private var _txtBatchFresh:GTextFiled;
		private var _bmpLabelBatchFresh:GBitmap;
		
		private var _checkBoxUseBindGold:GCheckBox;
		
		private var _txtFreshCount:GTextFiled;
		private var _bmpFreshCount:BitmapNumberText;
		private var _txtWarn:GTextFiled;
		private var _bgFreshStar:ScaleBitmap;
		
		//records
		private var _bgRecordTitle:ScaleBitmap;
		private var _bgRecordTitleLabel:GBitmap;
		private var _bgRecord:ScaleBitmap;
		private var _scrollPane:GScrollPane;
		private var _scrollContainer:GSprite;
		private var _txtRecords:GTextFiled;
		
		//skill books
		private var _bookCell1:BaseItem;
		private var _bookCell2:BaseItem;
		private var _bookCell3:BaseItem;
		private var _bookCell4:BaseItem;
		private var _bookCell5:BaseItem;
		private var _bookCell6:BaseItem;
		private var _bookCell7:BaseItem;
		private var _bookCell8:BaseItem;
		private var _bookCell9:BaseItem;
		private var _bookCell10:BaseItem;
		
		
		private var _starList:Vector.<GBitmap> = new Vector.<GBitmap>();
		
		public function PetFreshSkillBookPanel($layer:ILayer=null)
		{
			super($layer);
			title = "宠物";
			titleIcon = ImagesConst.PackIcon;
			setSize(754,568);
		}
		
		public static function get instance():PetFreshSkillBookPanel
		{
			if(!_instance)
			{
				_instance = new PetFreshSkillBookPanel();
			}
			return _instance;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			LoaderHelp.addResCallBack(ResFileConst.petFreshSkill,layoutUI);
		}
		
		private function layoutUI():void
		{
			_isLoadComplete = true;
			_bg = UIFactory.gBitmap(ImagesConst.petFreshSkillBg, 16, 42, this);
			_btnFreeFresh = UIFactory.gLoadingButton("petBatchFreshSkill", 102, 485, 111, 60, this);
			_txtFreeFreshCost = UIFactory.gTextField("[每日一次]", 129, 515, 60, 60, this);
			_txtFreeFreshCost.mouseEnabled = false;
			_bmpLabelFreeFresh = UIFactory.gBitmap(ImagesConst.petFreeFresh, 128, 500, this);
			_btnSingleFresh = UIFactory.gLoadingButton("petBatchFreshSkill", 220, 485, 111, 60, this);
			_txtSingleFresh = UIFactory.gTextField("[10元宝]", 247, 515, 56, 60, this);
			_txtSingleFresh.mouseEnabled = false;
			_bmpLabelSingleFresh = UIFactory.gBitmap(ImagesConst.petSingleFresh, 246, 500, this);
			_btnBatchFresh = UIFactory.gLoadingButton("petBatchFreshSkill", 338, 485, 111, 60, this);
			_txtBatchFresh = UIFactory.gTextField("[95元宝]", 369, 515, 56, 60, this);
			_txtBatchFresh.mouseEnabled = false;
			_bmpLabelBatchFresh = UIFactory.gBitmap(ImagesConst.petBatchFresh, 362, 500, this);
			
			_checkBoxUseBindGold = UIFactory.checkBox("绑定元宝", 460, 517, 74, 25, this);
			
			_bgFreshStar = UIFactory.bg(168, 434, 218, 32, this, ImagesConst.Menu_overSkin);
			var txtFmt:GTextFormat = GlobalStyle.textFormatLightChen;
			txtFmt.size = 14;
			_txtFreshCount = UIFactory.gTextField("解封次数：", 217, 410, 70, 22, this, txtFmt);
			_txtWarn = UIFactory.gTextField("注：每次只能解封一次，请谨慎操作！", 177, 470, 200, 20, this, GlobalStyle.textFormatItemGreen);
			_bmpFreshCount = UIFactory.bitmapNumberText(289, 416, "EquipmentTipsNumber.png", 16, 16, -5,  this);
			
			_bgRecord = UIFactory.bg(540, 42, 202, 512, this);
			_bgRecordTitle = UIFactory.bg(540, 42, 202, 26, this, ImagesConst.RegionTitleBg);
			_bgRecordTitleLabel = UIFactory.gBitmap(ImagesConst.petFreshSkillRecord, 548, 50, this);
			
			
			_bookCell1 = UIFactory.getUICompoment(BaseItem,88,380,this);
			_bookCell1.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell1.buttonMode = true;
			_bookCell2 = UIFactory.getUICompoment(BaseItem,55,288,this);
			_bookCell2.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell2.buttonMode = true;
			_bookCell3 = UIFactory.getUICompoment(BaseItem,33,195,this);
			_bookCell3.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell3.buttonMode = true
			_bookCell4 = UIFactory.getUICompoment(BaseItem,92,115,this);
			_bookCell4.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell4.buttonMode = true
			_bookCell5 = UIFactory.getUICompoment(BaseItem,182,56,this);
			_bookCell5.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell5.buttonMode = true
			_bookCell6 = UIFactory.getUICompoment(BaseItem,298,56,this);
			_bookCell6.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell6.buttonMode = true
			_bookCell7 = UIFactory.getUICompoment(BaseItem,390,115,this);
			_bookCell7.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell7.buttonMode = true
			_bookCell8 = UIFactory.getUICompoment(BaseItem,448,195,this);
			_bookCell8.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell8.buttonMode = true
			_bookCell9 = UIFactory.getUICompoment(BaseItem,425,288,this);
			_bookCell9.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell9.buttonMode = true
			_bookCell10 = UIFactory.getUICompoment(BaseItem,392,380,this);
			_bookCell10.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_bookCell10.buttonMode = true
			
			
			for(var i:int = 0; i < 10; i++)
			{
				var x:int = 178 + 20.5 * i;
				var y:int = 440;
				var star:GBitmap = UIFactory.gBitmap(ImagesConst.star, x, y, this);
				_starList.push(star);
			}
			
			
			_scrollContainer = UICompomentPool.getUICompoment(GSprite);
			
			_txtRecords = UIFactory.gTextField("", 0, 0, 190, 488, _scrollContainer, null, true);
			_txtRecords.multiline = true;
			_txtRecords.wordWrap = true;
			
			_scrollPane = UICompomentPool.getUICompoment(GScrollPane);
			_scrollPane.verticalScrollBarPos = GScrollPane.SCROLLBARPOSITIONRIGHT;
			_scrollPane.width = 200;
			_scrollPane.height = 485;
			_scrollPane.x = 542;
			_scrollPane.y = 68;
			_scrollPane.styleName = "GScrollPane";
			_scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
			_scrollPane.verticalScrollPolicy = ScrollPolicy.ON;
			_scrollPane.source = _scrollContainer;
			_scrollPane.mouseEnabled = false;
			(_scrollPane.content as DisplayObjectContainer).mouseEnabled = false;
			this.addChild(_scrollPane);
			_scrollContainer.parent.mouseEnabled = false;
			_scrollPane.update();
			
			update();
			
			configEventListener(MouseEvent.CLICK, onMouseClick);
			NetDispatcher.addCmdListener(ServerCommand.PetFreshSkillBook,update);
			NetDispatcher.addCmdListener(ServerCommand.PetGetSkillBook,onGetSkillBook);
			NetDispatcher.addCmdListener(ServerCommand.BackpackDataChange,update);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemsChange,update);
			NetDispatcher.addCmdListener(ServerCommand.Lottery_Record_Update,update);
		}
		
		public function update(obj:* = null):void
		{
			if (!_isLoadComplete)
				return;
			//刷新次数
			var freshCount:int = _shouHunShi.extInfo == null ? 0 : _shouHunShi.extInfo.petSkillRandTime;
			_bmpFreshCount.text = freshCount.toString();
			
			//10个技能书格子
			var items:Array = _shouHunShi.extInfo == null ? [] : _shouHunShi.extInfo.petSkillRandItem.split("#");
			if (items.length > 10)
			{
				Log.error("长度不对" +  _shouHunShi.extInfo.petSkillRandItem + "，后端请检查");
			}
			for (var i:int = 1; i <= 10; i++)
			{
				var cell:BaseItem = this["_bookCell" + i];
				var code:int = items.length > i - 1 ? items[i - 1] : 0;
				if (code != 0)
				{
					cell.itemCode = code;
				}
				else
				{
					cell.itemData = null;
				}
			}
			
			//星星
			var starNum:Number = freshCount > 0 ? GameDefConfig.instance.getPetSkillBookFreshStarNum(freshCount) : 0;
			
			for(i = 0; i < 10; i++)
			{
				var star:GBitmap = _starList[i];
				if ((i + 1) - starNum == 0.5)
				{
					star.bitmapData = GlobalClass.getBitmapData(ImagesConst.star_half_gray);
				}
				else if (starNum < i + 1)
				{
					star.bitmapData = GlobalClass.getBitmapData(ImagesConst.star_gray);
				}
				else
				{
					star.bitmapData = GlobalClass.getBitmapData(ImagesConst.star);
				}
			}
			
			//刷新纪录
			var html:String = "";
			var records:Vector.<SLotteryHistory> = Cache.instance.lottery.getRecordList(ELotteryType._ELotteryPetSkillRand);
			if (records == null)
			{
				return;
			}
			for (i = 0; i < records.length; i ++)
			{
				var record:SLotteryHistory = records[i];
				html += "<font color='#ff0099'>传闻：</font>" + 
					"<a href='event:queryPlayerInfo' target = ''><font color='#00ff00'><u>" + record.player.name + "</u></font></a>" + 
					"<font color='#ffffff'>打发神威，解封了</font>" + 
					"<a href='event:queryItemInfo' target = ''><font color='#ff6600'><u>顶级散杀</u></font></a>" + 
					"<font color='#ffffff'>真是可喜可贺</font><br><br>";
			}
			_txtRecords.htmlText = html;
			
			_btnFreeFresh.enabled = Cache.instance.pet.canFreeFreshSkill;
			_btnFreeFresh.filters = Cache.instance.pet.canFreeFreshSkill ? null : [FilterConst.colorFilter]
		}
		
		
		//兽魂石
		private var _shouHunShi:ItemData;
		public function setData(data:ItemData):void
		{
			_shouHunShi = data;
			update();
		}
		
		private function onMouseClick(even:MouseEvent):void
		{
			//技能刷新
			var freshSkill:Boolean = false;
			var obj:Object = null;
			switch(even.target)
			{
				case _btnFreeFresh:
					obj = new Object();
					obj.itemuid = _shouHunShi.serverData.uid;
					obj.times = 1;
					obj.onlyUseBindGold = _checkBoxUseBindGold.selected;
					obj.isFree = true;
					freshSkill = true;
					break;
				case _btnSingleFresh:
					obj = new Object();
					obj.itemuid = _shouHunShi.serverData.uid;
					obj.times = 1;
					obj.onlyUseBindGold = _checkBoxUseBindGold.selected;
					obj.isFree = false;
					freshSkill = true;
					break;
				case _btnBatchFresh:
					obj = new Object();
					obj.itemuid = _shouHunShi.serverData.uid;
					obj.times = 10;
					obj.onlyUseBindGold = _checkBoxUseBindGold.selected;
					obj.isFree = false;
					freshSkill = true;
					break;
			}
			if (freshSkill)
			{
				if (hasHighestLevelSkillBook())
				{
					var callback:Function = function(type:int):void
					{
						if(type == Alert.OK)
						{
							Dispatcher.dispatchEvent(new DataEvent(EventName.PetFreshSkillBook, obj));
						}
					};
					var html:String = "<font color='#ffffff'>兽魂石已获得</font><font color='#ff6600'>顶级技能</font><font><font color='#ffffff'>，确定继续刷新吗？</font>";
					Alert.show(html, null, Alert.OK|Alert.CANCEL, null, callback);
				}
				else
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.PetFreshSkillBook, obj));
				}
			}
				
				
			//解封技能
			if (even.target is BaseItem)
			{
				var book:BaseItem = even.target as BaseItem;
				if (book.itemData == null)
					return;
				callback = function(type:int):void
				{
					if(type == Alert.OK)
					{
						obj = new Object();
						obj.itemuid = _shouHunShi.serverData.uid; 
						obj.skillBookCode = book.itemData.itemInfo.code;
						Dispatcher.dispatchEvent(new DataEvent(EventName.PetGetSkillBook, obj));
					}
				};
				html = "<font color='#ffffff'>确认解封</font><font color='#00ff00'>" + book.itemData.name + "</font>" + 
					"<font><font color='#ffffff'>吗？</font><br>" + 
					"<font color='#ff0000'>注：解封技能不可逆，请谨慎操作</font>"
				Alert.show(html, null, Alert.OK|Alert.CANCEL, null, callback);
			}
		}
		
		private function hasHighestLevelSkillBook():Boolean
		{
			var items:Array = _shouHunShi.extInfo == null ? [] : _shouHunShi.extInfo.petSkillRandItem.split("#");
			for (var i:int = 0; i < items.length; i++)
			{
				var info:ItemInfo = ItemConfig.instance.getConfig(items[i]);
				if (info == null)
				{
					continue;
				}
				//顶级技能的等级是4
				if (info.itemLevel == 4)
				{
					return true;
				}
			}
			return false;
		}
		
		private function onGetSkillBook(obj:* = null):void
		{
			hide();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_isLoadComplete = false;
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			NetDispatcher.removeCmdListener(ServerCommand.PetFreshSkillBook,update);
			NetDispatcher.removeCmdListener(ServerCommand.PetGetSkillBook,onGetSkillBook);
			NetDispatcher.removeCmdListener(ServerCommand.BackpackDataChange,update);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackItemsChange,update);
			NetDispatcher.removeCmdListener(ServerCommand.Lottery_Record_Update,update);
			_starList.length = 0;
			
			var targetIndex:int = 0;
			while(this.numChildren > 0)
			{
				var child:DisplayObject = this.getChildAt(targetIndex);
				if (child is IDispose)
				{
					(child as IDispose).dispose(true);
					child = null;
				}
				else
					targetIndex ++;
				if (targetIndex == this.numChildren - 1)
					break;
			}
		}
		
	}
}
