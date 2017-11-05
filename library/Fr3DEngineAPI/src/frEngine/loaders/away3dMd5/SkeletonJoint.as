package frEngine.loaders.away3dMd5
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import frEngine.math.Quaternion;

	/**
	 * A value obect representing a single joint in a skeleton object.
	 *
	 * @see away3d.animators.data.Skeleton
	 */
	public class SkeletonJoint
	{
		/**
		 * The index of the parent joint in the skeleton's joints vector.
		 * 
		 * @see away3d.animators.data.Skeleton#joints
		 */
		public var parentIndex : int = -1;

		/**
		 * The name of the joint
		 */
		public var name : String; // intention is that this should be used only at load time, not in the main loop

		/**
		 * The inverse bind pose matrix, as raw data, used to transform vertices to bind joint space in preparation for transformation using the joint matrix.
		 */
		public var inverseBindPose :Matrix3D;
		public var pos:Vector3D;
		public var quat:Quaternion;
		
		public var children:Vector.<SkeletonJoint>=new Vector.<SkeletonJoint>();
		/**
		 * Creates a new <code>SkeletonJoint</code> object
		 */
		public function SkeletonJoint()
		{
		}
	}
}