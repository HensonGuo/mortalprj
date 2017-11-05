package frEngine.animateControler.particleControler
{
	
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Orientation3D;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Label3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.effectEditTool.lineRoad.LineRoadMesh3D;
	import frEngine.loaders.particleSub.multyEmmiterType.IMultyEmmiterType;
	import frEngine.math.MathConsts;
	import frEngine.render.IRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.registType.MaxtrixParam;
	import frEngine.shader.registType.VcParam;
	
	public class ParticleAnimateControler extends MeshAnimateBase implements IRender
	{
		private var _particleParams:ParticleParams;
		private var _globlePoint:Vector3D = new Vector3D();
		private var _oldGloblePoint:Vector3D = new Vector3D();
		private var _oldControlPoint:Vector3D = new Vector3D();
		
		private static var _zeroPoint:Vector3D = new Vector3D(0, 0, 0, 1);
		private static var _right:Vector3D = new Vector3D();
		private static var _up:Vector3D = new Vector3D();
		private static var _dir:Vector3D = new Vector3D();
		
		private var _tempVect3d:Vector3D = new Vector3D();
		private var _tempVect3d2:Vector3D = new Vector3D();
		private var timeOffset:VcParam;
		
		private var _distanceBirthNum:int;
		
		private var _maxDuring:int = 0;
		private var _perMaxDuring:int=0;

		private var _playMode:int=0;
		
		private var hasUpload:Boolean;
		private var _transformMatrix3d:Matrix3D;
		private var _faceCameraMatrix3d:Matrix3D;
		private var vc0_60:Vector.<Number>  = new Vector.<Number>();

		
		private var globlePositionRegist:VcParam;
		private var globleRotaionValue:Matrix3D
		private var localScaleValue:Vector.<Number>;
		
		private var _emitterTime:int=0;
		private var _curStarPlayTime:int=0;
		private var preDuring:int = -1;
		private var _oldIndex:Number = 0;
		private var _toltalParticleNum:int=0;
		private var _perParticleEmitterTime:Number;
		private var _emmitFinish:Boolean;
		private var _birthDistance:int;
		private var curIndex:int=0;
		
		private var tailMaxDistance:int;
		private var tailPerDistance:Number;
		private var _needUpdataTail:Boolean;
		private var _needUpDistanceBirth:Boolean;
		

		private var _targetMultyplaySpeed:int=0;
		private var _targetStartPos:Vector3D
		private var _targetEndPos:Vector3D;
		private var _minDistance:Number=0;
		private var _preFrame:int=-1;
		private var _preTime:int=0;
		
		public var lineRoadControler:LineRoadControler;
		
		public function ParticleAnimateControler()
		{
			
			
		}

		protected override function setMaterialHander(e:Event):void
		{
			if (normalMaterial)
			{
				normalMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER, setingParams);
			}
			super.setMaterialHander(e);
			if (normalMaterial)
			{
				normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER, setingParams);
			}
		}

		public function resetMultyEmmiter($startPos:Vector3D,$endPos:Vector3D,$speed:int,$hasPassFrame:int,$minDistance:Number):void
		{
			$startPos && (_targetStartPos=$startPos);
			$endPos && (_targetEndPos=$endPos);
			$speed>0 && (_targetMultyplaySpeed=$speed);
			$minDistance>=0 && (_minDistance=$minDistance)
			if(_particleParams && _particleParams.multyEmitterEnabled)
			{
				var len:int=_particleParams.multyEmmiters.length;
				vc0_60.length=0;
				curIndex=0;
				for(var i:int=0;i<len;i++)
				{ 
					var multyEmmiter:IMultyEmmiterType=_particleParams.multyEmmiters[i];
					multyEmmiter.reInit(_targetStartPos,_targetEndPos,_targetMultyplaySpeed,_particleParams,vc0_60);
				}
				
			}
			if($hasPassFrame!=-1)
			{
				targetObject3d.timerContorler.gotoFrame($hasPassFrame,$hasPassFrame);
			}
		}
		public override function set targetObject3d(value:Pivot3D):void
		{
			if (targetObject3d)
			{
				targetObject3d.removeEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT, visibleChangeHander);
				targetObject3d.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT, updateTransformHander);
			}
			if (value)
			{
				value.addEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT, visibleChangeHander);
			}
			super.targetObject3d = value;
			
		}
		
		private function updateTransformHander(e:Event):void
		{
			if (globleRotaionValue)
			{
				var _m:Matrix3D=targetMesh.world;
				_m.copyColumnTo(0, _right);
				_m.copyColumnTo(1, _up);
				_m.copyColumnTo(2, _dir);

				_right.normalize();
				_up.normalize();
				_dir.normalize();

				_dir.w =_up.w =_right.w = 0;
				
				globleRotaionValue.copyColumnFrom(0, _right);
				globleRotaionValue.copyColumnFrom(1, _up);
				globleRotaionValue.copyColumnFrom(2, _dir);

			}

			if(localScaleValue)
			{
				var parentObj:Pivot3D=targetMesh.parent;
				if(parentObj)
				{
					localScaleValue[0]=targetMesh.scaleX*parentObj.scaleX;
					localScaleValue[1]=targetMesh.scaleY*parentObj.scaleY;
					localScaleValue[2]=targetMesh.scaleZ*parentObj.scaleZ;
				}else
				{
					localScaleValue[0]=targetMesh.scaleX;
					localScaleValue[1]=targetMesh.scaleY;
					localScaleValue[2]=targetMesh.scaleZ;
				}
				
			}

		}
		
		public  function set particleParams(value:ParticleParams):void
		{
			if(!value.hasInitData)
			{
				throw new Error("请先初始化ParticleParams");
				return;
			}
			
			_emmitFinish=false;
			
			_particleParams=value;

			_distanceBirthNum=_particleParams.multyEmmiters[0].distanceBirthNum;
			
			_emitterTime=_particleParams.emitterTime;
			
			_playMode=_particleParams.playMode;
			
			_birthDistance=_particleParams.birthDistance;
			
			vc0_60.length=0;
			curIndex=0;
			_toltalParticleNum=_particleParams.total_number;

			tailMaxDistance = _particleParams.tailMaxDistance;
			
			tailPerDistance = tailMaxDistance/ _toltalParticleNum;
			
			_perParticleEmitterTime = _particleParams.perParticleEmitterTime;
			
			
			_maxDuring=_particleParams.maxDuring;

			_needUpdataTail=(_particleParams.tailEnabled && !_particleParams.multyEmitterEnabled);
			
			_needUpDistanceBirth=(_particleParams.distanceBirth && !_particleParams.multyEmitterEnabled);
			
			_perMaxDuring=_needUpDistanceBirth?1:_maxDuring;
			
			if(_particleParams.multyEmitterEnabled)
			{
				var len:int=_particleParams.multyEmmiters.length;
				for(var i:int=0;i<len;i++)
				{
					var multyEmmiter:IMultyEmmiterType=_particleParams.multyEmmiters[i];
					multyEmmiter.reInit(_targetStartPos,_targetEndPos,_targetMultyplaySpeed,_particleParams,vc0_60);
				}
			}
			if (timeOffset)
			{
				timeOffset.changeValue1(2, this._perMaxDuring);
				timeOffset.changeValue1(3, curIndex);
			}

			if (!cuPlayLable)
			{
				var label3d:Label3D = new Label3D(0, int(_particleParams.totalTime - 1), "default",0);
				this.setPlayLable(label3d);
			}
			else
			{
				this.cuPlayLable.change(0, _particleParams.totalTime - 1);
			}
		}
		public override function get type():int
		{
			return AnimateControlerType.ParticleAnimateControler;
		}
		
		private function visibleChangeHander(e:Event):void
		{
			_curStarPlayTime = targetObject3d.timerContorler.curFrame;
			if(targetObject3d.visible )
			{
				if(_needUpDistanceBirth || _needUpdataTail)
				{
					vc0_60.length=0;
					curIndex=0;
				}
				this._lastFrame=this.currentFrame-1;
			}
		}
		
		
		private function setingParams(e:Event):void
		{
			
			timeOffset = normalMaterial.getParam("{time_perCircleTime_maxDuring_curHeadIndex}", true);
			timeOffset.changeValue4(0, _particleParams.life, _perMaxDuring,curIndex);
			//var emitterWorldViewProj:MaxtrixParam = normalMaterial.getParam("emitterTransform", true);
			//_transformMatrix3d = emitterWorldViewProj.maxtrixValue;
			
			if (_particleParams.distanceBirth || _particleParams.tailEnabled || _particleParams.multyEmitterEnabled)
			{
				normalMaterial.getParam("{vc0-60}", true).value = vc0_60;
			}
			else
			{
				globlePositionRegist = normalMaterial.getParam("{globlePosition}", true)
			}
			

			if(_particleParams.useRotation)
			{
				globleRotaionValue=new Matrix3D();
				normalMaterial.getParam("{globleRotation}", true).value=globleRotaionValue;
			}

			if(_particleParams.useScale)
			{
				localScaleValue=Vector.<Number>([1,1,1,1]);
				normalMaterial.getParam("{localScale}", true).value=localScaleValue;
			}
			
			if(_particleParams.useScale || _particleParams.useRotation)
			{
				targetMesh.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT, updateTransformHander);
				updateTransformHander(null);
			}else
			{
				targetMesh.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT, updateTransformHander);
			}

			if (_particleParams.faceCamera)
			{
				var vm:MaxtrixParam = normalMaterial.getParam("{rotationMatrixRegister}", true)
				_faceCameraMatrix3d = vm.value;
			}
			
			
			if (_particleParams.useLineForce)
			{
				var _forceRegister:VcParam = normalMaterial.getParam("{lineForce}", true);
				var forceVecor3d:Vector3D=_particleParams.lineForceVecor3d
				_forceRegister.changeValue3(forceVecor3d.x, forceVecor3d.y, forceVecor3d.z);
			}
			if (_particleParams.useFriction && _particleParams.useSpeed)
			{
				var _frictionSize:VcParam = normalMaterial.getParam("{frictionSize}", true);
				var frictionVecor3d:Vector3D=_particleParams.frictionVecor3d
				_frictionSize.changeValue3(1000 / frictionVecor3d.x, 1000 / frictionVecor3d.y, 1000 / frictionVecor3d.z);
			}
			
			hasUpload = true;
			this.toUpdateAnimate(true);
		}
		
		public override function play():void
		{

			if (_isPlaying)
			{
				return;
			}
			
			super.play();
		}
		
		private function updataTailPath(hasPassTime:Number):void
		{

			if(_preFrame==this.currentFrame || hasPassTime>_emitterTime)
			{
				return;
			}
			
			if( this.currentFrame<_preFrame)
			{
				vc0_60.length=0;
			}

			_preFrame=this.currentFrame;

			var gx:Number = _globlePoint.x;
			var gy:Number = _globlePoint.y;
			var gz:Number = _globlePoint.z;
			var i:int = 0;
			var tempNum:int = 0;
			if (vc0_60.length == 0)
			{
				
				vc0_60.length = _toltalParticleNum * 4;
				
				for (i = 0; i < _toltalParticleNum; i++)
				{
					tempNum = i * 4;
					vc0_60[tempNum] = gx;
					vc0_60[tempNum + 1] = gy;
					vc0_60[tempNum + 2] = gz;
					vc0_60[tempNum + 3] = 0;
				}
				_oldGloblePoint = _globlePoint.clone();
				_oldControlPoint=_oldGloblePoint.clone();
			}
			curIndex = int(hasPassTime / _perParticleEmitterTime)%_toltalParticleNum; 

			
			var ox:Number=_oldGloblePoint.x;
			var oy:Number=_oldGloblePoint.y;
			var oz:Number=_oldGloblePoint.z;
			_tempVect3d2.x = gx-ox;
			_tempVect3d2.y = gy-oy;
			_tempVect3d2.z = gz-oz;
			var newLen:Number = _tempVect3d2.normalize();
			
			var forwoardNum:int=(curIndex - _oldIndex + _toltalParticleNum) % _toltalParticleNum;
			
			var dis:int = int(newLen/tailPerDistance);

			var __curIndex:int
			;
			if (dis>1)
			{
				if(dis>_toltalParticleNum)
				{
					dis=_toltalParticleNum;
				}
				
				dis = Math.max(dis,forwoardNum);
				
				var offsetNum:int=dis-forwoardNum;
				if(offsetNum>0)
				{
					var dis2:int=_toltalParticleNum-dis;
					for (i = 1; i <= dis2; i++)
					{
						var _index:int = curIndex+i;
						_index >=_toltalParticleNum && (_index-=_toltalParticleNum);
						var preIndex:int=_index+offsetNum;
						preIndex >= _toltalParticleNum && (preIndex-=_toltalParticleNum);
						tempNum = _index * 4;
						var tempNum2:int = preIndex * 4;
						vc0_60[tempNum]		= vc0_60[tempNum2];
						vc0_60[tempNum + 1]	= vc0_60[tempNum2 + 1];
						vc0_60[tempNum + 2]	= vc0_60[tempNum2 + 2];
					}
					
				}

				if(lineRoadControler)
				{
					var list:Vector.<Vector3D>=lineRoadControler.getMidPos(dis);
					__curIndex = curIndex-dis;
					__curIndex <0 && (__curIndex+=_toltalParticleNum);
					
					for (i = 0; i < dis; i++)
					{
						var _v:Vector3D=list[i];
						__curIndex++;
						__curIndex >= _toltalParticleNum && (__curIndex-=_toltalParticleNum);
						tempNum = __curIndex * 4;
						vc0_60[tempNum]		= _v.x;
						vc0_60[tempNum + 1]	= _v.y;
						vc0_60[tempNum + 2]	= _v.z;
					}
				}else
				{
					_tempVect3d.x=ox-_oldControlPoint.x;
					_tempVect3d.y=oy-_oldControlPoint.y;
					_tempVect3d.z=oz-_oldControlPoint.z;
					_tempVect3d.normalize();
					
					_tempVect3d.scaleBy(newLen*0.5);
					
					
					
					var tx:Number=_tempVect3d.x+ox;
					var ty:Number=_tempVect3d.y+oy;
					var tz:Number=_tempVect3d.z+oz;
					
					var _scaleTime:Number = (newLen==0?0:tailMaxDistance/newLen);
					if(_scaleTime>1)
					{
						_scaleTime=1;
					}
					for (i = 0; i < dis; i++)
					{
						var t:Number=i/dis*_scaleTime;
						var t2:Number=t*t;
						var n:Number=1-t;
						var n2:Number=n*n;
						var tn:Number=2*t*n;
						__curIndex = curIndex -i;
						__curIndex<0 && (__curIndex+=_toltalParticleNum);
						tempNum = __curIndex * 4;
						vc0_60[tempNum]		= gx*n2+tx*tn+ox*t2
						vc0_60[tempNum + 1]	= gy*n2+ty*tn+oy*t2
						vc0_60[tempNum + 2]	= gz*n2+tz*tn+oz*t2
						
					}
					
					_oldControlPoint.setTo(tx,ty,tz);

				}
				_oldGloblePoint.setTo(gx,gy,gz);
				_oldIndex = curIndex;
				
			}
			else
			{
				for(i=0;i<forwoardNum;i++)
				{
					__curIndex=curIndex-i;
					__curIndex<0 && (__curIndex+=_toltalParticleNum);
					tempNum = __curIndex * 4;
					
					vc0_60[tempNum] = gx;
					vc0_60[tempNum + 1] = gy;
					vc0_60[tempNum + 2] = gz;
				}
				
				_oldGloblePoint.setTo(gx,gy,gz);
				_oldIndex=curIndex;
			}
			
			
		}
		
		private function updataDistanceBirth(hasPassTime:int):void
		{
			if(_preFrame==this.currentFrame || hasPassTime>_emitterTime)
			{
				return;
			}
			
			if( this.currentFrame<_preFrame)
			{
				vc0_60.length=0;
				curIndex=0;
			}
			
			_preFrame=this.currentFrame;
			var gx:Number = _globlePoint.x;
			var gy:Number = _globlePoint.y;
			var gz:Number = _globlePoint.z;
			var i:int = 0;
			var tempNum:int = 0;
			if (vc0_60.length == 0)
			{
				vc0_60.length = _distanceBirthNum * 4;
				for (i = 0; i < _distanceBirthNum; i++)
				{
					tempNum = i * 4;
					vc0_60[tempNum] = gx;
					vc0_60[tempNum + 1] = gy;
					vc0_60[tempNum + 2] = gz;
					vc0_60[tempNum + 3] = -10000;
				}
				_oldGloblePoint = _globlePoint.clone();
				_oldControlPoint=_oldGloblePoint.clone();
				_preTime=hasPassTime;
			}
			var ox:Number=_oldGloblePoint.x;
			var oy:Number=_oldGloblePoint.y;
			var oz:Number=_oldGloblePoint.z;
			_tempVect3d2.x = gx-ox;
			_tempVect3d2.y = gy-oy;
			_tempVect3d2.z = gz-oz;
			var newLen:Number = _tempVect3d2.normalize();
			
			if (newLen>=_birthDistance)
			{

				_tempVect3d.x=ox-_oldControlPoint.x;
				_tempVect3d.y=oy-_oldControlPoint.y;
				_tempVect3d.z=oz-_oldControlPoint.z;
				_tempVect3d.normalize();
	
				_tempVect3d.scaleBy(newLen/2);
				var tx:Number=_tempVect3d.x+ox;
				var ty:Number=_tempVect3d.y+oy;
				var tz:Number=_tempVect3d.z+oz;
				
				var splitNum:int=Math.floor(newLen/_birthDistance);
				var firstTime:Number=(hasPassTime-_preTime)/splitNum;
				for (i = 1; i <= splitNum; i++)
				{
					var t:Number=1-i/splitNum;
					var t2:Number=t*t;
					var n:Number=1-t;
					var n2:Number=n*n;
					var tn:Number=2*t*n;
					
					curIndex = (curIndex+1) % _distanceBirthNum;
					tempNum = curIndex * 4;
					
					vc0_60[tempNum]		= gx*n2+tx*tn+ox*t2
					vc0_60[tempNum + 1]	= gy*n2+ty*tn+oy*t2
					vc0_60[tempNum + 2]	= gz*n2+tz*tn+oz*t2
					vc0_60[tempNum + 3] = _preTime+i*firstTime;
				}
				_oldControlPoint.setTo(tx,ty,tz);
				_oldGloblePoint.setTo(gx,gy,gz);
				_preTime = hasPassTime;
			}
			
			
		}
		protected override function updateCurFrame():void
		{
			var disframe:Number;
			if(this._playMode==1)
			{
				disframe=targetMesh.timerContorler.totalframe;
			}else
			{
				disframe= targetMesh.timerContorler.curFrame;
			}
			var frameLen:int = cuPlayLable.length;
			var _local1:Boolean;
			if (disframe >= frameLen)
			{
				disframe = frameLen - 1;
			}
			else if (disframe < 0)
			{
				disframe = 0;
			}
			this.currentFrame = cuPlayLable.from + disframe;
			
		}
		public override function toUpdateAnimate(forceUpdate:Boolean=false):void
		{
			if (!hasUpload)
			{
				return;
			}
			super.toUpdateAnimate(forceUpdate);
			
			if(!forceUpdate && !changeFrame)
			{
				return;
			}
			
			var curPlayTime:int = this.currentFrame - this._curStarPlayTime;
			if(curPlayTime<0)
			{
				curPlayTime=0;
			}
			var curDuring:int=int(curPlayTime / _particleParams.life);
			
			_emmitFinish=curDuring>_maxDuring?true:false;
			
			if(_emmitFinish)
			{
				return;
			}
			
			timeOffset.changeValue1(0, curPlayTime);
			
			targetObject3d.world.copyColumnTo(3, _globlePoint);
			
			
			if (_needUpDistanceBirth)
			{	
				updataDistanceBirth(curPlayTime);
			}
			else if(_needUpdataTail)
			{
				updataTailPath(curPlayTime);
			}
			else
			{
				globlePositionRegist && globlePositionRegist.changeValue3(_globlePoint.x, _globlePoint.y, _globlePoint.z);
			}
			
			/*_transformMatrix3d.copyFrom(targetObject3d.world);
			_transformMatrix3d.copyColumnFrom(3, _zeroPoint);*/
			
			if (_faceCameraMatrix3d)
			{
				var comps:Vector.<Vector3D> = Device3D.view.decompose(Orientation3D.AXIS_ANGLE);
				_faceCameraMatrix3d.identity();
				_faceCameraMatrix3d.appendRotation(-comps[1].w * MathConsts.RADIANS_TO_DEGREES, comps[1]);
			}
			
		}
		
		
		public function completeDraw(mesh:Mesh3D):void
		{
			
		}
		
		public function drawEdge(mesh:Mesh3D, edgeColor:Number = 0xffffff):void
		{
			
		}
		
		public function drawDepth(mesh:Mesh3D, objectColor:Number = 0, $alpha:Number=1):void
		{
			
		}

		public function draw(mesh:Mesh3D, material:ShaderBase = null):void
		{
			if (!normalMaterial || !_particleParams.hasBuildSurface || _emmitFinish)
			{
				return;
			}
			/*var m:Matrix3D=Device3D.worldViewProj
			m.copyFrom(mesh.world);
			m.copyColumnFrom(3, _zeroPoint);
			m.append(Device3D.viewProj);*/
			Device3D.objectsDrawn++;
			if(!normalMaterial.hasPrepared(mesh, targetSurface))
			{
				return;
			}
			var materialPrams:MaterialParams = mesh.materialPrams;
			normalMaterial.draw(mesh, targetSurface,materialPrams.depthCompare, materialPrams.cullFace, materialPrams.depthWrite, materialPrams.sourceFactor, materialPrams.destFactor);
			
		}
		
		public override function dispose():void
		{
			normalMaterial && normalMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER, setingParams);
			_particleParams=null;
			super.dispose();
		}
		
		
		
	}
}

