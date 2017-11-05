package frEngine.shape3d
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class BezierLine
	{ 
		public var isStart:Boolean=false;
		public var  startTime:Number = 0.0;
		public var  disTime:Number = 0.0;
		//曲线总长度  
		public var  total_length:Number = 0.0;  
		
		//在总长度范围内，使用simpson算法的分割数  
		private static const TOTAL_SIMPSON_STEP :int  =  100 
			
		//曲线分割的份数  
		private const STEP:int = 70;  
		
		public var P0:Object;//开始点
		public var P1:Object;//开始控制点
		public var P2:Object;//结束点
		public var P3:Object;//结束控制点
		
		public var startRM:Matrix3D;
		public var endRm:Matrix3D;
		
		public function BezierLine($p0:Object,$p1:Object,$p2:Object,$p3:Object,$len:int)
		{ 
			P0=$p0;
			P1=$p1;
			P2=$p2;
			P3=$p3;
			total_length=$len;//beze_length(1)
			
		}
		
		//x,y,z坐标方程  ,t为0到1之间
		public function beze(t:Number,result:Vector3D):Vector3D  
		{  
			
			var  it:Number = 1-t;  
			var a0:Number=it*it*it;
			var a1:Number=3*it*it*t;
			var a2:Number=3*it*t*t;
			var a3:Number=t*t*t;
			
			result.x=a0*P0.x + a1*P1.x + a2*P2.x + a3*P3.x;  
			result.y=a0*P0.y + a1*P1.y + a2*P2.y + a3*P3.y; 
			result.z=a0*P0.z + a1*P1.z + a2*P2.z + a3*P3.z; 
			
			return result;
			
		} 

		//速度方程  t为0到1之间
		
		public function beze_speed(t:Number ) :Number  
		
		{  
			var it:Number = 1-t; 
			
			var a1:Number=-3*it*it;

			var a3:Number=-6*it*t;

			var a5:Number=-3*t*t;

			var sx:Number  = a1*(P0.x-P1.x)+a3*(P1.x-P2.x)+a5*(P2.x-P3.x);
			
			var sy:Number  = a1*(P0.y-P1.y)+a3*(P1.y-P2.y)+a5*(P2.y-P3.y);
			
			var sz:Number  = a1*(P0.z-P1.z)+a3*(P1.z-P2.z)+a5*(P2.z-P3.z);

			return Math.sqrt(sx*sx+sy*sy+sz*sz);  
			
		} 
		
		//长度方程,使用Simpson积分算法 t为0到1之间
		public function beze_length(t :Number  )  :Number   
		{  
			//分割份数  
			
			var stepCounts:int = int(TOTAL_SIMPSON_STEP*t);  
			
			if(stepCounts & 1) stepCounts++;    //偶数  
			
			if(stepCounts==0) return 0.0;  

			var  halfCounts:int = stepCounts/2;  
			
			var sum1:Number=0.0, sum2:Number=0.0;  
			
			var dStep:Number = t/stepCounts;  

			for(var  i:int=0; i<halfCounts; i++)  	
			{  
				
				sum1 += beze_speed((2*i+1)*dStep);  
				
			}  
			
			for(i=1; i<halfCounts; i++)  
			{  
				
				sum2 += beze_speed((2*i)*dStep);  
				
			}  
			
			
			
			return (beze_speed(0.0)+beze_speed(1.0)+2*sum2+4*sum1)*dStep/3.0;  
			
		} 
		
		//根据t推导出匀速运动自变量t'的方程(使用牛顿切线法)  
		
		public function beze_even(t:Number) :Number
		{  
			
			var len:Number = t*total_length; //如果按照匀速增长,此时对应的曲线长度  
			
			var t1:Number=t, t2:Number;  
			
			var num:int=0;
			do  
			{  
				t2 = t1 - (beze_length(t1)-len)/beze_speed(t1);  
				
				if(Math.abs(t1-t2)<0.001 || num>100) break;  
				
				num++;
				
				t1=t2;  
				
			}while(true);  
			
			return t2;  
		}  
	}
}
