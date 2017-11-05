package frEngine.effectEditTool.parser
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Texture3D;
	import baseEngine.modifiers.Modifier;
	import baseEngine.system.Device3D;
	
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.particleControler.LineRoadControler;
	import frEngine.animateControler.skilEffect.SwordLightControler_Bone;
	import frEngine.animateControler.skilEffect.SwordLightControler_Normal;
	import frEngine.animateControler.transformControler.FaceObjectControler;
	import frEngine.animateControler.uvControler.FrUvStepControler;
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.core.mesh.ParticleMesh;
	import frEngine.core.mesh.SwordLightMesh_Bone;
	import frEngine.core.mesh.SwordLightMesh_Normal;
	import frEngine.effectEditTool.lineRoad.LineRoadMesh3D;
	import frEngine.effectEditTool.manager.AnimateControlerManager;
	import frEngine.effectEditTool.manager.MeshLoaderManager;
	import frEngine.effectEditTool.manager.Obj3dContainer;
	import frEngine.effectEditTool.obj3d.EmptyDummy;
	import frEngine.effectEditTool.parser.def.EGeometryType;
	import frEngine.effectEditTool.parser.def.ELayerType;
	import frEngine.effectEditTool.parser.def.ESwordLightType;
	import frEngine.loaders.EngineConstName;
	import frEngine.loaders.particleSub.ParticleParser;
	import frEngine.math.MathConsts;
	import frEngine.primitives.Dummy;
	import frEngine.primitives.FrAnimCylinder;
	import frEngine.primitives.FrCrossPlane;
	import frEngine.primitives.FrCube;
	import frEngine.primitives.FrPlane;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.fragmentFilters.AlphaKillFilter;

	public class ParserLayerObject
	{
		public static const instance:ParserLayerObject = new ParserLayerObject();
		public static const defaultNullStringFlag:String = "未选择";
		private var _particleParser:ParticleParser = new ParticleParser(Device3D.scene.renderLayerList);

		public function ParserLayerObject()
		{

		}

		public function parserLayerHang(container:Obj3dContainer, fromeId:String, toId:String, hangBoneName:String):void
		{
			//var parentLayer:Object = layerObj.parentLayer;
			//var hangObjId:String = parentLayer.hangObjId;
			var curObject:Pivot3D = container.getObject3dByID(fromeId);
			if (!toId || toId.length == 0)
			{
				if (curObject.curHangControler)
				{
					curObject.curHangControler.removeHang(curObject);
					curObject.curHangControler = null;
				}
				if (curObject.parent != container)
				{
					curObject.parent = container
				}
				return;
			}

			var targetHangObject:Pivot3D = container.getObject3dByID(toId);
			if (!targetHangObject)
			{
				return;
			}
			if (hangBoneName)
			{
				var skin:Md5SkinAnimateControler = targetHangObject.getAnimateControlerInstance(AnimateControlerType.Md5SkinAnimateControler) as Md5SkinAnimateControler
				skin && skin.attachObjectToBone(hangBoneName, curObject);
			}
			else
			{
				if (curObject.curHangControler)
				{
					curObject.curHangControler.removeHang(curObject);
					curObject.curHangControler = null;
				}
				targetHangObject.addChild(curObject);
				curObject.identityOffsetTransform();
			}

		}

		public function parserParentLayer(container:Obj3dContainer, parentLayer:Object, showHang:Boolean,$renderList:RenderList):void
		{
			var obj3d:Mesh3D;
			switch (parentLayer.type)
			{
				case ELayerType.Model:
					obj3d = addMeshLayer(parentLayer,$renderList);
					break;
				case ELayerType.Geometry:
					obj3d = addGeometryLayer(parentLayer,$renderList);
					break;
				case ELayerType.DaoGuang:
					obj3d = addSwordLightLayer(parentLayer,$renderList);
					break;
				case ELayerType.Particle:
					obj3d = addParticleLayer(parentLayer,$renderList);
					break;
				case ELayerType.Hang: //虚拟层
					obj3d = addContainerLayer(parentLayer, showHang,$renderList);
					break;
				case ELayerType.Road:
					obj3d = addLineRoadLayer(parentLayer, showHang,$renderList);
					break;
			}

			container.registerObject(parentLayer.uid, obj3d);

			container.addChild(obj3d);

			setObj3dBaseLayerAttributes(obj3d, parentLayer);
			createTargetControler(obj3d, parentLayer.frameBlock.keyFrames, AnimateControlerType.VisibleContoler ,"visible");
			
			setObj3dMaterialProperty(obj3d, parentLayer);
		}

		public function parserChildrenLayer(container:Obj3dContainer, parentLayerUid:String, childLayers:Array):void
		{
			var obj3d:Pivot3D=container.getObject3dByID(parentLayerUid);
			
			var len:int = childLayers.length;
			for (var i:int = 0; i < len; i++)
			{
				var childLayer:Object = childLayers[i];
				var animTypeName:String=childLayer.type
				var animatType:int = AnimateControlerManager.getAnimateTypeByFlag(animTypeName);
				var animateControler:Modifier = createTargetControler(obj3d, childLayer.frameBlock.keyFrames, animatType,animTypeName);
				if (animateControler is FrUvStepControler)
				{
					var _uvControler:FrUvStepControler = FrUvStepControler(animateControler);
					_uvControler.init(new Point(childLayer.uNum, childLayer.vNum), childLayer.cycleInterval, childLayer.cycleType);
				}
				else if(childLayer.lineRoadUid)
				{
					var _lineRoadControler:LineRoadControler = LineRoadControler(animateControler);
					var targetHangObject:LineRoadMesh3D = container.getObject3dByID(childLayer.lineRoadUid) as LineRoadMesh3D;
					_lineRoadControler.init(targetHangObject,childLayer.useRot);
				}
					
			}

		}

		private function setObj3dMaterialProperty(obj3d:Mesh3D, params:Object):void
		{

			obj3d.setLayer(params.layerIndex, false);
			params.materialAlpha && (obj3d.materialPrams.alphaBase = params.materialAlpha);
			var materialUrl:String = checkFileName(params.materialUrl);
			if (materialUrl)
			{
				var noUseMip:Boolean=(obj3d is Md5Mesh || !params.isOpenMip);
				var mipType:int = ( noUseMip ? Texture3D.MIP_NONE : Texture3D.MIP_LINEAR)
				obj3d.setMaterial(materialUrl, mipType,materialUrl);
			}
			else
			{
				obj3d.setMaterial(0xcccccc, Texture3D.MIP_NONE,"0xcccccc");
			}

			setMaterialBlendMode(obj3d, params.blendType, params.blendCustomSource, params.blendCustomTarget);

			obj3d.materialPrams.depthWrite = params.isDepthWrite;
			obj3d.materialPrams.twoSided = params.materialIsDblFace;

			obj3d.materialPrams.uvRepeat = params.uvRepeat;

			if (params.isOpenMaterialMask && params.materialMaskUrl)
			{
				var textureUrl:String = checkFileName(params.materialMaskUrl)
				obj3d.materialPrams.setMaskRotateAngle(params.materialMaskU, params.materialMaskV, params.materialMaskRotation, textureUrl, params.isShowMask);
			}
			if (params.isOpenUVScale)
			{
				obj3d.materialPrams.uvScaleBase = new Point(params.uvScaleX, params.uvScaleY);
			}
			if (params.isOpenUVOffset)
			{
				obj3d.materialPrams.uvOffsetBase = new Point(params.uvOffsetX, params.uvOffsetY);
			}
			if (params.isOpenUVRotate)
			{
				var value:Number = params.uvRotate * Math.PI / 180;
				obj3d.materialPrams.uvRotateBase = value;
			}
			if (params.isOpenAlphaKil)
			{
				parserAlphaKil(obj3d.materialPrams, true, params.alphaKilValue);
			}
			if (params.isOpenHerizionKil)
			{
				obj3d.materialPrams.isOpenHerizionKil = params.isOpenHerizionKil;
			}
			if(params.isOpenColorOffset)
			{
				obj3d.materialPrams.colorBase=params.colorOffsetValue;
			}
		}

		public function parserAlphaKil(materialPrams:MaterialParams, isOpenAlphaKil:Boolean, alphaKilValue:Number):void
		{
			var _filter:AlphaKillFilter = materialPrams.getFilterByTypeId(FilterType.Fragment_AlphaKill) as AlphaKillFilter;

			if (isOpenAlphaKil)
			{
				if (!_filter)
				{
					_filter = new AlphaKillFilter(alphaKilValue)
					materialPrams.addFilte(_filter);
				}
				_filter.kilValue = alphaKilValue;

			}
			else
			{
				if (_filter)
				{
					materialPrams.removeFilte(_filter);
				}
			}
		}

		public function setMaterialBlendMode(mesh:Mesh3D, blendType:String, src:String, des:String):void
		{
			var blendMode:int = EngineConstName.getBlendModeByName(blendType);
			mesh.setMateiralBlendMode(blendMode, src, des);
		}

		private function setObj3dBaseLayerAttributes(obj3d:Pivot3D, params:Object):void
		{
			var baseLayerAttributes:Array = params.baseLayerAttributes;
			var len:int = baseLayerAttributes.length;
			for (var i:int = 0; i < len; i++)
			{
				var attribute:Object = baseLayerAttributes[i];
				if (attribute.hasOwnProperty("value"))
				{
					var attributeName:String = AnimateControlerManager.changeBaseFlagToProperty(attribute.name);
					attributeName && (obj3d[attributeName] = attribute.value);
				}
			}


		}
		private function addContainerLayer(params:Object, showHang:Boolean,$renderList:RenderList):Mesh3D
		{
			//var layerSpecialAttribute:Object = params.layerSpecialAttribute;
			var newMesh:Mesh3D
			if (showHang)
			{
				newMesh = new Dummy("", 20, 1,0xffffff,1,$renderList);
			}
			else
			{
				newMesh = new EmptyDummy("", false, $renderList);
			}
			
			return newMesh;
		}
		private function addLineRoadLayer(params:Object, showHang:Boolean,$renderList:RenderList):Mesh3D
		{
			//var layerSpecialAttribute:Object = params.layerSpecialAttribute;
			var newMesh:LineRoadMesh3D;
			var layerSpecialAttribute:Object = params.layerSpecialAttribute;

			if (showHang)
			{
				newMesh =new LineRoadMesh3D($renderList);
				newMesh.initLine(layerSpecialAttribute.pointList,layerSpecialAttribute.totalLen);
				newMesh.drawLine();
			}
			else
			{
				newMesh = new LineRoadMesh3D(null);
				newMesh.initLine(layerSpecialAttribute.pointList,layerSpecialAttribute.totalLen);
			} 
			return newMesh;
		}
		
		

		private function addParticleLayer(params:Object,$renderList:RenderList):Mesh3D
		{
			var layerSpecialAttribute:Object = params.layerSpecialAttribute;
			var newMesh:Mesh3D
			var _url:String = checkFileName(layerSpecialAttribute.particleName);
			if (_url)
			{
				var _particle:ParticleMesh = new ParticleMesh("", _url, $renderList, true);
				_particle.useScale = layerSpecialAttribute.useScale;
				_particle.useRotation = layerSpecialAttribute.useRotation
				newMesh = _particle;
			}
			else
			{
				newMesh = new FrCube("",$renderList, 20, 20, 20);
			}

			return newMesh;
		}

		private function addSwordLightLayer(params:Object,$renderList:RenderList):Mesh3D
		{
			var layerSpecialAttribute:Object = params.layerSpecialAttribute;
			var type:String = layerSpecialAttribute.type;
			var len1:Number = layerSpecialAttribute.length1;
			var len2:Number = layerSpecialAttribute.length2;
			var angle:Number = layerSpecialAttribute.angle * MathConsts.DEGREES_TO_RADIANS;
			var animateFrame:int = layerSpecialAttribute.section;
			var spliteNum:int = layerSpecialAttribute.splitNum
			var swordmesh:Mesh3D;
			if (type == ESwordLightType.Bone)
			{
				swordmesh = new SwordLightMesh_Bone("swordMesh", $renderList);
				var swordeffectBone:SwordLightControler_Bone = swordmesh.getAnimateControlerInstance(AnimateControlerType.swordLight_Bone) as SwordLightControler_Bone;
				swordeffectBone.initData(len1, len2, angle, animateFrame, layerSpecialAttribute.offsetY, spliteNum);

			}
			else
			{
				swordmesh = new SwordLightMesh_Normal("swordMesh", $renderList);
				var swordeffectNormal:SwordLightControler_Normal = swordmesh.getAnimateControlerInstance(AnimateControlerType.swordLight_Normal) as SwordLightControler_Normal;
				swordeffectNormal.initData(len1, len2, angle, animateFrame, spliteNum);

			}

			return swordmesh;
		}

		private function addGeometryLayer(params:Object,$renderList:RenderList):Mesh3D
		{
			var layerSpecialAttribute:Object = params.layerSpecialAttribute;
			var _name:String=params.name;
			
			var geometryType:String = layerSpecialAttribute.geometryType;

			var newMesh:Mesh3D;
			if (geometryType == EGeometryType.Cylinder)
			{
				newMesh = new FrAnimCylinder(_name,$renderList, layerSpecialAttribute.upRadius, layerSpecialAttribute.downRadius, layerSpecialAttribute.height, layerSpecialAttribute.edges,null,layerSpecialAttribute.isSphereTexture);
			}
			else if (geometryType == EGeometryType.Plane)
			{

				if (layerSpecialAttribute.isTowardsCamera)
				{
					newMesh = new FrPlane(_name,$renderList, layerSpecialAttribute.width, layerSpecialAttribute.length, null, "+xy");
					createFaceCameraControler(newMesh, layerSpecialAttribute.isRotationAxis, new Vector3D(layerSpecialAttribute.axisX, layerSpecialAttribute.axisY, layerSpecialAttribute.axisZ));
				}
				else
				{
					newMesh = new FrPlane(_name,$renderList, layerSpecialAttribute.width, layerSpecialAttribute.length, null, "+xz");
				}

			}
			else if (geometryType == EGeometryType.CrossPlane)
			{
				newMesh = new FrCrossPlane(_name,$renderList, layerSpecialAttribute.width, layerSpecialAttribute.height,"y",null);
			}
			else
			{
				newMesh = new FrCube(_name,$renderList, 20, 20, 20,1,null);
			}

			return newMesh;
		}

		public function createFaceCameraControler(mesh:Mesh3D, useAsix:Boolean, asix:Vector3D):void
		{
			var faceCameraControler:FaceObjectControler = mesh.getAnimateControlerInstance(AnimateControlerType.NodeFaceObject) as FaceObjectControler;
			if (useAsix)
			{
				faceCameraControler.setFaceObject(Device3D.camera, asix);
			}
			else
			{
				faceCameraControler.setFaceObject(Device3D.camera, null);
			}

		}

		public function checkFileName(fileName:String):String
		{
			if (fileName == "" || fileName == null || fileName == defaultNullStringFlag)
			{
				return null;
			}
			return fileName;
		}

		private function addMeshLayer(params:Object,$renderList:RenderList):Mesh3D
		{
			var layerSpecialAttribute:Object = params.layerSpecialAttribute;

			var actionName:String = layerSpecialAttribute.actionName;
			var boneUrl:String = checkFileName(layerSpecialAttribute.boneUrl);
			var meshUrl:String = checkFileName(layerSpecialAttribute.meshUrl);
			var isCirclePlay:Boolean = layerSpecialAttribute.isCirclePlay
			var newMesh:Mesh3D;
			if (meshUrl)
			{
				newMesh = MeshLoaderManager.getMesh3dByUrl(meshUrl, null, boneUrl, actionName,isCirclePlay, $renderList);
			}
			else
			{
				newMesh = new FrCube("",$renderList, 20, 20, 20);
			}

			return newMesh;

		}

		private function createTargetControler(obj3d:Pivot3D, keyFrames:Array, animType:int ,animName:String):Modifier
		{
			var animate:Modifier = obj3d.getAnimateControlerInstance(animType);
			if (!animate)
			{
				return null;
			}
			animate.parserKeyFrames(keyFrames);
			animate.toUpdateAnimate(true);
			return animate;
		}
	}
}

