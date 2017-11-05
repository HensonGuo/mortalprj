/**
 * @heartspeak
 * 2014-4-24 
 */   	

package mortal.game.view.systemSetting.view
{
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.ScrollPolicy;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.IconProgressBar;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.game.view.systemSetting.SystemSettingType;
	import mortal.mvc.core.Dispatcher;
	
	public class SystemSetPanel extends GSprite
	{
		//数据
		protected var _settingItemArrayLeft:Array;
		protected var _settingItemArrayRight:Array;
		//显示
		protected var _scrollPaneLeft:GScrollPane;
		protected var _scrollPaneRight:GScrollPane;
		
		protected var _leftBox:GBox;
		protected var _rightBox:GBox;
		
		//音乐设置
		protected var _bgMusicBar:IconProgressBar;
		protected var _effectMusicBar:IconProgressBar;
		protected var _forbitMusicItem:SystemSetItem;
		
		protected var _btnReset:GButton;
		protected var _btnSave:GButton;
		
		public function SystemSetPanel()
		{
			super();
		}
		
		override protected function configUI():void
		{
			_settingItemArrayLeft = new Array();
			_settingItemArrayRight = new Array();
			var list:Array;
			
			//屏蔽玩家
			list = new Array();
			list.push(SystemSetting.instance.hideSetter);
			list.push(SystemSetting.instance.playerOnScreen);
			_settingItemArrayLeft.push({type:"屏蔽玩家",list:list});
			
			//屏蔽游戏特效
			list = new Array();
			list.push(SystemSetting.instance.isHideSkill);
			list.push(SystemSetting.instance.isHideAllEffect);
			_settingItemArrayLeft.push({type:"屏蔽游戏特效",list:list});
			
			//屏蔽信息
			list = new Array();
			list.push(SystemSetting.instance.isHideLife);
			list.push(SystemSetting.instance.isHideOterPlayerName);
			list.push(SystemSetting.instance.isHideTitle);
			list.push(SystemSetting.instance.isHideGuildName);
			_settingItemArrayLeft.push({type:"屏蔽信息",list:list});
			
			//屏蔽消息
			list = new Array();
			list.push(SystemSetting.instance.isHideTeamChatBubble);
			list.push(SystemSetting.instance.isHideSystemTips);
			list.push(SystemSetting.instance.isHideRumorTips);
			_settingItemArrayLeft.push({type:"屏蔽消息",list:list});
			
			//拒绝邀请
			list = new Array();
			list.push(SystemSetting.instance.isRefuseTrade);
//			list.push(SystemSetting.instance.isRefuseBeAddToFriend);
			list.push(SystemSetting.instance.isRefuseBeAddToGroup);
			list.push(SystemSetting.instance.isRefuseBeAddToGuild);
			_settingItemArrayRight.push({type:"拒绝邀请",list:list});
			
			//选取目标
			list = new Array();
			list.push(SystemSetting.instance.isSelectNotAutoAttack);
			list.push(SystemSetting.instance.isNotAutoSelectPet);
			list.push(SystemSetting.instance.isNotAutoSelectPlayer);
			list.push(SystemSetting.instance.isNotAutoSelectMonster);
			_settingItemArrayRight.push({type:"选取目标",list:list});
			
			list = new Array();
			list.push(SystemSetting.instance.isShortcutShowSecond);
			list.push(SystemSetting.instance.isLockShortcut);
			_settingItemArrayRight.push({type:"其他设置",list:list});
			super.configUI();
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		/**
		 * 创建子对象 
		 * 
		 */		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			pushUIToDisposeVec(UIFactory.bg(17, 67, 231, 306, this));
			pushUIToDisposeVec(UIFactory.bg(251, 67, 231, 306, this));
			
			var obj:Object;
			var i:int;
			
			//左边
			var gBox:GBox = UICompomentPool.getUICompoment(GBox);
			_leftBox = gBox;
			gBox.direction = GBoxDirection.VERTICAL;
			var length:int = _settingItemArrayLeft.length;
			var systemSetBigItem:SystemSetBigItem;
			for(i = 0;i < length;i++)
			{
				obj = _settingItemArrayLeft[i];
				systemSetBigItem = UICompomentPool.getUICompoment(SystemSetBigItem);
				systemSetBigItem.updateData(obj.type,obj.list);
				gBox.addChild(systemSetBigItem);
			}
			pushUIToDisposeVec(gBox);
			gBox.resetPosition2();
			
			if(!_scrollPaneLeft)
			{
				_scrollPaneLeft = UIFactory.gScrollPanel(0,0,220,300,this);
			}
			_scrollPaneLeft.source = gBox;
			_scrollPaneLeft.horizontalScrollPolicy = ScrollPolicy.OFF;
			_scrollPaneLeft.verticalScrollPolicy = ScrollPolicy.ON;
			_scrollPaneLeft.update();
			UIFactory.setObjAttri(_scrollPaneLeft,23,70,-1,-1,this);
			
			//右边
			gBox = UICompomentPool.getUICompoment(GBox);
			_rightBox = gBox;
			gBox.direction = GBoxDirection.VERTICAL;
			length = _settingItemArrayRight.length;
			for(i = 0;i < length;i++)
			{
				obj = _settingItemArrayRight[i];
				systemSetBigItem = UICompomentPool.getUICompoment(SystemSetBigItem);
				systemSetBigItem.updateData(obj.type,obj.list);
				gBox.addChild(systemSetBigItem);
			}
			pushUIToDisposeVec(gBox);
			gBox.resetPosition2();
			
			if(!_scrollPaneRight)
			{
				_scrollPaneRight = UIFactory.gScrollPanel(0,0,220,300,this);
			}
			_scrollPaneRight.source = gBox;
			_scrollPaneRight.horizontalScrollPolicy = ScrollPolicy.OFF;
			_scrollPaneRight.verticalScrollPolicy = ScrollPolicy.ON;
			_scrollPaneRight.update();
			UIFactory.setObjAttri(_scrollPaneRight,259,70,-1,-1,this);
			

			//音乐
			var tempTextField:GTextFiled = UIFactory.gTextField("音效",60,375,40,22,this);
			tempTextField.mouseEnabled = false;
			pushUIToDisposeVec(tempTextField);
			
			_bgMusicBar = UICompomentPool.getUICompoment(IconProgressBar);
			_bgMusicBar.setBg(ImagesConst.SystemSetBarBg,true,133,10);
			_bgMusicBar.setProgress(ImagesConst.SystemSetBar,false,1,1,131,9);
			_bgMusicBar.setLabel(BaseProgressBar.ProgressBarTextNone);
			_bgMusicBar.setIconBtnStyle(ImagesConst.SystemSetPoint_upSkin,19,19);
			_bgMusicBar.isCanDrag = true;
			_bgMusicBar.setValue(SystemSetting.instance.bgMusic.value,100);
			_bgMusicBar.configEventListener(Event.CHANGE,onBgMusicChange);
			UIFactory.setObjAttri(_bgMusicBar,96,380,-1,-1,this);
			
			tempTextField = UIFactory.gTextField("音乐",260,375,40,22,this);
			tempTextField.mouseEnabled = false;
			pushUIToDisposeVec(tempTextField);
			
			_effectMusicBar = UICompomentPool.getUICompoment(IconProgressBar);
			_effectMusicBar.setBg(ImagesConst.SystemSetBarBg,true,133,10);
			_effectMusicBar.setProgress(ImagesConst.SystemSetBar,false,1,1,131,9);
			_effectMusicBar.setLabel(BaseProgressBar.ProgressBarTextNone);
			_effectMusicBar.setIconBtnStyle(ImagesConst.SystemSetPoint_upSkin,19,19);
			_effectMusicBar.isCanDrag = true;
			_effectMusicBar.setValue(SystemSetting.instance.effectMusic.value,100);
			_effectMusicBar.configEventListener(Event.CHANGE,onEffectMusicChange);
			UIFactory.setObjAttri(_effectMusicBar,296,380,-1,-1,this);
			
			_forbitMusicItem = UICompomentPool.getUICompoment(SystemSetItem);
			_forbitMusicItem.data = SystemSetting.instance.isForbidMusic;
			UIFactory.setObjAttri(_forbitMusicItem,69,400,-1,-1,this);
			
			//按钮
			_btnReset = UIFactory.gButton("默认设置",162,402,70,22,this);
			_btnSave = UIFactory.gButton("保存设置",267,402,70,22,this);
			
			_btnReset.configEventListener(MouseEvent.CLICK,onClickReset);
			_btnSave.configEventListener(MouseEvent.CLICK,onClickSave);
		}
		
		protected function onBgMusicChange(e:Event):void
		{
			SystemSetting.instance.bgMusic.displayValue = int(_bgMusicBar.value);
		}
		
		protected function onEffectMusicChange(e:Event):void
		{
			SystemSetting.instance.effectMusic.displayValue = int(_effectMusicBar.value);
		}
		
		/**
		 * 点击默认设置按钮 
		 * @param e
		 * 
		 */		
		protected function onClickReset(e:MouseEvent):void
		{
			SystemSetting.instance.resetToDefault();
			refreshDisplay();
			save();
		}
		
		/**
		 * 点击默认保存按钮 
		 * @param e
		 * 
		 */		
		protected function onClickSave(e:MouseEvent):void
		{
			SystemSetting.instance.updateToServer();
			save();
		}
		
		/**
		 * 恢复 
		 * @param e
		 * 
		 */		
		protected function onRemoveFromStage(e:Event):void
		{
			SystemSetting.instance.recover();
		}
		
		/**
		 * 刷新显示 
		 * 
		 */		
		public function refreshDisplay():void
		{
			var length:int = _leftBox.numChildren;
			var i:int;
			var systemSetBigItem:SystemSetBigItem;
			for(i = length - 1;i >= 0;i--)
			{
				systemSetBigItem = _leftBox.getChildAt(i) as SystemSetBigItem;
				systemSetBigItem.refreshDisplay();
			}
			_leftBox.resetPosition2();
			_scrollPaneLeft.update();
			
			length = _rightBox.numChildren;
			for(i = length - 1;i >= 0;i--)
			{
				systemSetBigItem = _rightBox.getChildAt(i) as SystemSetBigItem;
				systemSetBigItem.refreshDisplay();
			}
			_rightBox.resetPosition2();
			_scrollPaneRight.update();
			
			//声音部分
			_bgMusicBar.setValue(SystemSetting.instance.bgMusic.value,100);
			_effectMusicBar.setValue(SystemSetting.instance.effectMusic.value,100);
			_forbitMusicItem.refreshDisplay();
		}
		
		/**
		 * 保存 
		 * 
		 */
		protected function save():void
		{
			var obj:Object = new Object();
			obj.type = SystemSettingType.SystemSetting;
			obj.value = SystemSetting.instance.getServerStr();
			Dispatcher.dispatchEvent(new DataEvent(EventName.SystemSettingSava, obj));
		}
		
		/**
		 * 释放 
		 * @param isReuse
		 * 
		 */		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_btnSave.dispose(isReuse);
			_btnReset.dispose(isReuse);
			
			_leftBox = null;
			_rightBox = null;
			
			_bgMusicBar.dispose(isReuse);
			_bgMusicBar = null;
			
			_effectMusicBar.dispose(isReuse);
			_effectMusicBar = null;
			
			_forbitMusicItem.dispose(isReuse);
			super.disposeImpl(isReuse);
		}
	}
}