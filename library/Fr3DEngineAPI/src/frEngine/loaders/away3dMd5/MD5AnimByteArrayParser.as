package frEngine.loaders.away3dMd5
{
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import frEngine.TimeControler;
	import frEngine.loaders.away3dMd5.md5Data.BaseFrameData;
	import frEngine.loaders.away3dMd5.md5Data.FrameData;
	import frEngine.loaders.away3dMd5.md5Data.HeadJoins;
	import frEngine.loaders.away3dMd5.md5Data.HierarchyData;
	import frEngine.loaders.away3dMd5.md5Data.TrackInfo;
	import frEngine.math.Quaternion;

	public class MD5AnimByteArrayParser extends MD5AnimParserBase
	{
		private var _bytes:ByteArray;
		public static const parseTypeValue:int = 0x2100;
		private var _curClip:SkeletonClipNode;
		private var _curFrame:int;
		private var preFrameIndex:int = -1;
		private var pre:SkeletonPose;
		public var animationSet:SkeletonAnimationSet;
		private var parsedTrackNum:int=0;
		private var numtrack:int=0;
		public var headAndJoins:HeadJoins
		
		public function MD5AnimByteArrayParser()
		{
			super();
		}

		
		public function proceedParsingHead(data :ByteArray):void
		{
			_bytes = data;
			headAndJoins = parseHeadAndJoints(_bytes);
			this._numJoints = headAndJoins.numJoints;
			this._hierarchy = headAndJoins.joinsList;
			this._baseFrameData = readBaseFrame(headAndJoins);
			parsedTrackNum=0;
			numtrack = headAndJoins.tracksNum;
			animationSet  = new SkeletonAnimationSet();
			_curClip = createClip(parsedTrackNum);
		}
		
		
		public function proceedParsing():Boolean
		{
			if ( parsedTrackNum < numtrack )
			{
				var _isComplete:Boolean=readClipFrames(_curClip);
				if(_isComplete)
				{
					animationSet.addAnimation(_curClip);
					parsedTrackNum++;
					if(parsedTrackNum < numtrack)
					{
						_curClip = createClip(parsedTrackNum);
					}else
					{
						_curClip=null;
					}
				}
				
			}
			return parsedTrackNum >= numtrack
		}

		private function createClip(index:int):SkeletonClipNode
		{
			
			var numFrames:uint = _bytes.readUnsignedShort();
			var boundsMin:Vector3D = parseVector3D(_bytes);
			var boundsMax:Vector3D = parseVector3D(_bytes);
			var boundsCenter:Vector3D = parseVector3D(_bytes);
			var trackInfo:TrackInfo=headAndJoins.tracksList[index]
			var _clip:SkeletonClipNode = new SkeletonClipNode(0, trackInfo.frameNum - 1, trackInfo.name,headAndJoins.joinsList,trackInfo.fightOnframe,numFrames);
			_curFrame=0;
			return _clip;
		}
		private function readClipFrames(_clip:SkeletonClipNode):Boolean
		{
			//(getTimer()-TimeControler.stageTime) < TimeControler.minFpsTime
			
			var data:FrameData;
			var numFrames:int=_clip.numFrames;
			var _numAnimatedComponents:uint = headAndJoins.numAnimatedComponents;
			
			while (_curFrame < numFrames && (getTimer()-TimeControler.stageTime < TimeControler.minFpsTime))
			{

				data = new FrameData();
				data.components = new Vector.<Number>(_numAnimatedComponents, true);

				var curFrameIndex:uint = _bytes.readUnsignedShort();
				for (var k:int = 0; k < _numAnimatedComponents; ++k)
				{
					data.components[k] = _bytes.readFloat();
				}
				
				var skeletonPose:SkeletonPose = translatePose(data);
				
				var dis:int = curFrameIndex - preFrameIndex
				if (dis > 1 && pre)
				{
					for (var n:int = 1; n < dis; n++)
					{
						var mid:SkeletonPose = new SkeletonPose();
						blendPose(mid, pre, skeletonPose, n / dis);
						_clip.addFrame(mid);
					}
				}

				_clip.addFrame(skeletonPose);
				
				pre=skeletonPose;
				preFrameIndex = curFrameIndex;
				_curFrame++;
			}
			
			return _curFrame >= numFrames;
		}

		private function blendPose(target:SkeletonPose, start:SkeletonPose, end:SkeletonPose, _blendWeight:Number):void
		{
			var numJoints:int = start.numJointPoses;
			var currentPose:Vector.<JointPose> = start.localPoses;
			var nextPose:Vector.<JointPose> = end.localPoses;
			var jointPoses : Vector.<JointPose> = new Vector.<JointPose>(numJoints);
			for (var i:uint = 0; i < numJoints; ++i)
			{

				var pose1:JointPose = currentPose[i];
				var pose2:JointPose = nextPose[i];
				var endPose:JointPose = new JointPose(pose1.name);
				endPose.orientation.lerp(pose1.orientation, pose2.orientation, _blendWeight);
				var tr:Vector3D = endPose.translation;
				var p1:Vector3D = pose1.translation;
				var p2:Vector3D = pose2.translation;
				tr.x = p1.x + _blendWeight * (p2.x - p1.x);
				tr.y = p1.y + _blendWeight * (p2.y - p1.y);
				tr.z = p1.z + _blendWeight * (p2.z - p1.z);

				jointPoses[i] = endPose;
			}
			target.localPoses=jointPoses;
		}

		private function readBaseFrame(headAndJoins:HeadJoins):Vector.<BaseFrameData>
		{
			var joinsNum:uint = headAndJoins.numJoints;
			var data:BaseFrameData;
			var baseFrameData:Vector.<BaseFrameData> = new Vector.<BaseFrameData>(joinsNum, true);
			for (var i:int = 0; i < joinsNum; i++)
			{
				data = new BaseFrameData();
				data.position = parseVector3D(_bytes);
				data.orientation = parseQuaternion(_bytes);
				baseFrameData[i] = data;
			}
			return baseFrameData;
		}

		public static function checkIsCompressBone(head1:uint,head2:uint):Boolean
		{
			var isNormal:Boolean;
			if(head1==MD5AnimByteArrayParser.parseTypeValue)
			{
				if(head2==1 || head2==2)
				{
					isNormal=true;
				}else
				{
					isNormal=false;
				}
			}else
			{
				isNormal=false;
			}
			return !isNormal;
		}
		
		public static function parseHeadAndJoints(_bytes:ByteArray):HeadJoins
		{
			_bytes.endian = Endian.LITTLE_ENDIAN;
			_bytes.position = 0;
			var headJoins:HeadJoins = new HeadJoins();
			headJoins.magic = _bytes.readUnsignedShort();
			headJoins.version = _bytes.readUnsignedShort();
		
			headJoins.isCompress=checkIsCompressBone(headJoins.magic,headJoins.version);
			
			if (headJoins.isCompress)
			{
				_bytes.position=0;
				_bytes.uncompress();
				headJoins.magic = _bytes.readUnsignedShort();
				headJoins.version = _bytes.readUnsignedShort();
				if (headJoins.magic != parseTypeValue)
				{
					return null;
				}
			}

			var numJoins:uint = _bytes.readUnsignedShort();
			headJoins.numAnimatedComponents = _bytes.readUnsignedShort();
			var tracknum:uint = _bytes.readUnsignedShort();

			var i:int,trackInfo:TrackInfo;
			
			if(headJoins.version==1)
			{
				for (i = 0; i < tracknum; i++)
				{
					trackInfo = new TrackInfo(readString(_bytes), _bytes.readUnsignedShort(), 0 , _bytes.readUnsignedShort());
					headJoins.tracksList.push(trackInfo);
				}
			}else
			{
				for (i = 0; i < tracknum; i++)
				{
					trackInfo = new TrackInfo(readString(_bytes), _bytes.readUnsignedShort(),_bytes.readUnsignedShort(), _bytes.readUnsignedShort());
					headJoins.tracksList.push(trackInfo);
				}
			}
			

			var joinsList:Vector.<HierarchyData> = new Vector.<HierarchyData>(numJoins, true);
			var data:HierarchyData;
			for (i = 0; i < numJoins; i++)
			{
				data = new HierarchyData();
				data.name = readString(_bytes);
				data.parentIndex = _bytes.readShort();
				data.flags = _bytes.readUnsignedShort();
				data.startIndex = _bytes.readUnsignedShort();
				joinsList[i] = data;
			}
			headJoins.joinsList = joinsList;
			return headJoins;
		}

		public static function readString(stream:ByteArray):String
		{
			var result:String;
			var n:int = 0;
			var pos:uint = stream.position;
			var maxNum:int = 10000;
			while (n < maxNum)
			{
				result = stream.readMultiByte(1, "gb2312")
				if (result == "\\")
				{
					var bytesNum:int = stream.position - pos - 1;
					stream.position = pos;
					result = stream.readMultiByte(bytesNum, "gb2312");
					stream.position += 2;
					break;
				}
				n++;
			}
			if (n == maxNum)
			{
				throw new Error("3dmax输出有误，字符串没有加\\");
			}
			return result;
		}

		private static function parseVector3D(stream:ByteArray):Vector3D
		{
			var vec:Vector3D = new Vector3D();

			vec.x = stream.readFloat();
			vec.y = stream.readFloat();
			vec.z = stream.readFloat();

			return vec;
		}

		/**
		 * Retrieves the next quaternion in the data stream.
		 */
		private static function parseQuaternion(stream:ByteArray):Quaternion
		{
			var quat:Quaternion = new Quaternion();

			quat.x = stream.readFloat();
			quat.y = stream.readFloat();
			quat.z = stream.readFloat();

			return quat;
		}
	}
}


