package frEngine.loaders.away3dMd5
{
	import flash.utils.Dictionary;
	
	import baseEngine.utils.SplitSurfaceInfo;

	/**
	 * A Skeleton object is a hierarchical grouping of joint objects that can be used for skeletal animation.
	 *
	 * @see away3d.animators.data.SkeletonJoint
	 */
	public class Skeleton
	{
		public var isCompress:Boolean;
		public var splitSurfaceInfo:SplitSurfaceInfo;
		public var maxJointCount:uint;
		public var magic:uint;
		public var hasNormal:Boolean;
		public var version:uint;
		public var material:String;
		//public var bindPoses:Vector.<Matrix3D>;
		private var _joinRoot:SkeletonJoint;
		/**
		 * A flat list of joint objects that comprise the skeleton. Every joint except for the root has a parentIndex
		 * property that is an index into this list.
		 * A child joint should always have a higher index than its parent.
		 */
		public var inherits : Vector.<SkeletonJoint> = new Vector.<SkeletonJoint>()

		
		/**
		 * The total number of joints in the skeleton.
		 */
		public function get numBones() : uint
		{
			return inherits.length;
		}

		public function set joinRoot(value:SkeletonJoint):void
		{
			_joinRoot=value;
		}
		public function get joinRoot():SkeletonJoint
		{
			if(!_joinRoot)
			{
				
				for each (var joint:SkeletonJoint in inherits)
				{
					if (joint.parentIndex == -1)
					{
						_joinRoot=joint;
						break;
					}
					
				}
			}
			return _joinRoot;
		}
		/**
		 * Creates a new <code>Skeleton</code> object
		 */
		public function Skeleton()
		{

		}

		/**
		 * Returns the joint object in the skeleton with the given name, otherwise returns a null object.
		 * 
		 * @param jointName The name of the joint object to be found.
		 * @return The joint object with the given name.
		 * 
		 * @see #joints
		 */
		public function jointFromName(jointName:String):SkeletonJoint
		{
			var jointIndex:int = jointIndexFromName(jointName);
			if (jointIndex != -1)
			{
				return inherits[jointIndex];
			}
			else
			{
				return null;
			}
		}

		/**
		 * Returns the joint index, given the joint name. -1 is returned if the joint name is not found.
		 * 
		 * @param jointName The name of the joint object to be found.
		 * @return The index of the joint object in the joints vector. 
		 * 
		 * @see #joints
		 */
		private var jointNameIndexMap:Dictionary;
		public function jointIndexFromName(jointName:String):int
		{
			// this function is implemented as a linear search, rather than a possibly
			// more optimal method (Dictionary lookup, for example) because:
			// a) it is assumed that it will be called once for each joint
			// b) it is assumed that it will be called only during load, and not during main loop
			// c) maintaining a dictionary (for safety) would dictate an interface to access SkeletonJoints,
			//    rather than direct array access.  this would be sub-optimal.
			if(!jointNameIndexMap)
			{
				jointNameIndexMap=new Dictionary(false);
				var jointIndex:int;
				for each (var joint:SkeletonJoint in inherits)
				{
					jointNameIndexMap[joint.name]=jointIndex;
					jointIndex++;
				}
			}
			if(jointNameIndexMap[jointName])
			{
				return jointNameIndexMap[jointName]
			}else
			{
				return -1;
			}
		}
		
		/**
		 * @inheritDoc
		*/
		public function dispose() : void
		{
			inherits.length = 0;
		}
	}
}