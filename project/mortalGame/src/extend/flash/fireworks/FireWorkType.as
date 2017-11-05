package extend.flash.fireworks
{
	import com.gengine.utils.MathUitl;
	
	import flash.geom.Point;

	public class FireWorkType
	{
		public static var NormalFire:int = 0;
		public static var MarryFire1:int = 1;
		public static var MarryFire2:int = 2;
		public static var MarryFire3:int = 3;
		public static var MarryWeddingFire:int = 4;
		public static var MarryWeddingContinuedFire:int = 5;
		
		/**
		 * 喜车巡游普通型的坐标点 
		 */	
		private static var _aryMarryFriePoint1:Array;
		public static function get aryMarryFirePoint1():Array
		{
			if(!_aryMarryFriePoint1)
			{
				_aryMarryFriePoint1 = new Array();
				_aryMarryFriePoint1.push( new Point(-100,-50));
				_aryMarryFriePoint1.push( new Point(100,-50));
			}
			return _aryMarryFriePoint1;
		}
		
		/**
		 * 喜车巡游高级型的坐标点 
		 */	
		private static var _aryMarryFriePoint2:Array;
		public static function get aryMarryFirePoint2():Array
		{
			if(!_aryMarryFriePoint2)
			{
				_aryMarryFriePoint2 = new Array();
				_aryMarryFriePoint2.push( new Point(-150,-50));
				_aryMarryFriePoint2.push( new Point(-50,-100));
				_aryMarryFriePoint2.push( new Point(50,-100));
				_aryMarryFriePoint2.push( new Point(150,-50));
			}
			return _aryMarryFriePoint2;
		}
		
		/**
		 * 喜车巡游豪华型的坐标点 
		 */		
		private static var _aryMarryFriePoint3:Array;
		public static function get aryMarryFirePoint3():Array
		{
			if(!_aryMarryFriePoint3)
			{
				_aryMarryFriePoint3 = new Array();
				_aryMarryFriePoint3.push( new Point(0,-150));
			}
			return _aryMarryFriePoint3;
		}
		
		/**
		 * 婚礼烟花道具的坐标点 
		 */		
		private static var _aryMarryWeddingFirePoint:Array;
		public static function get aryMarryWeddingFirePoint():Array
		{
			if(!_aryMarryWeddingFirePoint)
			{
				_aryMarryWeddingFirePoint = new Array();
				_aryMarryWeddingFirePoint.push( new Point(0,-150));
			}
			return _aryMarryWeddingFirePoint;
		}
		
		/**
		 * 婚礼持续性的烟花坐标点 
		 * @return 
		 * 
		 */		
		public static function get aryMarryWeddingContinuedFirePoint():Array
		{
			var aryPoints:Array = new Array();
			aryPoints.push(new Point(-300,100));
			aryPoints.push(new Point(-300,-200));
			aryPoints.push(new Point(0,-200));
			aryPoints.push(new Point(300,100));
			aryPoints.push(new Point(300,-200));
			return aryPoints;
		}
		
		/**
		 * 普通烟花道具的坐标点 
		 * @return 
		 * 
		 */		
		public static function get aryNormalFirePoint():Array
		{
			var aryPoints:Array = new Array();
			for(var i:int = 0;i < 12;i++)
			{
				aryPoints.push(new Point(MathUitl.random(-200 , 200),MathUitl.random(-250 ,-150)));
			}
			return aryPoints;
		}
		
		public function FireWorkType()
		{
			
		}
	}
}