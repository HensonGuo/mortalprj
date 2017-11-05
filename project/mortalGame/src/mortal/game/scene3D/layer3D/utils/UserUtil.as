package mortal.game.scene3D.layer3D.utils
{
	import Message.BroadCast.SEntityInfo;
	import Message.BroadCast.SEntityUpdate;
	import Message.Public.EEntityAttribute;
	import Message.Public.SAttributeUpdate;
	
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;

	public class UserUtil extends EntityLayerUtil
	{
		public function UserUtil($layer:PlayerLayer)
		{
			super($layer);
		}
		
		public function updateAttribute(seu:SEntityUpdate):void
		{
			var entity:SpritePlayer;
			if( seu.msgEx == null )
			{
				entity = ThingUtil.entityUtil.getEntity(seu.entityId) as SpritePlayer;
			}
//			if( entity == null )
//			{
//				ThingUtil.delayEntityUtil.updateEntityAttribute(seu.entityId,seu.propertyUpdates);
//				return;
//			}
			if(entity)
			{
				entity.updateEntityAttribute(seu.propertyUpdates);
			}
		}
		
		
		/**
		 * 更新属性 
		 * @param attributes
		 * 
		 */		
		public static function updateEntityAttribute(sinfo:SEntityInfo , attributes:Array):void
		{
			var len:uint=attributes.length;
			for (var i:uint=0; i < len; i++)
			{
				var item:SAttributeUpdate = attributes[i] as SAttributeUpdate;
				if(item.attribute)
				{
					switch (item.attribute.__value)
					{
						case EEntityAttribute._EAttributeLife: //生命
						{
							sinfo.life = item.value;
							break;
						}
						case EEntityAttribute._EAttributeSpeed: //速度
						{
							sinfo.speed = item.value;
							break;
						}
						case EEntityAttribute._EAttributeCareer: //职业
						{
							sinfo.career = item.value;
							break;
						}
						case EEntityAttribute._EAttributeLevel: //等级
						{
							sinfo.level = item.value;
							break;
						}
						case EEntityAttribute._EAttributeFighting://战斗中
						{
							sinfo.fighting = Boolean(item.value);
							break;
						}
					}
				}
			}
		}
		
		override public function removeAll():void
		{
			
		}
		
	}
}
