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
	import mortal.game.view.group.cellRenderer.GroupInviteCellRenderer;
	import mortal.mvc.core.Dispatcher;
	
	public class GroupInvitePanel extends GSprite
	{
		private var _inviteList:GTileList;
		
		private var _refreshBtn:GButton;
		
		private var _rejectAllBtn:GButton;
		
		public function GroupInvitePanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(17,90,773,296,this,ImagesConst.RoleInfoBg));
			this.pushUIToDisposeVec(UIFactory.bg(16,69,773,30,this,ImagesConst.RegionTitleBg));
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30224),23,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30225),158,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30219),282,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30220),377,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30217),477,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30221),577,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30216),695,72,100,20,this));
	
			_inviteList =  UIFactory.tileList(22,105,750,287,this);
			_inviteList.rowHeight = 30;
			_inviteList.columnWidth = 740;
			_inviteList.horizontalGap = 1;
			_inviteList.verticalGap = 1;
			_inviteList.setStyle("skin", new Bitmap());
			_inviteList.setStyle("cellRenderer", GroupInviteCellRenderer);
			this.addChild(_inviteList);
			
			_refreshBtn = UIFactory.gButton(Language.getString(30210),315,396,65,22,this);
			_refreshBtn.configEventListener(MouseEvent.CLICK,refreshHandeler);
			
			_rejectAllBtn = UIFactory.gButton(Language.getString(30227),415,396,65,22,this);
			_rejectAllBtn.configEventListener(MouseEvent.CLICK,rejectAll);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_inviteList.dispose(isReuse);
			_refreshBtn.dispose(isReuse);
			_rejectAllBtn.dispose(isReuse);
			
			_inviteList = null
			_refreshBtn = null;
			_rejectAllBtn = null;
			super.disposeImpl(isReuse);
		}
		
		private function refreshHandeler(e:MouseEvent):void
		{
			updateInviteList();
		}
		
		private function rejectAll(e:MouseEvent):void
		{
			var inviteList:Array = Cache.instance.group.inviteList;
			var len:int = inviteList.length;
			var sGroupOper:SGroupOper;
			var arr:Array = new Array();
			for(var i:int ; i < len ; i++)
			{
				sGroupOper = new SGroupOper();
				sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
				sGroupOper.toEntityId = (inviteList[i] as SGroupOper).fromEntityId;
				sGroupOper.fromPlayer = new SPublicPlayer();
				sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
				sGroupOper.type = EGroupOperType._EGroupOperTypeReject;
				sGroupOper.uid = (inviteList[i] as SGroupOper).uid;
				arr.push(sGroupOper);
			}
			if(arr.length > 0)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.GroupInviteOper,arr));
			}
		}
		
		private function getDateProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var arr:Array = Cache.instance.group.inviteList;
			
			for each(var i:SGroupOper in arr)
			{
				var obj:Object = {"data":i};
				dataProvider.addItem(obj);
			}
			return dataProvider;
		}
		
		public function updateInviteList():void
		{
			_inviteList.dataProvider = getDateProvider();
			_inviteList.drawNow();
		}
	}
}