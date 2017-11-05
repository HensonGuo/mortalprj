package frEngine.loaders.away3dMd5
{
	
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;
	
	import frEngine.core.FrSurface3D;
	import frEngine.core.SwordLightSurface;

	/**
	 * Provides an interface for assigning skeleton-based animation data sets to mesh-based entity objects
	 * and controlling the various available states of animation through an interative playhead that can be
	 * automatically updated or manually triggered.
	 */
	public class SkeletonAnimator
	{
		private var indentyMatrix:Matrix3D=new Matrix3D();
		private var nameToIndex:Dictionary=new Dictionary(false);
		
        //private var _globalPose : SkeletonPose = new SkeletonPose();

		protected var _actionTrack:SkeletonClipNode;
		
		private var _numJoints : uint;
		private var _animationStates : Dictionary = new Dictionary();

        private var _skeleton : Skeleton;
		
		private var _jointsPerVertex : uint;

		public var animationSet:SkeletonAnimationSet;
		private var _skeletonPose : SkeletonPose;
		private var _hasDipspose:Boolean=false;
		private var _frame:int=0;
		

		/**
		 * returns the calculated global matrices of the current skeleton pose.
		 *
		 * @see #globalPose
		 */
		public function getGlobalMatrices(boneList:Vector.<int>):Vector.<Number>
		{
			return _skeletonPose.getGlobalProperties(_skeleton,boneList);
		}
		
		
		/**
		 * Returns the skeleton object in use by the animator - this defines the number and heirarchy of joints used by the
		 * skinned geoemtry to which skeleon animator is applied.
		 */
		public function get skeleton():Skeleton
		{
			return _skeleton;
		}

		/**
		 * Creates a new <code>SkeletonAnimator</code> object.
		 *
		 * @param skeletonAnimationSet The animation data set containing the skeleton animations used by the animator.
		 * @param skeleton The skeleton object used for calculating the resulting global matrices for transforming skinned mesh data.
		 * @param forceCPU Optional value that only allows the animator to perform calculation on the CPU. Defaults to false.
		 */
		public function SkeletonAnimator($animationSet:SkeletonAnimationSet, skeleton : Skeleton)
		{
			super();
			animationSet=$animationSet;

			_skeleton = skeleton;
			_jointsPerVertex = animationSet.jointsPerVertex;
			
			_numJoints = _skeleton.numBones;
		
		}
		
		/**
		 * Plays an animation state registered with the given name in the animation data set.
		 *
		 * @param stateName The data set name of the animation state to be played.
		 * @param stateTransition An optional transition object that determines how the animator will transition from the currently active animation state.
		 */
		public function play(name : String, frame : int) : void
		{

			if (!animationSet.hasAnimation(name))
				throw new Error("Animation root node " + name + " not found!");

			_actionTrack = animationSet.getAnimation(name) as SkeletonClipNode;

			if(!_actionTrack)
			{
				throw new Error("动作不存在！");
			}
			updateFrame(frame);

		}

		public function getSwordLightSurface(boneName:String,swordLightLen:int,offsetY:int,splieNum:int):SwordLightSurface
		{
			var id:int=getJointIndexFromName(boneName);
			if(id==-1)
			{
				return null;
			}else
			{
				return _actionTrack.getBoneSwordLightSurface(id,swordLightLen,offsetY,splieNum);
			}
			
		}
		
		public function getBoneGlobleTransformByName(name:String):Matrix3D
		{
			var id:Number=nameToIndex[name];
			if( isNaN(id) || id==-1 )
			{
				id=getJointIndexFromName(name);
				nameToIndex[name]=id;
			}
			return getBoneGlobleMatrix3DByIndex(id);
		}
		public function getBoneGlobleMatrix3DByIndex(boneId:int):Matrix3D
		{
			if(boneId==-1)
			{
				return indentyMatrix;
			}
			var globalJointPose:JointPose = _skeletonPose.globalPosesCache[boneId];
			if(globalJointPose)
			{
				return globalJointPose.globleMatrix3D;
			}else
			{
				return indentyMatrix;
			}
		}
		
		public function getJointIndexFromName(name:String):int
		{
			return _skeleton.jointIndexFromName(name);
		}
		public function getBoneGlobleJointByName(name:String):JointPose
		{
			var id:Number=nameToIndex[name];
			if( isNaN(id) || id==-1 )
			{
				id=getJointIndexFromName(name);
				nameToIndex[name]=id;
			}
			
			if(id==-1)
			{
				return null;
			}
			var globalJointPose:JointPose = _skeletonPose.globalPosesCache[id];
			
			return globalJointPose;
			
		}
		
		
		public function dispose():void
		{
			_actionTrack=null;
			_animationStates=null;
			_skeleton=null;
			animationSet=null;
			_skeletonPose=null;
			_hasDipspose=true;
		}

		public function updateFrame(frame:int):void
		{
			this._frame=frame;
			if(!_hasDipspose && !_actionTrack)
			{
				throw new Error("请先调用play方法");
			}
			_skeletonPose=_actionTrack.getGloblePoses(frame);
		}	
	}
}
