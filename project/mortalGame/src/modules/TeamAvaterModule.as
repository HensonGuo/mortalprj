package modules
{
	import flash.events.MouseEvent;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.GameController;
	import mortal.mvc.core.View;
	
	public class TeamAvaterModule extends View
	{
//		//数据
//		private var _teamMateList:Vector.<RoleAvatar>;  //队伍列表
//		
//		private var _showTrack:Boolean = true;
//		
//		//显示对象
//		private var _bodySprite:GSprite;  //主容器
//		
//		private var _hideBtn:BtnShowTeamAvatar;  //隐藏按钮
//		
//		private var _hideTween:TweenMax;
//		private var _showTween:TweenMax;
		
		public function TeamAvaterModule()
		{
			super();
			this.layer = LayerManager.uiLayer;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
//			super.createDisposedChildrenImpl();
//			
//			_bodySprite = UICompomentPool.getUICompoment(GSprite);
//			_bodySprite.createDisposedChildren();
////			addChild(_bodySprite);
//			
//			UIFactory.bitmap(ImagesConst.Team,0,0,_bodySprite);
//			
//			_hideBtn = UICompomentPool.getUICompoment(BtnShowTeamAvatar);
//			_hideBtn.x = 100;
//			_hideBtn.y = 500;
//			addChild(_hideBtn);
//			
//			_hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
//			super.disposeImpl();
		}
		
		public function removeTeamMateById(id:int):void
		{
			
		}
		
		public function addTeamMateById(id:int):void
		{
			
		}
		
		/**
		 * 隐藏/显示
		 * @param event
		 * 
		 */
		private function onHideBtnClickHandler(event:MouseEvent):void
		{
//			if(_showTrack)//隐藏
//			{
//				hideTrack();
//			}
//			else//显示
//			{
//				showTrack();
//			}
		}
		
		/**
		 * 显示追踪 
		 * 
		 */
		public function showTrack():void
		{
//			if(_hideTween && _hideTween.active)
//			{
//				_hideTween.kill();
//			}
//			
//			x = SceneRange.display.width - width;
//			y = 180 + 20 *(SceneRange.display.height/1000);
//			_showTween = TweenMax.to(_bodySprite,0.2,{x:0,ease:Quint.easeIn});
//			_hideBtn.show = true;
//			_showTrack = true;
//			
//			if(!_bodySprite.parent)
//			{
//				addChild(_bodySprite);
//			}
		}
		
		/**
		 * 隐藏追踪 
		 * 
		 */
		public function hideTrack():void
		{
//			if(_showTween && _showTween.active)
//			{
//				_showTween.kill();
//			}
//			
//			x = SceneRange.display.width - width;
//			y = 180 + 20 *(SceneRange.display.height/1000);
//			_hideTween = TweenMax.to(_bodySprite,0.2,{x:width,ease:Quint.easeOut,onComplete:onHideEnd});
//			_hideBtn.show = false;
//			_showTrack = false;
		}
		
		/**
		 * 隐藏完成 
		 * 
		 */
		private function onHideEnd():void
		{
//			if(_bodySprite.parent)
//			{
//				removeChild(_bodySprite);
//			}
		}
		
		override public function stageResize():void
		{
			this.y = GameController.avatar.view.y + GameController.avatar.view.height + 15;
		}
		
	}
}