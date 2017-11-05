/**
 * 2014-4-22
 * @author chenriji
 **/
package mortal.game.view.npc.render
{
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.npc.data.NpcChooseData;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.mvc.core.Dispatcher;
	
	public class NpcChooseRender extends GCellRenderer
	{
		private var _txt:GTextFiled;
		private var _info:NpcChooseData
		
		public function NpcChooseRender()
		{
			super();
		}
	
		public override function set data(value:Object):void
		{
			_info = value as NpcChooseData;
			_txt.htmlText = "<u><a href='event:0'>" + _info.text + "</u></a>";
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_txt = UIFactory.gTextField("", 0, 0, 230, 20, this);
			_txt.configEventListener(MouseEvent.CLICK, textClickHandler);
		}
		
		private function textClickHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.NpcChooseAnswer, _info));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_txt.dispose(isReuse);
			_txt = null;
			_info = null;
		}
		
		public override function set label(value:String):void
		{
			
		}
	}
}