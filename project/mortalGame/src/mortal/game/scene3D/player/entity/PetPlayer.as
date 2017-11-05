/**
 * @heartspeak
 * 2014-1-27 
 */   	

package mortal.game.scene3D.player.entity
{
	import Message.BroadCast.SEntityInfo;
	import Message.DB.Tables.TModel;
	import Message.DB.Tables.TPetConfig;
	import Message.Public.EEntityType;
	
	import baseEngine.system.Device3D;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.resource.tableConfig.PetConfig;
	import mortal.game.utils.EntityRelationUtil;
	import mortal.game.utils.NameUtil;
	import mortal.game.utils.PetUtil;

	public class PetPlayer extends MovePlayer
	{
		private var _petInfo:TPetConfig;
		
		public function PetPlayer()
		{
			super();
		}
		
		override protected function updateOther(info:SEntityInfo, isAllUpdate:Boolean=true):void
		{
			if (_petInfo == null || isAllUpdate)
			{
				_petInfo = PetConfig.instance.getInfoByCode(_entityInfo.entityInfo.code);
				//更新模型
				var model:TModel = ModelConfig.instance.getInfoByCode(_petInfo.model);
//				var model:TModel = ModelConfig.instance.getInfoByCode(_entityInfo.entityInfo.model);
				_bodyPlayer.load(model.mesh1 + ".md5mesh",model.bone1 + ".skeleton",model.texture1);
			}
			super.updateOther(info, isAllUpdate);
		}
		
		override public function updateName(value:String=null, isUpdate:Boolean=true):void
		{
			var name:String = NameUtil.getPetName(_entityInfo,_entityInfo.entityInfo.name);
			super.updateName(name,isUpdate);
		}
		
		override public function get type():int
		{
			return EEntityType._EEntityTypePet;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			_petInfo = null;
		}
	}
}