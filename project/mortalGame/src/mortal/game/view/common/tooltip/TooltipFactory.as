/**
 * 2014-1-3
 * @author chenriji
 **/
package mortal.game.view.common.tooltip
{
	import Message.DB.Tables.TRune;
	import Message.Game.SBuyBackItem;
	
	import com.mui.controls.Alert;
	import com.mui.manager.IToolTip;
	import com.mui.manager.IToolTipBaseItem;
	
	import flash.utils.Dictionary;
	
	import mortal.game.model.ToolTipInfo;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.tooltip.tooltips.ToolTipBaseItem;
	import mortal.game.view.common.tooltip.tooltips.ToolTipBuff;
	import mortal.game.view.common.tooltip.tooltips.ToolTipEquipment;
	import mortal.game.view.common.tooltip.tooltips.ToolTipMount;
	import mortal.game.view.common.tooltip.tooltips.ToolTipPetEgg;
	import mortal.game.view.common.tooltip.tooltips.ToolTipRune;
	import mortal.game.view.common.tooltip.tooltips.ToolTipSkill;
	import mortal.game.view.common.tooltip.tooltips.ToolTipSkillShowNext;
	import mortal.game.view.common.tooltip.tooltips.ToolTipWingItem;
	import mortal.game.view.common.tooltip.tooltips.base.ToolTipLabel;
	import mortal.game.view.skill.SkillInfo;

	public class TooltipFactory
	{
		/**
		 * 缓存左边的tips， 用过则保存下来下次继续使用 
		 */		
		private var _cacheLeft:Dictionary = new Dictionary();
		/**
		 * 缓存右边的 
		 */		
		private var _cacheRight:Dictionary = new Dictionary();
		/**
		 * ToolTipType对应的ToolTip的render类，使用之前必须先调用 registerToolTip 函数注册
		 */		
		private var _tipsMap:Dictionary = new Dictionary();
		
		private static var _instance:TooltipFactory;
		
		public function TooltipFactory()
		{
			// 注册需要显示对比tips
			TooltipType.registerCompareToolTipType(TooltipType.TestCompareTips);
//			TooltipType.registerCompareToolTipType(TooltipType.Equipment);
			
			// 注册对应关系
			registerToolTipRender(TooltipType.Item, ToolTipBaseItem);
			registerToolTipRender(TooltipType.Text, ToolTipLabel);
			registerToolTipRender(TooltipType.Buff, ToolTipBuff);
			registerToolTipRender(TooltipType.Skill, ToolTipSkill);
			registerToolTipRender(TooltipType.SkillShowNext, ToolTipSkillShowNext);
			registerToolTipRender(TooltipType.Equipment, ToolTipEquipment);
			registerToolTipRender(TooltipType.Rune, ToolTipRune);
			registerToolTipRender(TooltipType.PetEgg, ToolTipPetEgg);
			registerToolTipRender(TooltipType.Mount, ToolTipMount);
		}
		
		
		public static function get instance():TooltipFactory
		{
			if(_instance == null)
			{
				_instance = new TooltipFactory();
			}
			return _instance;
		}
		
		/**
		 * 将ToolTipType中的各个类型与ToolTip的渲染类对应起来 
		 * @param type
		 * @param render
		 * 
		 */		
		public function registerToolTipRender(type:String, render:Class):void
		{
			_tipsMap[type] = render;
		}
		
		/**
		 * 删除对应关系 
		 * @param type
		 * 
		 */		
		public function unRegisterToolTipRender(type:String):void
		{
			delete _tipsMap[type];
		}
		
		
		/**
		 * 根据不同的data，创建IToolTip 
		 * @param data
		 * @return [IToolTip,IToolTip]， 假如结果有2个则表示显示对比tips， 绝大部分情况下是1个
		 * 
		 */		
		public function createToolTip(data:*):Array
		{
			// 解析tips的类型、数据
			var type:String = TooltipType.Text;
			var tipsData:Object = data;
			var buyBackPrice:int = -1;
			
			if(data is String)
			{
				type = TooltipType.Text;
			}
			else if(data is ItemData)
			{
				type = getItemToolTipType(data as ItemData);
			}
			else if(data is SBuyBackItem)
			{
				var buyback:SBuyBackItem = data as SBuyBackItem;
				tipsData = new ItemData(buyback.itemCode);
				buyBackPrice = buyback.amount * tipsData.itemInfo.sellPrice;
				type = getItemToolTipType(tipsData as ItemData);
			}
			else if(data is TRune)
			{
				type = TooltipType.Rune;
			}
			else if(data is ToolTipInfo)
			{
				type = (data as ToolTipInfo).type;
				tipsData = (data as ToolTipInfo).tooltipData;
			}
			else if(data is SkillInfo)
			{
				type = TooltipType.Skill;
			}
			
			var isNeedRightTips:Boolean = TooltipType.isNeedCompareToolTipType(type);
			var res:Array = [];
			
			// 生成tips
			var left:IToolTip = getToolTipByType(type, _cacheLeft);
			left.data = tipsData;
			if(left is IToolTipBaseItem) // 物品的tips，要显示是否是回购tips
			{
				(left as IToolTipBaseItem).setBuyback(buyBackPrice);
			}
			res.push(left);
			
			if(isNeedRightTips && (buyBackPrice <= 0))
			{
				var right:IToolTip = getToolTipByType(type, _cacheRight);
				// 获取自身已经拥有的数据
				var rightData:Object = {};
				right.data = rightData;
				res.push(right);
			}
			
			return res;
			
		}
		
		/**
		 * 根据类型，从缓存中获取ToolTip的实例，缓存没有此类型则创建一个全新的 
		 * @param type
		 * @param cacheData
		 * @return 
		 * 
		 */		
		private function getToolTipByType(type:String, cacheData:Dictionary):IToolTip
		{
			var res:IToolTip = cacheData[type] as IToolTip;
			if(res == null)
			{
				var cls:Class = _tipsMap[type] as Class;
				if(cls == null)
				{
					Alert.show("TooltipFactory:未注册的ToolTipType:" + type);
					return null;
				}
				res = new cls() as IToolTip;
				if(!(res is IToolTip))
				{
					Alert.show("TooltipFactory:注册的不是IToolTip， ToolTipType:" + type);
					return null;
				}
				cacheData[type] = res;
			}
			return res;
		}
		
		/**
		 * 根据ItemData获取ToolTipType 
		 * @param data
		 * @return 
		 * 
		 */		
		private function getItemToolTipType(data:ItemData):String
		{
			if(ItemsUtil.isEquip(data))
			{
				return TooltipType.Equipment;
			}
			if(ItemsUtil.isRuneStuff(data.itemInfo))
			{
				return TooltipType.Rune;
			}
			if(ItemsUtil.isPetEgg(data.itemInfo))
			{
				return TooltipType.PetEgg;
			}
			if(ItemsUtil.isMount(data))
			{
				return TooltipType.Mount;
			}
			return TooltipType.Item;
		}
	}
}