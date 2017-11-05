package frEngine.loaders.away3dMd5
{
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;

	/**
	 * A collection of pose objects, determining the pose for an entire skeleton.
	 * The <code>jointPoses</code> vector object corresponds to a skeleton's <code>joints</code> vector object, however, there is no
	 * reference to a skeleton's instance, since several skeletons can be influenced by the same pose (eg: animation
	 * clips are added to any animator with a valid skeleton)
	 * 
	 * @see away3d.animators.data.Skeleton
	 * @see away3d.animators.data.JointPose
	 */
	public class SkeletonPose
	{
		/**
		 * A flat list of pose objects that comprise the skeleton pose. The pose indices correspond to the target skeleton's joint indices.
		 * 
		 * @see away3d.animators.data.Skeleton#joints
		 */
		public var hasChangeToGloble:Boolean=false;
		public var localPoses : Vector.<JointPose>;
		public var globalPosesCache:Dictionary=new Dictionary(false);
		private var _globalMatrices : Vector.<Matrix3D>;
		//public var inherits:Vector.<HierarchyData>;
		
		
		/**
		 * Creates a new <code>SkeletonPose</code> object.
		 */
		public function SkeletonPose()
		{
			
		}

		
		public function getGlobalProperties(_skeleton : Skeleton,boneList:Vector.<int>) :Vector.<Number>
		{
			if(!_globalMatrices)
			{
				_globalMatrices=new Vector.<Matrix3D>();
				var joints : Vector.<SkeletonJoint> = _skeleton.inherits;
				var pose : JointPose;
				var _numJoints:int=_skeleton.numBones;
				var raw:Matrix3D;
				for (var i : uint = 0; i < _numJoints; ++i) 
				{
					pose = globalPosesCache[i];
					//pose.generateGlobleMatrix3D();
					raw = joints[i].inverseBindPose;
					var m:Matrix3D=new Matrix3D();
					m.copyFrom(pose.globleMatrix3D);
					m.prepend(raw);
					_globalMatrices.push(m);
				}
			}

			var _len:int = boneList.length;
			var _curNum:int = 0;
			var _bonesVecter2:Vector.<Number>= new Vector.<Number>();
			while (_curNum < _len)
			{
				var _boneIndex:int = boneList[_curNum];
				_globalMatrices[_boneIndex].copyRawDataTo(_bonesVecter2, _curNum * 12, true);
				_curNum++;
			}
			return _bonesVecter2;
		}
		/**
		 * The total number of joint poses in the skeleton pose.
		 */
		public function get numJointPoses() : uint
		{
			return localPoses.length;
		}
		
		
		/**
		 * Returns the joint pose object with the given joint name, otherwise returns a null object.
		 * 
		 * @param jointName The name of the joint object whose pose is to be found.
		 * @return The pose object with the given joint name.
		 */
		public function jointPoseFromName(jointName : String) : JointPose
		{
			var jointPoseIndex : int = jointPoseIndexFromName(jointName);
			if (jointPoseIndex != -1) {
				return localPoses[jointPoseIndex];
			}
			else {
				return null;
			}
		}
		
		/**
		 * Returns the pose index, given the joint name. -1 is returned if the joint name is not found in the pose.
		 * 
		 * @param The name of the joint object whose pose is to be found.
		 * @return The index of the pose object in the jointPoses vector. 
		 * 
		 * @see #jointPoses
		 */
		public function jointPoseIndexFromName(jointName : String) : int
		{
			// this function is implemented as a linear search, rather than a possibly
			// more optimal method (Dictionary lookup, for example) because:
			// a) it is assumed that it will be called once for each joint
			// b) it is assumed that it will be called only during load, and not during main loop
			// c) maintaining a dictionary (for safety) would dictate an interface to access JointPoses,
			//    rather than direct array access.  this would be sub-optimal.
			var jointPoseIndex : int;
			for each (var jointPose : JointPose in localPoses) {
				if (jointPose.name == jointName) {
					return jointPoseIndex;
				}
				jointPoseIndex++;
			}

			return -1;
		}
		
		/**
		 * Creates a copy of the <code>SkeletonPose</code> object, with a dulpicate of its component joint poses.
		 * 
		 * @return SkeletonPose
		 */
		public function clone() : SkeletonPose
		{
			var clone : SkeletonPose = new SkeletonPose();
			var numJointPoses : uint = this.localPoses.length;
			for (var i : uint = 0; i < numJointPoses; i++) {
				var thisJointPose : JointPose = this.localPoses[i];
				var cloneJointPose : JointPose = new JointPose(thisJointPose.name);
				cloneJointPose.copyFrom(thisJointPose);
				clone.localPoses[i] = cloneJointPose;
			}
			return clone;
		}
		
		/** 
		 * @inheritDoc
		 */
		public function dispose() : void
		{
			
			localPoses.length = 0;
			_globalMatrices=null;
			globalPosesCache=null;
		}
	}
}