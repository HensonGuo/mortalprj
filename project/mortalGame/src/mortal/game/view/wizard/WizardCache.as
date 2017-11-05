package mortal.game.view.wizard
{
	import Message.Game.SSoul;
	
	import mortal.game.resource.tableConfig.WizardConfig;
	import mortal.game.view.wizard.data.WizardData;

	public class WizardCache
	{
		/**
		 * 剩余时间 
		 */		
		public var leftTime:int;  
		
		/**
		 * 当前放出的精灵 
		 */		
		public var gost:int;  
		
		/**
		 * 当前升级的经脉
		 */		
		public var nowSoul:int;  
		
		/**
		 * 精灵信息列表(长度减1) 
		 */		
		private var _soulList:Vector.<WizardData>; 
		
		public function WizardCache()
		{
		}
		
		public function get soulList():Vector.<WizardData>
		{
			if(_soulList == null)
			{
				_soulList = new Vector.<WizardData>;
				for (var i:String in WizardConfig.instance.wizardUpArr)
				{
					if(i == "0")
					{
						continue;
					}
					_soulList.push(new WizardData(int(i)));
				}
			}
			return _soulList;
		}
		
		public function set soulList(arr:Vector.<WizardData>):void
		{
			_soulList = arr;
		}
		
		public function updateList(arr:Array):Vector.<WizardData>
		{
			for each(var i:SSoul in arr)
			{
				(soulList[i.soul - 1] as WizardData).sSoul = i;
			}
			return soulList;
		}
		
		public function addSoul(ssoul:SSoul):void
		{
			soulList[ssoul.soul - 1].sSoul = ssoul;
		}
		
	}
}