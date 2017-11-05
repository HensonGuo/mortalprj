/**
 * 2014-1-9
 * @author chenriji
 **/
package mortal.game.view.mainUI.shortcutbar
{
	import com.gengine.global.Global;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.events.DragEvent;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.common.shortcutsKey.KeyMapData;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.item.CDItem;
	import mortal.game.view.skill.SkillInfo;
	import mortal.mvc.core.Dispatcher;

	public class ShortcutBar extends ShortcutBarBase
	{
		private var _items:Array;
		private var _itemSize:int = 36;
		private var _vGap:int = 2;
		private var _hGap:int = 4;
		private var _colNum:int = 10;
		
		
		// 容器
		private var _line1Container:Sprite;
		private var _line2Container:Sprite;
		// 组件
		private var _lockBg:Bitmap;
		private var _upDownBg:Bitmap;
		private var _btnLock:GLoadedButton;
		private var _btnUnlock:GLoadedButton;
		private var _btnDown:GLoadedButton;
		private var _btnUp:GLoadedButton;
		
		public function ShortcutBar()
		{
			super();
			
			this.addEventListener(DragEvent.Event_Move_In, moveInHandler);
			this.addEventListener(DragEvent.Event_Throw_goods, throwHandler);
		}
		
		/**
		 * 拖动操作 不需要启动 冷却
		 * @param e
		 *
		 */
		private function moveInHandler(e:DragEvent):void
		{
			var from:CDItem = e.dragItem as CDItem;
			var to:CDItem = e.dropItem as CDItem;
			Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarMoveIn, {"from":from, "to":to}));
		}
		
		/**
		 * 丢弃 
		 * @param e
		 * 
		 */		
		private function throwHandler(e:DragEvent):void
		{
			var dragItem:ShortcutBarItem = e.dragItem as ShortcutBarItem;
			Dispatcher.dispatchEvent(new DataEvent(EventName.ShortcutBarThrow, dragItem));
		}
		
		public function getDragSource(pos:int):Object
		{
			var item:ShortcutBarItem = _items[pos] as ShortcutBarItem;
			if(item == null)
			{
				return null;
			}
			return item.dragSource;
		}
		
		public function getAllItems():Array
		{
			return _items;
		}
		
		protected function createItems():void
		{
			_items = [];
			var item:ShortcutBarItem;
			var info:SkillInfo;
			
			// 第一行
			_line1Container = new Sprite();
			this.addChild(_line1Container);
			for(var i:int = 1; i <= _colNum; i++)
			{
				item = new ShortcutBarItem(i);
				item.x = (i % (_colNum + 1)) * 37;
				item.y = 0;
	
//				info  = new SkillInfo();
//				info.tSkill = SkillConfig.instance.getInfoByName(10001001);
//				item.dragSource = info;
				item.setSize(35, 35);
				
				item.isDragAble=true;
				item.isDropAble=true;
				item.isThrowAble=true;
				_line1Container.addChild(item);
				
				_items[i] = item;
			}
			
			// 第二行
			_line2Container = new Sprite();
			this.addChild(_line2Container);
			for(i = 11; i <= _colNum*2; i++)
			{
				item = new ShortcutBarItem(i);
				item.x = (i % (_colNum + 1)) * 42;
				item.y = 39;
//				info  = new SkillInfo();
//				info.tSkill = SkillConfig.instance.getInfoByName(10001001);
//				item.dragSource = info;
				item.setSize(42, 42);
				
				item.isDragAble=true;
				item.isDropAble=true;
				item.isThrowAble=true;
				
				_line2Container.addChild(item);
				_items[i] = item;
			}
			
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			createItems();
		}
		
		/**
		 *更新快捷栏标识 
		 * @param index 序号.从1开始
		 * @param label 快捷键
		 * 
		 */		
		public function updateLabelByIndex(index:int,label:String):void
		{
			var scItem:ShortcutBarItem = _items[index];
			if(scItem)
			{
				scItem.setLabelTxt(label);
			}
		}
		
		/**
		 * 更新所有的快捷键。
		 * @param keyDataArray KeyMapData
		 * 
		 */		
		public function updateShortcutKey(keyMapDataArray:Array):void
		{
			var keyMapData:KeyMapData;
			var item:ShortcutBarItem;
			var tip:String;
			for (var i:int = 0; i < keyMapDataArray.length; i++) 
			{
				keyMapData = keyMapDataArray[i];
				if(keyMapData.key is int)//快捷栏为数字
				{
					item = _items[keyMapData.key];
					if(item)
					{
						if( keyMapData.keyData )
						{
							tip = keyMapData.keyData.shortcutsName;
						}
						else
						{
							tip = "";
						}
						item.setLabelTxt(tip);
					}
				}
			}
		}
		
		/**
		 * 更新快捷键的内容（SkillInfo， ItemData） 
		 * @param pos
		 * @param source
		 * 
		 */		
		public function updateShortcutSource(pos:int, source:Object):void
		{
			var item:ShortcutBarItem = _items[pos];
			if(item != null)
			{
				item.dragSource = source;
			}
		}
		
		public override function show(x:int=0, y:int=0):void
		{
			onStageResize();
			LayerManager.uiLayer.addChild(this);
		}
		
		public function onStageResize():void
		{
			this.x = (Global.stage.stageWidth - 350)/2;
			this.y = Global.stage.stageHeight - 83;
		}
		
		public override function hide():void
		{
			DisplayUtil.removeMe(this);
		}
	}
}