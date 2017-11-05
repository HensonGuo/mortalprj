/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.view.relive
{
	import Message.Public.SEntityKillerInfo;
	
	import extend.language.Language;
	
	import mortal.component.window.BaseWindow;
	import mortal.component.window.SmallWindow;
	import mortal.game.view.common.SecTimerView;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.interfaces.ILayer;
	
	public class RelivePanelBase extends SmallWindow
	{
		protected var _desc:SecTimerView;
		public function RelivePanelBase($layer:ILayer=null)
		{
			super($layer);
			this.setSize(300, 190);
		}
		
		protected override function configUI():void
		{
			super.configUI();
			_desc = UIFactory.secTimeView("", 20, 40, 260, 60, this);
			_desc.multiline = true;
			_desc.wordWrap = true;
			_desc.timeOutHandler = descTimerOut;
		}
		
		public function set killerInfo(info:SEntityKillerInfo):void
		{
		}
		
		public function set killDesc(value:String):void
		{
//			_desc.htmlText = value;
			_desc.setParse(value);
		}
		
		protected function descTimerOut():void
		{
		}
	}
}