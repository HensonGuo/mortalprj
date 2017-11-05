package frEngine.animateControler.particleControler
{
	import flash.geom.Vector3D;
	
	import frEngine.loaders.particleSub.multyEmmiterType.IMultyEmmiterType;

	public class PEmitterDirectionInfo
	{
		public var motionType:Number = 0;
		public var isRandom:Boolean=true;
		public var direction_vector_x:Number = 0;
		public var direction_vector_y:Number = 0;
		public var direction_vector_z:Number = 0;
		public var directionVariation:Number = 0;
		public var herizonAngle:Number = 0;
		private var randnomArr:Array
		public function PEmitterDirectionInfo($randnomArr:Array)
		{
			randnomArr=$randnomArr;
		}

		private function createType4(emitter:Vector.<IMultyEmmiterType>,total_number:Number, vertexNum:Number, vect:Vector.<Number>, speedRandomValue:Number, baseSpeed:Number,posOffsetVect:Vector.<Number>,direction:int):void
		{
			var i:int, j:int
			var x2:Number;
			var y2:Number;
			var z2:Number;
			var v:Vector3D = new Vector3D();
			var resultSpeed:Number;
			var emitterNum:int=emitter.length;
			
			
			var _random:Number
			
			for(var m:int=0;m<emitterNum;m++)
			{
				var distanceBirthNum:int=emitter[m].distanceBirthNum;
				for(var k:int=0;k<distanceBirthNum;k++)
				{
					for (i = 0; i < total_number; i++)
					{
						_random=randnomArr[i];
						resultSpeed = baseSpeed + speedRandomValue * _random;
						var n:int=i*vertexNum*4;
						v.x=direction*posOffsetVect[n]
						v.y=direction*posOffsetVect[n+1]
						v.z=direction*posOffsetVect[n+2]
						v.normalize();	
						x2 = v.x * resultSpeed;
						y2 = v.y * resultSpeed;
						z2 = v.z * resultSpeed;
						for (j = 0; j < vertexNum; j++)
						{
							vect.push(x2, y2, z2);
						}
					}
				}
			}
		}
		
		private function createType3(emitter:Vector.<IMultyEmmiterType>,total_number:Number, vertexNum:Number, vect:Vector.<Number>, speedRandomValue:Number, baseSpeed:Number):void
		{
			var i:int, j:int
			var x2:Number;
			var y2:Number;
			var z2:Number;
			var v:Vector3D = new Vector3D();
			var resultSpeed:Number;
			var direct:Vector3D = new Vector3D(direction_vector_x, direction_vector_y, direction_vector_z);
			direct.normalize();
			direct.scaleBy(1 - directionVariation);
			var emitterNum:int=emitter.length;
			

			for(var m:int=0;m<emitterNum;m++)
			{
				var distanceBirthNum:int=emitter[m].distanceBirthNum;
				for(var k:int=0;k<distanceBirthNum;k++)
				{
					for (i = 0; i < total_number; i++)
					{
						resultSpeed = baseSpeed + speedRandomValue * randnomArr[i];
						
						v.x = 0.5 - randnomArr[i+1];
						v.y = 0.5 - randnomArr[i+2];
						v.z = 0.5 - randnomArr[i+3];
						v.normalize();
						v.scaleBy(directionVariation);
						
						v = v.add(direct);
						v.normalize();
						v.scaleBy(resultSpeed);
						
						x2 = v.x;
						y2 = v.y;
						z2 = v.z;
						
						for (j = 0; j < vertexNum; j++)
						{
							vect.push(x2, y2, z2);
						}
					}
				}
			}
			
			
		}

		public function setDirectionVector(emitter:Vector.<IMultyEmmiterType>,total_number:Number, speed_variation:Number, speed:Number, vect:Vector.<Number>, vertexNum:int,posOffsetVect:Vector.<Number>):void
		{
			
			var dis:Number = speed_variation * speed;
			var baseSpeed:Number = speed - dis;
			var speedRandomValue:Number = dis * 2;
			switch(motionType)
			{
				case 1:
					//球形随机
					createType1(emitter,total_number, vertexNum, vect, speedRandomValue, baseSpeed);
					break;
				case 2:
					//圆形随机
					createType2(emitter,total_number, vertexNum, vect, speedRandomValue, baseSpeed);
					break;
				case 3:
					//指定方向
					createType3(emitter,total_number, vertexNum, vect, speedRandomValue, baseSpeed);
					break;
				case 4:
					//指向球心
					createType4(emitter,total_number, vertexNum, vect, speedRandomValue, baseSpeed,posOffsetVect,-1);
					break;
				case 5:
					//背向球心
					createType4(emitter,total_number, vertexNum, vect, speedRandomValue, baseSpeed,posOffsetVect,1);
					break;
			}
			
		}

		private function createType2(emitter:Vector.<IMultyEmmiterType>,total_number:Number, vertexNum:Number, vect:Vector.<Number>, speedRandomValue:Number, baseSpeed:Number):void
		{
			var i:int, j:int
			var x2:Number;
			var y2:Number;
			var z2:Number;
			var v:Vector3D = new Vector3D();
			var resultSpeed:Number;
			var emitterNum:int=emitter.length;
			var singleNum:Number=Math.PI*2/total_number;
			var _angle:Number
			
			
			
			var _random:Number
			
			
			for(var m:int=0;m<emitterNum;m++)
			{
				var distanceBirthNum:int=emitter[m].distanceBirthNum;
				
				for(var k:int=0;k<distanceBirthNum;k++)
				{
					_random=randnomArr[k];
					
					var offsetNum:Number=0//Math.PI*_random;
					for (i = 0; i < total_number; i++)
					{
						_random=randnomArr[i];
						var _angle0:Number = (1 - _random * 2) * herizonAngle;
						v.y = Math.sin(_angle0);
						var _r:Number = Math.cos(herizonAngle);
						
						if(isRandom)
						{
							_random=randnomArr[i+1];
							_angle = _random * Math.PI * 2;
							v.z = _r * Math.cos(_angle);
							v.x = _r * Math.sin(_angle);
						}else
						{
							_angle = i*singleNum+offsetNum;
							v.z = _r * Math.cos(_angle);
							v.x = _r * Math.sin(_angle);
						}

						resultSpeed = baseSpeed + speedRandomValue * _random;
						
						x2 = v.x * resultSpeed;
						y2 = v.y * resultSpeed;
						z2 = v.z * resultSpeed;
						
						for (j = 0; j < vertexNum; j++)
						{
							vect.push(x2, y2, z2);
						}
					}
				}
			}
			
			
		}

		private function createType1(emitter:Vector.<IMultyEmmiterType>,total_number:Number, vertexNum:Number, vect:Vector.<Number>, speedRandomValue:Number, baseSpeed:Number):void
		{
			var i:int, j:int
			var x2:Number;
			var y2:Number;
			var z2:Number;
			var v:Vector3D = new Vector3D();
			var resultSpeed:Number;
			var emitterNum:int=emitter.length;
			
			
			var _random0:Number=randnomArr[0];
			var _random1:Number=randnomArr[1];
			var _random2:Number=randnomArr[3];
			var _random3:Number
			
			for(var m:int=0;m<emitterNum;m++)
			{
				var distanceBirthNum:int=emitter[m].distanceBirthNum;
				for(var k:int=0;k<distanceBirthNum;k++)
				{
					for (i = 0; i < total_number; i++)
					{
						_random3=randnomArr[i];
						resultSpeed = baseSpeed + speedRandomValue * _random3;
						v.x = 0.5 - _random0;
						v.y = 0.5 - _random1;
						v.z = 0.5 - _random2;
						v.normalize();
						
						x2 = v.x * resultSpeed;
						y2 = v.y * resultSpeed;
						z2 = v.z * resultSpeed;
						for (j = 0; j < vertexNum; j++)
						{
							vect.push(x2, y2, z2);
						}
						_random2=_random1;
						_random1=_random0;
						_random0=_random3;
					}
				}
			}
		}
	}
}
