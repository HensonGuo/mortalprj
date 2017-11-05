/**
 * @heartspeak
 * 2014-4-23 
 */   	

package mortal.game.scene3D.player.entity
{
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEvent;
	import mortal.game.scene3D.player.info.EntityInfoEventName;

	public class RoleModelPlayer extends UserModelPlayer
	{
		protected var _entityInfo:EntityInfo;
		
		public function RoleModelPlayer()
		{
			super();
		}
		
		public function set entityInfo(value:EntityInfo):void
		{
			removeEntityInfoEvent();
			_entityInfo = value;
			this.updateInfo(_entityInfo.entityInfo.career,_entityInfo.entityInfo.sex,_entityInfo.clothes,_entityInfo.weapon);
			addEntityInfoEvent();
		}
		
		protected function addEntityInfoEvent():void
		{
			_entityInfo.addEventListener(EntityInfoEventName.UpdateClothes,onUpdateClothes);
			_entityInfo.addEventListener(EntityInfoEventName.UpdateWeapon,onUpdateWeapon);
			_entityInfo.addEventListener(EntityInfoEventName.UpdateSex,onUpdateSex);
			_entityInfo.addEventListener(EntityInfoEventName.UpdateCareer,onUpdateCareer);
		}
		
		protected function removeEntityInfoEvent():void
		{
			if(_entityInfo)
			{
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateClothes,onUpdateClothes);
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateWeapon,onUpdateWeapon);
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateSex,onUpdateSex);
				_entityInfo.removeEventListener(EntityInfoEventName.UpdateCareer,onUpdateCareer);
			}
		}
		
		/**
		 * 更新衣服 
		 * @param e
		 * 
		 */		
		protected function onUpdateClothes(e:EntityInfoEvent):void
		{
			this.clothes = _entityInfo.clothes;
			loadClothes();
		}
		
		/**
		 * 更新武器
		 * @param e
		 * 
		 */
		protected function onUpdateWeapon(e:EntityInfoEvent):void
		{
			this.weapon = _entityInfo.weapon;
			loadWeapon();
		}
		
		/**
		 * 更新性别
		 * @param e
		 * 
		 */
		protected function onUpdateSex(e:EntityInfoEvent):void
		{
			this.sex = _entityInfo.entityInfo.sex;
			loadClothes();
			loadWeapon();
		}
		
		/**
		 * 更新职业 
		 * @param e
		 * 
		 */
		protected function onUpdateCareer(e:EntityInfoEvent):void
		{
			this.weapon = _entityInfo.entityInfo.career;
			loadClothes();
			loadWeapon();
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			removeEntityInfoEvent();
			_entityInfo = null;
		}
	}
}