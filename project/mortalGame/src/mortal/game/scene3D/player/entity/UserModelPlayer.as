/**
 * @heartspeak
 * 2014-4-23 
 */   	

package mortal.game.scene3D.player.entity
{
	import Message.DB.Tables.TPlayerModel;
	
	import baseEngine.basic.RenderList;
	
	import com.gengine.utils.pools.ObjectPool;
	
	import mortal.game.resource.tableConfig.PlayerModelConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.model.player.WeaponPlayer;
	import mortal.game.scene3D.player.type.ModelType;

	public class UserModelPlayer extends Game2DPlayer
	{
		protected var _bodyPlayer:ActionPlayer;
		
		protected var _weaponPlayer:WeaponPlayer;
		
		protected var _career:int;
		protected var _sex:int;
		protected var _weapon:int;
		protected var _clothes:int;
		protected var _renderList:RenderList;
		
		public function UserModelPlayer()
		{
			super();
		}
		
		public function get bodyPlayer():ActionPlayer
		{
			return _bodyPlayer;
		}

		protected function initPlayer():void
		{
			if(!_bodyPlayer)
			{
				_bodyPlayer = ObjectPool.getObject(ActionPlayer);
				_bodyPlayer.changeAction(ActionName.Stand);
				_bodyPlayer.hangBoneName = "guazai001";
				_bodyPlayer.selectEnabled = false;
				_bodyPlayer.timerContorler = this.timerContorler;
				_bodyPlayer.play();
			}
			this.timerContorler.active();
			this.addChild(_bodyPlayer);
			if(!_weaponPlayer)
			{
				_weaponPlayer = ObjectPool.getObject(WeaponPlayer);
				_weaponPlayer.hangBoneName = "Bip001 Prop1";
			}
		}
		
		public function updateInfo(career:int,sex:int,clothes:int,weapon:int):void
		{
			this.sex = sex;
			this.career = career;
			this.clothes = clothes;
			this.weapon = weapon;
			
			initPlayer();
			loadClothes();
			loadWeapon();
		}
		
		public function set sex(value:int):void
		{
			_sex = value;
		}
		
		public function set career(value:int):void
		{
			_career = value;
		}
		
		public function set weapon(value:int):void
		{
			_weapon = value;
		}
		
		public function set clothes(value:int):void
		{
			_clothes = value;
		}
		
		public function loadWeapon():void
		{
			var model:TPlayerModel = getModelInfo(ModelType.WEAPONS,_weapon);
			var index:int;
			if(model)
			{
				_weaponPlayer.load(model.mesh + ".mesh",model.texture,_renderList);
				_bodyPlayer.hang(_weaponPlayer);
			}
			else
			{
				_bodyPlayer.unHang(_weaponPlayer);
				this.removeChild(_weaponPlayer);
			}
		}
		
		public function loadClothes():void
		{
			var model:TPlayerModel = getModelInfo(ModelType.CLOTHES,_clothes);
			if(model)
			{
				_bodyPlayer.load(model.mesh + ".md5mesh",model.bone + ".skeleton",model.texture,_renderList);
			}
		}
		
		public function getModelInfo(type:int,modelId:int):TPlayerModel
		{
			return PlayerModelConfig.instance.getModelInfo(type,modelId,_sex,_career);
		}
		
		public function setRenderList(renderList:RenderList):void
		{
			_renderList = renderList;
			if(_bodyPlayer)
			{
				_bodyPlayer.renderList = renderList;
			}
			if(_weaponPlayer)
			{
				_weaponPlayer.renderList = renderList;
			}
		}
		
		public function set scaleAll(value:Number):void
		{
			_bodyPlayer.scaleX = value;
			_bodyPlayer.scaleY = value;
			_bodyPlayer.scaleZ = value;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			_career = 0;
			_sex = 0;
			_weapon = 0;
			_clothes = 0;
			_renderList = null;
			if(_bodyPlayer)
			{
				_bodyPlayer.dispose(isReuse);
				_bodyPlayer = null;
			}
			if(_weaponPlayer)
			{
				_weaponPlayer.dispose(isReuse);
				_weaponPlayer = null;
			}
		}
	}
}