package frEngine.animateControler
{
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Label3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.PlayMode;
	import baseEngine.system.Device3D;
	import baseEngine.utils.SplitSurfaceInfo;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.loaders.away3dMd5.AnimationClipNodeBase;
	import frEngine.loaders.away3dMd5.SkeletonAnimationSet;
	import frEngine.loaders.away3dMd5.SkeletonAnimator;
	import frEngine.loaders.away3dMd5.SkeletonClipNode;
	import frEngine.render.IRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.fragmentFilters.LightFilter;
	import frEngine.shader.filters.vertexFilters.Md5EdgeFilter;
	import frEngine.shader.filters.vertexFilters.ShadowVertexFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.VcParam;

	public class Md5SkinAnimateControler extends MeshAnimateBase implements IRender
	{
		public var startIndex:Array;
		public var triangleNum:Array;
		public var skinData:Vector.<Vector.<int>>;
		
		protected var attachObjectToBoneList:Dictionary = new Dictionary(false);
		protected var attachObjectOffsetMatrix:Dictionary = new Dictionary(false);
		protected var meshList:Dictionary = new Dictionary(false);
		public static var defaultOffsetMatrix3d:Matrix3D = getDefaultMatrix3d();
		
		private var _mapBoneNameIndex:Dictionary;
		private var tracksMap:Dictionary = new Dictionary(false);
		private var _tempMatrix3d:Matrix3D = new Matrix3D();
		private var _bonesRegister:VcParam;
		private var _depthBonesRegister:VcParam;
		private var _edgeBonesRegister:VcParam;
		private var _shadowBonesRegister:VcParam;
		private var _bonesVecter:Vector.<Number>;
		private var _frameList:Dictionary;
		public var depthMaterial:ShaderBase;
		public var edgeMaterial:ShaderBase;
		public var shadowMaterial:ShaderBase;
		
		public var tracksCache:Dictionary = new Dictionary(false);
		public var depthColorRegister:FcParam;
		public var skeletoAnimator:SkeletonAnimator;
		private static var _noTrackNameMatrix3d:Matrix3D;

		private var _noTrackNameVectorList:Array = new Array();
		private static const _drawEdgeParams:MaterialParams = new MaterialParams();
		private var _matrix3d:Matrix3D = Device3D.global;
		public var animationMode:int = PlayMode.ANIMATION_STOP_MODE;

		public function Md5SkinAnimateControler()
		{
			super();
			_drawEdgeParams.depthWrite = false;
			_drawEdgeParams.twoSided = false;

		}

		private static function getDefaultMatrix3d():Matrix3D
		{

			var _defaultOffsetMatrix3d:Matrix3D = new Matrix3D();
			_defaultOffsetMatrix3d.appendRotation(-90, Vector3D.Y_AXIS);
			_defaultOffsetMatrix3d.appendRotation(90, Vector3D.X_AXIS);
			return _defaultOffsetMatrix3d;

		}

		protected override function updateCurFrame():void
		{
			var disframe:Number = targetMesh.timerContorler.curFrame;
			var frameLen:int = cuPlayLable.length;
			var _local1:Boolean;
			if (disframe >= frameLen)
			{
				if (animationMode == PlayMode.ANIMATION_LOOP_MODE)
				{
					disframe = disframe % frameLen;
				}
				else
				{
					disframe = frameLen - 1;
				}
			}
			else if (disframe < 0)
			{
				if (animationMode == PlayMode.ANIMATION_LOOP_MODE)
				{
					disframe = (frameLen - 1) + disframe % frameLen;
				}
				else
				{
					disframe = 0;
				}
			}
			this.currentFrame = cuPlayLable.from + disframe;
		}

		public override function dispose():void
		{
			_bonesRegister = null;
			_depthBonesRegister = null;
			_edgeBonesRegister = null;
			_bonesVecter = null;
			_shadowBonesRegister=null;
			_frameList = null;
			depthMaterial = null;
			edgeMaterial = null;
			tracksCache = null;
			depthColorRegister = null;
			shadowMaterial=null;
			if (skeletoAnimator)
			{
				skeletoAnimator.dispose();
			}
			skeletoAnimator = null;

			removeAllHang();
			super.dispose();
		}

		public function removeAllHang():void
		{
			var arr:Array = new Array();
			for (var obj:* in attachObjectToBoneList)
			{
				arr.push(obj);
			}
			for each (obj in arr)
			{
				this.removeHang(obj);
			}
		}

		public override function get type():int
		{
			return AnimateControlerType.Md5SkinAnimateControler;
		}

		private function cloneFrom(targetMd5Controler:Md5SkinAnimateControler):void
		{
			this.labels = targetMd5Controler.labels;
			this.tracksCache = targetMd5Controler.tracksCache;
			this.depthMaterial = targetMd5Controler.depthMaterial;
			this.edgeMaterial = targetMd5Controler.edgeMaterial;
			this.shadowMaterial=targetMd5Controler.shadowMaterial;
			targetMesh.bounds = targetMd5Controler.targetMesh.bounds;
		}

		protected override function setMaterialHander(e:Event):void
		{
			super.setMaterialHander(e);
			if (!instance)
			{

				depthMaterial = new ShaderBase("depthMaterial", normalMaterial.vertexFilter, new ColorFilter(1, 0, 0, 0), null);

				/*var edgeMaterialParams:MaterialParams=new MaterialParams();
				edgeMaterial = new ShaderBase("", new EdgeFilter2(this.maxBone), new ColorFilter(1, 1, 1, 1),edgeMaterialParams);*/

				var edgeMaterialParams:MaterialParams = new MaterialParams();

				var skinNun:uint = TransformFilter(normalMaterial.vertexFilter).skinNum
				edgeMaterialParams.addFilte(new Md5EdgeFilter(skinNun));

				edgeMaterial = new ShaderBase("edgeMaterial", normalMaterial.vertexFilter, new ColorFilter(1, 1, 1, 1), edgeMaterialParams);

				shadowMaterial = new ShaderBase("shadowMaterial", new ShadowVertexFilter(skinNun), new ColorFilter(0, 0, 0, 0.3), null);

				if (Device3D.openSunLight)
				{ 
					normalMaterial.materialParams.addFilte(new LightFilter(skinNun));
				}
				
				

			}
		}


		public function addAnimateTracks(animator:SkeletonAnimator, _defaultPlayLable:String):void
		{
			skeletoAnimator = animator;
			var aset:SkeletonAnimationSet = skeletoAnimator.animationSet;
			var animations:Vector.<AnimationClipNodeBase> = aset.animations;
			for (var i:int = 0; i < animations.length; i++)
			{
				this.addLabel(animations[i]);
			}
			if (curPlayTrackName == null && _defaultPlayLable)
			{
				this.setPlayLable(_defaultPlayLable);
			}
			else if (!cuPlayLable)
			{
				this.setPlayLable(animations[0]);
			}
			else
			{
				var lable:Label3D=this.setPlayLable(cuPlayLable.trackName);
				if(!lable)
				{
					throw new Error("当前动作："+cuPlayLable.trackName+"不存在！");
				}
			}
			this.dispatchEvent(new Event(Engine3dEventName.InitComplete));
		}

		public function removeHang(mesh:Pivot3D):void
		{

			delete attachObjectToBoneList[mesh];
			delete attachObjectOffsetMatrix[mesh];
			delete meshList[mesh];
			mesh.identityOffsetTransform();
			mesh.curHangControler = null;
			mesh.parent=null;
		}

		public function attachObjectToBone(boneName:String, mesh:Pivot3D, offsetMatrix3d:Matrix3D = null):void
		{

			if (mesh.parent != targetMesh && targetMesh)
			{
				targetMesh.addChild(mesh);
			}

			if (mesh.curHangControler && mesh.curHangControler != this)
			{
				mesh.curHangControler.removeHang(mesh);
			}
			attachObjectToBoneList[mesh] = boneName;
			if (offsetMatrix3d == null)
			{
				offsetMatrix3d = defaultOffsetMatrix3d;
			}
			attachObjectOffsetMatrix[mesh] = offsetMatrix3d;
			mesh.curHangControler = this;
			meshList[mesh] = null;
		}

		public override function setPlayLable(label:Object, targetFrame:int = 0):Label3D
		{

			var lable2:Label3D = super.setPlayLable(label, targetFrame);
			var md5track:SkeletonClipNode = lable2 as SkeletonClipNode;

			for (var mesh:Object in attachObjectToBoneList)
			{
				delete meshList[mesh];
			}

			if (md5track && skeletoAnimator)
			{
				skeletoAnimator.play(md5track.trackName, this.currentFrame);

				_frameList = tracksCache[md5track.trackName];
				checkFrameList();

				//skeletoAnimator.updateFrame(this.currentFrame);
				updateAttachBone();

			}
			return md5track;
		}



		private function autoPlaySeting():void
		{
			if (this.autoPlay)
			{
				for each (var p:Label3D in labels)
				{
					this.setPlayLable(p);
					break;
				}
			}
			checkFrameList();
		}

		private function checkFrameList():void
		{
			if (_frameList == null)
			{
				_frameList = tracksCache[curPlayTrackName] = new Dictionary(false);
				var surfaceNum:int = startIndex.length;
				for (var i:int = 0; i < surfaceNum; i++)
				{
					_frameList[i] = new Array();
				}
				_frameList["bone"] = new Array();
			}
		}

		public function clear():void
		{
			startIndex=null;
			triangleNum=null;
			skinData=null;
			skeletoAnimator=null;
			tracksCache=new Dictionary(false);
			_frameList=null;
			/*normalMaterial=null;
			depthMaterial=null;
			edgeMaterial=null;
			shadowMaterial=null;*/
			
		}
		public function initComplete(spliteInfo:SplitSurfaceInfo):void
		{
			//targetMesh.rotateY(90);
			this.startIndex = spliteInfo.startIndex;
			this.triangleNum = spliteInfo.triangleNum;
			this.skinData = spliteInfo.skinData;

			if (instance)
			{
				cloneFrom(Md5SkinAnimateControler(instance));
			}
			else
			{
				targetMesh.updateBoundings();
				autoPlaySeting();
			}

		}


		public function completeDraw(mesh:Mesh3D):void
		{
			if (normalMaterial)
			{
				normalMaterial.drawLeftNums(mesh, targetSurface);
			}
		}


		public override function toUpdateAnimate(forceUpdate:Boolean = false):void
		{
			super.toUpdateAnimate(forceUpdate);
			if (skeletoAnimator && this.changeFrame)
			{
				skeletoAnimator.updateFrame(this.currentFrame);
				updateAttachBone();
			}

		}

		public function getJointIndexFromName(name:String):int
		{
			if(skeletoAnimator)
			{
				return skeletoAnimator.getJointIndexFromName(name);
			}else
			{
				return -1;
			}
		}
		protected function updateAttachBone():void
		{
			for (var mesh:Object in attachObjectToBoneList)
			{
				var boneArr:Array = meshList[mesh];
				if (!boneArr)
				{
					meshList[mesh] = boneArr = new Array();
				}
				var m:Matrix3D = boneArr[this.currentFrame];
				if (!m)
				{
					var p:String = attachObjectToBoneList[mesh];
					var offsetMatrix:Matrix3D = attachObjectOffsetMatrix[mesh];
					var boneMatrix:Matrix3D = skeletoAnimator.getBoneGlobleTransformByName(p);

					m = new Matrix3D();
					m.copyFrom(boneMatrix);
					m.prepend(offsetMatrix);
					boneArr[this.currentFrame] = m
						//m.append( targetMesh.world );
				}
				mesh.offsetTransform = m;
					//mesh.setTransform(m,true);
			}
		}

		public function drawEdge(mesh:Mesh3D, edgeColor:Number = 0xffffff):void
		{

			if (!targetSurface || !edgeMaterial || !this.startIndex)
			{
				return;
			}
			
			var toReBuiderProgram:Boolean=edgeMaterial.toReBuiderProgram;
			
			var hasPrepared:Boolean = edgeMaterial.hasPrepared(mesh, targetSurface);
			
			if (!_edgeBonesRegister || toReBuiderProgram)
			{
				_edgeBonesRegister = edgeMaterial.getParam("{bones}", true);
			}
			
			if (!hasPrepared)
			{
				return;
			}
			

			var materialPrams:MaterialParams = mesh.materialPrams;
			drawImp(_edgeBonesRegister, edgeMaterial, materialPrams.cullFace, false, materialPrams.sourceFactor, materialPrams.destFactor);

		}


		public function drawShadow(mesh:Mesh3D):void
		{
			if (!targetSurface || !shadowMaterial || !this.startIndex)
			{
				return;
			}
			var toReBuiderProgram:Boolean=shadowMaterial.toReBuiderProgram;
			
			var hasPrepared:Boolean = shadowMaterial.hasPrepared(mesh, targetSurface);
			
			if (!_shadowBonesRegister || toReBuiderProgram)
			{
				_shadowBonesRegister = shadowMaterial.getParam("{bones}", true);
			}
			
			if(!hasPrepared)
			{
				return;
			}
			

			drawImp(_shadowBonesRegister, shadowMaterial, Context3DTriangleFace.BACK, false, Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		}
		
		public function drawDepth(mesh:Mesh3D, objectColor:Number = 0, $alpha:Number = 1):void
		{
			if (!targetSurface || !depthMaterial || !this.startIndex)
			{
				return;
			}
			var toReBuiderProgram:Boolean=depthMaterial.toReBuiderProgram;
			
			var hasPrepared:Boolean = depthMaterial.hasPrepared(mesh, targetSurface);
			
			if (!_depthBonesRegister || toReBuiderProgram)
			{
				_depthBonesRegister = depthMaterial.getParam("{bones}", true);
				depthColorRegister = depthMaterial.getParam(FilterName.COLOR, false);
			}
			
			if(!hasPrepared)
			{
				return;
			}
			

			depthColorRegister.value[0] = objectColor;
			depthColorRegister.value[3] = $alpha;

			drawImp(_depthBonesRegister, depthMaterial, mesh.materialPrams.cullFace, true, Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
		}

		public function draw(mesh:Mesh3D, material:ShaderBase = null):void
		{
			if (!targetSurface || !normalMaterial || !this.startIndex)
			{
				return;
			}
			var toReBuiderProgram:Boolean=normalMaterial.toReBuiderProgram;
			
			var hasPrepared:Boolean = normalMaterial.hasPrepared(mesh, targetSurface);
			
			if (!_bonesRegister || toReBuiderProgram)
			{
				_bonesRegister = normalMaterial.getParam("{bones}", true);
			}
			
			if(!hasPrepared)
			{
				return;
			}
			

			var materialPrams:MaterialParams = targetMesh.materialPrams;
			drawImp(_bonesRegister, normalMaterial, materialPrams.cullFace, materialPrams.depthWrite, materialPrams.sourceFactor, materialPrams.destFactor);

		}

		private function drawImp($bonesRegister:VcParam, $material:ShaderBase, cullFace:String, depthWrite:Boolean, sourceFactor:String, destFactor:String):void
		{
			if (!$bonesRegister)
			{
				return;
			}

			_matrix3d.copyFrom(targetMesh.world);

			var surfaceNum:int = startIndex.length;
			var _surfaceIndex:int = 0

			if (skeletoAnimator)
			{
				for (_surfaceIndex = 0; _surfaceIndex <surfaceNum; _surfaceIndex++)
				{
					_bonesVecter = _frameList[_surfaceIndex][this.currentFrame];
					if (!_bonesVecter)
					{
						_bonesVecter = skeletoAnimator.getGlobalMatrices(this.skinData[_surfaceIndex]);
						_frameList[_surfaceIndex][this.currentFrame] = _bonesVecter

					}
					$bonesRegister.value = _bonesVecter;
					$material.draw(targetMesh, targetSurface,Context3DCompareMode.LESS_EQUAL, cullFace, depthWrite, sourceFactor, destFactor, this.startIndex[_surfaceIndex], this.triangleNum[_surfaceIndex]);

				}
			}
			else
			{
				for (_surfaceIndex = 0; _surfaceIndex < surfaceNum; _surfaceIndex++)
				{
					_bonesVecter = _noTrackNameVectorList[_surfaceIndex];
					if (!_bonesVecter)
					{
						_bonesVecter = getNoTrack(_surfaceIndex);
						_noTrackNameVectorList[_surfaceIndex] = _bonesVecter
					}
					$bonesRegister.value = _bonesVecter;
					$material.draw(targetMesh, targetSurface,Context3DCompareMode.LESS_EQUAL, cullFace, depthWrite, sourceFactor, destFactor, this.startIndex[_surfaceIndex], this.triangleNum[_surfaceIndex]);
				}
			}

			Device3D.objectsDrawn++;
		}

		private function getNoTrack(_surfaceIndex:uint):Vector.<Number>
		{
			if (!_noTrackNameMatrix3d)
			{
				_noTrackNameMatrix3d = new Matrix3D();
				_noTrackNameMatrix3d.appendRotation(180, Vector3D.Y_AXIS);
			}
			var _noTrackNameVector:Vector.<Number> = new Vector.<Number>();
			var _curNum:int = 0;
			var _boneIndexList:Vector.<int> = this.skinData[_surfaceIndex];
			var _len:int = _boneIndexList.length;
			while (_curNum < _len)
			{
				_noTrackNameMatrix3d.copyRawDataTo(_noTrackNameVector, _curNum * 12, true);
				_curNum++;
			}
			return _noTrackNameVector;
		}

		public function getMeshHangBoneName(obj3d:Pivot3D):String
		{
			return attachObjectToBoneList[obj3d];
		}

	}
}
