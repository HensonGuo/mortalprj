package mortal.game.view.group.groupAvatar
{
	import Message.Public.EEntityAttribute;
	import Message.Public.SEntityId;
	import Message.Public.SGroupPlayer;
	import Message.Public.SPublicPlayer;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.mui.controls.GSprite;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mortal.common.net.CallLater;
	import mortal.game.cache.Cache;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.GameController;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.mainUI.roleAvatar.GroupAvatar;
	import mortal.mvc.core.View;
	
	public class GroupAvatarView extends View
	{
		//数据
		private var _teamMateDic:Dictionary; //队伍列表
		
		private var _showTrack:Boolean = true;
		
		private var _selfId:int = Cache.instance.role.entityInfo.entityId.id;
		
		//显示对象
		private var _bodySprite:GSprite;  //主容器
		
		private var _hideBtn:BtnShowTeamAvatar;  //隐藏按钮
		
		private var _hideTween:TweenMax;
		private var _showTween:TweenMax;
		
		public function GroupAvatarView()
		{
			super();
			this.layer = LayerManager.uiLayer;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bodySprite = UICompomentPool.getUICompoment(GSprite);
			_bodySprite.createDisposedChildren();
			_bodySprite.x = 9;
			_bodySprite.y = 30;
			addChild(_bodySprite);
			
			_hideBtn = UICompomentPool.getUICompoment(BtnShowTeamAvatar);
			_hideBtn.createDisposedChildren();
			_hideBtn.x = 0;
			_hideBtn.y = 140;
			addChild(_hideBtn);
			
			_teamMateDic = new Dictionary();
			
//			
			_hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_bodySprite.dispose(isReuse);
			_hideBtn.dispose(isReuse);
			
			for each(var i:GroupAvatar in _teamMateDic)
			{
				i.dispose(isReuse);
			}
			_teamMateDic = new Dictionary();
			
			if(_showTween && _showTween.active)
			{
				_showTween.kill();
				_showTween = null;
			}
			
			_hideBtn = null;
			_bodySprite = null;
			super.disposeImpl();
		}
		
		private function resetPos():void
		{
			var arr:Array = Cache.instance.group.players;
			var len:int = arr.length;
			for(var i:int = 1 ; i < len ; i++)
			{
				if(arr[i].player.entityId.id ==_selfId)
				{
					continue;
				}
				
				if(_teamMateDic[arr[i].player.entityId.id])
				{
					_teamMateDic[arr[i].player.entityId.id].y = GameController.avatar.view.y + GameController.avatar.view.height + 45 + (i - 1) * 75;
				}
			}
		}
		
		/**
		 * 添加队员 
		 * @param entityId
		 * 
		 */		
		private function addTeamMate(publicPlayer:SPublicPlayer):void
		{
			var entityInfo:EntityInfo = Cache.instance.entity.getEntityInfoById(publicPlayer.entityId);
			if(!_teamMateDic[publicPlayer.entityId.id])
			{
				var playerAvater:GroupAvatar = UICompomentPool.getUICompoment(GroupAvatar);
				playerAvater.createDisposedChildren();
				_bodySprite.addChild(playerAvater);
				_teamMateDic[publicPlayer.entityId.id] = playerAvater;
			}
			
			(_teamMateDic[publicPlayer.entityId.id] as GroupAvatar).updateEntity(entityInfo);
			(_teamMateDic[publicPlayer.entityId.id] as GroupAvatar).updatePlayer(publicPlayer);
			
			if(publicPlayer.online == 0)
			{
				(_teamMateDic[publicPlayer.entityId.id] as GroupAvatar).stopUpdateEntity();
			}
			
			resetPos();
		}
		
		/**
		 * 更新队伍信息 
		 * 
		 */		
		public function updateTeamMate():void
		{
			var players:Array = Cache.instance.group.players;
			for each(var i:SGroupPlayer in players)
			{
				if(i.player.entityId.id ==_selfId)
				{
					continue;
				}
				
				addTeamMate(i.player);
			}
			
			if(Cache.instance.group.players.length > 1)
			{
				_hideBtn.visible = true;
			}
			else
			{
				_hideBtn.visible = false;
			}
		}
		
		/**
		 * 队员进入范围 
		 * @param entityInfo
		 * 
		 */		
		public function teamMateIn(entityInfo:EntityInfo):void
		{
		    if(_teamMateDic[entityInfo.entityInfo.entityId.id])
			{
				(_teamMateDic[entityInfo.entityInfo.entityId.id] as GroupAvatar).updateEntity(entityInfo);
			}
		}
		
		/**
		 * 队员远离 
		 * @param entityId
		 * 
		 */		
		public function teamMateOut(entityId:SEntityId):void
		{
			if(_teamMateDic[entityId.id])
			{
				(_teamMateDic[entityId.id] as GroupAvatar).stopUpdateEntity();
			}
		}
		
		/**
		 * 删除队员 
		 * @param entityId
		 * 
		 */		
		public function removeTeamMate(entityId:SEntityId):void
		{
			if(_teamMateDic[entityId.id] != null)
			{
				(_teamMateDic[entityId.id] as GroupAvatar).removeAndStopUpdate();
				(_teamMateDic[entityId.id] as GroupAvatar).dispose(true);
//				_bodySprite.removeChild(_teamMateDic[entityId.id]);
				delete _teamMateDic[entityId.id];
			}
			resetPos();
		}
		
		/**
		 * 解散队伍 /离开
		 * 
		 */		
		public function disbandTeam():void
		{
			for each(var i:GroupAvatar in _teamMateDic)
			{
				i.removeAndStopUpdate();
				i.dispose(true);
			}
			_teamMateDic = new Dictionary();
		}
		
		/**
		 * 更新状态 
		 * @param obj
		 * 
		 */		
		public function updateTeamMateState(obj:Object):void
		{
			var playerAvater:GroupAvatar = _teamMateDic[obj.id];
			if(playerAvater)
			{
				switch(obj.type)
				{
					case EEntityAttribute._EAttributeGroupMemberOnline:
						playerAvater.publicPlayer.online = obj.value;
						playerAvater.updateOnline();
						break;
					case EEntityAttribute._EAttributeSpaceId:
						playerAvater.updateMapId(obj.value);
						break;
					case EEntityAttribute._EAttributeGroupMemberAttacked:
						EffectManager.glowFilterReg(playerAvater);
						CallLater.setCallLater(removeEffect,3);
						break;
				}
				
				function removeEffect():void
				{
					EffectManager.glowFilterUnReg(playerAvater);
				}
			}
			
		}
		
		
		/**
		 * 隐藏/显示
		 * @param event
		 * 
		 */
		private function onHideBtnClickHandler(event:MouseEvent):void
		{
			if(_showTrack)//隐藏
			{
				hideTrack();
			}
			else//显示
			{
				showTrack();
			}
		}
		
		/**
		 * 显示组队列表
		 * 
		 */
		public function showTrack():void
		{
			if(_hideTween && _hideTween.active)
			{
				_hideTween.kill();
			}
			
			if(!_bodySprite.parent)
			{
				addChild(_bodySprite);
			}
			
			x = 0;
			y = 0;
			_hideBtn.show = true;
			_showTrack = true;
			
			var arr:Array = Cache.instance.group.players;
			var len:int = arr.length;
			var id:int;
			for(var i:int = 1 ; i < len ; i++)
			{
				id = arr[i].player.entityId.id;
				if(id ==_selfId)
				{
					continue;
				}
				
				if(_teamMateDic[id])
				{
					_showTween = TweenMax.to(_teamMateDic[id],i*0.12,{x:0,y:_teamMateDic[id].y,alpha:1,ease:Quint.easeIn,onComplete:onShowEnd,onCompleteParams:[i]});
				}
			}
		}
		
		/**
		 * 隐藏追踪 
		 * 
		 */
		public function hideTrack():void
		{
			if(_showTween && _showTween.active)
			{
				_showTween.kill();
			}
			
			x = 0;
			y = 0;
//			_hideTween = TweenMax.to(_bodySprite,0.5,{x:-width,y:10,alpha:0,ease:Quint.easeOut,onComplete:onHideEnd});
			_hideBtn.show = false;
			_showTrack = false;
			var arr:Array = Cache.instance.group.players;
			var len:int = arr.length;
			var id:int;
			for(var i:int = 1 ; i < len ; i++)
			{
				id = arr[i].player.entityId.id;
				if(id ==_selfId)
				{
					continue;
				}
				
				if(_teamMateDic[id])
				{
					_hideTween = TweenMax.to(_teamMateDic[id],i*0.1,{x:-_teamMateDic[id].width,y:_teamMateDic[id].y,alpha:0,ease:Quint.easeIn,onComplete:onHideEnd,onCompleteParams:[i]});
				}
			}
			
		}
		
		private function onShowEnd(index:int):void
		{
			if(index == Cache.instance.group.players.length - 1)
			{
				updateTeamMate();
			}
		}
		
		/**
		 * 隐藏完成 
		 * 
		 */
		private function onHideEnd(index:int):void
		{
			if(index == Cache.instance.group.players.length - 1)
			{
				removeChild(_bodySprite);
			}
		}
		
	}
}