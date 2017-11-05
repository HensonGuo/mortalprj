package mortal.game.scene3D.player.entity
{
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TItemMount;
	import Message.DB.Tables.TModel;
	import Message.DB.Tables.TPlayerModel;
	import Message.Public.ECareer;
	import Message.Public.EEntityType;
	
	import baseEngine.system.Device3D;
	
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.info.item.ItemMountInfo;
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.resource.tableConfig.PlayerModelConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.scene3D.model.player.WeaponPlayer;
	import mortal.game.scene3D.player.type.ModelType;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.game.utils.NameUtil;

	public class UserPlayer extends MovePlayer
	{
		
		protected var _weaponPlayer:WeaponPlayer;
		
		protected var _mountPlayer:ActionPlayer;
		
		public function UserPlayer()
		{
			super();
			overPriority = Game2DOverPriority.Use;
		}
		
		public function get weaponPlayer():WeaponPlayer
		{
			return _weaponPlayer;
		}

		override protected function initPlayers():void
		{
			super.initPlayers();
			if(!_weaponPlayer)
			{
				_weaponPlayer = ObjectPool.getObject(WeaponPlayer);
//				if(ParamsConst.instance.isUseATF)
//				{
//					_weaponPlayer.load("zsnv-wuqi.mesh","132_0+.cmp0");
//				}else
//				{
//					_weaponPlayer.load("zs_wuqi2.mesh","zs_wuqi.png");
//				}
				
				_weaponPlayer.hangBoneName = "Bip001 Prop1";
//				_weaponPlayer.selectEnabled = true;
			}
		}
		
		override protected function onFrameComplete():void
		{
			super.onFrameComplete();
			if(_bodyPlayer && _bodyPlayer.actionName == ActionType.Death)
			{
				_bodyPlayer.currentFrame = _bodyPlayer.getActionFrameLen(_bodyPlayer.actionName) - 1;
				_bodyPlayer.stop();
			}
		}
		
		override protected function updateActionName():void
		{
			if(_actionType == ActionType.Walking)
			{
				//一系列判断
				if(_inMount)
				{
					refreshActionName(ActionName.RoleMountWalk);
					_mountPlayer.changeAction(ActionName.MountWalk);
					_mountPlayer.play();
				}
				else if(sentityInfo.fighting)
				{
					refreshActionName(ActionName.FightRun);
				}
				else
				{
					refreshActionName(ActionName.Walking);
				}
			}
			if(_actionType == ActionType.Stand)
			{
				//一系列判断
				if(_inMount && _mountPlayer)
				{
					refreshActionName(ActionName.RoleMountStand);
					_mountPlayer.changeAction(ActionName.MountStand);
					_mountPlayer.play();
				}
				else if(sentityInfo.fighting)
				{
					refreshActionName(ActionName.FightWait);
				}
				else
				{
					refreshActionName(ActionName.Stand);
				}
			}
			
			updateBodyDirection();
		}
		
		override protected function updateBodyDirection():void
		{
			if(_inMount)
			{
				if(_mountPlayer)
				{
					_mountPlayer.direction = super._direction;
				}
				_bodyPlayer.direction = 90;
			}
			else
			{
				super.updateBodyDirection();
			}
		}
		
		/*override protected function set scaleValue(value:Number):void
		{
			super.scaleValue = value;
		}*/
		
		/*override protected function updateID():void
		{
			super.updateID();
//			_weaponPlayer.name = _entityID;
		}*/
		
		override public function get type():int
		{
			return EEntityType._EEntityTypePlayer;
		}
		
		override public function updateCCS(info:SEntityInfo, isUpdate:Boolean=false):void
		{
			super.updateCCS(info,isUpdate);
			updateClothes(_entityInfo.clothes);
			updateWeapons(_entityInfo.weapon);
		}
		
		override public function updateWeapons(value:int):void
		{
			var model:TPlayerModel = getModelInfo(ModelType.WEAPONS,value);
			var index:int;
			if(model)
			{
				_weaponPlayer.load(model.mesh + ".mesh",model.texture);
				_bodyPlayer.hang(_weaponPlayer);
				index = _playerList.indexOf(_weaponPlayer);
				if(index < 0)
				{
					_playerList.push(_weaponPlayer);
				}
			}
			else
			{
				_bodyPlayer.unHang(_weaponPlayer);
				this.removeChild(_weaponPlayer);
				index = _playerList.indexOf(_weaponPlayer);
				if(index >= 0)
				{
					_playerList.splice(index,1);
				}
			}
//			switch(this.career)
//			{
//				case ECareer._ECareerWarrior:
//					_weaponPlayer.load("zs_wuqi2.mesh","zs_wuqi.png");
//					break;
//				case ECareer._ECareerArcher:
//					_weaponPlayer.load("GS_1g.mesh","GS_1g.png");
//					break;
//				case ECareer._ECareerMage:
//					_weaponPlayer.load("FS_1wq.mesh","FS_1wq.png");
//					break;
//				case ECareer._ECareerPriest:
//					_weaponPlayer.load("MS_1lz.mesh","MS_1lz.png");
//					break;
//			}
		}
		
		override public function updateClothes(value:int):void
		{
			var model:TPlayerModel = getModelInfo(ModelType.CLOTHES,value);
			if(model)
			{
				_bodyPlayer.load(model.mesh + ".md5mesh",model.bone + ".skeleton",model.texture);
			}
		}
		
		override public function updateLife(life:int, maxLife:int):void
		{
			super.updateLife(life,maxLife);
			if( life <= 0 )
			{
				isDead = true;
			}
			if( this.isDead )
			{
				if( life > 0 )
				{
					isDead = false;
					this.setAction(ActionType.Stand,ActionName.Stand);
				}
			}
		}
		
		protected function getModelInfo(type:int,modelId:int):TPlayerModel
		{
			return PlayerModelConfig.instance.getModelInfo(type,modelId,sex,career);
		}
		
		/**
		 * 更新坐骑 
		 * @param code
		 * 
		 */		
		override public function updateMount(code:int):void
		{
			//更新
			if(code)
			{
				//初始化坐骑

				if(!_mountPlayer)
				{
					_mountPlayer = ObjectPool.getObject(ActionPlayer);
					_playerList.push(_mountPlayer);
					_mountPlayer.changeAction(ActionName.MountStand);
					_mountPlayer.timerContorler = this.timerContorler;
				}

				_mountPlayer.play();
				_inMount = true;
				this.addChild(_mountPlayer);
				_mountPlayer.hang(_bodyPlayer);
				//加载坐骑
				var mount:ItemMountInfo = ItemConfig.instance.getConfig(code) as ItemMountInfo;
				var mode:TModel = ModelConfig.instance.getInfoByCode(mount.model);
				_mountPlayer.load(mode.mesh1 + ".md5mesh",mode.bone1 + ".skeleton",mode.texture1);
			}
			else
			{
				_inMount = false;
				if(_mountPlayer && this.contains(_mountPlayer))
				{
					this.removeChild(_mountPlayer);
					_mountPlayer.unHang(_bodyPlayer);
					this.addChild(_bodyPlayer);
				}
			}
			updateActionName();
		}
		
		override public function set isDead(value:Boolean):void
		{
			super.isDead = value;
			if( value )
			{
				setAction(ActionType.Death,ActionName.Death);
				stopWalking();
			}
			else
			{
				setAction(ActionType.Stand,ActionName.Stand);
				_bodyPlayer.play();
			}
		}
		
		override public function updateName(value:String = null, isUpdate:Boolean = true):void
		{
			var name:String = NameUtil.getName(entityInfo,value);
			_headContainner.updateName(name);
		}
		
		/**
		 * 更新公会名字和职位信息 
		 * 
		 */		
		override protected function updateGuildName():void
		{
			var hasGuild:Boolean = sentityInfo.guildId.id  > 0;
			var name:String = "";
			if(hasGuild)
			{
				name = sentityInfo.guildName + NameUtil.Spacer + GameDefConfig.instance.getGuildPositonName(sentityInfo.guildPosition);
			}
			_headContainner.updateGuildName(name);
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			if(_weaponPlayer)
			{
				_weaponPlayer.dispose();
				_weaponPlayer = null;
			}
			if(_mountPlayer)
			{
				_mountPlayer.dispose();
				_mountPlayer = null;
			}
			super.dispose(isReuse);
		}
	}
}