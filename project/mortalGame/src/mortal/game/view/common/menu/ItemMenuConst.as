/**
 * 背包物品的菜单管理类
 * @author heartspeak
 * 
 */	
package mortal.game.view.common.menu
{
	import Message.Public.EGroup;
	import Message.Public.EProp;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.pack.social.ItemFeatureTips;
	import mortal.mvc.core.Dispatcher;

	public class ItemMenuConst
	{
		public static const USE:String = 		Language.getString(30001);
		public static const SHOW:String = 		Language.getString(30002);
		public static const TO_SALE:String = 	Language.getString(30003);
		public static const SPLIT:String = 		Language.getString(30004);
		public static const DISPOSE:String = 	Language.getString(30005);
		public static const FORGING:String = 	Language.getString(30006);
		public static const EQUIP:String = 		Language.getString(30007);
		public static const EQUIPFABAO:String = Language.getString(30008);
		public static const IDENTIFYFABAO:String = Language.getString(30009);
		public static const EQUIPMOUNT:String = Language.getString(30010);
		public static const GRADE:String = 		Language.getString(30011);
		public static const JEWELUP:String = 	Language.getString(30012);
		public static const BULKUSE:String = 	Language.getString(30036);
		
		/**
		 *道具类的操作列表
		 */		 
		public static const Prop:DataProvider = new DataProvider([
			{label: ItemMenuConst.USE},
			{label: ItemMenuConst.BULKUSE},
			{label: ItemMenuConst.SHOW},
//			{label: ItemMenuConst.TO_SALE},
			{label: ItemMenuConst.SPLIT},
			{label: ItemMenuConst.DISPOSE}
		]);
		
		
		/**
		 *装备类的操作列表 
		 */
		private static const Equip:DataProvider = new DataProvider([
			{label: ItemMenuConst.EQUIP}, 
//			{label: ItemMenuConst.FORGING},
			{label: ItemMenuConst.SHOW},
//			{label: ItemMenuConst.TO_SALE},
			{label: ItemMenuConst.DISPOSE}
		]);
		
		/**
		 *法宝类的操作列表 
		 */
		private static const Fabao:DataProvider = new DataProvider([
			{label: ItemMenuConst.SHOW},
			{label: ItemMenuConst.TO_SALE},
			{label: ItemMenuConst.DISPOSE}
		]);
		
		
		/**
		 * 任务物品的操作列表 
		 */
		private static const Task:DataProvider = new DataProvider([
		]);
		
		
		/**
		 *药包类的操作列表
		 */		 
		public static const DrugBag:DataProvider = new DataProvider([
			{label: ItemMenuConst.USE},
		]);
		
		
		/**
		 * 某一项是否可以进行操作 
		 * @param opName
		 * @return 
		 * 
		 */
		public static function getOpEnabled(opName:String,itemData:ItemData):Boolean
		{
			if(!itemData)
			{
				return false;
			}
			switch(opName)
			{
				case ItemMenuConst.USE:
					return true;
				case ItemMenuConst.SHOW:
					return true;
				case ItemMenuConst.TO_SALE:
					return !ItemsUtil.isBind(itemData);
				case ItemMenuConst.SPLIT:
					return itemData.serverData.itemAmount > 1;
				case ItemMenuConst.DISPOSE:
					return true;
//				case ItemMenuConst.FORGING:
//					if(itemData.type == EEquip._EEquipHeartLock || itemData.type==EEquip._EEquipHarmMedalDeeper || itemData.type==EEquip._EEquipHarmMedalLower)
//					{
//						return false;
//					}
//					return true;
				case ItemMenuConst.EQUIP:
					return true;
//				case ItemMenuConst.MOVETOWARDROBE:
//					return itemData.type == EEquip._EEquipWing || itemData.type == EEquip._EEquipFashion || itemData.type == EEquip._EEquipFashionWeapon
//					|| itemData.type == EEquip._EEquipFootPrint;
				case ItemMenuConst.EQUIPMOUNT:
					return true;
				case ItemMenuConst.GRADE:
					return true;
				case ItemMenuConst.JEWELUP:
					return true;
				case ItemMenuConst.BULKUSE:
					return ItemsUtil.isCanBulkUse(itemData);
				default:
					return true;
			}
		}
		
		/**
		 * 获取一个物品的下拉菜单
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function getDataProvider(itemData:ItemData):DataProvider
		{
			var group:int = itemData.itemInfo.group;
			var category:int = itemData.itemInfo.category;
			if (group == EGroup._EGroupProp && (category == EProp._EPropProp || category == EProp._EPropDrug))
			{
				return ItemMenuConst.Prop;
			}
			else if (group == EGroup._EGroupStuff)
			{
				return ItemMenuConst.Prop;
			}
			else if(group == EGroup._EGroupProp && category == EProp._EPropEquip)
			{
				return ItemMenuConst.Equip;
			}
//			else if (category == ECategory._ECategoryPetEquip)
//			{
//				return ItemMenuConst.PetEquip;
//			}
//			else if (category == ECategory._ECategoryRune)
//			{
//				return ItemMenuConst.Rune;
//			}
			return ItemMenuConst.Prop;
		}
		
		/**
		 * 获取经过筛选后的属性菜单
		 * @param dataProvider
		 * @param itemData
		 * @return 
		 * 
		 */
		public static function getEnabeldAttri(dataProvider:DataProvider,itemData:ItemData):DataProvider
		{
			var newDataProvider:DataProvider = new DataProvider();
			for(var i:int = 0;i<dataProvider.length;i++)
			{
				var objOld:Object = dataProvider.getItemAt(i);
				var enabled:Boolean = getOpEnabled(objOld["label"],itemData);
				if(enabled)
				{
					var objNew:Object = {label:objOld["label"],enabled:enabled};
					newDataProvider.addItem(objNew);
				}
			}
			return newDataProvider;
		}
		
		/**
		 * 对某一项进行操作
		 * @param opName
		 * @param itemData
		 * 
		 */	
		public static function opearte(opName:String,itemData:ItemData):void
		{
			switch(opName)
			{
				case ItemMenuConst.USE:
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Use,itemData));
					break;
				case ItemMenuConst.SHOW:
					Dispatcher.dispatchEvent(new DataEvent(EventName.ChatShowItem,itemData));
					break;
//				case ItemMenuConst.TO_SALE:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.MarketOpenSell,itemData));
//					break;
				case ItemMenuConst.SPLIT:
					ItemFeatureTips.splitTip(itemData);
					break;
				case ItemMenuConst.DISPOSE:
					ItemFeatureTips.destroyItem(itemData);
					break;
//				case ItemMenuConst.FORGING:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.Equipment_DoCast_Strengthen,itemData));
//					break;
				case ItemMenuConst.EQUIP:
					if(ItemsUtil.isBind(itemData))
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Equip,itemData));
					}
					else
					{
						ItemFeatureTips.equipItem(itemData);
					}
					break;
