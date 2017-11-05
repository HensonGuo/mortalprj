/**
 * 2013-11-6
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.data
{
	import flash.geom.Point;

	public class GeomUtil
	{
		public function GeomUtil()
		{
		}
		private static var v1:Vector2f = new Vector2f();
		private static var v2:Vector2f = new Vector2f();
		private static var v3:Vector2f = new Vector2f();
		private static var v4:Vector2f = new Vector2f();
		
		private static var t1:Vector2f = new Vector2f();
		private static var t2:Vector2f = new Vector2f();
		private static var t3:Vector2f = new Vector2f();
		
		/**
		 * 两线段p1p2 与 p3p4是否严格相交 
		 * @param p1
		 * @param p2
		 * @param p3
		 * @param p4
		 * @return 
		 * 
		 */		
		public static function isLimitLineCross(p1:Vector2f, p2:Vector2f, p3:Vector2f, p4:Vector2f):Boolean
		{
			p1.subtract(p3, t1);
			p4.subtract(p3, t2);
			p2.subtract(p3, t3);
			if(t1.crossMult(t2) * t3.crossMult(t2) > 0.00001)
			{
				return false;
			}
			
			p4.subtract(p1, t1);
			p2.subtract(p1, t2);
			p3.subtract(p1, t3);
			if(t1.crossMult(t2) * t3.crossMult(t2) > 0.00001)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * 线段p1p2是否在线段p3p4的两侧， 有公共点或者平衡也算 
		 * @param p1
		 * @param p2
		 * @param p3
		 * @param p4
		 * @return 
		 * 
		 */		
		public static function isLineP3P4CrossSegmentsP1P2(p1:Vector2f, p2:Vector2f, p3:Vector2f, p4:Vector2f):Boolean
		{
			p1.subtract(p3, t1);
			p4.subtract(p3, t2);
			p2.subtract(p3, t3);
			if(t1.crossMult(t2) * t3.crossMult(t2) > 0.000001)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 计算两条线段的交点（是线段，不是直线，或者延长线） 
		 * @param p1
		 * @param p2
		 * @param p3
		 * @param p4
		 * @param res
		 * @param hasCheckCross 是否已经验证了可定相交
		 * @return 是否有交点（）
		 * 
		 */		
		public static function calcSegmentsCrossPoint(p1:Point, p2:Point, p3:Point, p4:Point, res:Point, hasCheckCross:Boolean=true):Boolean
		{
			v1.fromPoint(p1);
			v2.fromPoint(p2);
			v3.fromPoint(p3);
			v4.fromPoint(p4);
			// 是否相交
			if(!hasCheckCross)
			{
				if(!isLimitLineCross(v1, v2, v3, v4))
				{
					return false;
				}
			}
			
			// 是否共线或者平衡
			v1.subtract(v2, t1);
			v3.subtract(v4, t2);
			if(t1.crossMult(t2) == 0)
			{
				return false;
			}
			
			res.x = p1.x;
			res.y = p1.y;
			var t:Number = ((p1.x - p3.x)*(p3.y - p4.y) - (p1.y - p3.y)*(p3.x - p4.x))/((p1.x - p2.x)*(p3.y - p4.y) - (p1.y - p2.y)*(p3.x-p4.x));
			res.x += (p2.x - p1.x)*t;
			res.y += (p2.y - p1.y)*t;
			return true;
		}
		
		/**
		 * 求直线ab与cd的交点:	Y = K*(x - x1) +y1; k = (y1-y2)/(x1-x2);
		 * @param a
		 * @param b
		 * @param c
		 * @param d
		 * @param res
		 * @return 
		 * 
		 */		
		public static function calcLineCrossPoint(a:Vector2f, b:Vector2f, c:Vector2f, d:Vector2f, res:Vector2f):Boolean
		{
			var dx1:Number = b._x - a._x;
			var dy1:Number = b._y - a._y;
			var dx2:Number = d._x - c._x;
			var dy2:Number = d._y - c._y;
			var pos1:Number = (dy1/dx1);
			var pos2:Number = (dy2/dx2);
			
			if(dx1 == 0)
			{
				if(dx2 == 0)
				{
					return false;
				}
				else
				{
					res._x = a._x;
					res._y = pos2*(res._x - c._x) + c._y;
					return true;
				}
			}
			else if(dx2 == 0)
			{
				res._x = c._x;
				res._y = pos1*(res._x - a._x) + a._y;
				return true;
			}
			else
			{
				if(pos1 == pos2)
				{
					return false;
				}
				else
				{
					res._x = (c._y - a._y - (pos2*c._x - pos1*a._x))/(pos1 - pos2);
					res._y = pos1 * (res._x - a._x) + a._y;
					return true;
				}
			}
			return false;
		}
		
		/**
		 * vertexs组成的多边形任意边是否与rect相交
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param vertexs
		 * @return 
		 * 
		 */		
		public static function isRectCrossVertexs(x:int, y:int, width:int, height:int, vertexs:Vector.<Vector2f>):Boolean
		{
			var len:int = vertexs.length;
			if(len == 2) // 线段与Rect相交
			{
				len = 1;
			}
			for(var i:int = 0; i < len; i++)
			{
				v1 = vertexs[i];
				if(i == vertexs.length - 1)
				{
					v2 = vertexs[0];
				}
				else
				{
					v2 = vertexs[i+1];
				}
				
				v3.x = x;
				v3.y = y;
				v4.x = x + width;
				v4.y = y;
				if(GeomUtil.isLimitLineCross(v1, v2, v3, v4))
				{
					return true;
				}
				
				
				v3.x = x + width;
				v3.y = y + height;
				v4.x = x + width;
				v4.y = y;
				if(GeomUtil.isLimitLineCross(v1, v2, v3, v4))
				{
					return true;
				}
				
				v3.x = x + width;
				v3.y = y + height;
				v4.x = x;
				v4.y = y + height;
				if(GeomUtil.isLimitLineCross(v1, v2, v3, v4))
				{
					return true;
				}
				
				v3.x = x;
				v3.y = y;
				v4.x = x;
				v4.y = y + height;
				if(GeomUtil.isLimitLineCross(v1, v2, v3, v4))
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * p点到线段AB的所有连线的最短距离 
		 * @param A
		 * @param B
		 * @param p
		 * 
		 */		
		public static function calcNearestPointDistance(A:Point, B:Point, p:Point):Number
		{
			var a:Number = calcDistance(B.x, B.y, p.x, p.y);
			var b:Number = calcDistance(A.x, A.y, p.x, p.y);
			var c:Number = calcDistance(A.x, A.y, B.x, B.y);
			
			if(a*b < 0.00001)
			{
				return 0;
			}
			
			if(a*a > b*b+c*c)
			{
				return b;
			}
			if(b*b > a*a + c*c)
			{
				return a;
			}
			
			var l:Number = (a+b+c)*0.5;     //周长的一半   
			var s:Number =Math.sqrt(l*(l-a)*(l-b)*(l-c));  //海伦公式求面积   , 或者用向量叉乘求面积
			return 2*s/c;  
		}
		
		/**
		 * 计算两点的距离 
		 * @param x1
		 * @param y1
		 * @param x2
		 * @param y2
		 * @return 
		 * 
		 */		
		public static function calcDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			x1 -= x2;
			y1 -= y2;
			return Math.sqrt(x1*x1 + y1*y1);
		}
		
		public static function calcDistance2(v1:Vector2f, v2:Vector2f):Number
		{
			t1._x = v1._x - v2._x;
			t1._y = v1._y - v2._y;
			return Math.sqrt(t1._x*t1._x + t1._y*t1._y);
		}
		
		/**
		 * 计算线段经过的格子 (0,0)代表第一个格子的中心点
		 * @param sx
		 * @param sy
		 * @param ex
		 * @param ey
		 * @param grideWidth
		 * @param grideHeiht
		 * @param isNeedLast
		 * @return 所有经过的格子数组
		 * 
		 */		
		public static function calcGridesPassLine(sx:Number, sy:Number, ex:Number, ey:Number, grideWidth:Number=1, grideHeiht:Number=1,isNeedLast:Boolean=false):Array
		{
			var res:Array = [];
			var gsx:int = Math.floor(sx/grideWidth);
			var gsy:int = Math.floor(sy/grideHeiht);
			var gex:int = Math.ceil(ex/grideWidth);
			var gey:int = Math.ceil(ey/grideHeiht);
			var dx:Number = ex - sx;
			var dy:Number = ey - sy;
			var ddx:int = dx>0?1:-1;
			var ddy:int = dy>0?1:-1;
			var v:Vector.<Vector2f> = new Vector.<Vector2f>();
			v.push(new Vector2f(sx + 0.5*grideWidth, sy + 0.5*grideHeiht), new Vector2f(ex+0.5*grideWidth, ey+0.5*grideHeiht));
			
			for(var j:int = gsy; j != gey+ddy; j += ddy)
			{
				for(var k:int = gsx; k != gex+ddx; k += ddx)
				{
					if(j == gey && k == gex && isNeedLast)
					{
						res.push(new Point(k*grideWidth, j*grideHeiht));
						break;
					}
					// ( k, j)
					if(GeomUtil.isRectCrossVertexs(k, j, 1, 1, v))
					{
						res.push(new Point(k*grideWidth, j*grideHeiht));
					}
				}
			}
			return res;
		}
		
		public static function calcLinePassGridesFastLeftTop(sx:int, sy:int, ex:int, ey:int):Vector.<int>
		{
			var dx:int = ex - sx;
			var dy:int = (ey - sy);
			var res:Vector.<int> = new Vector.<int>();
			res.push(sx, sy);
			var k:Number = dy/dx;
			var ddy:int = Math.abs(dy);
			var ddx:int = Math.abs(dx);
			var xx:int = dx/ddx;
			var yy:int = dy/ddy;
			var gcm:int = getGCM(ddy, ddx);
			dy /= gcm;
			dx /= gcm;
			var x:int;
			var y:int;
			var tmp:Number;
			var testIndex:int;
			var arr:Array = [];
			
			if(ddx > ddy)
			{
				// 计算Y整数值对应的x值
				for(y = sy + yy; y != ey; y += yy)
				{
					tmp = (y - sy)/k + sx;
					arr.push(tmp);
				}
				testIndex = 0;
				y = sy;
				if(yy < 0)
				{
					y = sy + yy;
				}
				// x递增
				for(x = sx; x != ex + xx; x += xx)
				{
					res.push(x, y);
					tmp = arr[testIndex];
					//					if(arr[testIndex] >= x && arr[testIndex] < (x+1))
					if(Math.abs(x - tmp) < 0.5 || tmp + xx*0.5 == x ) // tmp介于x 与 x+xx之间
					{
						y += yy;
						testIndex++;
						res.push(x, y);
					}
				}
			}
			else if(ddx == ddy)
			{
				for(x = 1; x < ddx; x++)
				{
					res.push(sx + xx*x, sy + yy*x);
				}
			}
			else
			{
				// 计算X整数值对应的y值
				for(x = sx + xx; x != ex; x += xx)
				{
					//y = k*(x - x1) + y1;  
					tmp = k*(x - sx) + sy;
					arr.push(tmp);
				}
				testIndex = 0;
				x = sx;
				if(xx < 0)
				{
					x = sx + xx;
				}
				// x递增
				for(y = sy ; y != ey + yy; y += yy)
				{
					res.push(x, y);
					//					if(arr[testIndex] >= y && arr[testIndex] < (y+1))
					
					tmp = arr[testIndex];
					if(Math.abs(y - tmp) < 0.5 || tmp + yy*0.5 == y ) // tmp介于x 与 x+xx之间
					{
						x += xx;
						testIndex++;
						res.push(x, y);
					}
				}
			}
			res.push(ex, ey);
			return res;
		}
		
		/**
		 * 	计算直线经过的格子， 格子单位为1, 1000w次使用时间为10ms， 也就是说calcLinePassGridesFast(0, 0, 10000, 1000)使用时间为10ms
		 * y = k*(x - x1) + y1;  
		 * x = (y-y1)/k + x1
		 * @param sx
		 * @param sy
		 * @param ex
		 * @param ey
		 * @return 
		 * 
		 */
		
		public static function calcLinePassGridesFastMidle(sx:int, sy:int, ex:int, ey:int):Vector.<int>
		{
			var res:Vector.<int> = new Vector.<int>();
			res.push(sx, sy);
			
			//			sx += 0.5;
			//			sy += 0.5;
			//			ex += 0.5;
			//			ey += 0.5;
			var dx:int = ex - sx;
			var dy:int = (ey - sy);
			
			var k:Number = dy/dx;
			var ddy:Number = Math.abs(dy);
			var ddx:Number = Math.abs(dx);
			var xx:int = dx/ddx;
			var yy:int = dy/ddy;
			var x05:Number = xx*0.5;
			var y05:Number = yy*0.5;
			var x:Number;
			var y:Number;
			var tmp:Number;
			var testIndex:int;
			var arr:Array = [];
			var endTest:Number;
			
			if(ddx > ddy)
			{
				// 计算Y整数 + 0.5*yy值对应的x值
				endTest = ey + y05;
				for(y = sy + y05; y != endTest; y += yy)
				{
					tmp = (y - sy)/k + sx;
					arr.push(tmp);
				}
				testIndex = 0;
				y = sy;
				// x递增
				tmp = arr[testIndex];
				for(x = sx + xx; x != ex; x += xx)
				{
					res.push(x, y);
					
					if(Math.abs(x - tmp) < 0.5 || tmp + x05 == x ) // tmp介于x 与 x+xx之间
					{
						y += yy;
						testIndex++;
						tmp = arr[testIndex];
						res.push(x, y);
					}
				}
			}
			else if(ddx == ddy)
			{
				for(x = 1; x < ddx; x++)
				{
					res.push(sx + xx*x, sy + yy*x);
				}
			}
			else
			{
				// 计算Y整数 + 0.5*yy值对应的x值
				endTest = ex + x05;
				for(x = sx + x05; x != endTest; x += xx)
				{
					tmp = (x - sx)*k + sy;
					arr.push(tmp);
				}
				testIndex = 0;
				x = sx;
				// x递增
				tmp = arr[testIndex];
				for(y = sy + yy; y != ey; y += yy)
				{
					res.push(x, y);
					
					if(Math.abs(y - tmp) < 0.5 || tmp + y05 == y ) // tmp介于x 与 x+xx之间
					{
						x += xx;
						testIndex++;
						tmp = arr[testIndex];
						res.push(x, y);
					}
				}
			}
			res.push(ex, ey);
			
			return res;
		}
		
		/**
		 * 求a、b的最大公约数 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		public static function getGCM(a:int, b:int):int
		{
			if(a<b)// 交换ab的值
			{
				a += b;
				b = a - b;
				a -= b;
			}
			var tmp:int;
			while(b != 0)
			{
				tmp = a%b;
				a = b;
				b = tmp;
			}
			return a;
		}
		
		/**
		 * 提供2点， 求从开始点距离为distance的点
		 * @param sx
		 * @param sy
		 * @param ex
		 * @param ey
		 * @param distance
		 * @param isMaxEnd 假如distance大于两点之间的距离，那么返回传入的结束点的坐标
		 * @return 
		 * 
		 */		
		public static function getPointByDistance(sx:Number, sy:Number, ex:Number, ey:Number, distance:Number, isMaxEnd:Boolean=true):Point
		{
			var res:Point = new Point();
			var dis:Number = calcDistance(sx, sy, ex, ey);
			if(dis <= distance && isMaxEnd)
			{
				res.x = ex;
				res.y = ey;
			}
			else
			{
				var rate:Number = distance / dis;
				res.x = sx + rate*(ex - sx);
				res.y = sy + rate*(ey - sy);
			}
			return res;
		}
	}
}