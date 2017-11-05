package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TGuildBranchTarget;
	
	import com.gengine.resource.ConfigManager;
	
	import mortal.game.view.common.ClassTypesUtil;

	public class GuildBranchLevelUpTargetConfig
	{
		private static var _instance:GuildBranchLevelUpTargetConfig;
		private var _targetList:Vector.<TGuildBranchTarget>;
		
		public function GuildBranchLevelUpTargetConfig()
		{
			if( _instance != null )
			{
				throw new Error(" GuildBranchLevelUpTargetConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():GuildBranchLevelUpTargetConfig
		{
			if( _instance == null )
			{
				_instance = new GuildBranchLevelUpTargetConfig();
			}
			return _instance;
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_guild_branch_target.json");
			write( object );
		}
		
		private function write( dic:Object ):void
		{
			var info:TGuildBranchTarget;
			//添加一条0的配置
			for each( var o:Object in dic  )
			{
				info = new TGuildBranchTarget();
				ClassTypesUtil.copyValue(info, o);
				if (!_targetList)
					_targetList = new Vector.<TGuildBranchTarget>();
				_targetList.push(info);
			}
		}
		
		public function getInfoByTarget( target:int):TGuildBranchTarget
		{
			if (target - 1 >= _targetList.length)
				return null;
			return _targetList[target - 1];
		}
		
	}
}