package frEngine.loaders.particleSub
{
	import com.gengine.utils.MathUitl;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	
	import frEngine.animateControler.particleControler.PAutoRoationInfo;
	import frEngine.animateControler.particleControler.PEmitterDirectionInfo;
	import frEngine.animateControler.particleControler.ParticleParams;
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.core.mesh.NormalMesh3D;
	import frEngine.effectEditTool.parser.def.ELineType;
	import frEngine.loaders.EngineConstName;
	import frEngine.loaders.particleSub.multyEmmiterType.CurveLineMultyEmmiter;
	import frEngine.loaders.particleSub.multyEmmiterType.IMultyEmmiterType;
	import frEngine.loaders.particleSub.multyEmmiterType.LinearMultyEmmiter;
	import frEngine.loaders.particleSub.multyEmmiterType.PointMultyEmmiter;
	import frEngine.loaders.particleSub.multyEmmiterType.SingleEmmiter;
	import frEngine.math.MathConsts;
	import frEngine.primitives.FrCrossPlane;
	import frEngine.primitives.FrCube;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;

	public class ParticleParser
	{
		private var _particleParams:ParticleParams;
		private var _errorInfo:String;
		private var _renderList:RenderList
		public function ParticleParser($renderList:RenderList)
		{
			_renderList=$renderList
			
		}

		public function parser($particleParams:ParticleParams,fileParams:Object):String
		{
			_particleParams=$particleParams;
			_particleParams.textureURL = fileParams.emitterTextureChoose;
			_particleParams.blendType=EngineConstName.getBlendModeByName(fileParams.blendMode);
			_particleParams.playMode=EngineConstName.getPlayModeByName(fileParams.playMode);
			_errorInfo=null; 
			parserHeadInfo(fileParams);
			parserBaseInfo(fileParams);
			parserEmitterInfo(fileParams);
			parserAnimInfo(fileParams);
			parserMultyEmmiterInfo(fileParams);
			return _errorInfo;
		}
		private function parserMultyEmmiterInfo(fileParams:Object):void
		{
			var _tdata:Vector.<IMultyEmmiterType>=new Vector.<IMultyEmmiterType>();
			_particleParams.multyEmmiters=_tdata;
			if(!fileParams.multyOpen)
			{
				_particleParams.multyEmitterEnabled=false;
				_tdata.push(new SingleEmmiter());
			}else
			{
				_particleParams.multyEmitterEnabled=true;
				_particleParams.multyEmmiterLineType=fileParams.lineType;
				if(_particleParams.multyEmmiterLineType==ELineType.point)
				{
					_particleParams.distanceBirth=_particleParams.tailEnabled=false;
				}
				_particleParams.multyPlaySpeed=fileParams.multyPlaySpeed;
				var typeClass:Class=getMultyEmmiterClass(_particleParams.multyEmmiterLineType);
				var obj:Object=fileParams.emmiterNumCom;
				var arr:Array=obj.data;
				var len:int=arr.length;
				for(var i:int=0;i<len;i++)
				{
					_tdata.push(new typeClass(arr[i].values));
				}
			}
		}
		
		private function getMultyEmmiterClass(lineType:String):Class
		{
			var _class:Class;
			switch(lineType)
			{
				case ELineType.point:		_class=PointMultyEmmiter;		break;
				case ELineType.linear:		_class=LinearMultyEmmiter;		break;
				case ELineType.curveLine:	_class=CurveLineMultyEmmiter;	break;
			}
			return _class;
		}
		public function clear():void
		{
			_particleParams=null;
		}
		private function parserAnimInfo(fileParams:Object):void
		{
			if(_errorInfo)
			{
				return;
			}
			createUvStepAnim(fileParams);
			createForceAnim(fileParams);
			createFrictionAnim(fileParams);
			createColorAnim(fileParams);
			createRotateAnim(fileParams);
			createDistanceBirth(fileParams);
			createGrowthAndFadeAnim(fileParams);
			_particleParams.tailEnabled=fileParams.tailEnabled;
			_particleParams.inertiaValue=fileParams.inertia?fileParams.inertiaValue:0;
			_particleParams.tailMaxDistance=fileParams.tailMaxDistance;
			_particleParams.rotateAxisYSpeed=fileParams.rotateAxisY ? fileParams.rotateAxisYSpeed/10:0;
			
		}
		private function createDistanceBirth(fileParams:Object):void
		{
			_particleParams.distanceBirth=fileParams.distanceBirth;
			_particleParams.birthDistance=fileParams.birthDistance;
		}
		private function createFrictionAnim(fileParams:Object):void
		{
			if(fileParams.frictionEnabled)
			{
				_particleParams.frictionVecor3d=new Vector3D(fileParams.rictionSizeX,fileParams.rictionSizeY,fileParams.rictionSizeZ);
			}else
			{
				_particleParams.frictionVecor3d=null;
			}
		}
		private function createGrowthAndFadeAnim(fileParams:Object):void
		{
			if(fileParams.sizeTimeEnabled)
			{
				_particleParams.isFadeToGrowth=(fileParams.fadeType==EngineConstName.FADETOGROWTH);
				if(_particleParams.isFadeToGrowth)
				{
					_particleParams.fade_time=fileParams.addSizeTime;
					_particleParams.growth_time=fileParams.subSizeTime;
				}else
				{
					_particleParams.growth_time=fileParams.addSizeTime;
					_particleParams.fade_time=fileParams.subSizeTime;
				}	
			}else
			{
				_particleParams.growth_time=0;
				_particleParams.fade_time=0;
			}
		}
		private function createUvStepAnim(fileParams:Object):void
		{
			if(fileParams.uvStepAnim)
			{
				_particleParams.uvStep=new Vector3D(fileParams.uNum,fileParams.vNum,fileParams.uvSpeed,fileParams.uvOffset);
			}else
			{
				_particleParams.uvStep=null;
			}
		}
		private function createForceAnim(fileParams:Object):void
		{
			if(fileParams.useForce)
			{
				var force:Vector3D=new Vector3D(fileParams.forceX,fileParams.forceY,fileParams.forceZ);
				force.normalize();
				force.scaleBy(fileParams.forceSize/100);
				_particleParams.lineForceVecor3d=force;

			}else
			{
				_particleParams.lineForceVecor3d=null;
			}
			
			_particleParams.lixinForceSize=fileParams.useLixinForce?fileParams.lixinForceSize/100:0
			

		}
		private function createRotateAnim(fileParams:Object):void
		{
			if(fileParams.isUseAutoRoation)
			{
				var autoRotationInfo:PAutoRoationInfo=new PAutoRoationInfo();
				autoRotationInfo.type=fileParams.roationType==EngineConstName.axixType2?1:0;
				autoRotationInfo.axis=new Vector3D(fileParams.roationX,fileParams.roationY,fileParams.roationZ);
				autoRotationInfo.axisVar=fileParams.roationVar;
				autoRotationInfo.angle=fileParams.roationAngle;
				autoRotationInfo.angleVar=fileParams.roationAngleVar;
				autoRotationInfo.offsetAngle=fileParams.offsetAngle;
				autoRotationInfo.offsetAngleVar=fileParams.offsetAngleVar;
				_particleParams.autoRotaionInfo=autoRotationInfo;
			}else
			{
				_particleParams.autoRotaionInfo=null;
			}
		}
		private function createColorAnim(fileParams:Object):void
		{
			var _colorsStr:String=fileParams.useColorMixer;
			if(fileParams.isUseAnimationColor && _colorsStr)
			{
				
				var arr:Array=_colorsStr.split(";");
				var len:int=arr.length;
				var _colors:Array=new Array();
				var _alphas:Array=new Array();
				var _ratios:Array=new Array();
				for(var i:int=0;i<len;i++)
				{
					var value:uint=uint(arr[i]);
					var _color:uint = (value & 0x00ffffff);
					value = (value >> 24);
					var _ratio:uint = (value & 0x000000ff);
					_colors.push(_color);
					_alphas.push(1);
					_ratios.push(_ratio);
				}
				_particleParams.setColor(_colors,_alphas,_ratios);
			}else
			{
				_particleParams.setColor(null,null,null);
			}
			
			var _alphaStr:String=fileParams.useAlphaMixer;
			if(fileParams.isUseAnimationAlpha &&　_alphaStr)
			{
				
				arr=_alphaStr.split(";");
				len=arr.length;
				_colors=new Array();
				_alphas=new Array();
				_ratios=new Array();
				for(i=0;i<len;i++)
				{
					value=uint(arr[i]);
					var _alpha:uint = (value & 0x00ff);
					value = (value >> 8);
					_ratio = (value & 0x00ff);
					_colors.push(0xffffff*_alpha/255);
					_alphas.push(1);
					_ratios.push(_ratio);
				}
				_particleParams.setAlpha(_colors,_alphas,_ratios);
			}else
			{
				_particleParams.setAlpha(null,null,null);
			}
		}
		private function parserHeadInfo(fileParams:Object):void
		{
			if(_errorInfo)
			{
				return;
			}
			var _particleMaterialUrl:String = fileParams.texture;
			if(!_particleMaterialUrl || _particleMaterialUrl==EngineConstName.defaultNullStringFlag)
			{
				//_particleMesh.setMaterial(0x999999,true);
				_particleParams.materialUrl=0x999999;
			}else
			{
				_particleParams.materialUrl=_particleMaterialUrl;
			}
			_particleParams.totalTime = int.MAX_VALUE;
			
		}
		
		private function parserBaseInfo(fileParams:Object):void
		{
			if(_errorInfo)
			{
				return;
			}
			_particleParams.life=fileParams.life;
			_particleParams.life_variation=fileParams.life_variation;
			_particleParams.size=fileParams.size;
			_particleParams.size_variation=fileParams.size_variation;
			

			if(_particleParams.instancingObject)
			{
				_particleParams.instancingObject.dispose();
			}
			
			_particleParams.useTimeGrowth=fileParams.useTimeGrowth;
			_particleParams.doubleFace=fileParams.doubleFace;
			_particleParams.randomValue=fileParams.randomValue;
			_particleParams.faceTransform=null;
			_particleParams.faceCamera = false;
			_particleParams.faceMovingDirection = false;
			
			var _matrix3d:Matrix3D=new Matrix3D();

			var particleFaceDirectionType:String=fileParams.particleFaceDirection;
			
			switch(particleFaceDirectionType)
			{
				case EngineConstName.particleFaceDirection0:
					break;
				case EngineConstName.particleFaceDirection1:
					_particleParams.faceCamera = true;
					break;
				case EngineConstName.particleFaceDirection2:
					_particleParams.faceMovingDirection = true;
					break;
				case EngineConstName.particleFaceDirection3:
					_particleParams.faceTransform=_matrix3d; 
					break;
				case EngineConstName.particleFaceDirection4:
					_matrix3d.appendRotation(180,Vector3D.X_AXIS);
					_particleParams.faceTransform=_matrix3d; 
					break;
				case EngineConstName.particleFaceDirection5:
					_matrix3d.appendRotation(90,Vector3D.Z_AXIS);
					_particleParams.faceTransform=_matrix3d; 
					break;
				case EngineConstName.particleFaceDirection6:
					_matrix3d.appendRotation(-90,Vector3D.Z_AXIS);
					_particleParams.faceTransform=_matrix3d; 
					break;
				case EngineConstName.particleFaceDirection7:
					_matrix3d.appendRotation(-90,Vector3D.X_AXIS);
					_particleParams.faceTransform=_matrix3d; 
					break;
				case EngineConstName.particleFaceDirection8:
					_matrix3d.appendRotation(90,Vector3D.X_AXIS);
					_particleParams.faceTransform=_matrix3d; 
					break;
			}
			
			createParticleInstance(fileParams);
		}
		private function createParticleInstance(fileParams:Object):void
		{
			var particleType:String=fileParams.particleType;
			var faceDirection:String;
			if (particleType == EngineConstName.particleType0)
			{
				faceDirection=_particleParams.faceMovingDirection ?"z":"y";
				var _crossPlane:FrCrossPlane=new FrCrossPlane("",null,fileParams.particleShapeWidth , fileParams.particleShapeHeight,faceDirection);
				_particleParams.instancingObject = _crossPlane;
			}else if (particleType == EngineConstName.particleType1)
			{
				var _cube:FrCube=new FrCube("",fileParams.particleShapeWidth , fileParams.particleShapeHeight, fileParams.particleShapeLength);
				_particleParams.instancingObject = _cube;
				
			}else if (particleType == EngineConstName.particleType2)
			{
				var instancingObjectUrl:String = fileParams.particleMesh;
				if(!instancingObjectUrl ||  instancingObjectUrl==EngineConstName.defaultNullStringFlag)
				{
					_errorInfo="选择了粒子形状为mesh，但却没有指定相应的mesh文件";
					return;
				}
				_particleParams.instancingObject = getMesh3dByUrl(instancingObjectUrl,false,null,null,_renderList);
			}else 
			{
				faceDirection=_particleParams.faceCamera ?"+xy":"+xz";
				var _defaultPlane:ParticlePlane= new ParticlePlane(fileParams.particleShapeWidth , fileParams.particleShapeHeight,faceDirection);
				_particleParams.instancingObject = _defaultPlane;
			}
		}

		private static function getMesh3dByUrl($meshUrl:String,isMd5Mesh:Boolean, $framentFilter:FragmentFilter, $boneUrl:String, $renderList:RenderList=null):Mesh3D
		{
			
			var _modle3d:Mesh3D;
			if (isMd5Mesh)
			{
				var md5mesh:Md5Mesh = new Md5Mesh("", $meshUrl,false, $renderList);
				
				_modle3d = md5mesh;
				if ($framentFilter)
				{
					md5mesh.setMaterial($framentFilter, Texture3D.MIP_NONE,$meshUrl);
				}
				if ($boneUrl)
				{
					md5mesh.initAnimate($boneUrl);
				}
			}
			else 
			{
				_modle3d = new NormalMesh3D("",$meshUrl, false, $renderList);
				_modle3d.setMaterial($framentFilter,Texture3D.MIP_NONE,$meshUrl);
			}
			return _modle3d;
		}
		
		private function parserEmitterInfo(fileParams:Object):void
		{
			if(_errorInfo)
			{
				return;
			}
			_particleParams.emmitCountType=(fileParams.emitCountType==EngineConstName.emmitCount?1:0);
			_particleParams.birth_rate=fileParams.birth_rate;
			_particleParams.total_number=fileParams.birth_count;

			var emitType:String=fileParams.emitType;
			switch(emitType)
			{
				case EngineConstName.emitTime0:
					_particleParams.emitterTime=1;
					break;
				case EngineConstName.emitTime1:
					_particleParams.emitterTime=fileParams.emitter_stop;
					break;
				case EngineConstName.emitTime2:
					_particleParams.emitterTime=int.MAX_VALUE
					break;
			}

			var directionInfo:PEmitterDirectionInfo=new PEmitterDirectionInfo(_particleParams.randnomArr);
			directionInfo.isRandom=fileParams.roundType==EngineConstName.linearFlag?false:true;
			directionInfo.motionType=EngineConstName.getMotionType(fileParams.motionType);
			directionInfo.direction_vector_x=fileParams.direction_vector_x
			directionInfo.direction_vector_y=fileParams.direction_vector_y
			directionInfo.direction_vector_z=fileParams.direction_vector_z
			directionInfo.directionVariation=fileParams.directionVariation;
			directionInfo.herizonAngle=fileParams.herizonAngle*MathConsts.DEGREES_TO_RADIANS;
			_particleParams.directionInfo=directionInfo;
			parserEmitterType(fileParams);
			
			_particleParams.speed=fileParams.speed;
			_particleParams.speed_variation=fileParams.speed_variation;
			
		}

		private function parserEmitterType(fileParams:Object):void
		{
			if(_errorInfo)
			{
				return;
			}
			_particleParams.formation=fileParams.formation;
			var emitterPosType:String=fileParams.emitPlace;
			if (_particleParams.formation == EngineConstName.emitterShapeChoose6)
			{
				var emitterUrl:String = fileParams.emitterShapeChoose;
				if(!emitterUrl ||  emitterUrl==EngineConstName.defaultNullStringFlag)
				{
					_errorInfo="选择了发射器为mesh，但却没有指定相应的mesh文件";
					return;
				}
				var node:Mesh3D =getMesh3dByUrl(emitterUrl,false,null,null,_renderList);
				
				_particleParams.emitterObject = new NodeEmitter(node,emitterPosType,_particleParams.randnomArr);
			}
			else
			{
				
				var w:Number = _particleParams.emitter_width=fileParams.emitter_width
				var h:Number = _particleParams.emitter_height=fileParams.emitter_height
				var l:Number = _particleParams.emitter_length=fileParams.emitter_length
				var r:Number = _particleParams.emitter_rad=fileParams.emitter_rad;
				var topR:Number = _particleParams.emitter_rad=fileParams.emitterShapeTopR;
				var bottomR:Number = _particleParams.emitter_rad=fileParams.emitterShapeBottomR;
				
				switch (_particleParams.formation)
				{
					case EngineConstName.emitterShapeChoose0:
						_particleParams.emitterObject = new SphereEmitter(r,1,emitterPosType,_particleParams.randnomArr);
						break;
					case EngineConstName.emitterShapeChoose1:
						_particleParams.emitterObject = new RoundEmitter(r,emitterPosType,_particleParams.randnomArr,_particleParams.directionInfo.isRandom);
						break;
					case EngineConstName.emitterShapeChoose2:
						_particleParams.emitterObject = new SphereEmitter(r,0.5,emitterPosType,_particleParams.randnomArr);
						break;
					case EngineConstName.emitterShapeChoose3:
						_particleParams.emitterObject = new CylinderEmitter(topR ,bottomR, h,emitterPosType,_particleParams.randnomArr); 
						break;
					case EngineConstName.emitterShapeChoose4:
						_particleParams.emitterObject = new BoxEmitter(w , h , l,emitterPosType,_particleParams.randnomArr);
						break;
					case EngineConstName.emitterShapeChoose5:
						_particleParams.emitterObject = new PlaneEmitter(w , h ,emitterPosType,_particleParams.randnomArr);
						break;
				}
			}
		}
	}
}