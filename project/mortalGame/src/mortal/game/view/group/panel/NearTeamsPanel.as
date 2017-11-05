package mortal.game.view.group.panel
{
	import Message.Public.SGroup;
	
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
	import mortal.game.view.group.cellRenderer.NearTeamCellRenderer;
	import mortal.mvc.core.Dispatcher;
	
	public class NearTeamsPanel extends GSprite
	{
		private var _teamList:GTileList;
		
		private var _refreshBtn:GButton;
		
		public function NearTeamsPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(17,90,773,296,this,ImagesConst.RoleInfoBg));
			this.pushUIToDisposeVec(UIFactory.bg(16,69,773,30,this,ImagesConst.RegionTitleBg));
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30212),23,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30213),195,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30214),330,72,100,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30215),460,72,115,20,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30216),695,72,100,20,this));
			
			_teamList =  UIFactory.tileList(22,105,750,287,this);
			_teamList.rowHeight = 30;
			_teamList.columnWidth = 740;
			_teamList.horizontalGap = 1;
			_teamList.verticalGap = 1;
			_teamList.setStyle("skin", new Bitmap());
			_teamList.setStyle("cellRenderer", NearTeamCellRenderer);
			this.addChild(_teamList);
			
			_refreshBtn = UIFactory.gButton(Language.getString(30210),363,396,65,22,this);
			_refreshBtn.configEventListener(MouseEvent.CLICK,refreshTeamInfo);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_teamList.dispose(isReuse);
			_refreshBtn.dispose(isReuse);
			
			_teamList = null;
			_refreshBtn = null;
			super.disposeImpl(isReuse);
		}
		
		private function getDateProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var groupArr:Array = Cache.instance.group.nearTeamList;
			
			for each(var i:SGroup in groupArr)
			{
				var obj:Object = {"data":i};
				dataProvider.addItem(obj);
			}
			
			return dataProvider;
		}
		
		private function refreshTeamInfo(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.GetNearTeam));
		}
		
		public function updateTeamList():void
		{
			_teamList.dataProvider = getDateProvider();
			_teamList.drawNow();
		}
		
		
	}
}