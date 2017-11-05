/**
 * 2014-3-10
 * @author chenriji
 **/
package mortal.game.view.copy
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	import Message.DB.Tables.TCopy;
	import Message.Public.ECopyMode;
	import Message.Public.SCopyWaitingInfo;
	import Message.Public.SPlayerCopyInfo;
	
	import com.mui.controls.Alert;
	import com.mui.controls.GLoadingButton;
	
	import extend.language.Language;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.resource.CopyConfig;
	import mortal.game.view.copy.group.CopyGroupController;
	import mortal.game.view.copy.group.CopyGroupModule;
	import mortal.game.view.npc.data.NpcFunctionData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class CopyController extends Controller
	{
		public var currentCopy:ICopyController;
		
		/**
		 * 副本通关评分面板
		 */		
//		private var _copyGradeAcountPanel:CopyGradeAccountView;
		
		/**
		 * 副本离开按钮
		 */		
		private var _copyLeaveBtn:GLoadingButton;
		
		///////////////////////////////////////////////////////// 每一个副本的controller
		public var group:CopyGroupController;
		
		
		public function CopyController()
		{
			super();
			initControllers();
			
//			ClockManager.instance.addEventListener(TimeEvent.DateChange,onCleanCopyEnteredNum);
		}

		
		protected function initControllers():void
		{
			group = new CopyGroupController();
		}
		
		override protected function initServer():void
		{
			// 副本次数更新
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicPlayerCopyInfo, copyEnterNumHandler);
			// 离开副本
			Dispatcher.addEventListener(EventName.CopyClickQuickBtn, onQuitCopy);
			// 申请进入副本
			Dispatcher.addEventListener(EventName.CopyGroupEnterCopyReq, enterGroupCopyReqHandler);
			
//			Dispatcher.addEventListener(EventName.AutoFight_A, showGroupModule);
			
			////////////////////////////////////////////////////////////////////////////////////////////////////
			
			/**
			Dispatcher.addEventListener(EventName.CopyKickOut,doKickOut);
			Dispatcher.addEventListener(EventName.CopyLeaveWithoutComfirm,doLeaveWithoutComfirm);
			Dispatcher.addEventListener(EventName.VIPHookQuit,onQuitVipHookMap);//离开vip挂机地图
			
			Dispatcher.addEventListener(EventName.CopyEnterPracticeCopy,onEnterCopyPracticeMode);//进入副本训练模式
			
			Dispatcher.addEventListener(EventName.CopyTotalExpGetReq,onGetAllCopyOffLineExp);
			Dispatcher.addEventListener(EventName.CopySetCopyExtraTime,onSetCopyExtraTime);
			
			Dispatcher.addEventListener(EventName.CopyAddLeaveButton,addLeaveBtn); //增加离开按钮
			Dispatcher.addEventListener(EventName.CopyRemoveLeaveButton,removeLeaveBtn); //移除离开按钮
			
			NetDispatcher.addCmdListener(ServerCommand.Copy_CopyNumInfoChange,onCopyNumInfoChange);
			NetDispatcher.addCmdListener(ServerCommand.Copy_RefreshCountDownInfo,onCountDownInfoChange);
			NetDispatcher.addCmdListener(ServerCommand.Copy_DefendCopyAddExp,onDefendCopyAddExp);
			
			NetDispatcher.addCmdListener(ServerCommand.Copy_EnterCopy,onEnterCopy);
			NetDispatcher.addCmdListener(ServerCommand.Copy_LeaveCopy,onLeaveCopy);
			
			NetDispatcher.addCmdListener(ServerCommand.Copy_ProcessUpdate,onCopyProcessUpdate);//副本进度更新
			
			//RolePlayer.instance.addEventListener(PlayerEvent.RoleLevelUpdate,onCopyNumInfoChange);
			Dispatcher.addEventListener(EventName.Guide_ClickCopyExit,onGuideCopyExitClick); **/
		}
		
		private function copyEnterNumHandler(mb:MessageBlock):void
		{
			var info:SPlayerCopyInfo = mb.messageBase as SPlayerCopyInfo;
			cache.copy.updateEnterCounts(info.playerCopys);
		}
		
		public function get copyInfo():TCopy
		{
			return null;
		}
		
		private function enterGroupCopyReqHandler(evt:DataEvent):void
		{
			var info:TCopy = evt.data as TCopy;
			if(info == null)
			{
				return;
			}
			GameProxy.copy.enterCopy(info.code);
		}
		
		/**
		 * 离开副本
		 * 
		 * */
		private function onQuitCopy(e:DataEvent = null):void
		{
			if(_view)
			{
				_view.hide();
			}
			if(!copyInfo)
			{
				return;
			}
			
			var flag:uint;
			var alarmText:String = Language.getString(20197);
			Alert.show(alarmText,null,Alert.YES|Alert.NO,null,onLeaveComfirm);
		}
		
		public function onLeaveComfirm(flag:int):void
		{
			if(flag == Alert.NO)
			{
			}
			else if(flag == Alert.YES)
			{
				leave();
			}
		}
		//离开
		private function leave():void
		{
			GameProxy.copy.leaveCopy();
		}
		
		
