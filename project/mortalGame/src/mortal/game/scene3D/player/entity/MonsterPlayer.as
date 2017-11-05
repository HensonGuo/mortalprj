package mortal.game.scene3D.player.entity
{
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TBoss;
	import Message.Public.EEntityType;
	
	import baseEngine.system.Device3D;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.common.global.ParamsConst;
	import mortal.game.resource.tableConfig.BossConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.game.utils.NameUtil;

	public class MonsterPlayer extends MovePlayer
	{
		public var _bossInfo:TBoss;
		
		public function MonsterPlayer()
		{
			super();
			overPriority = Game2DOverPriority.Monster;
		}
		
		public function get tboss():TBoss
		{
			return _bossInfo;
		}
		
		override public function get type():int
		{
			return EEntityType._EEntityTypeBoss;
		}
		
		override public function updateInfo(info:Object, isAllUpdate:Boolean=true):void
		{
			super.updateInfo(info,isAllUpdate);
		}
		
		override public function updateClothes(value:int):void
		{
//			if(ParamsConst.instance.isUseATF)
//			{
//				_bodyPlayer.load("97_zsntest.md5mesh","97_zsntest.skeleton","zsn.cmp0");
//			}
//			else
//			{
//				_bodyPlayer.load("97_zsntest.md5mesh","97_zsntest.skeleton","zsn.jpg");
//			}
		}
		
		override protected function updateOther(info:SEntityInfo, isAllUpdate:Boolean=true):void
		{
			super.updateOther(info);
			
			if( _bossInfo == null || isAllUpdate)
			{
				_bossInfo = BossConfig.instance.getInfoByCode(info.code);
				if( _bossInfo )
				{
					//如果服务器给了名字 就用服务请名字，如果没给就读配置
					if(!info.name)
					{
						info.name = _bossInfo.name;
					}
				}
				
				_bodyPlayer.load(_bossInfo.mesh + ".md5mesh",_bossInfo.bone + ".skeleton",_bossInfo.texture);
				if(_bossInfo.modelScale)
				{
					_bodyPlayer.scaleValue = _bossInfo.modelScale * 1.0/100;
				}
			}
			else
			{
				//Alert.show("怪物ID:"+info.code+"不存在");
			}
		}
		
		override public function updateName(value:String=null, isUpdate:Boolean=true):void
		{
			var nameStr:String = NameUtil.getNameHtmlByRelation(this.entityInfo.entityInfo,value);
			super.updateName(nameStr,isUpdate);
		}
	}
}