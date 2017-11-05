// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//_Pan3D.core.Quaternion

package frEngine.math
{
    import flash.geom.Matrix3D;
    import flash.geom.Orientation3D;
    import flash.geom.Vector3D;
    
    public final class Quaternion 
    {

		public static const IDENTITY:Quaternion=new Quaternion();
        public var x:Number = 0;
        public var y:Number = 0;
        public var z:Number = 0;
        public var w:Number = 1;

        public function Quaternion(x:Number=0, y:Number=0, z:Number=0, w:Number=1)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
		public function inverse ():Quaternion
		{
			var  fNorm:Number = w*w+x*x+y*y+z*z;
			if ( fNorm > 0 )
			{
				var  fInvNorm:Number = 1/fNorm;
				return new Quaternion(-x*fInvNorm,-y*fInvNorm,-z*fInvNorm,w*fInvNorm);
			}else
			{
				return new Quaternion();
			}
			
		}
        public function get magnitude():Number
        {
            return (Math.sqrt(((((this.w * this.w) + (this.x * this.x)) + (this.y * this.y)) + (this.z * this.z))));
        }
        public function multiply(qa:Quaternion, qb:Quaternion):void
        {
            var w1:Number = qa.w;
            var x1:Number = qa.x;
            var y1:Number = qa.y;
            var z1:Number = qa.z;
            var w2:Number = qb.w;
            var x2:Number = qb.x;
            var y2:Number = qb.y;
            var z2:Number = qb.z;
            this.w = ((((w1 * w2) - (x1 * x2)) - (y1 * y2)) - (z1 * z2));
            this.x = ((((w1 * x2) + (x1 * w2)) + (y1 * z2)) - (z1 * y2));
            this.y = ((((w1 * y2) - (x1 * z2)) + (y1 * w2)) + (z1 * x2));
            this.z = ((((w1 * z2) + (x1 * y2)) - (y1 * x2)) + (z1 * w2));
        }
        public function multiplyVector(vector:Vector3D, target:Quaternion=null):Quaternion
        {
            target = ((target) || (new Quaternion()));
            var x2:Number = vector.x;
            var y2:Number = vector.y;
            var z2:Number = vector.z;
            target.w = (((-(this.x) * x2) - (this.y * y2)) - (this.z * z2));
            target.x = (((this.w * x2) + (this.y * z2)) - (this.z * y2));
            target.y = (((this.w * y2) - (this.x * z2)) + (this.z * x2));
            target.z = (((this.w * z2) + (this.x * y2)) - (this.y * x2));
            return (target);
        }
		
		
		/**
		 * ogre中旋转向量的方法
		 */
		public function multiplyVector2(v:Vector3D):Vector3D
		{
			// nVidia SDK implementation
			var  uv:Vector3D, uuv:Vector3D;
			var  qvec:Vector3D=new Vector3D(x, y, z);
			uv = qvec.crossProduct(v);
			uuv = qvec.crossProduct(uv);
			uv.scaleBy(2 * w);
			uuv.scaleBy(2);
			v=v.add(uv);
			v=v.add(uuv);
			return v;
			
		}
		
		/**
		 * (使用之前axis先normalize)定义四元素的旋转轴， 旋转角度 
		 * @param axis 绕着轴axis旋转(使用之前axis先normalize)
		 * @param angle 旋转角度为angle， 单位为弧度
		 * 
		 */		
        public function fromAxisAngle(axis:Vector3D, angle:Number):void
        {
            var sin_a:Number = Math.sin((angle / 2));
            var cos_a:Number = Math.cos((angle / 2));
            this.x = (axis.x * sin_a);
            this.y = (axis.y * sin_a);
            this.z = (axis.z * sin_a);
            this.w = cos_a;
            this.normalize();
        }
		
		public function toAxisAngle(axis:Vector3D=null):Vector3D
		{
			if(!axis)
			{
				axis=new Vector3D();
			}
			this.normalize();
			axis.w=Math.acos(this.w);
			var sin_a:Number = Math.sin(axis.w);
			axis.x=this.x/sin_a;
			axis.y=this.y/sin_a;
			axis.z=this.z/sin_a;
			return axis;
		}
        public function slerp(qa:Quaternion, qb:Quaternion, t:Number):void
        {
            var angle:Number;
            var s:Number;
            var s1:Number;
            var s2:Number;
            var len:Number;
            var w1:Number = qa.w;
            var x1:Number = qa.x;
            var y1:Number = qa.y;
            var z1:Number = qa.z;
            var w2:Number = qb.w;
            var x2:Number = qb.x;
            var y2:Number = qb.y;
            var z2:Number = qb.z;
            var dot:Number = ((((w1 * w2) + (x1 * x2)) + (y1 * y2)) + (z1 * z2));
            if (dot < 0)
            {
                dot = -(dot);
                w2 = -(w2);
                x2 = -(x2);
                y2 = -(y2);
                z2 = -(z2);
            };
            if (dot < 0.95)
            {
                angle = Math.acos(dot);
                s = (1 / Math.sin(angle));
                s1 = (Math.sin((angle * (1 - t))) * s);
                s2 = (Math.sin((angle * t)) * s);
                this.w = ((w1 * s1) + (w2 * s2));
                this.x = ((x1 * s1) + (x2 * s2));
                this.y = ((y1 * s1) + (y2 * s2));
                this.z = ((z1 * s1) + (z2 * s2));
            }
            else
            {
                this.w = (w1 + (t * (w2 - w1)));
                this.x = (x1 + (t * (x2 - x1)));
                this.y = (y1 + (t * (y2 - y1)));
                this.z = (z1 + (t * (z2 - z1)));
                len = (1 / Math.sqrt(((((this.w * this.w) + (this.x * this.x)) + (this.y * this.y)) + (this.z * this.z))));
                this.w = (this.w * len);
                this.x = (this.x * len);
                this.y = (this.y * len);
                this.z = (this.z * len);
            };
        }
        public function lerp(qa:Quaternion, qb:Quaternion, t:Number):void
        {
            var len:Number;
            var w1:Number = qa.w;
            var x1:Number = qa.x;
            var y1:Number = qa.y;
            var z1:Number = qa.z;
            var w2:Number = qb.w;
            var x2:Number = qb.x;
            var y2:Number = qb.y;
            var z2:Number = qb.z;
            if (((((w1 * w2) + (x1 * x2)) + (y1 * y2)) + (z1 * z2)) < 0)
            {
                w2 = -(w2);
                x2 = -(x2);
                y2 = -(y2);
                z2 = -(z2);
            };
            this.w = (w1 + (t * (w2 - w1)));
            this.x = (x1 + (t * (x2 - x1)));
            this.y = (y1 + (t * (y2 - y1)));
            this.z = (z1 + (t * (z2 - z1)));
			/*len = 1.0/Math.sqrt(w*w + x*x + y*y + z*z);
			w *= len;
			x *= len;
			y *= len;
			z *= len;*/
        }
		public static function slerp(fT:Number, rkP:Quaternion,	rkQ:Quaternion, shortestPath:Boolean):Quaternion
		{
			var result:Quaternion=new Quaternion();
			if(shortestPath)
			{
				result.slerp(rkP,rkQ,fT);
			}
			return result;
		}
		public static function lerp(fT:Number, rkP:Quaternion,	rkQ:Quaternion, shortestPath:Boolean,target:Quaternion=null):Quaternion
		{
			if(!target)
			{
				target=new Quaternion();
			}
			
			if(shortestPath)
			{
				target.lerp(rkP,rkQ,fT);
			}
			return target;
		}
        public function fromEulerAngles(ax:Number, ay:Number, az:Number):void
        {
            var fSinPitch:Number = Math.sin((ax * 0.5));
            var fCosPitch:Number = Math.cos((ax * 0.5));
            var fSinYaw:Number = Math.sin((ay * 0.5));
            var fCosYaw:Number = Math.cos((ay * 0.5));
            var fSinRoll:Number = Math.sin((az * 0.5));
            var fCosRoll:Number = Math.cos((az * 0.5));
            var fCosPitchCosYaw:Number = (fCosPitch * fCosYaw);
            var fSinPitchSinYaw:Number = (fSinPitch * fSinYaw);
            this.x = ((fSinRoll * fCosPitchCosYaw) - (fCosRoll * fSinPitchSinYaw));
            this.y = (((fCosRoll * fSinPitch) * fCosYaw) + ((fSinRoll * fCosPitch) * fSinYaw));
            this.z = (((fCosRoll * fCosPitch) * fSinYaw) - ((fSinRoll * fSinPitch) * fCosYaw));
            this.w = ((fCosRoll * fCosPitchCosYaw) + (fSinRoll * fSinPitchSinYaw));
        }
        public function toEulerAngles(target:Vector3D=null):Vector3D
        {
            target = ((target) || (new Vector3D()));
            target.x = Math.atan2((2 * ((this.w * this.x) + (this.y * this.z))), (1 - (2 * ((this.x * this.x) + (this.y * this.y)))));
            target.y = Math.asin((2 * ((this.w * this.y) - (this.z * this.x))));
            target.z = Math.atan2((2 * ((this.w * this.z) + (this.x * this.y))), (1 - (2 * ((this.y * this.y) + (this.z * this.z)))));
            return (target);
        }
        public function normalize(val:Number=1):void
        {
            var mag:Number = (val / Math.sqrt(((((this.x * this.x) + (this.y * this.y)) + (this.z * this.z)) + (this.w * this.w))));
            this.x = (this.x * mag);
            this.y = (this.y * mag);
            this.z = (this.z * mag);
            this.w = (this.w * mag);
        }
        public function toString():String
        {
            return ((((((((("{x:" + this.x) + " y:") + this.y) + " z:") + this.z) + " w:") + this.w) + "}"));
        }
        public function toMatrix3D(target:Matrix3D=null):Matrix3D
        {
            var rawData:Vector.<Number> = FrMatrix3DUtils.RAW_DATA_CONTAINER;
            var xy2:Number = ((2 * this.x) * this.y);
            var xz2:Number = ((2 * this.x) * this.z);
            var xw2:Number = ((2 * this.x) * this.w);
            var yz2:Number = ((2 * this.y) * this.z);
            var yw2:Number = ((2 * this.y) * this.w);
            var zw2:Number = ((2 * this.z) * this.w);
            var xx:Number = (this.x * this.x);
            var yy:Number = (this.y * this.y);
            var zz:Number = (this.z * this.z);
            var ww:Number = (this.w * this.w);
            rawData[0] = (((xx - yy) - zz) + ww);
            rawData[4] = (xy2 - zw2);
            rawData[8] = (xz2 + yw2);
            rawData[12] = 0;
            rawData[1] = (xy2 + zw2);
            rawData[5] = (((-(xx) + yy) - zz) + ww);
            rawData[9] = (yz2 - xw2);
            rawData[13] = 0;
            rawData[2] = (xz2 - yw2);
            rawData[6] = (yz2 + xw2);
            rawData[10] = (((-(xx) - yy) + zz) + ww);
            rawData[14] = 0;
            rawData[3] = 0;
            rawData[7] = 0;
            rawData[11] = 0;
            rawData[15] = 1;
            if (!(target))
            {
                return (new Matrix3D(rawData));
            };
            target.copyRawDataFrom(rawData);
            return (target);
        }
        public function fromMatrix(matrix:Matrix3D):void
        {
            var v:Vector3D = matrix.decompose(Orientation3D.QUATERNION)[1];
            this.x = v.x;
            this.y = v.y;
            this.z = v.z;
            this.w = v.w;
        }
        public function toRawData(target:Vector.<Number>, exclude4thRow:Boolean=false):void
        {
            var xy2:Number = ((2 * this.x) * this.y);
            var xz2:Number = ((2 * this.x) * this.z);
            var xw2:Number = ((2 * this.x) * this.w);
            var yz2:Number = ((2 * this.y) * this.z);
            var yw2:Number = ((2 * this.y) * this.w);
            var zw2:Number = ((2 * this.z) * this.w);
            var xx:Number = (this.x * this.x);
            var yy:Number = (this.y * this.y);
            var zz:Number = (this.z * this.z);
            var ww:Number = (this.w * this.w);
            target[0] = (((xx - yy) - zz) + ww);
            target[1] = (xy2 - zw2);
            target[2] = (xz2 + yw2);
            target[4] = (xy2 + zw2);
            target[5] = (((-(xx) + yy) - zz) + ww);
            target[6] = (yz2 - xw2);
            target[8] = (xz2 - yw2);
            target[9] = (yz2 + xw2);
            target[10] = (((-(xx) - yy) + zz) + ww);
            target[3] = (target[7] = (target[11] = 0));
            if (!(exclude4thRow))
            {
                target[12] = (target[13] = (target[14] = 0));
                target[15] = 1;
            };
        }
        public function clone():Quaternion
        {
            return (new Quaternion(this.x, this.y, this.z, this.w));
        }
		
		/**
		 * 对目标点进行旋转 
		 * @param vector 目标点
		 * @param target 结果保存
		 * @return 
		 * 
		 */		
		public function rotatePoint(vector:Vector3D, target:Vector3D=null):Vector3D
		{
			var x1:Number;
			var y1:Number;
			var z1:Number;
			var w1:Number;
			var x2:Number = vector.x;
			var y2:Number = vector.y;
			var z2:Number = vector.z;
			target=target==null?new Vector3D():target;
			
			/*
			var v1:Vector3D=new Vector3D(vector.x,vector.y,vector.z);
			
			var px:Vector3D=new Vector3D(this.w,-this.z,this.y,this.x);
			var py:Vector3D=new Vector3D(this.z,this.w,-this.x,this.y);
			var pz:Vector3D=new Vector3D(-this.y,this.x,this.w,this.z);
			var pw:Vector3D=new Vector3D(this.x,this.y,this.z,this.w);
			
			var temp1:Vector3D=new Vector3D();
			
			temp1.x=v1.dotProduct(px);
			temp1.y=v1.dotProduct(py);
			temp1.z=v1.dotProduct(pz);
			temp1.w=v1.dotProduct(pw);
			
			target.x =temp1.x*px.x+temp1.y*px.y+temp1.z*px.z+temp1.w*px.w;
			target.y =temp1.x*py.x+temp1.y*py.y+temp1.z*py.z+temp1.w*py.w;
			target.z =temp1.x*pz.x+temp1.y*pz.y+temp1.z*pz.z+temp1.w*pz.w;*/
			
			w1 = ( this.x * x2) + ( this.y * y2) + ( this.z * z2);
			
			x1 = ( this.w * x2) + (-this.z * y2) + ( this.y * z2);
			y1 = ( this.z * x2) + ( this.w * y2) + (-this.x * z2);
			z1 = (-this.y * x2) + ( this.x * y2) + ( this.w * z2);
			
			target.x = (x1 *  this.w) + (y1 * -this.z) + (z1 *  this.y)+(w1 * this.x)
			target.y = (x1 *  this.z) + (y1 *  this.w) + (z1 * -this.x)+(w1 * this.y)
			target.z = (x1 * -this.y) + (y1 *  this.x) + (z1 *  this.w)+(w1 * this.z)
			return (target);
		}
        
		public function rotatePoint2(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Vector3D):Vector3D{
			var _local5:Number;
			var _local6:Number;
			var _local7:Number;
			var _local8:Number;
			var _local9:Number = _arg1;
			var _local10:Number = _arg2;
			var _local11:Number = _arg3;
			_local8 = (((-(this.x) * _local9) - (this.y * _local10)) - (this.z * _local11));
			_local5 = (((this.w * _local9) + (this.y * _local11)) - (this.z * _local10));
			_local6 = (((this.w * _local10) - (this.x * _local11)) + (this.z * _local9));
			_local7 = (((this.w * _local11) + (this.x * _local10)) - (this.y * _local9));
			_arg4.x = ((((-(_local8) * this.x) + (_local5 * this.w)) - (_local6 * this.z)) + (_local7 * this.y));
			_arg4.y = ((((-(_local8) * this.y) + (_local5 * this.z)) + (_local6 * this.w)) - (_local7 * this.x));
			_arg4.z = ((((-(_local8) * this.z) - (_local5 * this.y)) + (_local6 * this.x)) + (_local7 * this.w));
			return (_arg4);
		}
        public function copyFrom(q:Quaternion):void
        {
            this.x = q.x;
            this.y = q.y;
            this.z = q.z;
            this.w = q.w;
        }
        public function computeW():void
        {
            this.w = (1 - (((this.x * this.x) + (this.y * this.y)) + (this.z * this.z)));
            if (this.w < 0)
            {
                this.w = 0;
            }
            else
            {
                this.w = -(Math.sqrt(this.w));
            };
        }

    }
}//package _Pan3D.core

