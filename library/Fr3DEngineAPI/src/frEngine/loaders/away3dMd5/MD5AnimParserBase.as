package frEngine.loaders.away3dMd5
{
	import flash.geom.Vector3D;
	
	import frEngine.loaders.away3dMd5.md5Data.BaseFrameData;
	import frEngine.loaders.away3dMd5.md5Data.BoundsData;
	import frEngine.loaders.away3dMd5.md5Data.FrameData;
	import frEngine.loaders.away3dMd5.md5Data.HierarchyData;
	import frEngine.math.Quaternion;

	public class MD5AnimParserBase
	{
		public static const rotationQuat : Quaternion=initRotationQuat();
		
		protected var _numJoints:uint;
		protected var _hierarchy : Vector.<HierarchyData>;
		protected var _bounds : Vector.<BoundsData>;
		protected var _baseFrameData : Vector.<BaseFrameData>;
		public function MD5AnimParserBase()
		{
			super();
		}
		private static function initRotationQuat(additionalRotationAxis : Vector3D = null, additionalRotationRadians : Number = 0):Quaternion
		{
			var rotationQuat:Quaternion = new Quaternion();
			var t1 : Quaternion = new Quaternion();
			var t2 : Quaternion = new Quaternion();
			
			t1.fromAxisAngle(Vector3D.X_AXIS, -Math.PI*.5);
			t2.fromAxisAngle(Vector3D.Y_AXIS, -Math.PI);
			
			rotationQuat.multiply(t2, t1);
			
			if (additionalRotationAxis) 
			{
				rotationQuat.multiply(t2, t1);
				t1.fromAxisAngle(additionalRotationAxis, additionalRotationRadians);
				rotationQuat.multiply(t1, rotationQuat);
			}
			return rotationQuat;
		}
		/**
		 * Converts a single key frame data to a SkeletonPose.
		 * @param frameData The actual frame data.
		 * @return A SkeletonPose containing the frame data's pose.
		 */
		protected function translatePose(frameData : FrameData) : SkeletonPose
		{
			var hierarchy : HierarchyData;
			var pose : JointPose;
			var base : BaseFrameData;
			var flags : int;
			var j : int;
			var translate : Vector3D = new Vector3D();
			var orientation : Quaternion = new Quaternion();
			var components : Vector.<Number> = frameData.components;
			var skelPose : SkeletonPose = new SkeletonPose();
			var jointPoses : Vector.<JointPose> = new Vector.<JointPose>(_numJoints);
			
			for (var i : int = 0; i < _numJoints; ++i) {
				j = 0;
				hierarchy = _hierarchy[i];
				pose = new JointPose(hierarchy.name);
				base = _baseFrameData[i];
				flags = hierarchy.flags;
				translate.x = base.position.x;
				translate.y = base.position.y;
				translate.z = base.position.z;
				orientation.x = base.orientation.x;
				orientation.y = base.orientation.y;
				orientation.z = base.orientation.z;
				
				if (flags & 1) translate.x = components[hierarchy.startIndex + (j++)];
				if (flags & 2) translate.y = components[hierarchy.startIndex + (j++)];
				if (flags & 4) translate.z = components[hierarchy.startIndex + (j++)];
				if (flags & 8) orientation.x = components[hierarchy.startIndex + (j++)];
				if (flags & 16) orientation.y = components[hierarchy.startIndex + (j++)];
				if (flags & 32) orientation.z = components[hierarchy.startIndex + (j++)];
				
				var w : Number = 1 - orientation.x * orientation.x - orientation.y * orientation.y - orientation.z * orientation.z;
				orientation.w = w < 0 ? 0 : -Math.sqrt(w);
				
				if (hierarchy.parentIndex < 0) {
					pose.orientation.multiply(rotationQuat, orientation);
					pose.translation = rotationQuat.rotatePoint(translate);
				}
				else {
					pose.orientation.copyFrom(orientation);
					pose.translation.x = translate.x;
					pose.translation.y = translate.y;
					pose.translation.z = translate.z;
				}
				pose.orientation.y = -pose.orientation.y;
				pose.orientation.z = -pose.orientation.z;
				pose.translation.x = -pose.translation.x;
				
				jointPoses[i] = pose;
			}
			skelPose.localPoses=jointPoses;
			
			return skelPose;
		}
	}
}