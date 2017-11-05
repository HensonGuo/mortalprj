/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.view.relive
{
	import Message.Public.ERevival;
	import Message.Public.SEntityKillerInfo;
	
	import com.mui.controls.GButton;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.component.window.BaseWindow;
	import mortal.game.mvc.GameProxy;
	import mortal.game.proxy.SceneProxy;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.SecTimerView;
	import mortal.game.view.common.button.TimeButton;
	import mortal.mvc.interfaces.ILayer;
	
	public class ReliveGeneralPanel extends RelivePanelBase
	{
		protected var _btnRelivePointRelive:GButton;
		protected var _btnProRelive:GButton;
		
		public function ReliveGeneralPanel($layer:ILayer=null)
		{
			super($layer);
		}
		
		protected override function configUI():void
		{
			super.configUI();
			
			_btnRelivePointRelive = UIFactory.gButton(Language.getString(20002), 70, 160, 65, 24, this);
			_btnProRelive = UIFactory.gButton(Language.getString(20003), 160, 164, 65, 24, this);
			
			
			_btnRelivePointRelive.addEventListener(MouseEvent.CLICK, relivePointReliveReqHandler);
			_btnProRelive.addEventListener(MouseEvent.CLICK, proReliveReqHandler);
		
		}
		
		public override function set killerInfo(info:SEntityKillerInfo):void
		{
			var desc:String = Language.getStringByParam(20001, info.name);
			_desc.setParse(desc);
		}
		
		public function set leftSecond(value:int):void
		{
			_desc.setLeftTime(value, true);
		}
		
		private function relivePointReliveReqHandler(evt:MouseEvent):void
		{
			GameProxy.sceneProxy.relive(ERevival._ERevivalPoint);
		}
		
		private function proReliveReqHandler(evt:MouseEvent):void
		{
			// 检查道具是否够用，不够用的话弹出购买道具的面板
			GameProxy.sceneProxy.relive(ERevival._ERevivalSitu);
		}
		
		protected override function descTimerOut():void
		{
			GameProxy.sceneProxy.relive(ERevival._ERevivalPoint);
			_desc.stop();
		}
		
		public override function dispose(isReuse:Boolean=true):void
		{
			if(_desc)
			{
				_desc.stop();
				_desc.timeOutHandler = null;
				_desc = null;
			}
			_btnRelivePointRelive.removeEventListener(MouseEvent.CLICK, relivePointReliveReqHandler);
			_btnProRelive.removeEventListener(MouseEvent.CLICK, proReliveReqHandler);
			
			_btnRelivePointRelive = null;
			_btnProRelive = null;
			
			super.dispose(isReuse);
		}
	}
}