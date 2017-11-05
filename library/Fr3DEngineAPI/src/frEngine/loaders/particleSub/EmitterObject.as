package frEngine.loaders.particleSub
{
	import com.gengine.resource.info.ImageInfo;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Mesh3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.math.Quaternion;
	import frEngine.shader.filters.FilterName_ID;
	
	public class EmitterObject extends EventDispatcher
	{
		protected var _emitterPosType:String;
		public var initComplete:Boolean=true;
		public var isBitmapDataInited:Boolean = false;
		protected var _vect3d:Vector3D=new Vector3D();
		protected var _normal3d:Vector3D = new Vector3D();
		protected var _temp3d:Vector3D = new Vector3D();
		protected var _isCalculate:Dictionary  = new Dictionary();
		protected var _quaternion:Quaternion = new Quaternion();
		protected var _bitmapData:BitmapData;
		
		//  根据材质灰度算出生概率
		
		/**
		 * 每多少个像素采样一个点 
		 */		
		protected var _samplingPricision:uint = 6;
		/**
		 * 假如值为1，表示采集目标点的前后左右1个点作为计算结果， 也就是3X3象素的累加作为采样概率计算基值 
		 */		
		protected var _samplingPixelRound:uint = 0;
		protected var _uvWidth:int;
		protected var _uvHeight:int;
		protected var _coordVector:Vector.<Number>;
		protected var _normalVecotr:Vector.<Number> = new Vector.<Number>(); // 保存每个面的法线
		protected var _normalIndexs:Array = [];
		protected var _probabilityList:Array;
		
		// 顶点相关
		protected var posVector:Vector.<Number>;
		protected var indexVector:Vector.<uint>;
		protected var sizePerVertex:int;
		
		protected var uvPosVector:Vector.<Number>;
		protected var uvSizePerVectex:int;
		
		protected var positionOffset:int;
		protected var uvOffset:int;
		
		protected var pointA:Vector3D=new Vector3D();
		protected var uvPointA:Vector3D=new Vector3D();
		
		protected var pointB:Vector3D=new Vector3D();
		protected var uvPointB:Vector3D=new Vector3D();
		
		protected var pointC:Vector3D=new Vector3D();
		protected var uvPointC:Vector3D=new Vector3D();
		
		protected var randnomArr:Array;
		
		public function EmitterObject(emitterPosType:String,$randnomArr:Array)
		{
			_emitterPosType=emitterPosType;
			randnomArr=$randnomArr;
			
			super();
		}
		
		public function getObject3d():*
		{
			throw new Error("请覆盖getObject3d()方法");
			return null;
		}
		
		public function get emitterPosType():String
		{
			return _emitterPosType;
		}
		
		public function getTargetRondomXYZ(index:int):Vector3D
		{
			switch(_emitterPosType)
			{
				case EmitterPosType.Axis:
					processAxis(index);
					break;
				case EmitterPosType.CurveFace:
					processCurve(index);
					break;
				case EmitterPosType.Edage:
					processEdage(index);
					break;
				case EmitterPosType.Vertex:
					processVertex(index);
					break;
				case EmitterPosType.Volume:
					processVolume(index);
					break;
				case EmitterPosType.TextureRGB:
					processTextureRGB(index);
					break;
			}
			return _vect3d;
		}
		
		protected function processAxis(index:int):void
		{
			
		}
		
		protected function processVolume(index:int):void
		{
			
		}
		
		protected function processTextureRGB($index:int):void
		{
			if(_bitmapData == null)
			{
				return;
			}
			if(_coordVector == null)
			{
				calculateTextureRGBData();
			}

			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			var _rand3:Number = randnomArr[index+2];
			
			var rand:Number = _rand1;
			var index:int = binarySearch(0, _probabilityList.length-1, rand);
			if(index < 0)
			{
				return;
			}
			var normalIndex:int = _normalIndexs[index];
			normalIndex = normalIndex*3;
			index = index * 3;
			_vect3d.x = _coordVector[index];
			_vect3d.y = _coordVector[index+1];
			_vect3d.z = _coordVector[index+2];
			
			_normal3d.x = _normalVecotr[normalIndex];
			_normal3d.y = _normalVecotr[normalIndex+1];
			_normal3d.z = _normalVecotr[normalIndex+2];
			
			if(_normal3d.x ==0 && _normal3d.y == 0)
			{
				_temp3d.x = _rand2;
				_temp3d.y = 0;
				_temp3d.z = _vect3d.z;
				
			}
			else if(_normal3d.x == 0 && _normal3d.z == 0)
			{
				_temp3d.x = _rand2;
				_temp3d.y = _vect3d.y;
				_temp3d.z = 0;
			}
			else if(_normal3d.z == 0 && _normal3d.y == 0)
			{
				_temp3d.x = _vect3d.x;
				_temp3d.y = 0;
				_temp3d.z = _rand2;
			}
			else if(_normal3d.z == 0)
			{
				_temp3d.x = _rand2;
				_temp3d.y = _vect3d.y - ((_temp3d.x-_vect3d.x)*_normal3d.x)/_normal3d.y;
				_temp3d.z = _rand3;
			}
			else
			{
				_temp3d.x = _rand2;
				_temp3d.y = _rand3;
				_temp3d.z = _vect3d.z - ((_temp3d.x-_vect3d.x)*_normal3d.x + (_temp3d.y-_vect3d.y)*_normal3d.y)/_normal3d.z;
			}
			// 过_vect3d点， 与法线向量垂直，长度为_samplingPricision像素的向量， 然后随机旋转一个角度
			// 初始化变量
		
			_temp3d.x -= _vect3d.x;
			_temp3d.y -= _vect3d.y;
			_temp3d.z -= _vect3d.z;
			_temp3d.normalize();
			var rand1:Number = _samplingPricision * _rand2*0.9;
			_temp3d.scaleBy(rand1);
			
			var rand2:Number = Math.PI*_rand3*2;
			_normal3d.normalize();
			_quaternion.fromAxisAngle(_normal3d, rand2);
			_quaternion.rotatePoint(_temp3d, _normal3d);
			
			_vect3d.x += _normal3d.x;
			_vect3d.y +=_normal3d.y;
			_vect3d.z += _normal3d.z;
		}
		
		protected function processVertex(index:int):void
		{
			
		}
		
		protected function processEdage(index:int):void
		{
			
		}
		
		protected function processCurve(index:int):void
		{
			
		}
		
		public function dispose():void
		{
			_bitmapData=null;
			Resource3dManager.instance.unLoad(lastURL,loadTexturCompleted);
			lastURL=null;
		}
		
		public var lastURL:String;
		public function initTexture(url:String):void
		{
			if(url && url!=lastURL)
			{
				Resource3dManager.instance.unLoad(lastURL,loadTexturCompleted);
			}
			
			lastURL = url;
			_coordVector = null;
			var mesh:Mesh3D = getObject3d() as Mesh3D;
			Resource3dManager.instance.load(url,loadTexturCompleted,mesh.loadPriority);
		}
		
		private function loadTexturCompleted(imgInfo:ImageInfo):void
		{
			isBitmapDataInited = true;
			_bitmapData = imgInfo.bitmapData;
			_uvWidth = _bitmapData.width;
			_uvHeight = _bitmapData.height;
			this.dispatchEvent(new Event(Engine3dEventName.InitComplete));
		}
		/**
		 *  兼顾性能，所以没分出多个函数 
		 * 
		 */		
		protected function calculateTextureRGBData():void
		{
//			var start:int = getTimer();
			_coordVector = new Vector.<Number>();
			_probabilityList = [];
			
			// 获取顶点数据
			if(posVector == null)
			{
				var mesh:Mesh3D = getObject3d() as Mesh3D;
				var surface:FrSurface3D = mesh.getSurface(0);
				var buffer:FrVertexBuffer3D = surface.getVertexBufferByNameId(FilterName_ID.POSITION_ID);
				
				posVector=buffer.vertexVector;
				indexVector=surface.indexBufferFr.indexVector;
				sizePerVertex=buffer.sizePerVertex;
				positionOffset=buffer.bufferVoMap[FilterName_ID.POSITION_ID].offset;
				
				buffer = surface.getVertexBufferByNameId(FilterName_ID.UV_ID);
				uvPosVector = buffer.vertexVector;
				uvSizePerVectex = buffer.sizePerVertex;
				uvOffset = buffer.bufferVoMap[FilterName_ID.UV_ID].offset;
			}
			
			// 处理每一个三角面
			var len:int=indexVector.length;
			var total:Number = 0;
			
			////////////////////
			var tmpVector:Vector3D;
			var minLen:Number;
			var lineNum:int = 0;
		
			//////////////////////////////////////格式化要处理的三角形
			var vectorBC:Vector3D = new Vector3D();
			var uvVectorBC:Vector3D = new Vector3D();
			var vectorAC:Vector3D = new Vector3D();
			var uvVectorAC:Vector3D = new Vector3D();
			var scaleValue:Number;
			
			///////
			var pointInLineBC:Vector3D = new Vector3D();
			var uvPointInLineBC:Vector3D = new Vector3D();
			var lineFromBC_AC:Vector3D = new Vector3D();
			var uvLineFromBC_AC:Vector3D = new Vector3D();
			var pointNormal:Vector3D = new Vector3D(); // 法线
			var pointNormalIndex:int = -1;
			
			var linePointNum:int = 0;
			var lineLen:int = 0;
			var lineScaleValue:Number;
			
			// 最终的采样点
			var finalPoint:Vector3D = new Vector3D();
			var finalUVPoint:Vector3D = new Vector3D();
			var finalGrayValue:uint;
			
			
			var index0:int,index1:int,index2:int;
			var uvIndex0:int, uvIndex1:int, uvIndex2:int;
			
			for(var i:int = 0;i < len;i += 3)
			{
				index0=indexVector[i] * sizePerVertex + positionOffset;
				index1=indexVector[i+1] * sizePerVertex + positionOffset;
				index2=indexVector[i+2] * sizePerVertex + positionOffset;
				uvIndex0 = indexVector[i] * uvSizePerVectex + uvOffset;
				uvIndex1 = indexVector[i + 1] * uvSizePerVectex + uvOffset;
				uvIndex2 = indexVector[i + 2] * uvSizePerVectex + uvOffset;
				
				this.pointA.x=posVector[index0];
				this.pointA.y=posVector[index0+1];
				this.pointA.z=posVector[index0+2];
				this.uvPointA.x = uvPosVector[uvIndex0] * _uvWidth;
				this.uvPointA.y = uvPosVector[uvIndex0 + 1] * _uvHeight;
				
				this.pointB.x=posVector[index1];
				this.pointB.y=posVector[index1+1];
				this.pointB.z=posVector[index1+2];
				this.uvPointB.x = uvPosVector[uvIndex1] * _uvWidth;
				this.uvPointB.y = uvPosVector[uvIndex1+ 1] * _uvHeight;
				
				pointC.x=posVector[index2];
				pointC.y=posVector[index2+1];
				pointC.z=posVector[index2+2];
				uvPointC.x = uvPosVector[uvIndex2] * _uvWidth;
				uvPointC.y = uvPosVector[uvIndex2 + 1] * _uvHeight;
				
//				total += calculateTriangle();
				// 计算三角形内的所有采样点 算法： 最短的边为BC，顶点为A
				// 第一步：BC边，每隔_samplingPricision个像素点分出一个点，共有N个点；
				// 第二步：平衡AB边，对N个点中的每一个画直线与AC相交， 每条直线为Ai -> Bj
				// 第三步：对Ai -> Bj每隔_samplingPricision个像素点取一个采样点
				var len12:Number = Vector3D.distance(this.pointA, this.pointB);
				var len23:Number = Vector3D.distance(this.pointB, this.pointC);
				var len13:Number = Vector3D.distance(this.pointA, this.pointC);
				
				minLen = Math.min(len12, len23, len13);
				
				if(minLen == len12) // AB最短
				{
					tmpVector = this.pointA;
					this.pointA = this.pointC;
					this.pointC = tmpVector;
					tmpVector = this.uvPointA;
					this.uvPointA = this.uvPointC;
					this.uvPointC = tmpVector;
				}
				else if(minLen == len23) // BC 最短
				{
					// 不用动
				}
				else // AC最短
				{
					tmpVector = this.pointA;
					this.pointA = this.pointB;
					this.pointB = this.pointC;
					this.pointC = tmpVector;
					tmpVector = this.uvPointA;
					this.uvPointA = this.uvPointB;
					this.uvPointB = this.uvPointC;
					this.uvPointC = tmpVector;
				}
				
				// 计算出BC边有多少条线
				lineNum = int(minLen/_samplingPricision) + 1;
				// BC, AC的向量
				this.subtract(pointC, pointB, vectorBC);
				this.subtract(pointC, pointA, vectorAC);
				this.subtract(uvPointC, uvPointB, uvVectorBC);
				this.subtract(uvPointC, uvPointA, uvVectorAC);
				
				// 计算这个面的法线 AC X AB
				pointNormal = vectorBC.crossProduct(vectorAC);
				_normalVecotr.push(pointNormal.x, pointNormal.y, pointNormal.z);
				pointNormalIndex++;
				
				//////////////////////////////////////////////////////////////////////////////////////////

				for(var j:int = 1; j <= lineNum; j++)
				{
					scaleValue = (j / lineNum);
					
					// BC 边上的点
					pointInLineBC.x = pointB.x + vectorBC.x * scaleValue;
					pointInLineBC.y = pointB.y + vectorBC.y * scaleValue;
					pointInLineBC.z = pointB.z + vectorBC.z * scaleValue;
					uvPointInLineBC.x = uvPointB.x + uvVectorBC.x * scaleValue;
					uvPointInLineBC.y = uvPointB.y + uvVectorBC.y * scaleValue;
					// AC 边上的点
					finalPoint.x = pointA.x + vectorAC.x * scaleValue;
					finalPoint.y = pointA.y + vectorAC.y * scaleValue;
					finalPoint.z = pointA.z + vectorAC.z * scaleValue;
					finalUVPoint.x = uvPointA.x + uvVectorAC.x * scaleValue;
					finalUVPoint.y = uvPointA.y + uvVectorAC.y * scaleValue;
					
					this.subtract(finalPoint, pointInLineBC, lineFromBC_AC);// 每一条线
					this.subtract(finalUVPoint, uvPointInLineBC, uvLineFromBC_AC);// uv中对应的线
					
					// 每条线上的采样点数
					lineLen = lineFromBC_AC.length;
					linePointNum = lineLen/_samplingPricision + 1;
					
					for(var k:int = 1; k <= linePointNum ; k++)
					{
						lineScaleValue = k / linePointNum;
						
						finalPoint.x = pointInLineBC.x + lineFromBC_AC.x * lineScaleValue;
						finalPoint.y = pointInLineBC.y + lineFromBC_AC.y * lineScaleValue;
						finalPoint.z = pointInLineBC.z + lineFromBC_AC.z * lineScaleValue;
						
						finalUVPoint.x = (uvPointInLineBC.x + uvLineFromBC_AC.x * lineScaleValue);
						finalUVPoint.y = (uvPointInLineBC.y + uvLineFromBC_AC.y * lineScaleValue);
						// 获取颜色值
						finalGrayValue = getGrayValue(_bitmapData.getPixel32(finalUVPoint.x, finalUVPoint.y));
						finalGrayValue = finalGrayValue * finalGrayValue/255;
						
						_coordVector.push(finalPoint.x, finalPoint.y, finalPoint.z);
						_probabilityList.push(finalGrayValue);
						_normalIndexs.push(pointNormalIndex);
						
						total += finalGrayValue;
					}
				}
			}
			
			// 处理概率的问题
			len = _probabilityList.length;
			var tmp:Number;
			var tmpTotal:Number = 0;
			for(i = 0; i < len; i++)
			{
				tmpTotal += _probabilityList[i];
				_probabilityList[i] = tmpTotal/total;
			}
			
			///
//			trace("一共处理点数：" + _probabilityList.length.toString() + ",,,,, 用的时间：" + (start - getTimer()).toString());
		}
		
		public function getGrayValue(rgb:uint):uint
		{
			var r:uint = rgb >> 16 & 0xff; 
			var g:uint = rgb >> 8 & 0xff; 
			var b:uint = rgb & 0xff; 
			
			return ((r * 0.3 + g * 0.59 + b * 0.11)>>0);
		}
		
		private function subtract(a:Vector3D, b:Vector3D, target:Vector3D):void
		{
			target.x = a.x - b.x;
			target.y = a.y - b.y;
			target.z = a.z - b.z;
		}
		
		public function binarySearch(startIndex:int, endIndex:int, value:Number):int
		{
			if(_probabilityList[0] > value)
			{
				return 0;
			}
			if(endIndex <= startIndex)
			{
				return -1;
			}
			if(endIndex == startIndex + 1)
			{
				if(_probabilityList[startIndex] < value && _probabilityList[endIndex] >= value)
				{
					return endIndex;
				}
				else if(_probabilityList[startIndex] >= value && startIndex>=1 && _probabilityList[startIndex - 1] < value)
				{
					return startIndex;
				}
				return -1;
			}
			
			var index:int = startIndex + (endIndex - startIndex)/2;
			var curValue:Number = _probabilityList[index];
			var preValue:Number = _probabilityList[index - 1]
			if(curValue >= value && preValue < value) // 找到了
			{
				return index;
			}
			else if(curValue > value)
			{
				return binarySearch(startIndex, index, value);
			}
			else 
			{
				return binarySearch(index, endIndex, value);
			}
			return -1;
		}
		
	}
}