package mortal.game.scene3D.layer3D.utils
{
	import Message.Public.EEntityType;
	
	import baseEngine.core.Pivot3D;
	
	import com.gengine.game.core.GameSprite;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.utils.Dictionary;
	
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.scene3D.player.entity.PetPlayer;
	import mortal.game.scene3D.player.entity.UserPlayer;
	import mortal.game.scene3D.player.item.ItemPlayer;

	public class EntityClass
	{
		private static var _entityClass:Dictionary; 
		
		private static function get entityClass():Dictionary
		{
			if( _entityClass == null )
			{
				_entityClass = new Dictionary();
				_entityClass[EntityType.Player] = UserPlayer;  // 玩家
				_entityClass[EntityType.Boss] = MonsterPlayer;  // 怪物
				_entityClass[EntityType.Transport] = MonsterPlayer;  // 护送怪
				_entityClass[EntityType.Pet] = PetPlayer;  // 宠物
				_entityClass[EntityType.DropItem] = ItemPlayer;  // 掉落
			}
			return _entityClass;
		}
		
		public function EntityClass()
		{
			
		}
		
		public static function getInstanceByType( type:Object ):Object
		{
			//return new entityClass[ type ]();
			var _targetClass:Class = entityClass[ type ]?entityClass[ type ] : type as Class;
			var obj:Pivot3D = ObjectPool.getObject(_targetClass) as Pivot3D;
			obj.isDisposeToPool = false;
			return obj;
		}
		
		public static function disposeInstance( value:Pivot3D,typeClass:Class ):void
		{
			if( value && value.parent != null )
			{
				value.parent.removeChild(value);
			}
			if( value.isDisposeToPool == false )
			{
				value.isDisposeToPool = true;
				ObjectPool.disposeObject(value,typeClass);
			}
		}
	}
}
