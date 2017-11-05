/**
 * @heartspeak
 * 2014-1-10 
 */   	
package mortal.game.scene3D.layer3D.utils
{
	import Message.BroadCast.SDropEntityInfo;
	import Message.Public.SEntityId;
	import Message.Public.SPlayerItem;
	
	import com.gengine.debug.Log;
	import com.gengine.game.core.GameSprite;
	
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mortal.game.Game;
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.layer3D.DropItemDictionary;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.layer3D.utils.EntityClass;
	import mortal.game.scene3D.layer3D.utils.EntityLayerUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.item.ItemPlayer;
	
	public class DropItemUtil extends EntityLayerUtil
	{
		private var _dropItemMap:DropItemDictionary = new DropItemDictionary();
		
		private var _simpleItemMap:Dictionary = new Dictionary();
		
		public function DropItemUtil(  $layer:PlayerLayer )
		{
			super($layer);
		}
		
		public function get dropItemMap():DropItemDictionary
		{
			return _dropItemMap;
		}

		public function addDropItems( dropInfos:Array ):void
		{
			for each(var dropInfo:SDropEntityInfo in dropInfos)
			{
				addDropItem(dropInfo);
			}
		}
		
		public function addDropItem( dropInfo:SDropEntityInfo ):void
		{
			var dropItem:ItemPlayer = EntityClass.getInstanceByType(EntityType.DropItem) as ItemPlayer;
			dropItem.dropEntityInfo = dropInfo;
			_dropItemMap.addDropItem(dropInfo.entityId,dropItem);
			layer.addChild(dropItem);
		}
		
		public function removeDropItem( entityId:SEntityId ):ItemPlayer
		{
			var dropItem:ItemPlayer = _dropItemMap.removeDropItem(entityId);
			if(dropItem)
			{
				dropItem.dispose();
			}
			return dropItem;
		}
		
		public function getDropItem( entityId:SEntityId ):ItemPlayer
		{
			return _dropItemMap.getDropItem(entityId);
		}
		
		public function getRandomDropItem(isSelfOnly:Boolean = false):ItemPlayer
		{
			var dropItem:ItemPlayer = _dropItemMap.getRandomDropItem(isSelfOnly);
			return dropItem;
		}
		
		override public function removeAll():void
		{
			var dropItem:ItemPlayer;
			for each( dropItem in _dropItemMap.map )
			{
				if( dropItem )
				{
					dropItem.dispose();
				}
			}
			_dropItemMap.removeAll();
		}
		
		override public function updateEntity():void
		{
			var dic:Dictionary = _dropItemMap.map;
			var entity:ItemPlayer;
			for each ( entity in dic)
			{
				if (SceneRange.isInScene(entity.x2d, entity.y2d))
				{
					if (layer.contains(entity) == false)
					{
						layer.addChild(entity);
					}
				}
				else
				{
					if (layer.contains(entity))
					{
						layer.removeChild(entity);
					}
				}
			}
		}
		
		public function onClickScene():ItemPlayer
		{
			return null;
		}
	}
}
