package mortal.game.view.mainUI.rightTopBar
{
	import com.mui.controls.GLoadedButton;
	
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.View;
	
	/**
	 * 右上角图标 (排行、签到、成就等)
	 * @author lizhaoning
	 */
	public class RightTopBar extends View
	{
		/** 邮件 */
		private var _btnMail:GLoadedButton;
		/** 成就1 */
		private var _bntAchievement1:GLoadedButton;
		/** 成就2  */
		private var _bntAchievement2:GLoadedButton;
		/** 好友 */
		private var _bntFriend:GLoadedButton;
		/** 签到  */
		private var _bntSignIn:GLoadedButton;
		/** 排行榜 */
		private var _bntRank:GLoadedButton;
		/** 市场图标 */
		private var _btnMarket:GLoadedButton;
		
		public function RightTopBar()
		{
			super();
			this.layer = LayerManager.uiLayer;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			var iconWidth:int = 40;
			var iconHeight:int = 40;
			
			_bntRank = UIFactory.gLoadedButton(ImagesConst.rt_rank_upSkin,0,0,42,42,this);
			_bntSignIn = UIFactory.gLoadedButton(ImagesConst.rt_signin_upSkin,iconWidth *1,0,42,42,this); 
			_btnMail = UIFactory.gLoadedButton(ImagesConst.rt_mail_upSkin,iconWidth *2,0,42,42,this);
			_bntFriend = UIFactory.gLoadedButton(ImagesConst.rt_friend_upSkin,iconWidth *3,0,42,42,this);
			_btnMarket = UIFactory.gLoadedButton(ImagesConst.rt_market_upSkin,iconWidth *1,iconHeight * 1,42,42,this);
			_bntAchievement2 = UIFactory.gLoadedButton(ImagesConst.rt_achieve1_upSkin,iconWidth *2,iconHeight * 1,42,42,this);
			_bntAchievement1 = UIFactory.gLoadedButton(ImagesConst.rt_achieve_upSkin,iconWidth *3,iconHeight * 1,42,42,this);
			
			this.addEventListener(MouseEvent.CLICK,openWinHandeler);
			
			NetDispatcher.addCmdListener(ServerCommand.MailNotice,onNewMail);
			
			updateViewByData();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_btnMail.dispose(isReuse);
			_btnMarket.dispose(isReuse);
			_bntAchievement1.dispose(isReuse);
			_bntAchievement2.dispose(isReuse);
			_bntFriend.dispose(isReuse);
			_bntSignIn.dispose(isReuse);
			_bntRank.dispose(isReuse);
			
			_btnMail = null;
			_btnMarket = null;
			_bntAchievement2 = null;
			_bntAchievement2 = null;
			_bntFriend = null;
			_bntSignIn = null;
			_bntRank = null;
			
			this.removeEventListener(MouseEvent.CLICK,openWinHandeler);
		}
		
		
		private function updateViewByData():void
		{
			onNewMail(null);
		}
		
		private function openWinHandeler(e:MouseEvent):void
		{
			var btn:Object = e.target;
			switch(btn)
			{
				case _btnMail:
					GameManager.instance.popupWindow(ModuleType.Mail);
					break;
				case _btnMarket:
					GameManager.instance.popupWindow(ModuleType.Market);
					break;
				case _bntAchievement1:
					break;
				case _bntAchievement2:
					break;
				case _bntFriend:
					GameManager.instance.popupWindow(ModuleType.Friend);
					break;
				case _bntSignIn:
					break;
				case _bntRank:
					break;
			}
		}
		
		private function onNewMail(e:Object):void  //来了新邮件
		{
			if(Cache.instance.mail.mailNotice)
			{
				EffectManager.glowFilterReg(_btnMail,[FilterConst.chatTipsFilter],0.6,20,2,0);
//				_btnMail.filters = [FilterConst.buttonGlowFilter];
			}
			else
			{
				EffectManager.glowFilterUnReg(_btnMail);
//				_btnMail.filters = null;
			}
		}
		
		
		override public function stageResize():void
		{
			this.y = 60;
			this.x = SceneRange.display.width - 70 - 160;
		}
		
	}
}