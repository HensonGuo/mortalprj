package frEngine.math
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Matrix3DUtils;

	public class FrMathUtil
	{
		
		private static const sqrt3:Number=Math.sqrt(3);
		/**
		 * 
		 * cp 在此是四个元素的数组: 
		   cp[0] 为起点
		   cp[1] 为第一控制点 
		   cp[2] 为结束点
		   cp[3] 为第二控制点
		   t 为参数值，0 <= t <= 1 
		 * 
		 */		
		public static function bezier3_fun3(start:Vector3D,startControler:Vector3D,end:Vector3D,endControler:Vector3D, t:Number,resultPoint:Vector3D):void
		{
			var p0:Vector3D=start;
			var p1:Vector3D=startControler;
			var p2:Vector3D=endControler;
			var p3:Vector3D=end;
			
			var p4:Vector3D=p1.subtract(p0);
			p4.scaleBy(3);
			
			p2=p2.subtract(p1);
			p2.scaleBy(3)
			p2=p2.subtract(p4);
			
			p3=p3.subtract(p0).subtract(p4).subtract(p2);
			
			p1=new Vector3D(t,t*t,t*t*t);
			
			p3.scaleBy(p1.z);
			p2.scaleBy(p1.y);
			p4.scaleBy(p1.x);
			
			p1=p3.add(p2).add(p4).add(p0);

			resultPoint.x=p1.x;
			resultPoint.y=p1.y;
			resultPoint.z=p1.z;
			
			/*
			var  ax:Number, bx:Number, cx:Number, ay:Number, by:Number, cy:Number, az:Number, bz:Number, cz:Number; 
			var  tSquared:Number, tCubed:Number; 
			cx = 3.0 * (p1.x - p0.x); 
			bx = 3.0 * (p2.x - p1.x) - cx; 
			ax = p3.x - p0.x - cx - bx; 
			
			cy = 3.0 * (p1.y - p0.y); 
			by = 3.0 * (p2.y - p1.y) - cy; 
			ay = p3.y - p0.y - cy - by; 
			
			cz = 3.0 * (p1.z - p0.z); 
			bz = 3.0 * (p2.z - p1.z) - cz; 
			az = p3.z - p0.z - cz - bz; 

			tSquared = t * t; 
			tCubed = tSquared * t; 
			resultPoint.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + p0.x; 
			resultPoint.y = (ay * tCubed) + (by * tSquared) + (cy * t) + p0.y; 
			resultPoint.z = (az * tCubed) + (bz * tSquared) + (cz * t) + p0.z; */
			

		}
		
		/**
		 *用二分法快速查找目标所在数组中的索引 
		 * @param targetList
		 * @param targetValue
		 * @return 
		 * 
		 */		
		public static function fastGetInsertPos(targetList:Array,targetValue:Object):int
		{
			var _end:int = targetList.length;
			var _start:int=0;
			var _cur:int=-1;
			while (_start < _end)
			{
				_cur = ((_start + _end) >>> 1);
				if (targetList[_cur] == targetValue)
				{
					break;
				}
				if ((targetValue > targetList[_cur]))
				{
					_start = ++_cur;
				}
				else
				{
					_end = _cur;
				}
				
			}
			return _cur;
		}
		public static function fastGetInsertPos2(targetList:Array,targetValue:Number,property:String):int
		{
			var _end:int = targetList.length;
			var _start:int=0;
			var _cur:int=-1;
			while (_start < _end)
			{
				_cur = ((_start + _end) >>> 1);
				var _curValue:Number=targetList[_cur][property];
				if (_curValue == targetValue)
				{
					break;
				}
				if ((targetValue > _curValue))
				{
					_start = ++_cur;
				}
				else
				{
					_end = _cur;
				}
				
			}
			return _cur;
		}
		public static function pointOnCubicBezier2(start:Vector3D,mid:Vector3D,end:Vector3D, t:Number,resultPoint:Vector3D):void
		{
			var t2:Number=t*t;
			var n:Number=1-t;
			var n2:Number=n*n;
			var tn:Number=2*t*n;
			//var p1:Vector3D=start.x*n2+mid.x*tn+end.x*t2//_start.add(_mid).add(_end);
			resultPoint.x=start.x*n2+mid.x*tn+end.x*t2
			resultPoint.y=start.y*n2+mid.y*tn+end.y*t2
			resultPoint.z=start.z*n2+mid.z*tn+end.z*t2
			
		}
		public static function bezier3_fun2(start:Vector3D,startControler:Vector3D,end:Vector3D,endControler:Vector3D, t:Number,resultPoint:Vector3D):void
		{
			var p0:Vector3D=start.clone();
			var p1:Vector3D=startControler.clone();
			var p2:Vector3D=endControler.clone();
			var p3:Vector3D=end.clone();
			
			
			var t2:Number=1-t;
			var time1:Vector3D=new Vector3D(t,t*t,t*t*t);
			var time2:Vector3D=new Vector3D(t2,t2*t2,t2*t2*t2);
			
			p0.scaleBy(time2.z);
			p1.scaleBy(3*time1.x*time2.y);
			p2.scaleBy(3*time1.y*time2.x);
			p3.scaleBy(time1.z);
			
			p1=p0.add(p1).add(p2).add(p3);
			
			resultPoint.x=p1.x;
			resultPoint.y=p1.y;
			resultPoint.z=p1.z;
			
		}
		public static function bezier3_fun(start:Vector3D,scx:Number,scy:Number,scz:Number,end:Vector3D,ecx:Number,ecy:Number,ecz:Number,t:Number,resultPoint:Vector3D):void
		{
			var p0:Vector3D=start;
			var p3:Vector3D=end;
			
			var t2:Number=t*t;
			var t3:Number=t2*t;
			var n:Number=1-t;
			var n2:Number=n*n;
			var n3:Number=n2*n;
			
			var t0n2:Number=3*t*n2;
			var t2n0:Number=3*t2*n;

			resultPoint.x=p0.x*n3+scx*t0n2+ecx*t2n0+p3.x*t3;
			resultPoint.y=p0.y*n3+scy*t0n2+ecy*t2n0+p3.y*t3;
			resultPoint.z=p0.z*n3+scz*t0n2+ecz*t2n0+p3.z*t3;
			
		}
		public static function lineAndPlaneCrossPoint(lineP1:Vector3D,lineP2:Vector3D,planePoint:Vector3D,planeNomal:Vector3D):Vector3D
		{
			var lineA:Number=lineP1.x-lineP2.x;
			var lineB:Number=lineP1.y-lineP2.y;
			var lineC:Number=lineP1.z-lineP2.z;
			var subp:Vector3D=planePoint.subtract(lineP1);
			var num1:Number=lineA*planeNomal.x+lineB*planeNomal.y+lineC*planeNomal.z;
			var num2:Number=subp.x*planeNomal.x+subp.y*planeNomal.y+subp.z*planeNomal.z;
			var t:Number=num2/num1;
			var resutlPoint:Vector3D=new Vector3D(t*lineA+lineP1.x,t*lineB+lineP1.y,t*lineC+lineP1.z);
			return resutlPoint;
		}
		public static function pointToLineDistance1(point:Vector3D,lineP1:Vector3D,lineP2:Vector3D):Number
		{
			var lineNormal:Vector3D=lineP1.subtract(lineP2);
			var p2:Vector3D=lineP1.subtract(point);
			var p3:Vector3D=lineNormal.crossProduct(p2);
			var p4:Vector3D=lineNormal.crossProduct(p3);
			p4.normalize();
			return p2.dotProduct(p4);
		}
		public static function pointToLineDistance2(point:Vector3D,linePoint:Vector3D,lineNormal:Vector3D):Number
		{ 
			var p2:Vector3D=linePoint.subtract(point);
			var p3:Vector3D=lineNormal.crossProduct(p2);
			var p4:Vector3D=lineNormal.crossProduct(p3);
			p4.normalize();
			return p2.dotProduct(p4);
		}
		// 返回点p以点o为圆心逆时针旋转alpha(单位：弧度)后所在的位置
		public static function rotate(o:Point,alpha_ten:Number,p:Point):Point
		{
			var alpha:Number=Math.PI/180*alpha_ten;
			var tp:Point=new Point();
			var xx:Number=p.x-o.x;
			var yy:Number=p.y-o.y;
			
			tp.x=xx*Math.cos(alpha) - yy*Math.sin(alpha)+o.x;
			tp.y=yy*Math.cos(alpha) + xx*Math.sin(alpha)+o.y;
			return tp;
		}
		
		/**
		 *求出两直线的中垂线的交点 
		 * @param line1_normal
		 * @param line1_p1
		 * @param line2_normal
		 * @param line2_p1
		 * @param result
		 * 
		 */		
		public static function getTwoLineCrossPoints(line1_normal:Vector3D,line1_p1:Vector3D,line2_normal:Vector3D,line2_p1:Vector3D,result:CrossLineInfo):void
		{
			var value:Number=line1_normal.dotProduct(line2_normal);
			if(value>0.99 || value<-0.99)
			{
				result.crossPoint1.x=line1_p1.x;
				result.crossPoint1.y=line1_p1.y;
				result.crossPoint1.z=line1_p1.z;
				
				result.crossPoint2.x=line2_p1.x;
				result.crossPoint2.y=line2_p1.y;
				result.crossPoint2.z=line2_p1.z;
				
				return;
			}
			var xba:Number=line1_normal.x;
			var yba:Number=line1_normal.y;
			var zba:Number=line1_normal.z;
			
			var xdc:Number=line2_normal.x
			var ydc:Number=line2_normal.y
			var zdc:Number=line2_normal.z
			
			var disX:Number=line2_p1.x-line1_p1.x;
			var disY:Number=line2_p1.y-line1_p1.y;
			var disZ:Number=line2_p1.z-line1_p1.z;
			
			var F1_ab:Number=xba*xba+yba*yba+zba*zba;
			
			var F1_cd:Number= xdc*xdc+ydc*ydc+zdc*zdc;
			
			var F2:Number=xba*xdc+yba*ydc+zba*zdc;
			
			var F3_ab:Number=xba*disX+yba*disY+zba*disZ;
			
			var F3_cd:Number=xdc*disX+ydc*disY+zdc*disZ;
			
			var t1:Number=(F3_ab*F1_cd-F3_cd*F2)/(F1_ab*F1_cd-F2*F2);
			var t2:Number=(F3_cd*F1_ab-F2*F3_ab)/(F2*F2-F1_ab*F1_cd);

			result.crossPoint1.x=t1*xba+line1_p1.x;
			result.crossPoint1.y=t1*yba+line1_p1.y;
			result.crossPoint1.z=t1*zba+line1_p1.z;
			
			result.crossPoint2.x=t2*xdc+line2_p1.x;
			result.crossPoint2.y=t2*ydc+line2_p1.y;
			result.crossPoint2.z=t2*zdc+line2_p1.z;

		}
		public static function getVector3dByRate(v1:Vector3D,v2:Vector3D,rate:Number,result:Vector3D=null):Vector3D
		{
			result==null && (result=new Vector3D());
			result.x=v1.x+(v2.x-v1.x)*rate;
			result.y=v1.y+(v2.y-v1.y)*rate;
			result.z=v1.z+(v2.z-v1.z)*rate;
			return result;
		}
		
		/**
		 * 
		 * @param px 第一个点
		 * @param qx 第二个点
		 * @param fx 第一个点的控制点
		 * @param sx 第二个点的控制点
		 * @return 
		 * 
		 */		
		public static function getBezierData(px:Number,qx:Number,fx:Number,sx:Number,resultVecor:Vector3D):Vector3D
		{
			resultVecor.w=	 px;
			resultVecor.z=	-3*px	+ 3*fx
			resultVecor.y=	 3*px	- 6*fx	+3*sx;
			resultVecor.x=	-px		+ 3*fx	-3*sx	+ qx;
			return resultVecor;
		}
		
		public static function getBezierTimeAndValue(frameValue:uint,constX:Vector3D,constY:Vector3D):Number
		{
			var ax:Number=constX.x;
			var bx:Number=constX.y;
			var cx:Number=constX.z;
			var dx:Number=constX.w;
			
			var ax3:Number=3*ax;
			var value1:Number
			var value2:Number
			var powNum:Number=1/3;
			var dx2:Number=dx-frameValue;
			var A:Number=bx*bx-ax3*cx;
			var B:Number=bx*cx-9*ax*dx2;
			var C:Number=cx*cx-3*bx*dx2;
			var E:Number=B*B-4*A*C
			var t:Number;
			if(E>=0)
			{
				value1=int(A*bx-1.5*ax*B)
				value2=int(1.5*ax*Math.sqrt(E));
				var Y1:Number=value1+value2;
				var Y2:Number=value1-value2;
				
				if(Y1<0)
				{
					Y1=-Math.pow(-Y1,powNum);
				}else
				{
					Y1=Math.pow(Y1,powNum);
				}
				
				if(Y2<0)
				{
					Y2=-Math.pow(-Y2,powNum);
				}else
				{
					Y2=Math.pow(Y2,powNum);
				}
				
				t=(-bx-Y1-Y2 )/(ax3);
				
			}else
			{
				var T:Number=(2*A*bx-ax3*B)/(2*Math.pow(A,1.5));
				var angleT:Number=Math.acos(T)/3;
				var sqrtA:Number=Math.sqrt(A);
				var cosT:Number=Math.cos(angleT);
				var n1:Number=(-bx-2*sqrtA*cosT)/ax3;
				n1=int(n1*1000)/1000;
				
				if(n1>=0 && n1<=1)
				{
					t=n1;
				}else
				{
					var sinT:Number=Math.sin(angleT);
					value1=-bx+sqrtA*cosT;
					value2=sqrtA*sinT*sqrt3;
					var n2:Number=(value1+value2)/ax3;
					var n3:Number=(value1-value2)/ax3;
					n2=int(n2*1000)/1000;
					n3=int(n3*1000)/1000;
					if(n2>=0 && n2<=1)
					{
						t=n2;
					}else if(n3>=0 && n3<=1)
					{
						t=n3;
					}else
					{
						trace("erorr:",n1,n2,n3);
					}
					
				}
			}
			if(constY)
			{
				var t2:Number = t * t;
				var t3:Number = t2 * t;
				return (constY.x * t3 + constY.y * t2 + constY.z * t + constY.w);
			}else
			{
				return t;
			}
			
		}
		public static function pointPlane(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D):Number
		{
			return (-((_arg1.dotProduct(_arg3) - _arg1.dotProduct(_arg2))));
		}
		public static function mousePlane(_arg1:Number, _arg2:Number, _arg3:Vector3D, _arg4:Vector3D):Vector3D
		{
			var _local5:Vector3D = new Vector3D();
			var _local6:Vector3D = new Vector3D();
			var _local7:Vector3D = new Vector3D();
			Device3D.scene.camera.getPosition(false, _local5);
			Device3D.scene.camera.getPointDir(_arg1, _arg2, _local6);
			rayPlane(_arg4, _arg3, _local5, _local6, _local7);
			return (_local7);
		}
		public static function rayPlane(_arg1:Vector3D, _arg2:Vector3D, _arg3:Vector3D, _arg4:Vector3D, _arg5:Vector3D=null):Number
		{
			var _local6:Number = (-((_arg1.dotProduct(_arg3) - _arg1.dotProduct(_arg2))) / _arg1.dotProduct(_arg4));
			if (_arg5)
			{
				_arg5.x = (_arg3.x + (_arg4.x * _local6));
				_arg5.y = (_arg3.y + (_arg4.y * _local6));
				_arg5.z = (_arg3.z + (_arg4.z * _local6));
			};
			return (_local6);
		}
		public static function project2DPoint(_arg1:Vector3D, _arg2:Vector3D=null):Vector3D
		{
			if (_arg2 == null)
			{
				_arg2 = new Vector3D();
			};
			_arg2.w = 1;
			var _local3:Scene3D = Device3D.scene;
			if (!_local3.viewPort)
			{
				return (_arg2);
			};
			Matrix3DUtils.transformVector(_local3.camera.view, _arg1, _arg2);
			var _local4:Number = ((_local3.viewPort.width / Device3D.camera.zoom) / _arg2.z);
			_arg2.x = (((_arg2.x * _local4) + (_local3.viewPort.width * 0.5)) + _local3.viewPort.x);
			_arg2.y = (((-(_arg2.y) * _local4) + (_local3.viewPort.height * 0.5)) + _local3.viewPort.y);
			_arg2.z = 0;
			_arg2.w = _local4;
			return (_arg2);
		}
	}
}