//				case ItemMenuConst.EQUIPFABAO:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_EquipFabao,itemData));
//					break;
//				case ItemMenuConst.IDENTIFYFABAO:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_IdentifyFabao,itemData));
//					break;
//				//放入衣柜
//				case ItemMenuConst.MOVETOWARDROBE:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.MoveToWardrobe,itemData));
//					break;
//				case ItemMenuConst.EQUIPMOUNT:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_EquipMount,itemData));
//					break;
//				case ItemMenuConst.GRADE:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Grade,itemData));
//					break;
				case ItemMenuConst.BULKUSE:
					ItemFeatureTips.bulkUse(itemData);
					break;
//				case ItemMenuConst.JEWELUP:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.Equipment_DoCast_ComposeJewel,itemData));
//					break;
//				case ItemMenuConst.DRESS_PETEQUIP:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.PetEquipDress,itemData));
//					break;
//				case ItemMenuConst.UNDRESS_PETEQUIP:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.PetEquipUndress,itemData));
//					break;
//				case ItemMenuConst.UNDRESSALL_PETEQUIP:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.PetEquipUndressAll,null));
//					break;
//				case ItemMenuConst.MOREOPER_PETEQUIP:
//					
//					break;
//				case ItemMenuConst.DISPOSE_SKILLCARD:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.PetExploreUseCard,{uid:itemData.uid,isDestroy:true}));
//					break;
//				case ItemMenuConst.FEED:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.RuneOpenFeedWindow,itemData));
//					break;
//				case ItemMenuConst.INSERT:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.RuneOpenRuneWindow,itemData));
//					break;
//				case ItemMenuConst.CRAVE:
//					Dispatcher.dispatchEvent(new DataEvent(EventName.MountOpenCraveModule,itemData));
//					break;
				default:
					break;
			}
		}
	}
}