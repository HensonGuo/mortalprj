package extend.flash.flower.fallenLeaves
{
	import com.mui.core.GlobalClass;
	
	import extend.flash.flower.FlowerRunType;
	import extend.flash.flower.FlowerSprite;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	
	public class FallenLeaveSprite extends FlowerSprite
	{
		public function FallenLeaveSprite()
		{
			super();
			this._intervalNum = 1;
			this._flowerRunType = FlowerRunType.SPEEDADD;
		}
		
		override protected function initFlowerAry():void
		{
			_flowerAry = [
				GlobalClass.getBitmapData(ImagesConst.FallenLeaves1),
				GlobalClass.getBitmapData(ImagesConst.FallenLeaves2),
				GlobalClass.getBitmapData(ImagesConst.FallenLeaves3),
				GlobalClass.getBitmapData(ImagesConst.FallenLeaves4)
			];
		}
		
		protected override function getFlower():BitmapData
		{
			var index:int = random(0, _flowerAry.length - 1);
			return _flowerAry[index];
		}
	}
}