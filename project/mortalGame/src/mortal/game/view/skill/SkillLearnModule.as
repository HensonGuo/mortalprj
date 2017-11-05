/**
 * 2014-1-15
 * @author chenriji
 **/
package mortal.game.view.skill
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GImageBitmap;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import mortal.common.display.LoaderHelp;
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.skill.panel.RuneItem;
	import mortal.game.view.skill.panel.SkillLearnDesc;
	import mortal.game.view.skill.panel.SkillLearnItem;
	import mortal.game.view.skill.panel.data.RuneItemData;
	import mortal.game.view.skill.panel.data.SkillLearnArrowData;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class SkillLearnModule extends BaseWindow
	{
		private var _places:Array = [
			8, 8,
			8, 129,
			130, 80, 
			250, 28,
			370, 28,
			8, 240,
			132, 240,
			250, 175,
			370, 175, 
			490, 175,
			250, 304,
			370, 304,
			490, 304
		];
		
		// SkillLearnItem
		private var _items:Array;
		
		private var _bg:GImageBitmap;
		private var _desc:SkillLearnDesc;
		private var _arrows:Array = [];
		
		// 符文
		private var _runes:Array = [];
		
		
		public function SkillLearnModule($layer:ILayer=null)
		{
			super($layer);
			this.title = Language.getString(20052);
			setSize(790, 593);
			this.titleHeight = 60;
		}
		
		public function updateSkillInfo(pos:int, info:SkillInfo):void
		{
			var item:SkillLearnItem = _items[pos];
			item.skillInfo = info;
		}
		
		public function setNotOpen(pos:int):void
		{
			var item:SkillLearnItem = _items[pos];
			item.setNotOpen();
		}
		
		public function getAllSkillInfos():Array
		{
			var res:Array = [];
			for each(var item:SkillLearnItem in _items)
			{
				var info:SkillInfo = item.skillInfo;
				res[info.tSkill.posType] = info;
			}
			return res;
		}
		
		public function getItemByPos(pos:int):SkillLearnItem
		{
			return _items[pos];
		}
		
		public function updateRunes(arr:Array):void
		{
			for(var i:int = 0; i < 4; i++)
			{
				var rune:RuneItem = _runes[i];
				var data:RuneItemData = arr[i];
				rune.runeData = data;
			}
		}
		
		public function updateArrow(data:SkillLearnArrowData):void
		{
			var item:GBitmap = _arrows[data.pos];
			if(item == null)
			{
				return;
			}
			item.x = data.x;
			item.y = data.y;
			item.bitmapData = GlobalClass.getBitmapData(data.url);
			if(data.isActive)
			{
				item.filters = [];
			}
			else
			{
				item.filters = [FilterConst.colorFilter];
			}
		}
		
		private var _curItem:SkillLearnItem;
		public function selectSkillItem(info:SkillInfo):void
		{
			if(info == null)
			{
				return;
			}
			// 更新已经激活符文
			updateRunes(Cache.instance.skill.getRunesBySerial(info.tSkill.series));
			
			// 更新右边描述
			var item:SkillLearnItem = _items[info.tSkill.posType];
			if(item == null)
			{
				return;
			}
			if(_curItem != null)
			{
				_curItem.selected = false;
			}
			_curItem = item;
			_curItem.selected = true;
			
			_desc.updateData(info);
			
		}
		
		public function get selectedPos():int
		{
			if(_curItem == null)
			{
				return -1;
			}
			return _curItem.pos;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bg = UIFactory.gImageBitmap(ImagesConst.SkillPanelBg, 17, 72, this);
			
			// 符文
			_runes = [];
			for(var i:int = 0; i < 4; i++)
			{
				var rune:RuneItem = UICompomentPool.getUICompoment(RuneItem);
				_runes.push(rune);
				rune.x = 183 + i * 97;
				rune.y = 511;
				this.addChild(rune);
				pushUIToDisposeVec(rune);
			}
			
			LoaderHelp.addResCallBack(ResFileConst.skillPanel, onGetRes);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bg.dispose(isReuse);
		
			
			_items = null;
			_bg = null;
			
			if(_desc != null)
			{
				_desc.dispose(isReuse);
				_desc = null;
			}
			
			_curItem = null;
		}
		
		private function onGetRes():void
		{
			// 技能
			_items = [];
			for(var i:int = 0; i < _places.length; i += 2)
			{
				//  箭头
				if(i != 8)
				{
					var arrow:GBitmap = UIFactory.gBitmap("", 0, 0, this);
					_arrows[int(i/2) + 1] = arrow;
					pushUIToDisposeVec(arrow);
				}
				
				// 图标项
				var item:SkillLearnItem = UICompomentPool.getUICompoment(SkillLearnItem);
				item.pos = int(i/2 + 1);
				item.x = int(_places[i]) + _bg.x;
				item.y = int(_places[i+1]) + _bg.y;
				this.addChild(item);
				_items[int(i/2) + 1] = item;
				pushUIToDisposeVec(item);
			}
			
			
			
			_desc = ObjectPool.getObject(SkillLearnDesc);
			_desc.x = 611;
			_desc.y = 71;
			this.addChild(_desc);
			
			// 初始化完成后发事件，controller此时才更新数据
			Dispatcher.dispatchEvent(new DataEvent(EventName.SkillPanel_ViewInited));
			
		}
		
		
	}
}