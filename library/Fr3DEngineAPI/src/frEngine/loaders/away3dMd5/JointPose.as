package frEngine.loaders.away3dMd5
{

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import frEngine.math.Quaternion;

	/**
	 * Contains transformation data for a skeleton joint, used for skeleton animation.
	 *
	 * @see away3d.animation.data.Skeleton
	 * @see away3d.animation.data.SkeletonJoint
	 *
	 * todo: support (uniform) scale
	 */
	public class JointPose
	{
		/**
		 * The name of the joint to which the pose is associated
		 */
		public var name : String; // intention is that this should be used only at load time, not in the main loop
		
		/**
		 * The rotation of the pose stored as a quaternion
		 */
		public var orientation : Quaternion = new Quaternion();
		
		/**
		 * The translation of the pose
		 */
		public var translation : Vector3D = new Vector3D();
		
		/**
		 * Converts the transformation to a Matrix3D representation.
		 * 
		 * @param target An optional target matrix to store the transformation. If not provided, it will create a new instance.
		 * @return The transformation matrix of the pose.
		 */
		private var _globleMatrix:Matrix3D;

		public function JointPose($name:String)
		{
			this.name=$name;
		}
		public function get globleMatrix3D():Matrix3D
		{
			if(!_globleMatrix)
			{
				_globleMatrix= new Matrix3D();
				orientation.toMatrix3D(_globleMatrix);
				_globleMatrix.appendTranslation(translation.x, translation.y, translation.z);
			}
			return _globleMatrix;
			
		}
		/**
		 * Copies the transformation data from a source pose object into the existing pose object.
		 * 
		 * @param pose The source pose to copy from.
		 */
		public function copyFrom(pose : JointPose) : void
		{
			var or : Quaternion = pose.orientation;
			var tr : Vector3D = pose.translation;
			orientation.x = or.x;
			orientation.y = or.y;
			orientation.z = or.z;
			orientation.w = or.w;
			translation.x = tr.x;
			translation.y = tr.y;
			translation.z = tr.z;
		}
	}
}