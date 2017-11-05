package frEngine.loaders.md5sub
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import frEngine.math.Quaternion;
	
	public class ObjectBone
	{
		public var changtype:Number = 0;
		public var name:String = "";
		public var boneId:int;
		public var father:ObjectBone;
		public var startIndex:int;
		
		//public var boneResultMatrix3D:Matrix3D=new Matrix3D();
		
		public var globleMatrix3D:Matrix3D=new Matrix3D();

		public var localAngle:Quaternion=new Quaternion();
		public var localPostion:Vector3D=new Vector3D();
		
		public var globleAngle:Quaternion=new Quaternion();
		public var globlePostion:Vector3D=new Vector3D();
		
		public var hasInverse:Boolean;
		private var _callback:Function;
		public function ObjectBone($boneId:int,$name:String)
		{
			boneId=$boneId;	
			name=$name;
		}
		public function clone():ObjectBone
		{
			var _newer:ObjectBone=new ObjectBone(boneId,name);
			_newer.localAngle=this.localAngle.clone() as Quaternion;
			_newer.localPostion=this.localPostion.clone();
			return _newer;
		}

		public function toString():String
		{
			return " tx:" + localPostion.x + " ty:" + localPostion.y + " tz:" + localPostion.z + " qx:" + localAngle.x + " qy:" + localAngle.y + " qz:" + localAngle.z;
		}
		public function initAngle($qx:Number,$qy:Number,$qz:Number):void
		{
			localAngle.x=$qx;
			localAngle.y=$qy;
			localAngle.z=$qz;
		}

		public function calculateGloble():void
		{
			localAngle.normalize();
			localAngle.computeW();
			
			if(this.father==null)
			{
				globleAngle=localAngle.clone() as Quaternion;
				globlePostion=localPostion.clone();
			}else
			{
				globleAngle.multiply(father.globleAngle,localAngle);
				globlePostion = father.globleMatrix3D.transformVector(localPostion);
			}
		}
		public function calculateGlobleMatrix():void
		{
			calculateGloble();
			globleAngle.toMatrix3D(globleMatrix3D);
			globleMatrix3D.appendTranslation(globlePostion.x, globlePostion.y, globlePostion.z);
			
		}
		public function initPosition($tx:Number,$ty:Number,$tz:Number):void
		{
			localPostion.x=$tx;
			localPostion.y=$ty;
			localPostion.z=$tz;
		}

	}
}//package _Pan3D.base

