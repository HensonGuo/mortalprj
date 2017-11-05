/**
 * 2014-3-12
 * @author chenriji
 **/
package mortal.game.view.autoFight.render
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GCellRenderer;
	
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.view.autoFight.data.AFSkillData;
	import mortal.game.view.skill.panel.SkillItem;
	
	public class AFMainSkillRender extends GCellRenderer
	{
		private var _item:SkillItem;
		private var _myData:AFSkillData;
		
		public function AFMainSkillRender()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			_myData = value as AFSkillData;
			if(_myData.info == null || !_myData.info.learned)
			{
				this.mouseEnabled = false;
				return;
			}
			this.mouseEnabled = true;
			_item.skillInfo = _myData.info;
			if(_myData.isActive)
			{
//				_item.mouseEnabled = true;
				_item.filters = [];
			}
			else
			{
//				DisplayUtil.setEnabled(_item, false);
				_item.filters = [FilterConst.colorFilter];
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_item = ObjectPool.getObject(SkillItem);
			_item.y = 6;
			this.addChild(_item);
			_item.isDragAble = false;
			_item.isDropAble = false;
			_item.isThrowAble = false;
			_item.isShowFreezingEffect = false;
			_item.isShowLeftTimeEffect = false;
			_item.isShowToolTip = true;
			_item.setSize(42, 42);
			_item.setBg();
			
			this.configEventListener(MouseEvent.CLICK, selectedChangeHandler);
		}
		
		private function selectedChangeHandler(evt:MouseEvent):void
		{
			if(_myData.info == null)
			{
				return;
			}
			_myData.isActive = !_myData.isActive;
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_item.dispose(isReuse);
			_item = null;
		}
		
		public override function set label(value:String):void
		{
			
		}
	}
}