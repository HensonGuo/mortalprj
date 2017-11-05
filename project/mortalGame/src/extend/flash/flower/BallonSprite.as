package extend.flash.flower
{
	import com.gengine.global.Global;
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene.player.entity.SpritePlayer;
	
	public class BallonSprite extends FlowerSprite
	{
		public function BallonSprite()
		{
			super();
			_intervalNum = 24;
		}
		
		override protected function initFlowerAry():void
		{
			_flowerAry = [GlobalClass.getBitmapData(ImagesConst.MarryBalloon1),GlobalClass.getBitmapData(ImagesConst.MarryBalloon2),GlobalClass.getBitmapData(ImagesConst.MarryBalloon3),GlobalClass.getBitmapData(ImagesConst.MarryBalloon4),GlobalClass.getBitmapData(ImagesConst.MarryBalloon5)];
		}
		
		override protected function getFlower():BitmapData
		{
			var i:int = random(0,_flowerAry.length - 1);
			return _flowerAry[i];
		}
		
		/**
		 * 初始化位置 mmo
		 * 
		 */		
		override protected function initFlowerPosition(fbm:FlowerBitmap):void
		{
			fbm.x = random( 20 , Global.stage.stageWidth - 50 );
			fbm.y = Global.stage.stageHeight + 5;
		}
		
		/**
		 * 运行，改变位置 
		 * 
		 */
		override protected function runFlowerBmp(fbm:FlowerBitmap):void
		{
			if( int(Math.random()*Global.stage.stageWidth)%2 ==0 )
			{
				fbm.y -= 1;
			}
			else
			{
				fbm.y -= 2;
			}
		}
		
		/**
		 * 判断是否出位 
		 * 
		 */		
		override protected function judgeOut(fbm:FlowerBitmap):Boolean
		{
			return fbm.y < -90;
		}
	}
}