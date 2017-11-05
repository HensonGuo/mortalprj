package extend.flash.flower
{
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.utils.MathUitl;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene.modle.SWFPlayer;
	import mortal.game.scene.modle.data.ModelType;
	
	[Event(name="play_end",type="flash.events.Event")]
	
	public class FlowerSprite extends Sprite
	{
		
		//GlobalClass.getBitmapData(ImagesConst.flower1),GlobalClass.getBitmapData(ImagesConst.flower2),GlobalClass.getBitmapData(ImagesConst.flowerMotif1),GlobalClass.getBitmapData(ImagesConst.flowerMotif2)
		//public static var FlowerAry:Array; //= [new Flower1(43,36),new Flower2(36,27),new Petal1(23,14),new Petal2(30,18)];
		
		public static const PLAY_END:String = "play_end";
		
		private var _spriteArray:Array;
		
		protected var _flowerAry:Array;
		
		protected var _starAry:Array;
		
		private var _flowerTime:Number = FlowerConst.FLOWER_TIME;
		
		private var _num:int = 0;
		
		protected var _intervalNum:int = FlowerConst.FLOWER_INTERVAL;
		
		protected var _starIntervalNum:int = 5;
		
		private var _isStop:Boolean = false;
		
		protected var _flowerRunType:int = 0;
		
		protected var _isAddStar:Boolean = false;
		
		public function FlowerSprite()
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_spriteArray = [];
			_starAry = [];
			initFlowerType();
			initFlowerAry();
		}
		
		protected function initFlowerAry():void
		{
			_flowerAry = [GlobalClass.getBitmapData(ImagesConst.Flower1),GlobalClass.getBitmapData(ImagesConst.Flower2),GlobalClass.getBitmapData(ImagesConst.Petal1),GlobalClass.getBitmapData(ImagesConst.Petal2)];
		}
		
		protected function initFlowerType():void
		{
			_flowerRunType = FlowerRunType.NORMAL;
		}
		
		//开始飘花

		public function get flowerTime():Number
		{
			return _flowerTime;
		}

		public function start():void
		{
			_isStop = false;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}
		
		public function stop():void
		{
			_isStop = true;
		}
		/**
		 * 每帧触发事件 
		 * @param event
		 * 
		 */		
		public function onEnterFrameHandler( event:Event ):void
		{
			_num ++
			if( !_isStop && _num % _intervalNum == 0 )
			{
				addFlower();
			}
			if(!_isStop && _isAddStar && _num % _starIntervalNum == 0)
			{
				addStar();
			}
			runBitmapData();
		}
		
		private function addFlower():void
		{
			var fbm:FlowerBitmap = ObjectPool.getObject(FlowerBitmap);
			fbm.bitmapData = getFlower();
			fbm.initType(_flowerRunType);
//			setFlower(fbm);
			//fbm.scaleX = fbm.scaleY = getScaleRandom();
			initFlowerPosition( fbm );
			_spriteArray.push( fbm );
			this.addChild(fbm);
		}
		
		protected function addStar():void
		{
			var flowerStar:FlowerStar = ObjectPool.getObject(FlowerStar);
			flowerStar.load("flowerStar.swf",ModelType.NormalSwf,null,LoaderPriority.LevelA);
			flowerStar.reset();
			initStarPosition(flowerStar);
			_starAry.push(flowerStar);
			this.addChild(flowerStar);
		}
		
		protected function getScaleRandom():Number
		{
			return Math.random();//random(0.6,1);
		}
		
//		protected function setFlower(fbm:FlowerBitmap):void
//		{
//			var i:int = random(0,3);
//			fbm.bitmapData = _flowerAry[i];
////			var bmpType:int = i < 2?FlowerBitmapType.FlowerBloom:FlowerBitmapType.FlowerLeaves;
//			fbm.initType(_flowerRunType,bmpType);
//		}
		
		protected function getFlower():BitmapData
		{
			var i:int = random(0,3);
			return _flowerAry[i];
		}
		
		/**
		 * 初始化位置 
		 * 
		 */		
		protected function initFlowerPosition(fbm:FlowerBitmap):void
		{
			fbm.x = random( 20 , Global.stage.stageWidth - 50 );
			fbm.baseX = fbm.x;
			fbm.y = MathUitl.random(-50,-25);
		}
		
		protected function initStarPosition(swf:FlowerStar):void
		{
			swf.sceneX = random( 20 , Global.stage.stageWidth - 50 );
			swf.sceneY = Global.stage.stageHeight + MathUitl.random(-30,-10);
		}
		
		/**
		 * 运行，改变位置 
		 * 
		 */
		protected function runFlowerBmp(fbm:FlowerBitmap):void
		{
			fbm.update();
//			if( int(Math.random()*Global.stage.stageWidth)%2 ==0 )
//			{
//				fbm.y += 1;
//			}
//			else
//			{
//				fbm.y += 2;
//			}
			
//			fbm.x = fbm.baseX + (fbm.baseX%2?Math.sin(fbm.y/fbm.frequency) * fbm.amplitude:Math.cos(fbm.y/fbm.frequency) * fbm.amplitude);
//			fbm.rotation += Math.random() * fbm.rotationMargin;
		}
		
		protected function runStar(str:FlowerStar):void
		{
			str.update();
		}
		
		/**
		 * 判断是否出位 
		 * 
		 */		
		protected function judgeOut(fbm:FlowerBitmap):Boolean
		{
			return fbm.y > Global.stage.stageHeight + 40 || fbm.alpha < 0.001;
		}
		
		/**
		 * 判断星星是否移除 
		 * @param str
		 * @return 
		 * 
		 */		
		protected function judgeOutStar(str:FlowerStar):Boolean
		{
			return str.alpha < 0.001;
		}
		
		/**
		 * 刷屏 
		 * 
		 */		
		private function runBitmapData():void
		{
			if( _spriteArray.length <= 0 )
			{
				if(_isStop)
				{
					this.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
					if(this.parent)
					{
						dispatchEvent( new Event(PLAY_END) );
						this.parent.removeChild(this);
					}
					_num = 0 ;
				}
				return;
			}
			drawFlowersBmd();
			drawStarPlayer();
		}
		
		/**
		 * 绘制所有花到一个bitmapdata上 
		 * @return 
		 * 
		 */		
		private function drawFlowersBmd():void
		{
			var fbm:FlowerBitmap;
			for( var i:int=0; i <_spriteArray.length;i++ )
			{
				fbm = _spriteArray[i];
				runFlowerBmp(fbm);
				
				if( judgeOut(fbm))
				{
					if( this.contains(fbm) )
					{
						this.removeChild(fbm);
					}
					fbm.dispose();
					ObjectPool.disposeObject( fbm ,FlowerBitmap);
					_spriteArray.splice( i , 1 );
				}
			}
		}
		
		private function drawStarPlayer():void
		{
			var star:FlowerStar;
			for( var i:int=0; i <_starAry.length;i++ )
			{
				star = _starAry[i];
				runStar(star);
				
				if( judgeOutStar(star))
				{
					if( this.contains(star) )
					{
						this.removeChild(star);
					}
					star.dispose();
					ObjectPool.disposeObject( star );
					_starAry.splice( i , 1 );
				}
			}
		}
		
		/**
		 * 随机数 
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		protected function random(min:int,max:int):int
		{
			var num:int = max - min;
			return Math.round(Math.random()*num) + min;
		}
		public function destroy():void
		{
			_flowerAry = null;
			_spriteArray = null;
		}
	}
}