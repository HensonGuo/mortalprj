package frEngine.effectEditTool.temple
{
	import flash.geom.Vector3D;
	
	import frEngine.math.Quaternion;

	public class FightParams
	{
		private static const qu:Quaternion=new Quaternion();
		private static const _temp:Vector3D=new Vector3D();
		
		public var uid:String;
		public var startTargetLabel:String
		public var startBoneName:String
		public var startOffsetPos:Vector3D;
		public var endTargetLabel:String
		public var endBoneName:String
		public var endOffsetPos:Vector3D;
		public var speed:Number;
		public var startPos:Vector3D;
		public var endPos:Vector3D;

		public var lineType:String;
		public var openAngle:Number;
		public var rotateAngle:Number;
		public var midHerizionRate:Number;//herizon rate
		public var midHeightRate:Number;
		private var _fightEndPos:Vector3D;
		private var _up:Vector3D
		public function FightParams(obj:Object)
		{
			uid=obj.uid;
			var arr:Array = obj.startPos.split("||");
			startTargetLabel = arr[0];
			startBoneName = arr[1];
			var offstArr:Array;
			if(arr[2])
			{
				offstArr=arr[2].split(",");
				startOffsetPos=new Vector3D(offstArr[0],offstArr[1],offstArr[2]);
			}
			
			arr = obj.endPos.split("||");
			endTargetLabel = arr[0];
			endBoneName = arr[1];
			if(arr[2])
			{
				offstArr=arr[2].split(",");
				endOffsetPos=new Vector3D(offstArr[0],offstArr[1],offstArr[2]);
			}
			
			speed=obj.speed;
			
			if (speed <= 0)
			{
				speed = 5;
			}
			
			lineType=obj.lineType;
			openAngle=obj.openAngle;
			
			openAngle>60 && (openAngle=60)
			openAngle<-60 && (openAngle=-60)
				
			openAngle=openAngle/180*Math.PI;
			
			rotateAngle=obj.rotateAngle;
			
			rotateAngle=rotateAngle/180*Math.PI;
			
			midHerizionRate=obj.mid0;
			midHeightRate=obj.mid1;
		}
		
		public function get fightEndPos():Vector3D
		{
			var _direction:Vector3D=endPos.subtract(startPos);
			
			var _left:Vector3D=_direction.crossProduct(Vector3D.Y_AXIS);
			
			_up=_left.crossProduct(_direction);//_direction
			
			_up.normalize();
			
			qu.fromAxisAngle(_up,openAngle);
			
			qu.rotatePoint(_direction,_temp);
			_temp.normalize();
			
			var rate:Number=1/Math.cos(openAngle);
			
			_temp.scaleBy(_direction.length*rate);
			
			_fightEndPos=startPos.add(_temp);
			
			return _fightEndPos;
		}
		
		public function get curveMidPos():Vector3D
		{
			var _direction:Vector3D=_fightEndPos.subtract(startPos);

			var maxDistance:Number=_direction.normalize();
			
			_direction.crossProduct(_up);
			_up.scaleBy(maxDistance*midHeightRate);
			
			qu.fromAxisAngle(_direction,rotateAngle);
			qu.rotatePoint(_up,_temp);
			
			_direction.scaleBy(maxDistance*midHerizionRate);
			_direction=startPos.add(_direction);
			
			return _direction.add(_temp);
		}
		
		public function get fightSpeed():Number
		{
			return speed/Math.cos(openAngle);
		}

	}
}