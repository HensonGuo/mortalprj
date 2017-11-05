package mortal.game.view.miniGame.fishing.defin
{
	import mortal.game.view.miniGame.fishing.ObjController.PowerForceFishController;
	import mortal.game.view.miniGame.fishing.ObjController.UniformFishController;

	public class FishModelDefin
	{
		public var url:String;//路径
		public var minDepth:Number;//活动范围的最小深度
		public var maxDepth:Number;//活动范围的最大深度
		public var activeType:Class;//运动方式 为空的话就是代表随即一种运动方式
		
		public function FishModelDefin($url:String,$minDepth:Number,$maxDepth:Number,$activeType:Class = null)
		{
			url = $url;
			minDepth = $minDepth;
			maxDepth = $maxDepth;
			activeType = $activeType;
		}
		
		public static var fishType2:FishModelDefin = new FishModelDefin("fish2.swf",310,310,UniformFishController);
		public static var fishType3:FishModelDefin = new FishModelDefin("fish3.swf",120,260,PowerForceFishController);
		public static var fishType4:FishModelDefin = new FishModelDefin("fish4.swf",120,260,PowerForceFishController);
		public static var fishType5:FishModelDefin = new FishModelDefin("fish5.swf",120,260,UniformFishController);
		public static var fishType6:FishModelDefin = new FishModelDefin("fish6.swf",120,260,UniformFishController);
		public static var fishType7:FishModelDefin = new FishModelDefin("fish7.swf",200,260,UniformFishController);
		public static var fishType8:FishModelDefin = new FishModelDefin("fish8.swf",120,260,UniformFishController);
		public static var fishType9:FishModelDefin = new FishModelDefin("fish9.swf",120,260,UniformFishController);
		
		public static var _allFishType:Vector.<FishModelDefin>;
		
		public static function get allFishType():Vector.<FishModelDefin>
		{
			if(!_allFishType)
			{
				_allFishType = new Vector.<FishModelDefin>();
				_allFishType.push(fishType2);
				_allFishType.push(fishType3);
				_allFishType.push(fishType4);
				_allFishType.push(fishType5);
				_allFishType.push(fishType6);
				_allFishType.push(fishType7);
				_allFishType.push(fishType8);
				_allFishType.push(fishType9);
			}
			return _allFishType;
		}
	}
}