package mortal.game.view.friend
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 确认删除列表中的列表项
	 * @date   2014-2-26 下午4:12:16
	 * @author dengwj
	 */	 
	public class DeleteCellRenderer extends GCellRenderer
	{
		/** 玩家名字 */
		private var _roleName:GTextFiled;
		/** 取消按钮 */
		private var _cancelBtn:GButton;
		/** 对应左侧选择的好友项 */
		private var _dataSource:Object;
		
		public function DeleteCellRenderer()
		{
			super();
			this.setSize(153, 25);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_roleName = UIFactory.gTextField("玩家名字七个字",11,2,98,20,this);
			_cancelBtn = UIFactory.gButton("取消",112,3,41,22,this,"PageBtn");
			this.pushUIToDisposeVec(UIFactory.bg(0,27,160,1,this,ImagesConst.SplitLine));
			
			_cancelBtn.configEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		protected override function initSkin():void
		{
			var emptyBmp:GBitmap = new GBitmap;
			var selectSkin:ScaleBitmap = UIFactory.bg(0,0,0,0,null,ImagesConst.SelectBg);
			this.setStyle("downSkin",selectSkin);
			this.setStyle("overSkin",selectSkin);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",selectSkin);
			this.setStyle("selectedOverSkin",selectSkin);
			this.setStyle("selectedUpSkin",selectSkin);
		}
		
		override public function set data(arg0:Object):void
		{
			var friend:SelectedCellRenderer = arg0.data as SelectedCellRenderer;
			this._dataSource = arg0;
			_roleName.text = friend.roleName;
 		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if(dataSource != null)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.FriendCancelDelete,dataSource));
			}
		}
		
		public function get dataSource():Object
		{
			return this._dataSource;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.selected = false;
			super.disposeImpl(isReuse);
			
			_roleName.dispose(isReuse);
			_cancelBtn.dispose(isReuse);
			
			_roleName = null;
			_cancelBtn = null;
		}
	}
}