package frEngine.loaders.away3dMd5
{
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import frEngine.core.FrSurface3D;
	import frEngine.core.SwordLightSurface;
	import frEngine.loaders.away3dMd5.md5Data.HierarchyData;
	import frEngine.math.Quaternion;
	

	/**
	 * A skeleton animation node containing time-based animation data as individual skeleton poses.
	 */
	public class SkeletonClipNode extends AnimationClipNodeBase
	{
		public var frames : Vector.<SkeletonPose> = new Vector.<SkeletonPose>();
		private var surfaceCache:Dictionary=new Dictionary(false);
		private var cacheAllFrameJoints:Dictionary=new Dictionary(false);
		private var _hierarchy:Vector.<HierarchyData>;
		private static var _localOr : Quaternion=new Quaternion();
		private static var _localTr : Vector3D=new Vector3D();


		public function SkeletonClipNode(_arg2:Number, _arg3:Number,$trackName:String,$hierarchy:Vector.<HierarchyData>,$fightOnFrame:uint,$numFrames:uint)
		{
			super(_arg2,_arg3,$trackName,$fightOnFrame,$numFrames); 
			_hierarchy=$hierarchy;
		}
		
		/**
		 * Adds a skeleton pose frame to the internal timeline of the animation node.
		 * 
		 * @param skeletonPose The skeleton pose object to add to the timeline of the node.
		 * @param duration The specified duration of the frame in milliseconds.
		 */
		public function addFrame(skeletonPose : SkeletonPose) : void
		{
			frames.push(skeletonPose);
			_stitchDirty = true;
		}
		
		private function calculateAllFrameBonePose(boneIndex:int):Vector.<JointPose>
		{

			var _nextPose:SkeletonPose;
			var cur:JointPose;
			var _result:Vector.<JointPose>=new Vector.<JointPose>();
			var len:int=frames.length;
			for(var i:int=1;i<len;i++)
			{
				_nextPose=frames[i];
				cur=getGloblePoseByIndex(_nextPose,null,boneIndex,0);
				_result.push(cur);
			}
			return _result;
		}
		
		public function localToGlobalPose(targetPoses:SkeletonPose) : void
		{
			if(targetPoses.hasChangeToGloble)
			{
				return;
			}
			
			targetPoses.hasChangeToGloble=true;
			
			var len : uint = targetPoses.numJointPoses;
			var _globalPosesCache:Dictionary=targetPoses.globalPosesCache;
			for (var i : uint = 0; i < len; ++i) 
			{
				if(_globalPosesCache[i])
				{
					continue;
				}
				calculateLocalToGloblePose(targetPoses,null,i,0);
				
			}
		}
		
		public function getGloblePoseByIndex(curPoses:SkeletonPose,nextPoses:SkeletonPose,index:Number,rate:Number):JointPose
		{
			
			var id:Number=index+rate;
			var globalJointPose : JointPose=curPoses.globalPosesCache[id];
			if(!globalJointPose)
			{
				globalJointPose=calculateLocalToGloblePose(curPoses,nextPoses,index,rate);
			}
			return globalJointPose;
			
		}
		private function calculateLocalToGloblePose(curFramePoses:SkeletonPose,nextFramePoses:SkeletonPose,index:int,blendWeight:Number):JointPose
		{
			var joint : HierarchyData;
			var parentIndex : int;
			var pose : JointPose;
			var parentPose : JointPose;
			var localOr : Quaternion;
			var localTr : Vector3D;
			var parentOr : Quaternion;
			var parentTr : Vector3D;
			
			var t : Vector3D;
			var q : Quaternion;
			
			var x1 : Number, y1 : Number, z1 : Number, w1 : Number;
			var x2 : Number, y2 : Number, z2 : Number, w2 : Number;
			var x3 : Number, y3 : Number, z3 : Number, w3 : Number;
			var x4 : Number, y4 : Number, z4 : Number, w4 : Number;
			
			joint = _hierarchy[index];
			
			var globalJointPose : JointPose=new JointPose(joint.name);
			
			q = globalJointPose.orientation;
			t = globalJointPose.translation;
			
			pose = curFramePoses.localPoses[index];
			localTr = pose.translation;
			localOr = pose.orientation;
			
			x3 = localTr.x;
			y3 = localTr.y;
			z3 = localTr.z;
			
			if(nextFramePoses)
			{
				pose = nextFramePoses.localPoses[index];
				var localTr2:Vector3D = pose.translation;
				var localOr2:Quaternion = pose.orientation;
				x3=x3+(localTr2.x-x3)*blendWeight;
				y3=y3+(localTr2.y-y3)*blendWeight;
				z3=z3+(localTr2.z-z3)*blendWeight;
				_localOr.lerp(localOr,localOr2,blendWeight);
				localOr=_localOr;
			}

			x4 = localOr.x;
			y4 = localOr.y;
			z4 = localOr.z;
			w4 = localOr.w;
			
			
			parentIndex = joint.parentIndex;
			
			if (parentIndex < 0) 
			{
				t.x = x3;
				t.y = y3;
				t.z = z3;
				q.x = x4;
				q.y = y4;
				q.z = z4;
				q.w = w4;
			}
			else 
			{
				
				// append parent pose
				parentPose = curFramePoses.globalPosesCache[(parentIndex+blendWeight)];
				if(!parentPose)
				{
					parentPose=calculateLocalToGloblePose(curFramePoses,nextFramePoses,parentIndex,blendWeight);
				}
				// rotate point
				parentOr = parentPose.orientation;
				parentTr = parentPose.translation;
				
				x2 = parentOr.x;
				y2 = parentOr.y;
				z2 = parentOr.z;
				w2 = parentOr.w;
				
				
				w1 = -x2 * x3 - y2 * y3 - z2 * z3;
				x1 = w2 * x3 + y2 * z3 - z2 * y3;
				y1 = w2 * y3 - x2 * z3 + z2 * x3;
				z1 = w2 * z3 + x2 * y3 - y2 * x3;
				
				// append parent translation
				
				t.x = -w1 * x2 + x1 * w2 - y1 * z2 + z1 * y2 + parentTr.x;
				t.y = -w1 * y2 + x1 * z2 + y1 * w2 - z1 * x2 + parentTr.y;
				t.z = -w1 * z2 - x1 * y2 + y1 * x2 + z1 * w2 + parentTr.z;
				
				// append parent orientation
				
				
				q.w = w2 * w4 - x2 * x4 - y2 * y4 - z2 * z4;
				q.x = w2 * x4 + x2 * w4 + y2 * z4 - z2 * y4;
				q.y = w2 * y4 - x2 * z4 + y2 * w4 + z2 * x4;
				q.z = w2 * z4 + x2 * y4 - y2 * x4 + z2 * w4;
			}
			curFramePoses.globalPosesCache[(index+blendWeight)]=globalJointPose;
			return globalJointPose;
		}
		/**
		 * 目前每帧的分段数统一为10
		 * @param boneName
		 * @param swordLightLen
		 * @param offsetY
		 * @return 
		 * 
		 */	
		public function getBoneSwordLightSurface(boneIndex:int,swordLightLen:int,offsetY:int,splieNum:int):SwordLightSurface
		{
			var cacheBone:Vector.<JointPose>=cacheAllFrameJoints[boneIndex];
			if(!cacheBone)
			{
				cacheBone=cacheAllFrameJoints[boneIndex]=calculateAllFrameBonePose(boneIndex);
			}
			var _id:String="id:"+boneIndex+",n:"+swordLightLen+",y:"+offsetY+"sp:"+splieNum;
			var surface:SwordLightSurface=surfaceCache[_id];
			if(surface)
			{
				return surface
			}
			surface=new SwordLightSurface(_id,cacheBone,swordLightLen,offsetY,splieNum);
			return surface;
		}
		public function getGloblePoses(frame:int):SkeletonPose
		{
			var _skeletonPose:SkeletonPose=frames[frame];
			if(!_skeletonPose.hasChangeToGloble)
			{
				localToGlobalPose(_skeletonPose);
				
			}
			return _skeletonPose;
		}
		public function dispose():void
		{
			var len:int=frames.length;
			for(var i:int=0;i<len;i++)
			{
				var _pose:SkeletonPose=frames[i];
				_pose.dispose();
			}
			
			for each(var p:FrSurface3D in surfaceCache)
			{
				p.disposeImp();
			}
			surfaceCache=null;
			cacheAllFrameJoints=null;
			_hierarchy=null;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateStitch():void
		{
			super.updateStitch();
			
			var i:uint = numFrames - 1;
			var p1 : Vector3D, p2 : Vector3D, delta : Vector3D;
			while (i--) {
				p1 = frames[i].localPoses[0].translation;
				p2 = frames[i+1].localPoses[0].translation;
				delta = p2.subtract(p1);
				_totalDelta.x += delta.x;
				_totalDelta.y += delta.y;
				_totalDelta.z += delta.z;
			}
			
			if (_stitchFinalFrame || !_looping) {
				p1 = frames[0].localPoses[0].translation;
				p2 = frames[1].localPoses[0].translation;
				delta = p2.subtract(p1);
				_totalDelta.x += delta.x;
				_totalDelta.y += delta.y;
				_totalDelta.z += delta.z;
			}
		}
	}
}
