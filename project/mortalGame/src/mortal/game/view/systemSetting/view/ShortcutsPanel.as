/**
 * @heartspeak
 * 2014-4-24 
 */   	

package mortal.game.view.systemSetting.view
{
	import Message.Public.EClientSetType;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GList;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTileList;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.common.shortcutsKey.KeyMapData;
	import mortal.common.shortcutsKey.ShortcutsKey;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.systemSetting.SystemSettingType;
	import mortal.mvc.core.Dispatcher;
	
	public class ShortcutsPanel extends GSprite
	{
		protected var _btnResetToDefault:GButton;
		protected var _btnOK:GButton;
		protected var _btnCancel:GButton;
		
		protected var _listModuleKey:GTileList;
		protected var _listSkillsKey:GTileList;
		
		public function ShortcutsPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			pushUIToDisposeVec(UIFactory.bg(17, 67, 231, 329, this));
			pushUIToDisposeVec(UIFactory.bg(19, 69, 227, 26, this, ImagesConst.RegionTitleBg));
			pushUIToDisposeVec(UIFactory.gTextField("功能",40,72,100,20,this,GlobalStyle.textFormatAnjin));
			pushUIToDisposeVec(UIFactory.gTextField("快捷键",150,72,100,20,this,GlobalStyle.textFormatAnjin));
			
			pushUIToDisposeVec(UIFactory.bg(251, 67, 231, 329, this));
			pushUIToDisposeVec(UIFactory.bg(253, 69, 227, 26, this, ImagesConst.RegionTitleBg));
			pushUIToDisposeVec(UIFactory.gTextField("快捷栏",270,72,100,20,this,GlobalStyle.textFormatAnjin));
			pushUIToDisposeVec(UIFactory.gTextField("快捷键",380,72,100,20,this,GlobalStyle.textFormatAnjin));
			
			var moduleMap:Array = ShortcutsKey.instance.moduleAry;
			_listModuleKey = UIFactory.tileList(17,95,228,298,this);
			_listModuleKey.rowHeight = 30;
			_listModuleKey.columnWidth = 210;
			_listModuleKey.setStyle("cellRenderer",ShortcutItemRenderer);
			_listModuleKey.dataProvider = new DataProvider(moduleMap);
			_listModuleKey.drawNow();
			pushUIToDisposeVec(_listModuleKey);
			
			var skillMap:Array = ShortcutsKey.instance.skillsAry;
			_listSkillsKey = UIFactory.tileList(251,95,228,298,this);
			_listSkillsKey.rowHeight = 30;
			_listSkillsKey.columnWidth = 210;
			_listSkillsKey.setStyle("cellRenderer",ShortcutItemRenderer);
			_listSkillsKey.dataProvider = new DataProvider(skillMap);
			_listSkillsKey.drawNow();
			pushUIToDisposeVec(_listSkillsKey);
			
			_btnResetToDefault = UIFactory.gButton("恢复默认",97,402,64,22,this);
			pushUIToDisposeVec(_btnResetToDefault);
			_btnOK = UIFactory.gButton("确定",277,402,64,22,this);
			pushUIToDisposeVec(_btnOK);
//			_btnCancel = UIFactory.gButton("取消",383,402,64,22,this);
//			pushUIToDisposeVec(_btnCancel);
			
			_btnResetToDefault.configEventListener(MouseEvent.CLICK,onClickResetToDefault);
			_btnOK.configEventListener(MouseEvent.CLICK,onClickOK);
//			_btnCancel.configEventListener(MouseEvent.CLICK,onClickCancel);
			Dispatcher.addEventListener(EventName.ShortcutsUpdate,onShortcutsUpdateHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		private function onShortcutsUpdateHandler(e:DataEvent):void
		{
			var mapData:KeyMapData = e.data as KeyMapData;
			if( mapData )
			{
				if(ShortcutsKey.instance.skillsAry.indexOf(mapData) > -1)
				{
					_listSkillsKey.invalidateItem(mapData);
				}
				else if(ShortcutsKey.instance.moduleAry.indexOf(mapData) > -1)
				{
					_listModuleKey.invalidateItem(mapData);
				}
			}
		}
		
		/**
		 * 恢复默认 
		 * @param e
		 * 
		 */		
		protected function onClickResetToDefault(e:MouseEvent):void
		{
			ShortcutsKey.instance.setDefaultShortcutsKey();
			_listModuleKey.invalidateList();
			_listSkillsKey.invalidateList();
			save();
		}
		
		/**
		 * 保存设置 
		 * @param e
		 * 
		 */		
		protected function onClickOK(e:MouseEvent):void
		{
			save();
		}
		
		/**
		 * 保存 
		 * 
		 */
		protected function save():void
		{
			var obj:Object = new Object();
			obj.type = SystemSettingType.SystemKeyMapData;
			obj.value = ShortcutsKey.instance.getServerStr();
			Dispatcher.dispatchEvent(new DataEvent(EventName.SystemSettingSava, obj));
		}
		
		/**
		 * 取消设置 
		 * @param e
		 * 
		 */		
		protected function onClickCancel(e:MouseEvent):void
		{
			recoverySet();
		}
		
		/**
		 * 移除舞台 
		 * @param e
		 * 
		 */		
		protected function onRemoveFromStage(e:Event):void
		{
			ShortcutsKey.instance.recoverySetter();
		}
		
		protected function recoverySet():void
		{
			ShortcutsKey.instance.recoverySetter();
			_listModuleKey.invalidateList();
			_listSkillsKey.invalidateList();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			Dispatcher.removeEventListener(EventName.ShortcutsUpdate,onShortcutsUpdateHandler);
		}
	}
}