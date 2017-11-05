/**
 * 2014-4-4
 * @author chenriji
 **/
package mortal.game.view.task.drama
{
	import Message.DB.Tables.TTaskDrama;
	import Message.Public.EStepType;
	
	import flash.utils.getTimer;
	
	import mortal.common.net.CallLater;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.fight.SkillEffectUtil;
	import mortal.game.view.task.drama.operations.TaskDramaBossAction;
	import mortal.game.view.task.drama.operations.TaskDramaBossTalk;
	import mortal.game.view.task.drama.operations.TaskDramaMouseKeyboardControl;
	import mortal.game.view.task.drama.operations.TaskDramaMovie;
	import mortal.game.view.task.drama.operations.TaskDramaNpcAction;
	import mortal.game.view.task.drama.operations.TaskDramaNpcTalk;
	import mortal.game.view.task.drama.operations.TaskDramaOpBlackScreen;
	import mortal.game.view.task.drama.operations.TaskDramaOpBlackScreenThenTips;
	import mortal.game.view.task.drama.operations.TaskDramaOpPetHide;
	import mortal.game.view.task.drama.operations.TaskDramaOpTalk;
	import mortal.game.view.task.drama.operations.TaskDramaOpTaskTalkText;
	import mortal.game.view.task.drama.operations.TaskDramaPlayerMoveOnly;
	import mortal.game.view.task.drama.operations.TaskDramaPlayerScreenMove;
	import mortal.game.view.task.drama.operations.TaskDramaScreenMove;
	import mortal.mvc.core.Dispatcher;

	public class TaskDramaOperator
	{
		private var _lastStep:TTaskDrama;
		
		public function TaskDramaOperator()
		{
		}
		
		public function stageResizeHandler():void
		{
			if(_npcTalk != null)
			{
				_npcTalk.onStageResize();
			}
			if(_movie != null)
			{
				_movie.onStageResize();
			}
		}

		private var _lastTime:int;
		public function operate(data:TTaskDrama, params:Object=null):void
		{
			var now:int = getTimer();
			trace("code = " + data.dramaCode + ", step=" + data.step + ", time = " +(now - _lastTime));
			_lastTime = now;
			_lastStep = data;
			
			switch(data.type)
			{
				case EStepType._EStepTypeNormal:
					break;
				
				case EStepType._EStepTypeDramaAdd: //添加剧情条
					LayerManager.uiLayer.visible = false;
					lockAll();
//					npcTalk.call(data, callEnd);
					callEnd();
					break;
				case EStepType._EStepTypeDramaPrint: //打印剧情文字
					lockAll();
					npcTalk.call(data, callEnd);
					break;
				case EStepType._EStepTypeDramaCancel: // 移除剧情条
					LayerManager.uiLayer.visible = true
					unLockAll();
					npcTalk.cancel(data, callEnd);
					break;
				
				case EStepType._EStepTypeTaskDramaPrint:// 任务剧情文字
					taskTalk.call(data, callEnd);
					break;
				
				case EStepType._EStepTypeAnimation: // //黑屏
					lockAll();
					blackScreen.call(data, callEnd);
					break;
				case EStepType._EStepTypeAnimationPrint: // 黑屏文字
					BlackThenTips.call(data, callEnd);
					break;
				case EStepType._EStepTypeAnimationEnd: // 取消黑屏
					unLockAll();
					blackScreen.cancel(data, callEnd);
					break; 
				
				
				case EStepType._EStepTypePetActive: // 放出宠物
					hidePet.cancel(data, callEnd);
					break;
				case EStepType._EStepTypePetIdle: // 收回宠物
					hidePet.call(data, callEnd);
					break;
				case EStepType._EStepTypeEffect:// 特效出现
					lockAll();
					SkillEffectUtil.addDramaEffect(int(data.entity), unlockThenEnd);
					break;
				case EStepType._EStepTypeEffectActive://  特效移动
					lockAll();
					SkillEffectUtil.addDramaEffect(int(data.entity), unlockThenEnd);
					break;
				case EStepType._EStepTypeEffectDel://  特效消失
					SkillEffectUtil.removeDramaEffect(int(data.entity));
					callEnd();
					break;
				
				
				case EStepType._EStepTypePlayerMoveOnly://  角色移动，屏幕不移动
					lockAll();
					playerMoveOnly.call(data, callEnd);
					break; 
				case EStepType._EStepTypePlayerMoveOnlyDel: // 取消角色移动屏幕不动
					playerMoveOnly.cancel(data, unlockThenEnd);
					break;
				
				case EStepType._EStepTypeScreenMove://  屏幕移动，角色不动
					lockAll();
					moveScreen.call(data, callEnd);
					break;
				case EStepType._EStepTypeScreenRestore://  恢复moveScreen
					moveScreen.cancel(data, unlockThenEnd);
					break;
				
				case EStepType._EStepTypePlayerMoveScreen:// 角色+屏幕一起移动，其他操作不能 
					lockAll();
					playerScreenMove.call(data, unlockThenEnd);
					break;
				
				case EStepType._EStepTypeScreenLock://  锁住屏幕，不能响应键盘、鼠标事件
					lockAll();
					callEnd();
					break;
				case EStepType._EStepTypeScreenUnlock://  解锁屏幕
					unLockAll();
					callEnd();
					break;
				
				case EStepType._EStepTypePlayerFly://  飞行， 不是小飞鞋
					break;
				case EStepType._EStepTypeMenuShow://  主界面显示
					LayerManager.uiLayer.visible = true;
					callEnd();
					break;
				case EStepType._EStepTypeMenuHide://  主界面隐藏
					LayerManager.uiLayer.visible = false;
					callEnd();
					break;
				case EStepType._EStepTypeMoviePlay:// 播放视频
					lockAll();
					movie.call(data, unlockThenEnd);
					break;
				case EStepType._EStepTypeMovieEnd:// 结束视频, 暂时不用，视频播放完毕就结束
					movie.cancel(data, unlockThenEnd);
					break;
				
				case EStepType._EStepTypeBossDialog: // boss顶冒泡
					lockAll();
					bossTalk.call(data, unlockThenEnd);
					break;
				case EStepType._EStepTypeBossActive:// 怪物动作
					lockAll();
					bossAction.call(data, unlockThenEnd);
					break;
				
				case EStepType._EStepTypeNpcDialog: // NPC顶冒泡
					lockAll();
					npcSceneTalk.call(data, unlockThenEnd);
					break;
				case EStepType._EStepTypeNpcActive:// NPC动作
					lockAll();
					npcAction.call(data, unlockThenEnd);
					break;
			}
			
		
		}
		
		private function unlockThenEnd():void
		{
			unLockAll();
			callEnd();
		}
		
		private function callEnd():void
		{
			CallLater.addCallBack(nextFrame);
			function nextFrame():void
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.Task_DramaNextStep, _lastStep));
			}
		}
		
		private function lockAll():void
		{
			TaskDramaMouseKeyboardControl.enablePlayerOp = false;
			TaskDramaMouseKeyboardControl.enableViews = false;
		}
		
		private function unLockAll():void
		{
			TaskDramaMouseKeyboardControl.enablePlayerOp = true;
			TaskDramaMouseKeyboardControl.enableViews = true;
		}
		
		private function get blackScreen():TaskDramaOpBlackScreen
		{
			return TaskDramaOpBlackScreen.instance;
		}
		
		private var _blackThenTips:TaskDramaOpBlackScreenThenTips;
		private function get BlackThenTips():TaskDramaOpBlackScreenThenTips
		{
			if(_blackThenTips == null)
			{
				_blackThenTips = new TaskDramaOpBlackScreenThenTips();
			}
			return _blackThenTips;
		}
		
		private var _npcTalk:TaskDramaOpTalk;
		private function get npcTalk():TaskDramaOpTalk
		{
			if(_npcTalk == null)
			{
				_npcTalk = new TaskDramaOpTalk();
			}
			return _npcTalk;
		}
		
		private var _hidePet:TaskDramaOpPetHide;
		private function get hidePet():TaskDramaOpPetHide
		{
			if(_hidePet == null)
			{
				_hidePet = new TaskDramaOpPetHide();
			}
			return _hidePet;
		}
		
		private var _playerMoveOnly:TaskDramaPlayerMoveOnly
		private function get playerMoveOnly():TaskDramaPlayerMoveOnly
		{
			if(_playerMoveOnly == null)
			{
				_playerMoveOnly = new TaskDramaPlayerMoveOnly();
			}
			return _playerMoveOnly;
		}
		
		private var _moveScreen:TaskDramaScreenMove;
		private function get moveScreen():TaskDramaScreenMove
		{
			if(_moveScreen == null)
			{
				_moveScreen = new TaskDramaScreenMove();
			}
			return _moveScreen;
		}
		
		private var _taskTalk:TaskDramaOpTaskTalkText;
		private function get taskTalk():TaskDramaOpTaskTalkText
		{
			if(_taskTalk == null)
			{
				_taskTalk = new TaskDramaOpTaskTalkText();
			}
			return _taskTalk;
		}
		
		private var _playerScreenMove:TaskDramaPlayerScreenMove;
		private function get playerScreenMove():TaskDramaPlayerScreenMove
		{
			if(_playerScreenMove == null)
			{
				_playerScreenMove = new TaskDramaPlayerScreenMove();
			}
			return _playerScreenMove;
		}
		
		private var _bossTalk:TaskDramaBossTalk;
		private function get bossTalk():TaskDramaBossTalk
		{
			if(_bossTalk == null)
			{
				_bossTalk = new TaskDramaBossTalk();
			}
			return _bossTalk;
		}
		
		private var _bossAction:TaskDramaBossAction;
		private function get bossAction():TaskDramaBossAction
		{
			if(_bossAction == null)
			{
				_bossAction = new TaskDramaBossAction();
			}
			return _bossAction;
		}
		
		private var _npcSceneTalk:TaskDramaNpcTalk;
		private function get npcSceneTalk():TaskDramaNpcTalk
		{
			if(_npcSceneTalk == null)
			{
				_npcSceneTalk = new TaskDramaNpcTalk();
			}
			return _npcSceneTalk;
		}
		
		private var _npcAction:TaskDramaNpcAction;
		private function get npcAction():TaskDramaNpcAction
		{
			if(_npcAction == null)
			{
				_npcAction = new TaskDramaNpcAction();
			}
			return _npcAction;
		}
		
		private var _movie:TaskDramaMovie;
		private function get movie():TaskDramaMovie
		{
			if(_movie == null)
			{
				_movie = new TaskDramaMovie();
			}
			return _movie;
		}
	}
}