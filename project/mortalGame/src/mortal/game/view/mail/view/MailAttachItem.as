package mortal.game.view.mail.view
{
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.item.BaseItem;
	
	/**
	 * 邮件附件，单个物品
	 * @author lizhaoning
	 */
	public class MailAttachItem extends BaseItem
	{
		private var _bgBmp:GBitmap;
		
		public function MailAttachItem()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.mouseChildren = false;
			
			_bgBmp = GlobalClass.getBitmap(ImagesConst.PackItemBg);
			this.addChildAt(_bgBmp,0);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_bgBmp.dispose(isReuse);
			
			_bgBmp = null;
		}
		
	}
}