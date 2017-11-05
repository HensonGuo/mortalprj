/**
 * @heartspeak
 * 2014-4-28 
 */   	

package mortal.game.view.systemSetting.view
{
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.utils.UICompomentPool;
	
	import flash.system.System;
	
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.data.SettingItem;
	
	public class SystemSetBigItem extends GSprite
	{
		private var _textField:GTextFiled;
		private var _itemBox:GBox;
		
		public function SystemSetBigItem()
		{
			super();
		}
		
		/**
		 * 更新数据 
		 * 
		 */
		public function updateData(text:String,settingItems:Array):void
		{
			disposeImpl();
			_textField = UIFactory.textField(text,0,0,180,22,this);
			_itemBox = UICompomentPool.getUICompoment(GBox) as GBox;
			UIFactory.setObjAttri(_itemBox,20,22,-1,-1,this);
			_itemBox.direction = GBoxDirection.VERTICAL;
			var length:int = settingItems.length;
			for(var i:int = 0;i < length;i++)
			{
				var systemItem:SystemSetItem = UICompomentPool.getUICompoment(SystemSetItem);
				systemItem.data = settingItems[i] as SettingItem;
				_itemBox.addChild(systemItem);
			}
			_itemBox.resetPosition2();
		}
		
		/**
		 * 刷新显示 
		 * 
		 */		
		public function refreshDisplay():void
		{
			var length:int = _itemBox.numChildren;
			for(var i:int = length - 1;i >= 0;i--)
			{
				var systemItem:SystemSetItem = _itemBox.getChildAt(i) as SystemSetItem;
				systemItem.refreshDisplay();
			}
			_itemBox.resetPosition2();
		}
		
		override public function get height():Number
		{
			return 20 + _itemBox.height;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_textField)
			{
				_textField.dispose(isReuse);
				_textField = null;
			}
			if(_itemBox)
			{
				_itemBox.dispose(isReuse);
				_itemBox = null;
			}
		}
	}
}