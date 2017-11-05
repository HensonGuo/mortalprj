/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.control
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EGateCommand;
	import Message.Command.EPublicCommand;
	import Message.Public.SEntityKillerInfo;
	
	import extend.language.Language;
	
	import flash.events.Event;
	import flash.utils.setTimeout;
	
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.WindowEvent;
	import mortal.game.Game;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.scene3D.map3D.util.GameSceneUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.relive.ReliveGeneralPanel;
	import mortal.game.view.relive.ReliveLocalPanel;
	import mortal.game.view.relive.RelivePanelBase;
	import mortal.game.view.relive.ReliveRelivePointPanel;
	import mortal.game.view.relive.ReliveType;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.NetDispatcher;
	
	public class ReliveController extends Controller
	{
		public function ReliveController()
		{
			super();
		}
		
		override protected function initServer():void
		{
			super.initServer();
			
			RolePlayer.instance.addEventListener(PlayerEvent.ENTITY_Relived, onRoleRelived, false, 0, true);
//			RolePlayer.instance.addEventListener(PlayerEvent.ENTITY_DEAD, onRoleDead, false, 0, true);
			
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicEntityKillerInfo, onRoleDead);//玩家被实体杀死
		}
		
		public function stageResize():void
		{
			
		}
		
		/**
		 * 角色复活 
		 */		
		private function onRoleRelived(evt:PlayerEvent):void
		{
			// 复活成功音效
			SoundManager.instance.soundPlay(SoundTypeConst.Resurrection);
			hideRelivePanel();
		}
		
		/**
		 * 角色死亡 
		 * @param e
		 * 
		 */		
		private function onRoleDead(e:MessageBlock):void
		{
			
			// 角色死亡音效
			SoundManager.instance.soundPlay(SoundTypeConst.MaleRoleDead);
			
			var info:SEntityKillerInfo = e.messageBase as SEntityKillerInfo;
			// 被杀了刷新，就会出现杀人信息为空的情况
			if(info == null)
			{
				info = new SEntityKillerInfo();
				info.name = "";
			}
			showRelivePanel(info);
		}	
		
		private var _curRelivePanel:RelivePanelBase;
		private function showRelivePanel(info:SEntityKillerInfo):void
		{
			var reliveType:int = GameSceneUtil.getReliveType(); 
			hideRelivePanel();
			switch(reliveType)
			{
				case ReliveType.General:
					_curRelivePanel = new ReliveGeneralPanel();
					_curRelivePanel.killerInfo = info;
					ReliveGeneralPanel(_curRelivePanel).leftSecond = 120;
					break;
				case ReliveType.Prop:
					_curRelivePanel = new ReliveLocalPanel();
					_curRelivePanel.killDesc = Language.getStringByParam(20004, info.name);
					break;
				case ReliveType.RelivePoint:
					_curRelivePanel = new ReliveRelivePointPanel();
					_curRelivePanel.killDesc = Language.getStringByParam(20005, info.name);
					break;
				case ReliveType.Force:
					break;
				case ReliveType.FailCopy:
					break;
			}
			
			if(_curRelivePanel != null)
			{
				_curRelivePanel.show();
				_curRelivePanel.addEventListener(WindowEvent.CLOSE, onRelivePanelClosed);
			}
		}
		
		private function hideRelivePanel():void
		{
			if(_curRelivePanel == null)
			{
				return;
			}
			
			_curRelivePanel.removeEventListener(WindowEvent.CLOSE, onRelivePanelClosed);
			if(!_curRelivePanel.isHide)
			{
				_curRelivePanel.hide();
				
			}
			
			_curRelivePanel.dispose(false);
			_curRelivePanel = null;
		}
		
		private function onRelivePanelClosed(evt:WindowEvent):void
		{
			if(_curRelivePanel != null)
			{
				_curRelivePanel.removeEventListener(WindowEvent.CLOSE, onRelivePanelClosed);
				_curRelivePanel = null;
			}
		}
		
		/**
		 * 死亡复活确定事件 
		 * 
		 */
		private function onAlertOkHandler(index:int):void
		{
		}
		
	}
}