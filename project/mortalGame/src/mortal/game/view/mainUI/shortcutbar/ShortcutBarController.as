/**
 * 2014-1-9
 * @author chenriji
 **/
package mortal.game.view.mainUI.shortcutbar
{
	import Message.Public.ESkillType;
	import Message.Public.ESkillUpdateType;
	import Message.Public.SSkill;
	
	import com.gengine.global.Global;
	
	import extend.language.Language;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mortal.common.net.CallLater;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.rules.BossRule;
	import mortal.game.scene3D.ai.AIFactory;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.ai.data.FollowFightAIData;
	import mortal.game.scene3D.ai.singleAIs.TabKeyAI;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.util.FightUtil;
	import mortal.game.utils.BuffUtil;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.game.view.common.display.FlyToNavbarTool;
	import mortal.game.view.common.item.CDItem;
	import mortal.game.view.skill.SkillController;
	import mortal.game.view.skill.SkillInfo;
	import mortal.game.view.skill.SkillLearnModule;
	import mortal.game.view.skill.panel.SkillLearnItem;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.game.view.systemSetting.SystemSettingType;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class ShortcutBarController extends Controller
	{
		private var _shortcutBar:ShortcutBar;
		private var _nextCanUseShortcutTime:int = 0;
		public function ShortcutBarController()
		{
			super();
		}
		
		protected override function initView():IView
		{
			if(_shortcutBar == null)
			{
				_shortcutBar = new ShortcutBar();
			}
			return _shortcutBar;
		}
		
		protected override function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.ShortcutBarDataUpdate, shortcutDataUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.SkillUpgrade, skillUpgradeHandler);
			NetDispatcher.addCmdListener(ServerCommand.SkillAdd, skillAddHandler);
			NetDispatcher.addCmdListener(ServerCommand.BufferUpdate, buffUpdateHandler);
			
			Dispatcher.addEventListener(EventName.StageResize, stageResizeHandler);
			Dispatcher.addEventListener(EventName.ShortcutKeyUpdate, shorcutKeyUpdateHandler);//更新所有快捷键
			Dispatcher.addEventListener(EventName.ShortcutBarDataChange, shortcutBarDataChangeHandler);
			Dispatcher.addEventListener(EventName.ShortcutBarMoveIn, moveInHandler);
			Dispatcher.addEventListener(EventName.ShortcutBarThrow, throwHandler);
			
			Dispatcher.addEventListener(EventName.ShortcutBarKeyDown, keyDownHandler); // 快捷方式
			Dispatcher.addEventListener(EventName.ShortcutBarClicked, clickHandler);
			Dispatcher.addEventListener(EventName.ShortcutBarKeyUp, keyUpHandler); // 快捷方式
			Dispatcher.addEventListener(EventName.ShortcutBarCDFinished, cdFinishedHandler);
			
			Dispatcher.addEventListener(EventName.TabKeyChangeTarget, tabKeyChangeTargetHandler);
			
			// 监听跟技能栏相关的系统设置
			Dispatcher.addEventListener(EventName.SystemSettingSaved, settingSavedHandler);
			NetDispatcher.addCmdListener(ServerCommand.SystemSettingDataGot, systemSettingGotHandler);
		}
		
		private function systemSettingGotHandler(obj:Object):void
		{
			if(_shortcutBar != null)
			{
				updateLockStatus();
				updateShowCDTime();
			}
		}
		
		private function settingSavedHandler(evt:DataEvent):void
		{
			var type:int = int(evt.data["type"]);
			if(type != SystemSettingType.SystemSetting)
			{
				return;
			}
			updateLockStatus();
			updateShowCDTime();
		}
		
		private function updateLockStatus():void
		{
			var isLock:Boolean = SystemSetting.instance.isLockShortcut.bValue;
			var lastLocked:Boolean = cache.shortcut.isLocked;
			if(isLock == lastLocked)
			{
				return;
			}
			cache.shortcut.isLocked = isLock;
			var all:Array = _shortcutBar.getAllItems();
			for(var i:int = 0; i < all.length; i++)
			{
				var item:ShortcutBarItem = all[i];
				if(item == null)
				{
					continue;
				}
				item.setLock(isLock);
			}
		}
		
		private function updateShowCDTime():void
		{
			var isShow:Boolean = SystemSetting.instance.isShortcutShowSecond.bValue;
			var lastIsShow:Boolean = cache.shortcut.isShowCDTime;
			if(isShow == lastIsShow)
			{
				return;
			}
			cache.shortcut.isShowCDTime = isShow;
			var all:Array = _shortcutBar.getAllItems();
			for(var i:int = 0; i < all.length; i++)
			{
				var item:ShortcutBarItem = all[i];
				if(item == null)
				{
					continue;
				}
				item.isShowLeftTimeEffect = isShow;
			}
		}
		
		/**
		 *  buff更新的时候， 检查技能栏里面的技能能否使用
		 * @param obj
		 * 
		 */		
		private function buffUpdateHandler(obj:Object):void
		{
			// 找到所有技能，判断一遍是否能使用
			var items:Array = _shortcutBar.getAllItems();
			for(var i:int = 0; i < items.length; i++)
			{
				var item:ShortcutBarItem = items[i];
				if(item == null)
				{
					continue;
				}
				var info:SkillInfo = item.dragSource as SkillInfo;
				if(info == null)
				{
					continue;
				}
				// 不能使用的，并且不许使用快捷键、鼠标
				if(!BuffUtil.isCanRoleFireSkill(info))
				{
					item.mouseChildren = false;
					item.mouseEnabled = false;
					item.filters = [FilterConst.colorFilter];
				}
				else
				{
					item.mouseChildren = true;
					item.mouseEnabled = true;
					item.filters = [];
				}
			}
		}
		
		private function skillAddHandler(obj:Object):void
		{
			if(cache.shortcut.isLocked)
			{
				return;
			}
			CallLater.addCallBack(nextFrameLearnSkill);
			var targetItem:ShortcutBarItem;
			
			function nextFrameLearnSkill():void
			{
				var info:SkillInfo = cache.skill.getSkill(SSkill(obj).skillId);
				var item:ShortcutBarItem = getSkillsShortcutItem(info);
				if(item != null) // 已经有快捷键了，不用自动添加
				{
					return;
				}
			
				// 找到第一个空的，把它加进去
				var items:Array = _shortcutBar.getAllItems();
				for(var i:int = 1; i < items.length; i++)
				{
					item = items[i];
					if(item == null || item.dragSource != null)
					{
						continue;
					}
					if(cache.shortcut.getData(i) != null)
					{
						continue;
					}
					targetItem = item;
					break;
				}
				if(targetItem == null)
				{
					return;
				}
				var yellowP:Point = new Point(0, 0);
				if(SkillController(GameController.skill).isModuleShowing)
				{
					var fromItem:SkillLearnItem = SkillLearnModule(GameController.skill.view).getItemByPos(info.position);
				}
				
				// 记录到快捷栏的数据
				var info2:SkillInfo = cache.skill.getSkill(SSkill(obj).skillId);
				var fromType:int = CDDataType.parseType(info2);
				var fromValue:Object = ShortcutBarUtil.parseValue(info2);
				cache.shortcut.addShortCut(targetItem.pos, fromType, fromValue);
				cache.shortcut.save();
				
				
				if(fromItem != null && fromItem.skillItem != null)
				{
					var p:Point = fromItem.localToGlobal(yellowP);
					p.x += 28;
					p.y += 28;
					FlyToNavbarTool.flyToAnyPoint(fromItem.skillItem.bitmapdata, p, targetItem.localToGlobal(yellowP), afterFlyTo,
						targetItem.width, targetItem.height, true);
				}
				else
				{
//					targetItem = null;
					afterFlyTo();
				}
			}
			function afterFlyTo():void
			{
				if(targetItem == null)
				{
					return;
				}
				var info2:SkillInfo = cache.skill.getSkill(SSkill(obj).skillId);
				_shortcutBar.updateShortcutSource(targetItem.pos, info2);
				targetItem = null;
			}
		}
		
		private var _lastFrameSSkill:SSkill;
		/**
		 * 技能升级， 返回的是新的技能 
		 * @param obj
		 * 
		 */		
		private function skillUpgradeHandler(obj:Object):void
		{
			_lastFrameSSkill = obj as SSkill;
			CallLater.addCallBack(nextFrameSkillUpgrade);
		}
		private function nextFrameSkillUpgrade():void
		{
			var skill:SSkill = _lastFrameSSkill;
			var info:SkillInfo = cache.skill.getSkill(skill.skillId);
			if(info == null)
			{
				return;
			}
			var item:ShortcutBarItem = getSkillsShortcutItem(info);
			if(item != null)
			{
				item.dragSource = info;
			}
		}
		
		private function getSkillsShortcutItem(info:SkillInfo):ShortcutBarItem
		{
			var items:Array = _shortcutBar.getAllItems();
			for(var i:int = 0; i < items.length; i++)
			{
				var item:ShortcutBarItem = items[i];
				if(item && (item.dragSource is SkillInfo))
				{
					var preInfo:SkillInfo = item.dragSource as SkillInfo;
					if(preInfo.tSkill.series == info.tSkill.series)
					{
						return item;
					}
				}
			}
			return null;
		}
		
		private function stageResizeHandler(evt:DataEvent):void
		{
			_shortcutBar.onStageResize();
		}
		
		private function moveInHandler(evt:DataEvent):void
		{
			var from:CDItem = evt.data["from"];
			var to:ShortcutBarItem = evt.data["to"];
			if(to == null || from == null)
			{
				return;
			}
			
			var posTo:int = to.pos;
			var sourceFrom:Object = from.dragSource;
			var sourceTo:Object = to.dragSource;
			var dataTo:Object = cache.shortcut.getData(posTo);
			var fromType:int = CDDataType.skillInfo;
			
			// 交换位置
			if(from is ShortcutBarItem)
			{
				var posFrom:int = ShortcutBarItem(from).pos;
				var dataFrom:Object = cache.shortcut.getData(posFrom);
				// to是一个空的位置
				if(dataTo == null)
				{
					cache.shortcut.addShortCut(posTo, int(dataFrom["t"]), dataFrom["v"]);
					cache.shortcut.removeShortcut(posFrom);
					
					_shortcutBar.updateShortcutSource(posTo, sourceFrom);
					_shortcutBar.updateShortcutSource(posFrom, null);
				}
				// to是一个有东西的位置
				else
				{
					cache.shortcut.addShortCut(posTo, int(dataFrom["t"]), dataFrom["v"]);
					cache.shortcut.addShortCut(posFrom, int(dataTo["t"]), dataTo["v"]);
					
					_shortcutBar.updateShortcutSource(posFrom, sourceTo);
					_shortcutBar.updateShortcutSource(posTo, sourceFrom);
				}
				
			}
			else // 从其他地方用新的替换， 或者从其他地方拖进一个新的
			{
				fromType = CDDataType.parseType(sourceFrom);
				var fromValue:Object = ShortcutBarUtil.parseValue(sourceFrom);
				cache.shortcut.addShortCut(posTo, fromType, fromValue);
				_shortcutBar.updateShortcutSource(posTo, sourceFrom);
			}
			
			// 保存快捷栏数据
			cache.shortcut.save();
		}
		
		private function throwHandler(evt:DataEvent):void
		{
			var item:ShortcutBarItem = evt.data as ShortcutBarItem;
			var pos:int = item.pos;
			cache.shortcut.removeShortcut(pos);
			_shortcutBar.updateShortcutSource(pos, null);
			
			cache.shortcut.save();
		}
		
		private function shortcutDataUpdateHandler(evt:Object):void
		{
			var data:Object = cache.shortcut.shortcutBarDatas;
			for(var key:String in data)
			{
				var obj:Object = data[key];
				var type:int = int(obj["t"]);
				var value:int = int(obj["v"]);
				var pos:int = int(key);
				var source:Object = ShortcutBarUtil.getSource(obj, pos);
				if(source == null)
				{
					return;
				}
				_shortcutBar.updateShortcutSource(pos, source);
			}
			
			CallLater.addCallBack(nextFrameShortcutDataGot);
			
			if(SystemSetting.instance.isInitedFromServer)
			{
				updateLockStatus();
				updateShowCDTime();
			}
		}
		private function nextFrameShortcutDataGot():void
		{
			// 第一次进入游戏， 设置第一个技能进快捷栏
			var isFirstSkillSeted:Boolean = ClientSetting.local.getIsDone(IsDoneType.SetFirstSkillToShortCut);
			
			if(!isFirstSkillSeted)
			{
				var info:SkillInfo = cache.skill.getSkillByPosType(1, false);
				if(!info)
				{
					return;
				}
				ClientSetting.local.setIsDone(true, IsDoneType.SetFirstSkillToShortCut);
				var fromType:int = CDDataType.parseType(info);
				var fromValue:Object = ShortcutBarUtil.parseValue(info);
				cache.shortcut.addShortCut(1, fromType, fromValue);
				cache.shortcut.save();
				_shortcutBar.updateShortcutSource(1, info);
			}
		}
		
		private function shorcutKeyUpdateHandler(evt:DataEvent):void
		{
			var keyMapDataArray:Array = evt.data as Array;
			if(_shortcutBar == null)
			{
				view;
			}
			_shortcutBar.updateShortcutKey(keyMapDataArray);
		}
		
		private function shortcutBarDataChangeHandler(evt:DataEvent):void
		{
			var obj:Object = evt.data;
			var pos:int = int(obj["pos"]);
			var type:int = int(obj["t"]);
			var value:int = int(obj["v"]);
			var source:Object;
			if(type == CDDataType.skillInfo)
			{
				source = cache.skill.getSkill(value);
			}
			else if(type == CDDataType.itemData)
			{
				source = ItemConfig.instance.getConfig(value);
			}
			if(source != null)
			{
				_shortcutBar.updateShortcutSource(pos, source);
			}
			
		}
		
		
		private function keyUpHandler(evt:DataEvent):void
		{
			cache.shortcut.lastKeyDownPos = -1;
		}
		
		/**
		 * 用户按下快捷键，那么请求快捷键的功能（放技能、使用药品等) 
		 * @param evt
		 * 
		 */		
		private function keyDownHandler(evt:DataEvent):void
		{
			var pos:int = int(evt.data);
			cache.shortcut.lastKeyDownPos = pos;
			cache.shortcut.isLastKeyByClick = false;
			CallLater.addCallBack(checkAndUseKey);
		}
		
		private function clickHandler(evt:DataEvent):void
		{
			var pos:int = int(evt.data);
			cache.shortcut.lastKeyDownPos = pos;
			cache.shortcut.isLastKeyByClick = true;
			CallLater.addCallBack(checkAndUseKey);
		}
		
		/**
		 * 技能CD完成后，假如快捷键仍然保持按下状态，那么检查并触发继续使用技能 
		 * @param evt
		 * 
		 */		
		private function cdFinishedHandler(evt:DataEvent):void
		{
			var isNotCD:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsNotCD);
			if(cache.shortcut.isLastKeyByClick && !isNotCD)
			{
				return;
			}
			var pos:int = int(evt.data);
			if(cache.shortcut.lastKeyDownPos == pos) // 一直按住快捷键不放，CD完成后将触发继续使用本快捷键
			{
				CallLater.addCallBack(checkAndUseKey);
			}
		}
		
		private function tabKeyChangeTargetHandler(evt:DataEvent):void
		{
			TabKeyAI.instance.work();
		}
		
		/**
		 * 检查并使用快捷键 
		 * @param pos
		 * 
		 */		
		private function checkAndUseKey():void
		{
			var pos:int = cache.shortcut.lastKeyDownPos;
			if(pos < 0)
			{
				return;
			}
			var source:Object = _shortcutBar.getDragSource(pos);
			var type:int = ShortcutBarUtil.parseType(source);
			var cd:ICDData = cache.cd.getCDData(source);
			var isNotCD:Boolean = ClientSetting.local.getIsDone(IsDoneType.IsNotCD);
			if(!isNotCD && cd && cd.isCoolDown)
			{
				// 提示下
			
				var tips:String = Language.getString(20052);
				if(type == CDDataType.itemData)
				{
					tips = Language.getString(20053);
				}
				tips = Language.getStringByParam(20051, tips);
				MsgManager.showRollTipsMsg(tips);
				return;
			}
			
			var now:int = getTimer();
			if(now < _nextCanUseShortcutTime)
			{
				return;
			}
			_nextCanUseShortcutTime = now + 200;
			// 使用技能/物品, 冷却的， 统一在CDController控制
			
			// 在某些状态下，不能使用某些技能（例如，眩晕不能使用普通技能）
			// 在某些地方不能使用药膏， 例如在1v1的时候不能使用大药膏
			if(!canIUseKeySource(source))
			{
				return;
			}
			
			switch(type)
			{
				case CDDataType.skillInfo:
					var info:SkillInfo = source as SkillInfo;
					Dispatcher.dispatchEvent(new DataEvent(EventName.SkillCheckAndSkillAI, info));
					break;
				case CDDataType.itemData:
					var itemData:ItemData = source as ItemData;
					if(itemData != null)
					{
						var arr:Array = cache.pack.backPackCache.getItemsByCode(itemData.itemInfo.code);
						if(arr == null || arr.length == 0)
						{
							return;
						}
						arr.sort(sortItemData);
						itemData = arr[0];
						if(itemData == null || itemData.serverData.itemAmount <= 0)
						{
							return;
						}
						Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Use, itemData));
					}
					break;
			}
		}
		
		private function canIUseKeySource(source:Object):Boolean
		{
			if(source is SkillInfo)
			{
				if(BuffUtil.isCanRoleFireSkill(source as SkillInfo))
				{
					return true;
				}
				return false;
			}
			return true;
		}
		
		private function sortItemData(a:ItemData, b:ItemData):int
		{
			var va:int = ItemsUtil.isBind(a)?1:0;
			var vb:int = ItemsUtil.isBind(b)?1:0;
			if(va > vb)
			{
				return -1;
			}
			if(va < vb)
			{
				return 1;
			}
			if(a.serverData.itemAmount < b.serverData.itemAmount)
			{
				return -1;
			}
			return 1;
		}
		
	}
}