//		/**
//		 * 晚上十二点，进入副本次数清零
//		 * 
//		 * */
//		private function onCleanCopyEnteredNum(e:Object = null):void
//		{
//			cache.copy.cleanCopyEnteredNum();
////			NetDispatcher.dispatchCmd(ServerCommand.Copy_CopyNumInfoChange, null);
//		}
//		
		
//		
//		/**
//		 * 进入副本
//		 * @param e
//		 * 
//		 */		
//		private function onEnterCopy(obj:Object):void
//		{
//			if(!Game.isSceneInit())
//			{
//				_tempObj = obj;
//				Dispatcher.addEventListener(EventName.Scene_Update, onSceneUpdateHandler);
//				return;
//			}
//			else if(!cache.copy.isInCopy)
//			{
//				return;
//			}
//			
//			var copy:TCopy = CopyConfig.instance.getCopyInfoByCode(obj as int);
//			if(!copy)
//			{
//				return;
//			}
//			
//			// 隐藏组队副本的模块
//			// 赋值currentCopy为哪个controller
//			
//			//需要收起任务栏的副本
//			if(needHideTaskTrace(copy))
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.TaskTrackShowOrHide, false));
//			}
//			
//			//需要收起上下图标
//			if(needHideMainUI(copy))
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.ShowHideMainUI, false));
//			}
//			
//			// 需要隐藏快捷键栏目
//			if(needHideShortcuts(copy))
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarShowHide, false));
//			}
//			
//			//需要显示离开按钮的副本
//			if(needShowLeaveBtn(copy))
//			{
//				setTimeout(addLeaveBtn,1000);
//			}
//			else
//			{
//				removeLeaveBtn();
//			}
//			
//		}
//		
//		private var _tempObj:Object;
//		private function onSceneUpdateHandler(e:*):void
//		{
//			Dispatcher.removeEventListener(EventName.Scene_Update,onSceneUpdateHandler);
//			onEnterCopy(_tempObj);
//		}
//		
//		/**
//		 * 离开副本
//		 * @param copy
//		 * 
//		 */		
//		private function onLeaveCopy(copy:TCopy):void
//		{
//			if(currentCopy)
//			{
//				currentCopy.leaveCopy();
//				currentCopy = null;
//			}
//			
//			//需要收起任务栏的副本
//			if(needHideTaskTrace(copy))
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.TaskTrackShowOrHide,true));
//			}
//			
//			//需要收起上下图标
//			if(needHideMainUI(copy))
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.ShowHideMainUI,true));
//			}
//			
//			// 需要隐藏快捷键栏目
//			if(needHideShortcuts(copy))
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarShowHide, true));
//			}
//			
//			//移除离开按钮
//			removeLeaveBtn();
//			
////			MsgManager.removeTaskTarget();
//		}
//		
//		private function addLeaveBtn(e:Event = null):void
//		{
//			if((cache.copy.isInCopy && !_copyLeaveBtn))
//			{
//				_copyLeaveBtn = UIFactory.gLoadingButton(ResFileConst.TaskCatogeryBtn, 320, 20, 50, 50, LayerManager.uiLayer);
//				_copyLeaveBtn.configEventListener(MouseEvent.CLICK,onLeaveCopyBtnClick);
//			}
//		}
//		
//		private function removeLeaveBtn(e:Event = null):void
//		{
//			if(_copyLeaveBtn && _copyLeaveBtn.parent)
//			{
//				EffectManager.glowFilterUnReg(_copyLeaveBtn);
//				DisplayUtil.removeMe(_copyLeaveBtn);
//				_copyLeaveBtn = null;
//			}
//		}
//		
//		/**
//		 * 是否需要收起任务栏
//		 * @param copy
//		 * @return 
//		 * 
//		 */		
//		private function needHideTaskTrace(copy:TCopy):Boolean
//		{
//			if(!copy)
//			{
//				return false;
//			}
//			
////			if(copy.code == 106 || copy.code == 116 || copy.code == 123 
////				|| copy.copyType == ECopyType._ECopyDefense 
////				|| copy.copyType == ECopyType._ECopy60Defense 
////				|| copy.copyType == ECopyType._ECopySeventy 
////				|| copy.copyType == ECopyType._ECopyGuildStruggle
////				|| copy.copyType == ECopyType._ECopyGuildDefense
////				|| copy.copyType == ECopyType._ECopyEighty
////				|| copy.copyType == ECopyType._ECopySeal
////				|| copy.copyType == ECopyType._ECopyCrossStair
////				|| copy.copyType == ECopyType._ECopyRobCityOne 
////				|| copy.copyType == ECopyType._ECopyRobCityTwo 
////				|| copy.copyType == ECopyType._ECopyRobCityThree 
////				|| copy.copyType == ECopyType._ECopyCountryMoney
////				|| copy.copyType == ECopyType._ECopyRobFlag
////				|| copy.copyType == ECopyType._ECopyGuildElite
////				|| copy.copyType == ECopyType._ECopy80Defense
////				|| copy.copyType == ECopyType._ECopyFireMonsterIsland
////				|| copy.copyType == ECopyType._ECopyFireIslandCenter
////				|| copy.copyType == ECopyType._ECopyUpgradeCrossSecret
////				)
////			{
////				return true;
////			}
//			return false;
//		}
//		
//		/**
//		 * 是否需要收起上下图标 
//		 * @return 
//		 * 
//		 */		
//		private function needHideMainUI(copy:TCopy):Boolean
//		{
//			if(!copy)
//			{
//				return false;
//			}
//			
////			if(copy.copyType == ECopyType._ECopyRobCityTwo 
////				|| copy.copyType == ECopyType._ECopyRobCityThree
////				|| copy.copyType == ECopyType._ECopyCountryMoney
////				|| copy.copyType == ECopyType._ECopyCrossBoss
////				|| copy.copyType == ECopyType._ECopyCrossBossEntrance
////				|| copy.copyType == ECopyType._ECopyRobFlag
////				|| copy.copyType == ECopyType._ECopyGuildElite
////				|| copy.copyType == ECopyType._ECopy80Defense
////				|| copy.copyType == ECopyType._ECopyFireMonsterIsland
////				|| copy.copyType == ECopyType._ECopyFireIslandCenter
////				|| copy.copyType == ECopyType._ECopyUpgradeCrossSecret
////			)
////			{
////				return true;
////			}
//			return false;
//		}
//		
//		/**
//		 * 是否需要隐藏快捷键栏 
//		 * @param copy
//		 * @return 
//		 * 
//		 */		
//		private function needHideShortcuts(copy:TCopy):Boolean
//		{
////			if(cache.copy.isInCrossDefenceCopy()
////				|| copy.copyType == ECopyType._ECopyCountryMoney
////				|| copy.copyType == ECopyType._ECopyRobFlag )
////			{ 
////				return true;
////			}
//			return false;
//		}
//		
//		/**
//		 * 是否需要显示离开按钮
//		 * @param copy
//		 * @return 
//		 * 
//		 */		
//		private function needShowLeaveBtn(copy:TCopy):Boolean
//		{
////			if(copy.copyType == ECopyType._ECopyVIPHook
////			    || copy.copyType == ECopyType._ECopyCrossSecret
////			)
////			{
////				return true;
////			}
//			return false;
//		}
//		
//		/**
//		 * 副本进度更新 
//		 * @param e
//		 * 
//		 */		
//		private function onCopyProcessUpdate(e:*):void
//		{
////			ThingUtil.isEntitySort = true;
//			if(currentCopy)
//			{
//				currentCopy.updateCopyProcess();
//			}
//		}
//		
//		/**
//		 * 副本信息类型
//      	 * enum ECopyInfoType
//      	 * {
//      	 * ECopyInfoTypeRing           = 0,   //副本环数     num1--环数 num2--时间
//      	 * ECopyInfoTypeEnd            = 1,   //副本结束时间 num1--结束倒计时
//      	 * ECopyInfoTypeEvenCut        = 2,   //连斩副本显示 num1--当前连斩次数 num2--下一次连斩倒计时 num3--积分值 num4--最大连斩数 num5--杀怪数量 num6--副本排名
//      	 * ECopyInfoTypeExchange       = 4,   //兑换规则     num1--消耗积分数 num2--获得铜钱数 num3--副本ID num4--杀怪数量 num5--最大连斩 num6--积分排名
//      	 * ECopyInfoTypeBossRefresh    = 8,   //触发刷怪方案	num1--怪物id	num2--倒计时时间
//      	 * ECopyInfoTypeEvenCutEx      = 16,  //高级连斩FB显示   num1--当前连斩次数 num2--下一次连斩倒计时 num3--最大连斩数 num4--小怪数量 num5--BOSS数量 num6--铜钱 num7-绑定铜钱 num8--历史最大连斩 num9--历史最大击杀BOSS
//      	 * ECopyInfoTypeEvenCutEnd     = 32,  //铜钱FB结束   num1--当前连斩次数 num2--下一次连斩倒计时 num3--最大连斩数 num4--小怪数量 num5--BOSS数量 num6--铜钱 num7-绑定铜钱 num8--历史最大连斩 num9--历史最大收益数
//      	 * ECopyInfoTypeMark		   = 64,  //副本评分 num1--杀怪数量 num2--获得经验 num3--时间  num4--进度(层数)  num5--环数  num6--积分
//      	 * };
//	 	 * 
//		 * 副本倒计时，积分等信息
//		 * @param msgInfo
//		 * 
//		 */		
//		private function onCountDownInfoChange(msgInfo:SCopyMsgInfo):void
//		{
//			if(!copyInfo)
//			{
//				return;
//			}
//			
//			switch(msgInfo.type.value())
//			{
//				case ECopyInfoType._ECopyInfoTypeRing:
//					if(currentCopy == defenceCopy)
//					{
//						defenceCopy.updateRing(msgInfo);
//					}
//					else if(copyInfo.copyType == ECopyType._ECopyGuildDefense)
//					{
//						Dispatcher.dispatchEvent(new DataEvent(EventName.GuildDefenseUpdateRing,msgInfo.num1));
//					}
//					else if(copyInfo.copyType == ECopyType._ECopy80Defense)
//					{
//						eightyDefenceCopy.updateRing(msgInfo);
//					}
//					break;
//				
//				//副本剩余时间--新的打钱副本
//				case ECopyInfoType._ECopyInfoTypeEnd:
//					//_countDownLabel.setTimeLabel_End(msgInfo.num1);
//					NetDispatcher.dispatchCmd(ServerCommand.CoinCopyEndTimeUpdate,msgInfo.num1);
//					break;
//				
//				case ECopyInfoType._ECopyInfoTypeEvenCut:
//					//countDownLabel.setKillCountsLabel(msgInfo.num1,msgInfo.num2,msgInfo.num3);
//					break;
//				
//				case ECopyInfoType._ECopyInfoTypeExchange:
//					var title:String = CopyConfig.instance.getInfoByCode(msgInfo.num3).name;
//					var accountpanel:CopyRewardsAccountPanel = new CopyRewardsAccountPanel();
//					accountpanel.title = title;
//					PopupManager.addPopUp(accountpanel,"",false);
//					accountpanel.startAccounts(msgInfo.num4,msgInfo.num5,msgInfo.num1,msgInfo.num2,msgInfo.num6);
//					break;
//				
//				case ECopyInfoType._ECopyInfoTypeBossRefresh:
//					if(cache.copy.isInPetlandCopy() && msgInfo.num2 == 0)	//宠物岛副本刷出稀有boss屏幕抖动
//					{
//						//屏幕抖动
//						Game.scene.shake(3);
//					}
//					else if(currentCopy == defenceCopy)
//					{
//						defenceCopy.updateBossRefresh(msgInfo);
//					}
//					break;
//				
//				//铜钱副本消息更新
//				case ECopyInfoType._ECopyInfoTypeEvenCutEx:
//					//交给铜钱副本处理
//					NetDispatcher.dispatchCmd(ServerCommand.CoinCopyMsgInfoUpdate,msgInfo);
//					break;
//				
//				//铜钱副本结束
//				case ECopyInfoType._ECopyInfoTypeEvenCutEnd:
//					//交给铜钱副本处理
//					NetDispatcher.dispatchCmd(ServerCommand.CoinCopyMsgEnd,msgInfo);
//					break;
//				
//				case ECopyInfoType._ECopyInfoTypeMark:
//					if(isShowDrawAndMark())
//					{
//						if(msgInfo.num9 == 1 && !PulseSharedObject.isTodayNotTips(TodayNoTipsConst.CopyGradeAccountTodayNoTips))
//						{
//							showCopyGradeAccountPanel(msgInfo);
//						}
//						else
//						{
//							var copy:TCopy = CopyConfig.instance.getInfoByCode(msgInfo.num8);
//							checkAndShowCopyDrawReward(copy);
//						}
//					}
//					break;
//				/*case ECopyInfoType._ECopyInfoTypeMarkEx://王者副本
//					showCopyGradeAccountPanel(msgInfo);
//					break;*/
//			}
//		}
//		
//		/**
//		 * 显示副本通关评分面板
//		 * @param msgInfo
//		 * 
//		 */		
//		private function showCopyGradeAccountPanel(msgInfo:SCopyMsgInfo):void
//		{
//			if(!_copyGradeAcountPanel)
//			{
//				_copyGradeAcountPanel = new CopyGradeAccountView(cache.role.playerInfo.sex);
//				_copyGradeAcountPanel.addEventListener(ViewEvent.Hide,onCopyGradeAcountPanelHide);
//			}
//			_copyGradeAcountPanel.show();
//			_copyGradeAcountPanel.updateInfo(msgInfo);
//			stageResize();
//		}
//		
//		private function onCopyGradeAcountPanelHide(e:ViewEvent):void
//		{
//			checkAndShowCopyDrawReward(_copyGradeAcountPanel.copy);
//		}
//		
//		/**
//		 * 防守副本，刷怪获得累积经验
//		 * @param value
//		 * 
//		 */		
//		private function onDefendCopyAddExp(value:int):void
//		{
//			if(!copyInfo)
//			{
//				return;
//			}
//			
//			if(currentCopy == defenceCopy)
//			{
//				defenceCopy.updateRingBottleExp();
//			}
//			if(currentCopy == eightyDefenceCopy)
//			{
//				eightyDefenceCopy.updateExp(value);
//			}
//		}
//		
//		/**
//		 * 从NPC处进入副本
//		 * 
//		 * */
//		private function onCopyChooseFromNpc(e:DataEvent):void
//		{
//			var code:int = e.data as int;
//			var copy:TCopy = CopyConfig.instance.getInfoByCode(code);
//			
//			if(!copy)
//			{
//				MsgManager.showRollTipsMsg(Language.getString(60023));
//				return;
//			}
//			
//			if(!checkCanEnterCopy(copy))
//			{
//				return;
//			}
//			
//			if(copy && copy.singleMode == 1)
//			{
//				doEnterCopy(copy.code);
//			}
//			else
//			{
//				var npcInfo:NPCInfo = cache.dialog.npcInfo;
//				if(npcInfo)
//				{
//					if(CopyUtil.isCrossCopy(copy))
//					{
//						GameProxy.copy.enterCrossCopyWaitingRoom_async(code,ECopyWaitingOperate._ECopyWaitingEnter,npcInfo.tnpc.npcId);
//					}
//					else
//					{
//						GameProxy.copy.enterCopyWaitingRoom_async(code,ECopyWaitingOperate._ECopyWaitingEnter,npcInfo.tnpc.npcId);
//					}
//					
//					copyGroupController.showModuleByCopy(copy,npcInfo);
//				}
//			}
//		}
//		
//		/**
//		 * 检查是否符合进入副本的所有条件 
//		 * @return 
//		 * 
//		 */		
//		private function checkCanEnterCopy(copy:TCopy):Boolean
//		{
//			if(cache.role.roleInfo.level < copy.enterMinLevel)
//			{
//				MsgManager.showRollTipsMsg(Language.getString(60024));
//				return false;
//			}
//			else if(cache.task.getTrasnportTask())
//			{
//				Alert.buttonWidth = 75;
//				Alert.okLabel = Language.getString(60025);
//				Alert.show(Language.getString(60026),Language.getString(69900),Alert.OK|Alert.CANCEL,null,function(flag:int):void
//				{
//					if(flag == Alert.OK)
//					{
//						AIManager.onAutoPathAIControl(cache.task.getTrasnportTask().getTargetByIndex(0));
//					}
//				});
//				return false;
//			}
//			else if( copy.difficultyNum != EDifficultyOption._EDifficultyHard && cache.copy.getCopyNumInfoByCode(copy.code) && cache.copy.getCopyNumInfoByCode(copy.code).todayEnterNum >= CopyUtil.getCopyNumByDay(copy) && !Global.isDebugModle)
//			{
//				MsgManager.showRollTipsMsg(Language.getString(60027));
//				var info:TaskActInfo = cache.task.getNearlyActiveDaily();
//
//				if(info)
//				{
//					Alert.buttonWidth = 75;
//					Alert.okLabel = Language.getString(60028);
//					Alert.show(Language.getString(60029) + HTMLUtil.addColor(info.dailyInfo.name,"#FF00FF") + "。",Language.getString(69900),Alert.OK|Alert.CANCEL,null,function(flag:int):void
//					{
//						if(flag == Alert.OK)
//						{
//							Dispatcher.dispatchEvent(new DataEvent(EventName.DailyActiveGoTo,info.dailyInfo));
//						}
//					});
//				}
//				return false;
//			}
//			return true;
//		}
//		
//		
//		private function onCopyGroupEnterCopy(e:DataEvent):void
//		{
//			var code:int = e.data as int;
//			doEnterCopy(code);
//		}
//		
//		/**
//		 * 进入副本联系模式 
//		 * @param e
//		 * 
//		 */		
//		private function onEnterCopyPracticeMode(e:DataEvent):void
//		{
//			var code:int = e.data as int;
//			
//			var copy:TCopy = CopyConfig.instance.getInfoByCode(code);
//			if(copy)
//			{
//				Alert.extendObj = code;
//				
//				var text:String = Language.getStringByParam(60462,GameConst.CrossDefensePracticeNum,HTMLUtil.addColor(copy.name,"#00a2ff"),GameConst.CrossDefensePracticeCost);
//				Alert.show(text,null,Alert.OK|Alert.CANCEL,null,onEnterCopyPracticeAlertHandler);
//			}
//		}
//		private function onEnterCopyPracticeAlertHandler(flag:int,code:int):void
//		{
//			if(flag == Alert.OK)
//			{
//				GameProxy.copy.enterCrossCopy(code,true);
//			}
//		}
//		
//		
//		/**
//		 * 领取全部副本离线经验  -1:全部领取、 -2：领取单人副本、 -3：领取多人副本
//		 * @param e
//		 * 
//		 */		
//		private function onGetAllCopyOffLineExp(e:DataEvent):void
//		{
//			var code:int = e.data as int;
//			GameProxy.copy.drawCopyExp(-1,-1,code,0);
//		}
//		
//		/**
//		 * 设置副本合并进入次数
//		 * @param e
//		 * 
//		 */		
//		private function onSetCopyExtraTime(e:DataEvent):void
//		{
//			var data:Object = e.data;
//			cache.copy.setCopyExtraTime(data.copyId,data.value);
//		}
//		
//		
//		/**
//		 * 关闭转盘窗口，检查是否还有转盘
//		 * @param e
//		 * 
//		 */		
//		private function onDrawComplete(e:DataEvent):void
//		{
//			var item:ItemData;
//			var copy:TCopy;
//			
//			item = e.data as ItemData;
//			if(item)
//			{
//				copy = CopyConfig.instance.getInfoByCode(item.itemInfo.item.effectEx);
//			}
//			
//			//排除相同副本
//			if(!copy || (cache.copy.isInCopy && cache.copy.copyInfo && cache.copy.copyInfo.code == copy.code))
//			{
//				return;
//			}
//			
//			//暂时只开放爬塔副本
//			//都开放
//			if(true) //copy.copyType == ECopyType._ECopyTower)
//			{
//				item = getCopyBox(copy);
//				if(item)
//				{
//					drawCopyRewards(item);
//				}
//			}
//		}
//		
//		
//		private function onLeaveCopyBtnClick(e:MouseEvent):void
//		{
//			//离开跨服圣天城,在这里特殊处理，因为没有copyinfo
//			if(GameMapUtil.curMapState.isCrossMainCity)
//			{
//				GameProxy.sceneProxy.pass(EPassType.convert(EPassType._EPassTypeCrossUnique),0,0);
//				return;
//			}
//			else
//			{
//				onQuitCopy();
//			}
//		}
//		
//		
//		
//		//----------------------------------------------------------------------------------//
//		
//		/**
//		 * 进入某一副本 
//		 * 
//		 */		
//		private function doEnterCopy(code:int):void
//		{
//			var copy:TCopy = CopyConfig.instance.getInfoByCode(code);
//			
//			if(copy.singleMode == 1)
//			{
//				if(CopyUtil.isCrossCopy(copy))
//				{
//					var cost:int;
//					var unitStr:String;
//					if(copy.costCoin > 0)
//					{
//						cost = copy.costCoin;
//						unitStr = GameDefConfig.instance.getEPrictUnitName(EPrictUnit._EPriceUnitCoin);
//					}
//					else if(copy.costGold > 0)
//					{
//						cost = copy.costGold;
//						unitStr = GameDefConfig.instance.getEPrictUnitName(EPrictUnit._EPriceUnitGold);
//					}
//					
//					if(cost > 0)
//					{
//						Alert.extendObj = copy;
//						Alert.show(Language.getStringByParam(60901,cost,unitStr),Language.getString(69900),Alert.OK|Alert.CANCEL,null,onEnterCopyAlertHandler);
//					}
//					else
//					{
//						enterCopyEx(copy);
//					}
//				}
//				else
//				{
//					enterCopyEx(copy);
//				}
//			}
//			else
//			{
//				if(!CopyUtil.isCrossCopy(copy) && !cache.group.isInGroup)
//				{
//					Alert.extendObj = copy;
//					Alert.show("    " + Language.getString(60038),Language.getString(69900),Alert.OK|Alert.CANCEL,null,onCreateGroupAlertHandler);
//				}
//				else if(CopyUtil.isCrossCopy(copy) && !cache.crossGroup.isInGroup)
//				{
//					Alert.extendObj = copy;
//					Alert.show("    " + Language.getString(60903),Language.getString(69900),Alert.OK|Alert.CANCEL,null,onCreateGroupAlertHandler);
//				}
//				else if((!CopyUtil.isCrossCopy(copy) && cache.group.isCaptain) || (CopyUtil.isCrossCopy(copy) && cache.crossGroup.isCaptain))
//				{
//					Alert.extendObj = copy;
//					Alert.show("    " + Language.getStringByParam(60039,copy.name),Language.getString(69900),Alert.OK|Alert.CANCEL,null,onEnterCopyAlertHandler);
//				}
//				else
//				{
//					enterCopyEx(copy);
//				}
//			}
//		}
//		private function onCreateGroupAlertHandler(index:int, copy:TCopy):void
//		{
//			if(index == Alert.OK)
//			{
//				if(CopyUtil.isCrossCopy(copy))
//				{
//					GameProxy.crossGroupProxy.createGroup(cache.crossGroup.memberInvite,AutoFight.localAutoFight.acceptTeam);
//				}
//				else
//				{
//					GameProxy.groupProxy.createGroup(cache.group.memberInvite,AutoFight.localAutoFight.acceptTeam);
//				}
//			}
//		}
//		
//		private function onEnterCopyAlertHandler(flag:int,copy:TCopy):void
//		{
//			if(flag == Alert.OK)
//			{
//				enterCopyEx(copy);
//			}
//		}
//		
//		/**
//		 * 根据副本情况，调用进入副本接口
//		 * @param copy
//		 * 
//		 */		
//		private function enterCopyEx(copy:TCopy):void
//		{
//			var cost:int = 0;
//			var isEnough:Boolean;
//			var extraTime:int = cache.copy.getCopyExtraTime(copy.code);
//			
//			//如果合并数次大于0，检测元宝是否足够
//			if(extraTime > 0)
//			{
//				cost += copy.extraDropCost * extraTime;
//			}
//			
//			if(copy.copyType == ECopyType._ECopyTower)
//			{
//				if(CopyUtil.toWhichFloor != 0 && cache.pack.towerCopy.itemLength > 0)
//				{
//					MsgManager.showRollTipsMsg(Language.getString(60416));
//					return;
//				}
//				
//				var config:TMagicTowerConfig;
//				if(CopyUtil.toWhichFloor != 0)
//				{
//					config = MagicTowerConfig.instance.getJumpInfoByJumpFloor(copy.code,CopyUtil.toWhichFloor);
//					cost += config ? config.jumpCost : 0;
//				}
//				
//				isEnough = BuyAlert.checkMoney(EPrictUnit._EPriceUnitGold,cost);
//				if(!isEnough)
//				{
//					return;
//				}
//				
//				var floor:int = config ? config.realFloor : 1;
//				GameProxy.copy.enterMagicTower(copy.code,floor,extraTime);
//			}
//			else if(CopyUtil.isCrossCopy(copy))
//			{
//				//跨服副本直接调进入接口，服务器会判断后发消息确认CrossCopyCostNoticeCommand
//				GameProxy.copy.enterCrossCopy(copy.code);
//			}
//			else
//			{
//				isEnough = BuyAlert.checkMoney(EPrictUnit._EPriceUnitGold,cost);
//				if(!isEnough)
//				{
//					return;
//				}
//				
//				GameProxy.copy.enterCopyEx_async(copy.code,extraTime);
//			}
//		}
//		
//		private function doLeaveWithoutComfirm(e:DataEvent):void
//		{
//			GameProxy.copy.leftGroup_async();
//		}
//		
//		private function doKickOut(e:DataEvent):void
//		{
//			var id:SEntityId = e.data as SEntityId;
//			if(cache.copy.groupInfo.fighting)
//			{
//				function alertResult(data:int):void
//				{
//					if(data == Alert.YES)
//					{
//						GameProxy.copy.kickOutGroup_async(id);
//					}
//				}
//				Alert.show(Language.getString(60040),null,Alert.YES|Alert.NO,null,alertResult);
//			}
//			else
//			{
//				GameProxy.copy.kickOutGroup_async(id);
//			}
//		}
//		
//		/**
//		 * 指引点击副本出口 
//		 * @param event
//		 * 
//		 */
//		private var _leaveTips:GuideTips;
//		private function onGuideCopyExitClick(event:DataEvent):void
//		{
//			if(_copyLeaveBtn && _copyLeaveBtn.parent)
//			{
//				EffectManager.glowFilterReg(_copyLeaveBtn,[FilterConst.guideTipsFilter]);
//				var text:String = Language.getString(60041);
//				if(cache.copy.isInSeventyCopyWhichFloor() == 1)
//				{
//					text = Language.getString(60368);
//				}
//				
//				if(!_leaveTips)
//				{
//					_leaveTips = new GuideTips();
//				}
//				_leaveTips.updateTxt(text);
//				_leaveTips.updateDir(GuideTipsManager.Dir_TL);
//				//var tips:GuideTips = GuideTipsManager.getGuideTips(GuideTipsManager.Dir_TL,text);
//				_leaveTips.x = _copyLeaveBtn.x + _copyLeaveBtn.width;
//				_leaveTips.y = _copyLeaveBtn.y + _copyLeaveBtn.height;
//				_copyLeaveBtn.parent.addChild(_leaveTips);
//			}
//		}
//		
//		/**
//		 * 舞台大小改变 
//		 * 
//		 */
//		public function stageResize():void
//		{
//			if(currentCopy)
//			{
//				currentCopy.stageResize();
//			}
//			
//			copyGroupController.stageResize();
//			
//			if(_copyLeaveBtn)
//			{
//				_copyLeaveBtn.x = 320;
//				_copyLeaveBtn.y = 20;
//			}
//			
//			if(_drawRewardButton && _drawRewardButton.parent)
//			{
//				_drawRewardButton.x = Global.stage.stageWidth/2 + 3;
//			}
//			if(_drawRewardPanel)
//			{
//				_drawRewardPanel.stageResize();
//			}
//			
//			if(_copyGradeAcountPanel)
//			{
//				_copyGradeAcountPanel.x = Global.stage.stageWidth/2 - 320;
//				_copyGradeAcountPanel.y = Global.stage.stageHeight/2 - 225;
//			}
//			if(upgradeCrossSecretCopy)
//			{
//				upgradeCrossSecretCopy.stageResize();
//			}
//		}
	}
}