package mortal.game.view.mail.view
{
	import com.mui.controls.GCellRenderer;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.MouseEvent;
	
	import mortal.game.resource.info.item.ItemData;
	
	/**
	 * 邮件附件列表item renderer
	 * @author lizhaoning
	 */
	public class MailAttachRenderer extends GCellRenderer
	{
		private var _item:MailAttachItem;
		public function MailAttachRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_item = UICompomentPool.getUICompoment(MailAttachItem);
			_item.createDisposedChildren();
			
			this.addChild(_item);
			_item.mouseChildren = false;
			_item.doubleClickEnabled = true;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_item.itemData = null;
			_item.doubleClickEnabled = false;
			_item.dispose(isReuse);
			
			_item = null;
			
			super.disposeImpl(isReuse);
		}
		
		override public function set data(arg0:Object):void
		{
			// TODO Auto Generated method stub
			super.data = arg0;
			
			if(arg0 is ItemData)
				_item.itemData = arg0 as ItemData;
			else
				_item.itemData = null;
		}
		
		override public function get data():Object
		{
			// TODO Auto Generated method stub
			return super.data;
		}
		
		
	}
}