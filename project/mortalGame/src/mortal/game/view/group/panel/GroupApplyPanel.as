package mortal.game.view.group.panel
{
	import Message.Public.EGroupOperType;
	import Message.Public.SGroupOper;
	import Message.Public.SPublicPlayer;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTileList;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.group.cellRenderer.GroupApplyCellRenderer;
	import mortal.mvc.core.Dispatcher;
	
	public class GroupApplyPanel extends GSprite
	{
		private var _applyList:GTileList;
		
		private var _refreshBtn:GButton;
		
		private var _rejectAllBtn:GButton;
		
		public function GroupApplyPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(17,90,773,296,this,ImagesConst.RoleInfoBg));
			this.pushUIToDisposeVec(UIFactory.bg(16,69,773,30,this,ImagesConst.RegionTitleBg));
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30229),23,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30219),188,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30220),312,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30217),435,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30221),555,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30216),695,72,100,20,this));
			
			_applyList =  UIFactory.tileList(22,105,750,287,this);
			_applyList.rowHeight = 30;
			_applyList.columnWidth = 740;
			_applyList.horizontalGap = 1;
			_applyList.verticalGap = 1;
			_applyList.setStyle("skin", new Bitmap());
			_applyList.setStyle("cellRenderer", GroupApplyCellRenderer);
			
			_refreshBtn = UIFactory.gButton(Language.getString(30210),315,396,65,22,this);
			_refreshBtn.configEventListener(MouseEvent.CLICK,refreshHandeler);
			
			_rejectAllBtn = UIFactory.gButton(Language.getString(30227),415,396,65,22,this);
			_rejectAllBtn.configEventListener(MouseEvent.CLICK,rejectAll);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_refreshBtn.dispose(isReuse);
			_rejectAllBtn.dispose(isReuse);
			
			_refreshBtn = null;
			_rejectAllBtn = null;
			super.disposeImpl(isReuse);
		}
		
		private function refreshHandeler(e:MouseEvent):void
		{
			updateApplyList();
		}
		
		private function rejectAll(e:MouseEvent):void
		{
			var applyList:Array = Cache.instance.group.applyList;
			var len:int = applyList.length;
			var sGroupOper:SGroupOper;
			var arr:Array = new Array();
			for(var i:int ; i < len ; i++)
			{
				sGroupOper = new SGroupOper();
				sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
				sGroupOper.toEntityId = (applyList[i] as SGroupOper).fromEntityId;
				sGroupOper.fromPlayer = new SPublicPlayer();
				sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
				sGroupOper.type = EGroupOperType._EGroupOperTypeReject;
				sGroupOper.uid = (applyList[i] as SGroupOper).uid;
				arr.push(sGroupOper);
			}
			if(arr.length > 0)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.GroupApplyOper,arr));
			}
		
		}
		
		private function getDateProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var arr:Array = Cache.instance.group.applyList;
			
			for each(var i:SGroupOper in arr)
			{
				var obj:Object = {"data":i};
				dataProvider.addItem(obj);
			}
			return dataProvider;
		}
		
		public function updateApplyList():void
		{
			_applyList.dataProvider = getDateProvider();
			_applyList.drawNow();
		}
	}
}