package mortal.game.view.palyer
{
	import Message.Public.EEquip;
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.debug.Log;
	import com.mui.controls.GSprite;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.mvc.core.Dispatcher;

	public class EquipsPanel extends GSprite
	{
		private var _equipmentList:Vector.<PlayerEquipItem>;
		
		public function EquipsPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			createEquipList();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			for each(var equipment:PlayerEquipItem in _equipmentList)
			{
				equipment.dispose(isReuse);
				equipment = null;
			}
			_equipmentList = new Vector.<PlayerEquipItem>();
			
		}
		
		private function createEquipList():void
		{
			_equipmentList = new Vector.<PlayerEquipItem>();
			
			var len:int = 13;
			var equipItem:PlayerEquipItem;
			
			var posArr:Array = [
				 {x:105,y:73}//0
				,{x:45,y:50}//1
				,{x:0,y:150}//2
				,{x:165,y:50}//3
				,{x:0,y:200}//4
				,{x:210,y:150}//5
				,{x:210,y:250}//6
				,{x:210,y:200}//7
				,{x:0,y:250}//8
				,{x:25,y:100}//9
				,{x:210,y:300}//10
				,{x:185,y:100}//11
				,{x:0,y:300}];//12
				
			for(var i:int ; i < len ; i++)
			{
				equipItem = UICompomentPool.getUICompoment(PlayerEquipItem);
				equipItem.createDisposedChildren();
//				equipItem.setSize(36,36);
				equipItem.setItemStyle(ItemStyleConst.Small,ImagesConst.PackItemBg,3,3);
				equipItem.bgName = "EqmBg_" + i;
				equipItem.isThrowAble = false;
				equipItem.x = posArr[i].x;
				equipItem.y = posArr[i].y;
				equipItem.doubleClickEnabled = true;
				equipItem.configEventListener(MouseEvent.DOUBLE_CLICK,doubleCkickHandler);
				this.addChild(equipItem);
				_equipmentList.push(equipItem);
			}
			upDateAllEquip();
		}
		
		private function doubleCkickHandler(e:MouseEvent):void
		{
			var playerEquipItem:PlayerEquipItem = e.currentTarget as PlayerEquipItem;
			if (playerEquipItem.itemData && playerEquipItem.itemData.serverData)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.GetOffEquip,playerEquipItem.itemData));
			}
		}
		
		private function mappingType(type:int):int    //改变映射(用于改变物品的位置)
		{
			var mappingType:int = type;
			switch(mappingType)
			{
				case EEquip._EEquipHelmet:mappingType = 0;break;  //头盔	
				case EEquip._EEquipNecklace:mappingType = 1;break;  //项链
				case EEquip._EEquipShoulder:mappingType = 2;break;  //护肩
				case EEquip._EEquipAmulet:mappingType = 3;break;  //护符
				case EEquip._EEquipClothes:mappingType = 4;break;  //上衣
				case EEquip._EEquipWristlet:mappingType = 5;break;  //护腕
				case EEquip._EEquipBelt:mappingType = 6;break;  //腰带
				case EEquip._EEquipGlove:mappingType = 7;break;  //手套
				case EEquip._EEquipPants:mappingType = 8;break;  //裤子
				case EEquip._EEquipPendant:mappingType = 9;break;  //挂坠
				case EEquip._EEquipShoe:mappingType = 10;break;  //鞋子
				case EEquip._EEquipRing:mappingType = 11;break;  //戒指
				case EEquip._EEquipWeapon:mappingType = 12;break;  //武器
				default :mappingType = 13;                        //坐骑
			}
			return mappingType;
		}
		
		public function upDateAllEquip():void
		{
			var len:int = _equipmentList.length;
			for(var i:int ; i < len ; i++)
			{
				var mappingIndex:int = mappingType(i);
				_equipmentList[mappingIndex].itemData = Cache.instance.pack.packRolePackCache.getEquipByType(i);
			
				if(_equipmentList[mappingIndex].itemData)
				{
					_equipmentList[mappingIndex].buttonMode = true;
//					_equipmentList[mappingIndex].toolTipData = _equipmentList[mappingIndex].itemData;
				}
				else
				{
					_equipmentList[mappingIndex].buttonMode = false;
					_equipmentList[mappingIndex].toolTipData = GameDefConfig.instance.getEquipName(i);
				}
				_equipmentList[mappingIndex].updateStrengLevel();
			}
		}
		
		public function upDateEquipByType(type:int):void
		{
			if(type < 0 ||type > _equipmentList.length)
			{
				return;
			}
			
			var mappingIndex:int = mappingType(type);
			
			_equipmentList[mappingIndex].itemData = Cache.instance.pack.packRolePackCache.getEquipByType(type);
			if(_equipmentList[mappingIndex].itemData)
			{
				_equipmentList[mappingIndex].buttonMode = true;
			}
			else
			{
				_equipmentList[mappingIndex].buttonMode = false;
				_equipmentList[mappingIndex].toolTipData = GameDefConfig.instance.getEquipName(type);
			}
			_equipmentList[mappingIndex].updateStrengLevel();
		}
		
		public function getEquipByType(type:int):PlayerEquipItem
		{
			var mappingIndex:int = mappingType(type);
			return _equipmentList[mappingIndex];
		}
		
		public function get equipmentList():Vector.<PlayerEquipItem>
		{
			return this._equipmentList;
		}
		
		
	}
}