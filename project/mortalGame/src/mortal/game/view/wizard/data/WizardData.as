package mortal.game.view.wizard.data
{
	import Message.Game.SSoul;
	
	import mortal.game.resource.tableConfig.WizardConfig;

	public class WizardData
	{
		/**
		 * 穴位的个数 
		 */		
		public var boolNum:int;
		
		private var _soulId:int;
		
		private var _sSoul:SSoul;
		
		public function WizardData(value:*)
		{
			if(value is SSoul)
			{
				sSoul = value;
			}
			else if(value is int)
			{
				soulId = value;
			}
			
		}
		
		public function set sSoul(value:SSoul):void
		{
			_sSoul = value;
			soulId = _sSoul.soul;
		}
		
		public function get sSoul():SSoul
		{
			return _sSoul;
		}
		
		public function get soulId():int
		{
			return _soulId;
		}
		
		public function set soulId(value:int):void
		{			
			_soulId = value;
			boolNum = (WizardConfig.instance.wizardUpArr[_soulId] as Array).length - 1;
		}
		
		public function get isHasWizard():Boolean
		{
			return _sSoul != null;
		}
	
		/**
		 * 所有穴位中的最低等级 
		 * @return 
		 * 
		 */		
		public function get minLevel():int
		{
			return _sSoul.level - 1 < 0? 0:_sSoul.level - 1;
		}
			
		
	}
}