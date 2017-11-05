package extend.flash.flower.fallenLeaves
{
	import extend.flash.flower.FlowerManager;
	import extend.flash.flower.FlowerSprite;
	
	public class FallenLeavesManager extends FlowerManager
	{
		public function FallenLeavesManager()
		{
			super();
		}
		
		protected override function getflowerSprite(type:int):FlowerSprite
		{
			return new FallenLeaveSprite();
		}
	}
}