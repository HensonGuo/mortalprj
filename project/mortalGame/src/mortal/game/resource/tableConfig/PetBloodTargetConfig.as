package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TPetBloodTarget;
	
	import com.gengine.resource.ConfigManager;
	
	import mortal.game.view.common.ClassTypesUtil;

	public class PetBloodTargetConfig
	{
		private static var _instance:PetBloodTargetConfig;
		private var _targetList:Vector.<TPetBloodTarget>;
		
		public function PetBloodTargetConfig()
		{
			if( _instance != null )
			{
				throw new Error(" PetBloodUpConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():PetBloodTargetConfig
		{
			if( _instance == null )
			{
				_instance = new PetBloodTargetConfig();
			}
			return _instance;
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_pet_blood_target.json");
			write( object );
		}
		
		private function write( dic:Object ):void
		{
			var info:TPetBloodTarget;
			//添加一条0的配置
			for each( var o:Object in dic  )
			{
				info = new TPetBloodTarget();
				ClassTypesUtil.copyValue(info, o);
				if (!_targetList)
					_targetList = new Vector.<TPetBloodTarget>();
				_targetList.push(info);
			}
		}
		
		public function getInfoByTarget( target:int):TPetBloodTarget
		{
			return _targetList[target];
		}
		
	}
}