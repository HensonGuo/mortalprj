/**
 * 2014-3-12
 * @author chenriji
 **/
package mortal.game.view.autoFight.render
{
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GCheckBox;
	
	import flash.events.Event;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.autoFight.data.SelectBossData;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class SelectBossRender extends GCellRenderer
	{
		private var _box:GCheckBox;
		private var _myData:SelectBossData;
		
		public function SelectBossRender()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			_myData = value as SelectBossData;
			_box.label = _myData.boss.name;
			_box.selected = _myData.selected;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_box = UIFactory.checkBox("", 0, 8, 120, 20, this);
			_box.configEventListener(Event.CHANGE, selectedChangeHandler);
		}
		
		private function selectedChangeHandler(evt:Event):void
		{
			_myData.selected = _box.selected;
			Dispatcher.dispatchEvent(new DataEvent(EventName.AutoFight_BossNotSelect, _myData));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_box.dispose(isReuse);
			_box = null;
		}
		
		public override function set label(value:String):void
		{
			
		}
	}
}