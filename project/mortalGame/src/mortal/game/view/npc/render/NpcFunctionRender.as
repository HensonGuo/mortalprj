/**
 * 2014-3-5
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
	import mortal.game.view.npc.data.NpcFunctionData;
	import mortal.mvc.core.Dispatcher;

	public class NpcFunctionRender extends GCellRenderer
	{
		private var _txt:GTextFiled;
		private var _info:NpcFunctionData;
		
		public function NpcFunctionRender()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			_info = value as NpcFunctionData;
			_txt.htmlText = "<u><a href='event:0'>" + _info.desc + "</u></a>";
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_txt = UIFactory.gTextField("", 0, 0, 230, 20, this);
			_txt.configEventListener(MouseEvent.CLICK, textClickHandler);
		}
		
		private function textClickHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.NPC_ClickNpcFunction, _info));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_txt.dispose(isReuse);
			_txt = null;
		}
		
		public override function set label(value:String):void
		{
			
		}
	}
}