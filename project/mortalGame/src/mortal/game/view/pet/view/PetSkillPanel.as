package mortal.game.view.pet.view
{
	import Message.Game.SPet;
	import Message.Public.EAdvanceType;
	import Message.Public.EGroup;
	import Message.Public.EProp;
	import Message.Public.EPropType;
	import Message.Public.EStuff;
	
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.controls.GTabBar2;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.PetConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.panel.SkillItem;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class PetSkillPanel extends PetPanelBase
	{
		private static const CELL_SKILL_BOOK_COUNT:int = 14;
		private static const CELL_SKILL_COUNT:int = 8;
		private var _talentSkill:SkillItem;//天赋技能
		private var _skillCellList:Vector.<SkillItem> = new Vector.<SkillItem>();
		private var _skillBookCellList:Vector.<BaseItem> = new Vector.<BaseItem>();
		
		//middle lay skill book for learn
		private var _btnLearnSkill:GButton;
		private var _txtSkillBookName:GTextFiled;
		private var _baseItemSkillBookForLearn:BaseItem;
		
		private var _bookForLearnCode:int;
		
		//right
		private var _tabBarSkillBook:GTabBar2;
		private var _pageSelecter:PageSelecter;
		
		
		public function PetSkillPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			LoaderHelp.addResCallBack(ResFileConst.petSkill,layoutUI);
		}
		
		private function layoutUI():void
		{
			_isLoadComplete = true;
			//bg
			UIFactory.gBitmap(ImagesConst.petSkillBg, 185, 69, this);
			
			_talentSkill = UIFactory.getUICompoment(SkillItem,266,110,this);
			_talentSkill.setSize(42, 42);
			_talentSkill.setBg(ImagesConst.PackItemBg);
			
			for (var i:int = 0; i < CELL_SKILL_BOOK_COUNT; i++)
			{
				var x:int = 212 + 50*(i % 7);
				var y:int = i > 6 ? 434 : 390;
				var item:BaseItem = UIFactory.getUICompoment(BaseItem,x,y,this);
				item.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,2,3);
				item.configEventListener(MouseEvent.CLICK, onSelectBookForLearn);
				_skillBookCellList.push(item);
			}
			
			for (var j:int = 0; j < CELL_SKILL_COUNT; j++)
			{
				x = 364 + 50 * (j % 4)
				y = j > 3 ? 133 : 84;
				var skillItem:SkillItem = UIFactory.getUICompoment(SkillItem, x, y, this);
				skillItem.setSize(42, 42);
				skillItem.setBg(ImagesConst.PackItemBg);
				_skillCellList.push(skillItem);
			}
			
			var skillIntroLink:String = "<a href='event:myGuildLink' target = ''><font color='#00ff00'><u>技能图鉴</u></font></a>";
			UIFactory.gTextField(skillIntroLink, 188, 73, 56, 20, this, null, true);
			
			_btnLearnSkill = UIFactory.gButton("学习技能",335,313,90,30,this,"RedButton");
			_btnLearnSkill.configEventListener(MouseEvent.CLICK, learnSkill);
			var txtFmt:GTextFormat = GlobalStyle.textFormatJiang;
			txtFmt.size = 14;
			txtFmt.align = "center";
			_txtSkillBookName = UIFactory.gTextField("技能名称", 336, 277, 90, 24, this, txtFmt);
			
			_baseItemSkillBookForLearn = UIFactory.getUICompoment(BaseItem,346,211,this);
			_baseItemSkillBookForLearn.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,5,5);
			_baseItemSkillBookForLearn.configEventListener(MouseEvent.CLICK, unSelectBookForLearn);
			
			UIFactory.bg(580, 68, 174, 415, this);
			UIFactory.bg(580, 68, 174, 26, this, ImagesConst.RegionTitleBg);
			txtFmt = GlobalStyle.textFormatItemWhite;
			txtFmt.size = 14;
			UIFactory.gTextField("获取更多宠物书", 586, 69, 110, 24, this, txtFmt);
			
			_tabBarSkillBook = UICompomentPool.getUICompoment(GTabBar2);
			_tabBarSkillBook.cellRenderer = PetSkillBookCellRenderer;
			_tabBarSkillBook.gap = 2;
			_tabBarSkillBook.cellWidth = 158;
			_tabBarSkillBook.cellHeight = 71;
			_tabBarSkillBook.direction = GBoxDirection.VERTICAL;
			_tabBarSkillBook.x = 584;
			_tabBarSkillBook.y = 94;
			this.addChild(_tabBarSkillBook);
			
			//page handler
			var textFormat1:GTextFormat = GlobalStyle.textFormatBai;
			textFormat1.align = "center";
			_pageSelecter = UIFactory.pageSelecter(610, 463, this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , textFormat1);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 45;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			updateMsg(_pet);
			
			NetDispatcher.addCmdListener(ServerCommand.BackpackDataChange,onPackChange);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemsChange,onPackChange);
			NetDispatcher.addCmdListener(ServerCommand.PetSkillUpdate,onSkillUpdate);
		}
		
		protected function onSkillUpdate(obj:Object):void
		{
			updateMsg(_pet);
		}
		
		
		override public function updateMsg(pet:SPet):void
		{
			super.updateMsg(pet);
			if (!_isLoadComplete)
				return;
			
			//right
			updateRightPage(_pageSelecter.currentPage);
			
			//刷新技能书格子
			var bookList:Array = Cache.instance.pack.backPackCache.getItemsByCategoryAndType(EGroup._EGroupStuff, EStuff._EStuffAdvance, EAdvanceType._EAdvanceTypePet);
			for (var j:int = 0; j < CELL_SKILL_BOOK_COUNT; j++)
			{
				var cellBook:BaseItem = _skillBookCellList[j];
				if (j < bookList.length)
				{
					cellBook.itemData = bookList[j];
					cellBook.canNotUse = _bookForLearnCode == cellBook.itemData.itemCode;
				}
				else
				{
					cellBook.itemData = null;
					cellBook.canNotUse = false;
				}
			}
			
			if (!pet)
				return;
			//刷新天赋技能     天赋技能位置为0
			var talentSkillList:Vector.<SkillInfo> = Cache.instance.pet.getTalentSkillList(pet.publicPet.uid);
			var skillInfo:SkillInfo = talentSkillList.length > 0 ? talentSkillList[0] : null;
			_talentSkill.setSkillInfo(skillInfo);
			//刷新技能格子
			var openNum:int = Cache.instance.pet.getPassiveSkillOpenPosNum(_pet.publicPet.uid);
			for (var i:int = 0; i < CELL_SKILL_COUNT; i++)
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
			//middle
			var bookForLearn:ItemData = Cache.instance.pack.backPackCache.getItemByCode(_bookForLearnCode);
			if (bookForLearn != null)
			{
				_baseItemSkillBookForLearn.itemData = bookForLearn;
				_txtSkillBookName.text = bookForLearn.itemInfo.name;
			}
			else
			{
				_baseItemSkillBookForLearn.itemData = null;
				_txtSkillBookName.text = "";
			}
		}
		
		private function updateRightPage(page:int):void
		{
			//获取背包中的兽魂石
			var shouHunShiBackPackList:Array = Cache.instance.pack.backPackCache.getItemsByCategoryAndType(EGroup._EGroupProp, EProp._EPropProp, EPropType._EPropTypePetSkillRand);
			//获取商城对应售卖的忆魂石和技能书
			var skillBookListFromShopMall:Vector.<ItemData> = getSkillBookFromShopMall();
			var shouHunShiListFromShopMall:Vector.<ItemData> = getShouHunShiFromShopMall();
			
			var maxPage:int = Math.ceil((shouHunShiBackPackList.length + skillBookListFromShopMall.length + shouHunShiListFromShopMall.length) / 5);
			_pageSelecter.maxPage = maxPage == 0 ? 1 : maxPage;
			var dataArr:Array = [];
			var curStartIndex:int = (_pageSelecter.currentPage - 1) * 5;
			for (var i:int =0; i < 5; i++)
			{
				var index:int = curStartIndex + i;
				//查看背包
				if (index < shouHunShiBackPackList.length)
				{
					var obj:Object = new Object();
					obj.type = "fresh";
					obj.data = shouHunShiBackPackList[index];
					dataArr.push(obj);
				}
				else
				{
					//刷商城中售卖的兽魂石
					var nIndex:int = index - shouHunShiBackPackList.length;
					if (nIndex < shouHunShiListFromShopMall.length)
					{
						obj = new Object();
						obj.type = "buy";
						obj.data = shouHunShiListFromShopMall[nIndex];
						dataArr.push(obj);
					}
					else
					{
						//刷新商城中售卖的技能书
						var mIndex:int = index - shouHunShiBackPackList.length - shouHunShiListFromShopMall.length;
						if (mIndex >= skillBookListFromShopMall.length)
						{
							break;
						}
						obj = new Object();
						obj.type = "buy";
						obj.data = skillBookListFromShopMall[mIndex];
						dataArr.push(obj);
					}
				}
			}
			
			_tabBarSkillBook.dataProvider = dataArr;
		}
		
		override public function updatePetAttribute(uid:String):void
		{
			if (_pet && _pet.publicPet.uid == uid)
			{
				updateMsg(_pet);
			}
		}
		
		private function onSelectBookForLearn(event:MouseEvent):void
		{
			var item:BaseItem = event.target as BaseItem;
			if (item.itemData == null)
				return;
			if (_pet == null)
			{
				MsgManager.showRollTipsMsg("请选择一个宠物");
				return;
			}
			_bookForLearnCode = item.itemData.itemCode;
			
			updateMsg(_pet);
			item.canNotUse = true;
		}
		
		private function unSelectBookForLearn(event:MouseEvent):void
		{
			var item:BaseItem = event.target as BaseItem;
			if (item.itemData == null)
				return;
			_bookForLearnCode = 0;
			updateMsg(_pet);
		}
		
		private function learnSkill(event:MouseEvent):void
		{
			if (_bookForLearnCode == 0)
			{
				MsgManager.showRollTipsMsg("请先选择一本技能书！");
				return;
			}
			if (_pet == null)
			{
				MsgManager.showRollTipsMsg("请选择一个宠物");
				return;
			}
			var bookForLearn:ItemData = Cache.instance.pack.backPackCache.getItemByCode(_bookForLearnCode);
			var obj:Object = new Object();
			obj.petuid = _pet.publicPet.uid;
			obj.skillbookuid = bookForLearn.uid;
			Dispatcher.dispatchEvent(new DataEvent(EventName.PetLearnSkill, obj));
		}
		
		private function onPageChange(event:Event):void
		{
			updateRightPage(_pageSelecter.currentPage);
		}
		
		//从商城获取售卖的兽魂石 信息保存
		private var _skillBookList:Vector.<ItemData> = null;
		private function getSkillBookFromShopMall():Vector.<ItemData>
		{
			if (_skillBookList == null)
			{
				_skillBookList = ShopConfig.instance.getShopItemByType(EGroup._EGroupStuff, EStuff._EStuffAdvance, EAdvanceType._EAdvanceTypePet);
			}
			return _skillBookList;
		}
		
		private var _shouHunShiList:Vector.<ItemData> = null;
		private function getShouHunShiFromShopMall():Vector.<ItemData>
		{
			if (_shouHunShiList == null)
			{
				_shouHunShiList = ShopConfig.instance.getShopItemByType(EGroup._EGroupProp, EProp._EPropProp, EPropType._EPropTypePetSkillRand);
			}
			return _shouHunShiList;
		}
		
		protected function onPackChange(obj:*):void
		{
			updateMsg(_pet);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_bookForLearnCode = 0;
			_skillBookCellList.length = 0;
			_skillCellList.length = 0;
			NetDispatcher.removeCmdListener(ServerCommand.BackpackDataChange,onPackChange);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackItemsChange,onPackChange);
			NetDispatcher.removeCmdListener(ServerCommand.PetSkillUpdate,onSkillUpdate);
			super.disposeImpl(isReuse);
		}
		
	}
}