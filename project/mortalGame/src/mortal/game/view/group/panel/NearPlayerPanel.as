package mortal.game.view.group.panel
{
	import Message.Public.EEntityType;
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
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.group.cellRenderer.NearPlayerCellRenderer;
	import mortal.mvc.core.Dispatcher;

	public class NearPlayerPanel extends GSprite
	{
		private var _playerList:GTileList;
		
		private var _refreshBtn:GButton;
		
		private var _inviteAllBtn:TimeButton;
		
		public function NearPlayerPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(17,90,773,296,this,ImagesConst.RoleInfoBg));
			this.pushUIToDisposeVec(UIFactory.bg(16,69,773,30,this,ImagesConst.RegionTitleBg));
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30218),23,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30219),160,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30220),280,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30217),390,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30221),530,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30216),695,72,100,20,this));
			
			_playerList =  UIFactory.tileList(22,105,750,287,this);
			_playerList.rowHeight = 30;
			_playerList.columnWidth = 740;
			_playerList.horizontalGap = 1;
			_playerList.verticalGap = 1;
			_playerList.setStyle("skin", new Bitmap());
			_playerList.setStyle("cellRenderer", NearPlayerCellRenderer);
			this.addChild(_playerList);
			
			_refreshBtn = UIFactory.gButton(Language.getString(30210),315,396,65,22,this);
			_refreshBtn.configEventListener(MouseEvent.CLICK,refreshList);
			
			_inviteAllBtn = UIFactory.timeButton(Language.getString(30249), 415, 396, 65, 22, this);
			_inviteAllBtn.cdTime = 5000;
			_inviteAllBtn.configEventListener(MouseEvent.CLICK,inviteAll);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_playerList.dispose(isReuse);
			_refreshBtn.dispose(isReuse);
			_inviteAllBtn.dispose(isReuse);
			
			_playerList = null;
			_refreshBtn = null;
			_inviteAllBtn = null;
			super.disposeImpl(isReuse);
		}
		
		private function getDateProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var entityArr:Array = Cache.instance.entity.getAllEntityInfo();
			entityArr.sort(sortOnLevelAndPower);
			for each(var i:EntityInfo in entityArr)
			{
				if(i.entityInfo.entityId.type == EEntityType._EEntityTypePlayer && i.entityInfo.groupId.id == 0)
				{
					var obj:Object = {"data":i};
					dataProvider.addItem(obj);
				}
			}
			
			return dataProvider;
		}
		
		private function sortOnLevelAndPower(a1:EntityInfo,a2:EntityInfo):int
		{
			if(a1.entityInfo.level > a2.entityInfo.level)
			{
				return -1;
			}
			else if(a1.entityInfo.level < a2.entityInfo.level)
			{
				return 1;
			}
			else   //留作后面有战斗力的时候再排序
			{
				return 0;
			}
		}
		
		private function refreshList(e:MouseEvent):void
		{
			updatePlayerList();
		}
		
		private function inviteAll(e:MouseEvent):void
		{
			var inviteList:Array = Cache.instance.entity.getAllEntityInfo();
			var len:int = inviteList.length;
			var sGroupOper:SGroupOper;
			var arr:Array = new Array();
			for(var i:int ; i < len ; i++)
			{
				sGroupOper = new SGroupOper();
				sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
				sGroupOper.toEntityId = (inviteList[i] as EntityInfo).entityInfo.entityId;
				sGroupOper.fromPlayer = new SPublicPlayer();
				sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
				sGroupOper.type = EGroupOperType._EGroupOperTypeInvite;
				arr.push(sGroupOper);
			}
			if(arr.length > 0)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.GroupInviteOper,arr));
			}
		
		}
		
		public function updatePlayerList():void
		{
			_playerList.dataProvider = getDateProvider();
			_playerList.drawNow();
		}
	}
}