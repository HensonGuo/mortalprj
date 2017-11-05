package frEngine.animateControler.particleControler
{
	import com.gengine.utils.MathUitl;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.effectEditTool.parser.def.ELineType;
	import frEngine.loaders.particleSub.EmitterObject;
	import frEngine.loaders.particleSub.EmitterPosType;
	import frEngine.loaders.particleSub.multyEmmiterType.IMultyEmmiterType;
	import frEngine.math.MathConsts;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.vertexFilters.ParticleVertexFilter;

	public class ParticleParams extends EventDispatcher
	{
		private static const _shape:Shape = new Shape();
		public static const bitmapHeight:int=2;
		public var multyEmitterEnabled:Boolean;
		public var distanceBirth:Boolean ;
		public var inertiaValue:Number=0; 
		public var birthDistance:int = 1;
		public var multyEmmiters:Vector.<IMultyEmmiterType>
		public var blendType:int;
		public var playMode:int;
		public var materialUrl:*;
		public var doubleFace:Boolean;
		public var randomValue:int=0;
		public var textureURL:String; 
		public var useTimeGrowth:Boolean ;
		public var lineForceVecor3d:Vector3D; 
		public var randnomArr:Array=new Array();
		public var frictionVecor3d:Vector3D;
		public var rotateAxisYSpeed:Number;
		public var lixinForceSize:Number;
		public var autoRotaionInfo:PAutoRoationInfo
		public var formation:String
		public var emitter_rad:Number = 0;
		public var emitter_width:Number = 0;
		public var emitter_height:Number = 0;
		public var emitter_length:Number = 0;

		public var emmitCountType:uint=0;
		public var birth_rate:Number = 0;
		public var total_number:uint = 0;
		public var speed:Number = 0;
		public var speed_variation:Number = 0;
		public var speed_direction_variation:Number = 0;
		public var directionInfo:PEmitterDirectionInfo;
		public var emitterTime:int = 0;

		public var display_until:int = 0;
		public var life:int = 0;
		public var life_variation:int = 0;
		public var size:Number = 0;
		public var size_variation:Number = 0;
		
		public var growth_time:Number = 0;
		public var fade_time:Number = 0;
		public var isFadeToGrowth:Boolean;
		
		public var seed:Number = 0;
		public var totalTime:int = 0;
		public var particleTyp:uint = 0;
		public var standardparticle:uint = 0;
		public var metaparticle_tension:Number = 0;
		public var metaparticle_tension_variation:Number = 0;
		public var motionMultiplier:Number = 1; //惯性指数
		public var emitterObject:EmitterObject;
		public var faceTransform:Matrix3D;
		public var instancingObject:Mesh3D;
		public var faceCamera:Boolean;
		public var faceMovingDirection:Boolean;
		public var uvStep:Vector3D;
		public var maxDuring:Number = 0;
		
		public var tailEnabled:Boolean ;
		public var tailMaxDistance:int = 0;
		
		public var perParticleEmitterTime:Number;
		public var emitterTimeEffectPeriod:Number; //有效发射时间

		private var _useColor:Boolean ;
		private var _useAlpha:Boolean ;
		private var _dataTexture:Texture3D;
		public var targetSurface:FrSurface3D;
		public var hasBuildSurface:Boolean;
		public var hasInitData:Boolean;
		public var  emmiterNum:int;
		public var multyPlaySpeed:int=0;
		public var multyEmmiterLineType:String;
		
		public var useScale:Boolean;
		public var useRotation:Boolean;
		
		private var _colorBitmapData:BitmapData
		public function ParticleParams()
		{
			targetSurface=new FrSurface3D("");
		}
		public function startBuild():void
		{
			initData();
			
			emmiterNum=multyEmmiters.length;
			for(var i:int=0;i<emmiterNum;i++)
			{
				multyEmmiters[i].initData(this);
			}
			
			targetSurface.clear();
			
			checkAndBuildSurface(null);
		}

		private function checkAndBuildSurface(e:Event = null):void
		{
			if (!instancingObject || !emitterObject)
			{
				return;
			}

			if (instancingObject.getSurfacesLen() > 0 && emitterObject.initComplete)
			{
				if(emitterObject.emitterPosType == EmitterPosType.TextureRGB && (!emitterObject.isBitmapDataInited || textureURL != emitterObject.lastURL))
				{
					hasBuildSurface=false;
					emitterObject.removeEventListener(Engine3dEventName.InitComplete, checkAndBuildSurface);
					emitterObject.addEventListener(Engine3dEventName.InitComplete, checkAndBuildSurface);
					emitterObject.initTexture(textureURL);
					
				}
				else
				{
					hasBuildSurface=true;
					builderSurfaceImp();
					instancingObject.removeEventListener(Engine3dEventName.SetMeshSurface, checkAndBuildSurface);
					emitterObject.removeEventListener(Engine3dEventName.InitComplete, checkAndBuildSurface);
				}
			}
			else
			{
				hasBuildSurface=false;
				instancingObject.addEventListener(Engine3dEventName.SetMeshSurface, checkAndBuildSurface);
				emitterObject.addEventListener(Engine3dEventName.InitComplete, checkAndBuildSurface);
				
			}
		}
		private function builderSurfaceImp():void
		{
			
			var instancingObject_surface:FrSurface3D = instancingObject.getSurface(0);
			
			var numVertexs:uint = instancingObject_surface.getVertexNum();
			
			createParticlePosOffsetVertex(targetSurface,numVertexs);
			useSpeed && createPerSpeed(targetSurface, numVertexs);
			createParticleVertex(targetSurface,numVertexs);
			createParticleUV(targetSurface,numVertexs);
			createPerParticleTime(targetSurface, numVertexs); 
			if (autoRotaionInfo)
			{
				createAutoRoationAngle(targetSurface, numVertexs);
				if(!faceCamera)
				{
					createAutoRoationAxis(targetSurface, numVertexs);
				}
			}
			if(_useAlpha || _useColor)
			{
				dateaTexture.request=_colorBitmapData;
			}
			hasBuildSurface=true;
			this.dispatchEvent(new Event(Engine3dEventName.InitComplete));
		}
		
		private function initData():void
		{
			var minTime:int=Math.min(life, emitterTime)
			if (emmitCountType == 1)//发射总数
			{
				/*if (life < emitterTime)
				{
					life = emitterTime / total_number;
					total_number = Math.ceil(life / life);
					life = life * total_number;
					emitterTimeEffectPeriod = life;
				}
				else
				{*/
					emitterTimeEffectPeriod = minTime; //emitterTimeEffectPeriod=emitterTime
				//}
			}
			else
			{
				
				total_number = int(birth_rate * minTime);
				total_number = total_number < 1 ? 1 : total_number;
				emitterTimeEffectPeriod = minTime;
			}
			
			//tailEnabled && !multyEmitterEnabled && 
			if(total_number>ParticleVertexFilter.maxConstRegistNum)
			{
				total_number=ParticleVertexFilter.maxConstRegistNum;
			}
			
			randnomArr.length=0;
			var randomLen:int=total_number+5;
			var i:int;
			if(randomValue==0)
			{
				for(i=0;i<randomLen;i++)
				{
					randnomArr.push(Math.random());	
				}
			}else
			{
				MathUitl.setSeed(randomValue);
				for(i=0;i<randomLen;i++)
				{
					randnomArr.push(MathUitl.getNext());	
				}
			}
			
			var _num:Number=Math.max(emitterTime,life) / life
				
			maxDuring = int(_num);


			/*if(multyEmitterEnabled)
			{
				
			}else
			{
				distanceBirthNum=distanceBirth?20:1;
			}*/

			perParticleEmitterTime=emitterTimeEffectPeriod / total_number;
			
			hasInitData=true;
			
		}
		
		private function createAutoRoationAngle(surface:FrSurface3D, numVertex:uint):void
		{
			var frvertexBuffer:FrVertexBuffer3D = surface.addVertexData(FilterName_ID.PARAM3_ID, 2, true, null);
			
			var vect:Vector.<Number> = frvertexBuffer.vertexVector;
			
			var angle:Number = autoRotaionInfo.angle * MathConsts.DEGREES_TO_RADIANS / 2;
			var disAngle:Number = autoRotaionInfo.angleVar * angle;
			var baseAngle:Number = angle - disAngle;
			var angleRandomValue:Number = disAngle * 2;
			
			var offsetAngle:Number = autoRotaionInfo.offsetAngle * MathConsts.DEGREES_TO_RADIANS / 2;
			var disOffsetAngle:Number = autoRotaionInfo.offsetAngleVar * offsetAngle;
			var baseOffsetAngle:Number = offsetAngle - disOffsetAngle;
			var offsetAngleRandomValue:Number = disOffsetAngle * 2;
			
			var resultAngle:Number;
			var resultOffsetAngle:Number;
			var emitterNum:int=multyEmmiters.length;
			
			
			
			for(var n:int=0;n<emitterNum;n++)
			{
				var distanceBirthNum:int=multyEmmiters[n].distanceBirthNum;
				for(var k:int=0;k<distanceBirthNum;k++)
				{
					for (var i:int = 0; i < total_number; i++)
					{
						var _random:Number=randnomArr[i];
						resultAngle = baseAngle + angleRandomValue * _random;
						resultOffsetAngle = baseOffsetAngle + offsetAngleRandomValue * _random;
						for (var j:int = 0; j < numVertex; j++)
						{
							vect.push( resultAngle, resultOffsetAngle);
						}
					}
				}
			}
			
			
		}
		
		private function createParticleUV(surface:FrSurface3D,numVertex:uint):void
		{
			var frvertexBuffer:FrVertexBuffer3D = surface.addVertexData(FilterName_ID.UV_ID, 2, true, null);
			var uvVect:Vector.<Number> = frvertexBuffer.vertexVector;
			var instancingObject_surface:FrSurface3D = instancingObject.getSurface(0);
			var uvBuffer:FrVertexBuffer3D = instancingObject_surface.getVertexBufferByNameId(FilterName_ID.UV_ID)
			var instancingObject_uvVector:Vector.<Number> = uvBuffer.vertexVector;
			var sizePerVertex:int = uvBuffer.sizePerVertex;
			var offset:int = uvBuffer.bufferVoMap[FilterName_ID.UV_ID].offset;
			var emitterNum:int=multyEmmiters.length;
			for(var m:int=0;m<emitterNum;m++)
			{
				var distanceBirthNum:int=multyEmmiters[m].distanceBirthNum;
				for(var k:int=0;k<distanceBirthNum;k++)
				{
					for (var i:int = 0; i < total_number; i++)
					{
						for (var j:int = 0; j < numVertex; j++)
						{
							var n:int = j * sizePerVertex + offset;
							uvVect.push(instancingObject_uvVector[n], instancingObject_uvVector[n + 1]);
						}
					}
				}
			}
			
			
		}
		
		private function createParticlePosOffsetVertex(surface:FrSurface3D,numVertex:uint):void
		{
			
			var postionOffsetBuffer:FrVertexBuffer3D = surface.addVertexData(FilterName_ID.PARAM1_ID, 4, true, null);//postionOffset
			var posOffsetVect:Vector.<Number> = postionOffsetBuffer.vertexVector;
			var distanceBirthNum:int
			var i:int, j:int,k:int,m:int, xx:Number, yy:Number, zz:Number,angle:Number,offsetPos:Vector3D;
			var emitterNum:int=multyEmmiters.length;
			for(m=0;m<emitterNum;m++)
			{
				distanceBirthNum=multyEmmiters[m].distanceBirthNum;
				
				for(k=0;k<distanceBirthNum;k++)
				{
					for (i = 0; i < total_number; i++)
					{
						offsetPos = emitterObject.getTargetRondomXYZ(i);
						xx = offsetPos.x;
						yy = offsetPos.y;
						zz = offsetPos.z;
						angle = Math.atan2(zz,xx);
						for (j = 0; j < numVertex; j++)
						{
							posOffsetVect.push(xx, yy, zz, angle);
						}
					}
				}
			}
		}
		
		private function createParticleVertex(surface:FrSurface3D,numVertex:uint):void
		{
			
			var frvertexBuffer:FrVertexBuffer3D = surface.addVertexData(FilterName_ID.POSITION_ID, 3, true, null);
			
			var posVect:Vector.<Number> = frvertexBuffer.vertexVector;

			var indexVect:Vector.<uint> = surface.indexBufferFr.indexVector;
			var instancingObject_surface:FrSurface3D = instancingObject.getSurface(0);
			var posBuffer:FrVertexBuffer3D = instancingObject_surface.getVertexBufferByNameId(FilterName_ID.POSITION_ID)
			
			var sizePerVertex:int = posBuffer.sizePerVertex;
			var offset:int = posBuffer.bufferVoMap[FilterName_ID.POSITION_ID].offset;
			var instancingObjectPos:Vector.<Number> = posBuffer.vertexVector;
			
			var instancingObjectIndex:Vector.<uint> = instancingObject_surface.indexBufferFr.indexVector;
			var numfaces:uint = instancingObjectIndex.length / 3;
			var n:int, startIndex:int,startN:int;
			var dis:Number = size_variation * size;
			var baseSize:Number = size - dis;
			var sizeRandomValue:Number = dis * 2;
			var distanceBirthNum:int
			var i:int, j:int,k:int,m:int,disN:int=0,  targetSize:Number;
			var emitterNum:int=multyEmmiters.length;
			
			
			
			var _random:Number
			if (useSpeed && faceMovingDirection)
			{
				var frSpeedVertexBuffer:FrVertexBuffer3D = surface.getVertexBufferByNameId(FilterName_ID.PARAM2_ID);
				var speedVect:Vector.<Number> = frSpeedVertexBuffer.vertexVector;
				var _matrix3d:Matrix3D = new Matrix3D();
				var _const1:Number = 180 / Math.PI;
				var moveDirection:Vector3D = new Vector3D();
				
				//这个地方很复杂，写得不好
				for(m=0;m<emitterNum;m++)
				{
					distanceBirthNum=multyEmmiters[m].distanceBirthNum;
					for(k=0;k<distanceBirthNum;k++)
					{
						startN=(k+disN)*total_number;
						for (i = 0; i < total_number; i++)
						{
							_random=randnomArr[i];
							targetSize = baseSize + _random * sizeRandomValue;
							var tempN:int = numVertex * 3 * i;
							moveDirection.x = speedVect[tempN++];
							moveDirection.y = speedVect[tempN++];
							moveDirection.z = speedVect[tempN];
							moveDirection.normalize();
							
							_matrix3d.identity();
							
							Matrix3DUtils.setOrientation(_matrix3d, moveDirection);
							
							for (j = 0; j < numVertex; j++)
							{
								n = j * sizePerVertex + offset;
								moveDirection.x = instancingObjectPos[n] * targetSize;
								moveDirection.y = instancingObjectPos[n + 1] * targetSize;
								moveDirection.z = instancingObjectPos[n + 2] * targetSize;
								moveDirection = _matrix3d.transformVector(moveDirection);
								posVect.push(moveDirection.x, moveDirection.y, moveDirection.z);
								
							}
							startIndex = (startN+i) * numVertex;
							for (j = 0; j < numfaces; j++)
							{
								n = j * 3;
								indexVect.push(startIndex + instancingObjectIndex[n], startIndex + instancingObjectIndex[n + 1], startIndex + instancingObjectIndex[n + 2]);
							}
						}
					}
					disN+=distanceBirthNum;
				}
				
				
			}
			else
			{
				for(m=0;m<emitterNum;m++)
				{
					distanceBirthNum=multyEmmiters[m].distanceBirthNum;
					
					for(k=0;k<distanceBirthNum;k++)
					{
						startN=(k+disN)*total_number;
						for (i = 0; i < total_number; i++)
						{
							_random=randnomArr[i];
							targetSize = baseSize + _random * sizeRandomValue;
							for (j = 0; j < numVertex; j++)
							{
								n = j * sizePerVertex + offset;
								posVect.push(instancingObjectPos[n] * targetSize, instancingObjectPos[n + 1] * targetSize, instancingObjectPos[n + 2] * targetSize);
								
							}
							startIndex = (startN+i) * numVertex;
							for (j = 0; j < numfaces; j++)
							{
								n = j * 3;
								indexVect.push(startIndex + instancingObjectIndex[n], startIndex + instancingObjectIndex[n + 1], startIndex + instancingObjectIndex[n + 2]);
							}
						}
					}
					disN+=distanceBirthNum;
				}
				
				
			}
			if (faceTransform != null)
			{
				var outVecotr:Vector.<Number> = new Vector.<Number>();
				faceTransform.transformVectors(posVect, outVecotr);
				frvertexBuffer.vertexVector = outVecotr;
			}
			
			
		}
		
		private function createPerSpeed(surface:FrSurface3D, numVertex:uint):void
		{
			var frvertexBuffer:FrVertexBuffer3D = surface.addVertexData(FilterName_ID.PARAM2_ID, 3, true, null);//speed
			var vect:Vector.<Number> = frvertexBuffer.vertexVector;
			
			var postionOffsetBuffer:FrVertexBuffer3D = surface.getVertexBufferByNameId(FilterName_ID.PARAM1_ID);//postionOffset
			var posOffsetVect:Vector.<Number> = postionOffsetBuffer.vertexVector;
			
			directionInfo.setDirectionVector(multyEmmiters,total_number,speed_variation,speed,vect,numVertex,posOffsetVect);

		}
		
		private function createPerParticleTime(surface:FrSurface3D, numVertex:uint):void
		{
			var frvertexBuffer:FrVertexBuffer3D = surface.addVertexData(FilterName_ID.PARAM0_ID, 3, true, null);//index_animtelife_random
			var vect:Vector.<Number> = frvertexBuffer.vertexVector;
			
			var preN:int,k:int,n:int;
			var emitterNum:int=multyEmmiters.length;
			var distanceBirthNum:int;
			
			
			var _random:Number,_random2:Number;
			_random=randnomArr[0];
			for(n=0;n<emitterNum;n++)
			{
				distanceBirthNum=multyEmmiters[n].distanceBirthNum;
				for(k=0;k<distanceBirthNum;k++)
				{
					
					for (var i:int = 0; i < total_number; i++)
					{
						_random2=randnomArr[i];
						
						var _animatelife:int = life + life_variation * 2 * (_random - 0.5);
						
						_animatelife < 1 && (_animatelife = 1)
		
						for (var j:int = 0; j < numVertex; j++)
						{
							vect.push(i, _animatelife,_random2);
						}
						_random=_random2;
					}
				}
				
			}
			
			
			if (distanceBirth || multyEmitterEnabled || tailEnabled)
			{
				var frvertexBuffer2:FrVertexBuffer3D
				var vect2:Vector.<Number>;
				var targerIndex:int=0;
				
				if(multyEmitterEnabled)
				{
					frvertexBuffer2 = surface.addVertexData(FilterName_ID.SKIN_INDICES_ID, 2, true, null);
					vect2 = frvertexBuffer2.vertexVector;
					var perHasRegisterNum:int=1;
					if(multyEmmiterLineType==ELineType.curveLine)
					{
						perHasRegisterNum=4;
					}
					else if(multyEmmiterLineType==ELineType.linear)
					{
						perHasRegisterNum=3;
					}
					for(n=0;n<emitterNum;n++)
					{
						var _n:int=n*perHasRegisterNum;
						distanceBirthNum=multyEmmiters[n].distanceBirthNum;
						for(k=0;k<distanceBirthNum;k++)
						{
							for (i = 0; i < total_number; i++)
							{
								for (j = 0; j < numVertex; j++)
								{
									vect2.push(k,_n);
								}
							}
						}
						
					}
				}
				else
				{
					if(distanceBirth)
					{
						frvertexBuffer2 = surface.addVertexData(FilterName_ID.SKIN_INDICES_ID, 1, true, null);
						vect2 = frvertexBuffer2.vertexVector;
						distanceBirthNum=multyEmmiters[0].distanceBirthNum;
						for(k=0;k<distanceBirthNum;k++)
						{
							for (i = 0; i < total_number; i++)
							{
								for (j = 0; j < numVertex; j++)
								{
									vect2.push(k);
								}
							}
						}
					}
					else
					{
						frvertexBuffer2 = surface.addVertexData(FilterName_ID.SKIN_INDICES_ID, 1, true, null);
						vect2 = frvertexBuffer2.vertexVector;
						for (i = 0; i < total_number; i++)
						{
							for (j = 0; j < numVertex; j++)
							{
								vect2.push(i);
							}
						}
						
					}
				}
				
			}
			
		}
		private function createAutoRoationAxis(surface:FrSurface3D, numVertex:uint):void
		{
			var frvertexBuffer:FrVertexBuffer3D = surface.addVertexData(FilterName_ID.PARAM4_ID, 3, true, null);
			
			var vect:Vector.<Number> = frvertexBuffer.vertexVector;
			
			var k:int,n:int;
			
			var emitterNum:int=multyEmmiters.length;
			var distanceBirthNum:int;
			
			
			
			
			if (autoRotaionInfo.type == 0)
			{
				for(n=0;n<emitterNum;n++)
				{
					distanceBirthNum=multyEmmiters[n].distanceBirthNum;
					for(k=0;k<distanceBirthNum;k++)
					{
						for (var i:int = 0; i < total_number; i++)
						{
							var rx:Number = randnomArr[i]
							var ry:Number = randnomArr[i+1]
							var rz:Number = randnomArr[i+2]
							
							for (var j:int = 0; j < numVertex; j++)
							{
								vect.push(rx, ry, rz);
							}
						}
					}
				}
			}
			else
			{ 
				var v:Vector3D = new Vector3D();
				var axis:Vector3D = autoRotaionInfo.axis;
				var axisVar:Number = autoRotaionInfo.axisVar;
				axis.normalize();
				for(n=0;n<emitterNum;n++)
				{
					distanceBirthNum=multyEmmiters[n].distanceBirthNum;
					for(k=0;k<distanceBirthNum;k++)
					{
						for (i = 0; i < total_number; i++)
						{
							v.x = 0.5 - randnomArr[i]
							v.y = 0.5 - randnomArr[i+1]
							v.z = 0.5 - randnomArr[i+2]
							v.normalize();
							v.scaleBy(axisVar);
							
							v = v.add(axis);
							v.normalize();
							
							rx = v.x;
							ry = v.y;
							rz = v.z;
							
							for (j = 0; j < numVertex; j++)
							{
								vect.push(rx, ry, rz);
							}
						}
					}
				}
			}
		}
		public function get useGrowthAndFadeType():int
		{
			var targetType:int=0;
			if(growth_time > 0 || fade_time > 0)
			{
				targetType=isFadeToGrowth?2:1;
			}
			return targetType;
		}
		
		public function get hasForce():Boolean
		{
			return (useLineForce || useLiXinForce)
		}
		
		public function get useFriction():Boolean
		{
			return frictionVecor3d != null;
		}
		
		
		
		public function get useSpeed():Boolean
		{
			return speed > 0 //|| useRotateAxisY;
		}
		
		public function get useLineForce():Boolean
		{
			return lineForceVecor3d != null;
		}
		
		public function get useLiXinForce():Boolean
		{
			return lixinForceSize != 0;
		}
		
		public function get useRotateAxisY():Boolean
		{
			return rotateAxisYSpeed!=0;
		}
		
		public function get dateaTexture():Texture3D
		{
			if (_useColor || _useAlpha)
			{
				if (!_dataTexture)
				{
					_dataTexture = new Texture3D(null,Texture3D.MIP_NONE);
				}
				return _dataTexture;
			}
			else
			{
				return null;
			}
		}
		
		public function get useAlpha():Boolean
		{
			return _useAlpha;
		}
		public function setAlpha(_colors:Array, _alphas:Array, _ratios:Array):void
		{
			if (_colors && _alphas && _ratios)
			{
				_useAlpha = true;
				if(!_colorBitmapData)
				{
					_colorBitmapData = new BitmapData(256, bitmapHeight, true, 0xffffffff);
				}
				var h2:int=bitmapHeight/2;
				var _matrix:Matrix = new Matrix();
				_matrix.createGradientBox(_colorBitmapData.width, h2);
				_shape.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix, "pad", InterpolationMethod.RGB);
				_shape.graphics.drawRect(0, h2, 256, h2);
				_colorBitmapData.draw(_shape);
			}
			else
			{
				_useAlpha = false;
			}
			
		}
		
		
		public function get useColor():Boolean
		{
			return _useColor;
		}
		public function setColor(_colors:Array, _alphas:Array, _ratios:Array):void
		{
			if (_colors && _alphas && _ratios)
			{
				_useColor = true;
				if(!_colorBitmapData)
				{
					_colorBitmapData = new BitmapData(256, bitmapHeight, true, 0xffffffff);
				}
				var _matrix:Matrix = new Matrix();
				_matrix.createGradientBox(_colorBitmapData.width, bitmapHeight/2);
				_shape.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix, "pad", InterpolationMethod.RGB);
				_shape.graphics.drawRect(0, 0, 256, bitmapHeight/2);
				_colorBitmapData.draw(_shape);
			}
			else
			{
				_useColor = false;
			}
			
		}
		public function dispose():void
		{
			if (_dataTexture)
			{
				_dataTexture.disposeImp();
				_dataTexture = null;
			}
			targetSurface.disposeImp();
			targetSurface=null;
			emitterObject.dispose();
			emitterObject=null;
		}
	}
}