package frEngine.animateControler.skilEffect
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Label3D;
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.NodeAnimateKey;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.core.mesh.SwordLightMesh_Normal;
	import frEngine.math.Quaternion;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.vertexFilters.SwordLightVertexFilter_Normal;

	public class SwordLightControler_Normal extends MeshAnimateBase
	{

		private var start1:Vector3D;
		private var end1:Vector3D;

		private var start2:Vector3D;
		private var end2:Vector3D;

		private var _curPos:Vector3D = new Vector3D();
		private var _totalLen:uint=1;
		private var _curRot:Quaternion = new Quaternion();
		private var _zero:Vector3D = new Vector3D();
		
		public var useTwoLine:Boolean = false;

		public var splitBlankKeyNum:int = 3;
		private var perFrameFragment:int = 8;
		private var totalLineNum:int = 0;
		private var posList:Vector.<Number> = new Vector.<Number>;
		private var rotList:Vector.<Number> = new Vector.<Number>;
		private var swordVertexFilter:SwordLightVertexFilter_Normal;
		private var enabledShut:Number = 1;

		private var _maxLen:uint=0;
		public function SwordLightControler_Normal()
		{
			super();
			swordVertexFilter = new SwordLightVertexFilter_Normal(splitBlankKeyNum + 1);
		}

		public function initData($length1:int, $length2:int, $angle:Number, $splitBlankKeyNum:int, $perFrameFragment:int):void
		{
			//targetSword=$targetSword;
			start1 = new Vector3D( -$length1 / 2,0, 0);
			end1 = new Vector3D($length1 / 2,0, 0);

			useTwoLine = $length2 > 1 ? true : false;

			if (useTwoLine)
			{
				var xx:Number = Math.cos($angle) * $length2 / 2;
				var zz:Number = Math.sin($angle) * $length2 / 2;
				
				start2 = new Vector3D(xx, 0, zz);
				end2 = new Vector3D(-xx, 0, -zz);
			}

			splitBlankKeyNum = $splitBlankKeyNum > 20 ? 20 : $splitBlankKeyNum;

			perFrameFragment = $perFrameFragment > 5 ? 5 : $perFrameFragment;

			totalLineNum = splitBlankKeyNum * perFrameFragment + 1;


			var surface:FrSurface3D = new FrSurface3D("");
			targetMesh.addSurface(surface);

			createCIndexBuffer();
			createTriangleIndex();
			createUV();
			createTime();
			createPostion();

			var constRegistNum:uint=splitBlankKeyNum + 1;
			
			if (swordVertexFilter.reInit(constRegistNum))
			{
				targetMesh.materialPrams.needRebuild();
			}
			
			this.setPlayLable(defaultLable);
			
			_maxLen=constRegistNum * 4;
		}

		public override function get defaultLable():Label3D
		{
			_defaultLable == null && (_defaultLable = new Label3D(0, int.MAX_VALUE, "#default#",0));
			return _defaultLable;
		}

		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return enabledShut;
		}

		protected override function setTargetProperty(value:*):void
		{
			enabledShut = Number(value);
		}

		protected override function calculateFrameValue(tframe:int):void
		{
			var index:int = getTimeIndex(tframe, _keyframes);
			var m1:NodeAnimateKey = _keyframes[index];
			_cache[tframe] = m1.value;
		}

		protected override function setMaterialHander(e:Event):void
		{
			super.setMaterialHander(e);
			normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER, getRegsiterHander);

			if (normalMaterial)
			{
				normalMaterial.setVertexFilter(swordVertexFilter);
			}

		}

		private function getRegsiterHander(e:Event):void
		{
			normalMaterial.getParam("{keyLinePos}", true).value = this.posList;
			normalMaterial.getParam("{keyLineRot}", true).value = this.rotList;
			
		}

		private function createUV():void
		{
			var uvvector:Vector.<Number> = new Vector.<Number>;
			var perData1:Number = 1 / splitBlankKeyNum;
			var perData2:Number = perData1 / perFrameFragment;
			for (var i:int = 0; i < splitBlankKeyNum; i++)
			{
				var baseU:Number = i * perData1;
				for (var j:int = 0; j < perFrameFragment; j++)
				{
					var uValue:Number = 1 - (baseU + j * perData2);
					uvvector.push(uValue, 1);
					uvvector.push(uValue, 0);
					if (useTwoLine)
					{
						uvvector.push(uValue, 1);
						uvvector.push(uValue, 0);
					}
				}
			}
			uvvector.push(0, 1);
			uvvector.push(0, 0);
			if (useTwoLine)
			{
				uvvector.push(0, 1);
				uvvector.push(0, 0);
			}
			var f1:FrVertexBuffer3D = targetSurface.addVertexData(FilterName_ID.UV_ID, 2, true, null);
			f1.vertexVector = uvvector;
		}
		
		private function createCIndexBuffer():void
		{
			var f1:FrVertexBuffer3D = targetSurface.addVertexData(FilterName_ID.SKIN_INDICES_ID, 4, true, null);//cindex
			var vector:Vector.<Number> = f1.vertexVector;

			var numVertex:int = useTwoLine ? 4 : 2;

			for (var i:int = 0; i < splitBlankKeyNum; i++)
			{
				var pre:int = i - 1;
				pre < 0 && (pre = 0 )
				var nextp:int = i + 1;
				var nextc:int = nextp + 1;
				nextc > splitBlankKeyNum && (nextc = splitBlankKeyNum);

				for (var j:int = 0; j < perFrameFragment; j++)
				{
					for (var k:int = 0; k < numVertex; k++)
					{
						vector.push(i, pre, nextp, nextc);
					}
				}
			}

			for (k = 0; k < numVertex; k++)
			{
				vector.push(splitBlankKeyNum, splitBlankKeyNum, splitBlankKeyNum, splitBlankKeyNum);
			}


		}

		private function createPostion():void
		{
			var p:Number = 1 / perFrameFragment;

			var position:Vector.<Number> = new Vector.<Number>;
			for (var i:int = 0; i < splitBlankKeyNum; i++)
			{
				for (var j:int = 0; j < perFrameFragment; j++)
				{
					var k1:Number = j * p;
					position.push(start1.x, start1.y, start1.z, k1);
					position.push(end1.x, end1.y, end1.z, k1);
					if (useTwoLine)
					{
						position.push(start2.x, start2.y, start2.z, k1);
						position.push(end2.x, end2.y, end2.z, k1);
					}
				}
			}
			position.push(start1.x, start1.y, start1.z, 1);
			position.push(end1.x, end1.y, end1.z, 1);
			if (useTwoLine)
			{
				position.push(start2.x, start2.y, start2.z, 1);
				position.push(end2.x, end2.y, end2.z, 1);
			}
			var f2:FrVertexBuffer3D = targetSurface.addVertexData(FilterName_ID.POSITION_ID, 4, true, null);
			f2.vertexVector = position;
		}

		private function createTime():void
		{
			var p:Number = 1 / perFrameFragment;
			var timeVector:Vector.<Number> = new Vector.<Number>;
			for (var i:int = 0; i < splitBlankKeyNum; i++)
			{
				for (var j:int = 0; j < perFrameFragment; j++)
				{
					var k1:Number = j * p;
					var k2:Number = 1 - k1;
					var t1:Number = k2 * k2 * k2;
					var t2:Number = 3 * k1 * k2 * k2;
					var t3:Number = 3 * k1 * k1 * k2;
					var t4:Number = k1 * k1 * k1;
					timeVector.push(t1, t2, t3, t4);
					timeVector.push(t1, t2, t3, t4);
					if (useTwoLine)
					{
						timeVector.push(t1, t2, t3, t4);
						timeVector.push(t1, t2, t3, t4);
					}

				}
			}

			timeVector.push(0, 0, 0, 1);
			timeVector.push(0, 0, 0, 1);
			if (useTwoLine)
			{
				timeVector.push(0, 0, 0, 1);
				timeVector.push(0, 0, 0, 1);
			}

			var f2:FrVertexBuffer3D = targetSurface.addVertexData(FilterName_ID.PARAM0_ID, 4, true, null);//time
			f2.vertexVector = timeVector;
		}

		private function createTriangleIndex():void
		{
			var len:int = totalLineNum - 1;
			var indexVector:Vector.<uint> = new Vector.<uint>;
			var i:int, n:int;
			if (useTwoLine)
			{
				for (i = 0; i < len; i++)
				{

					n = i * 4;
					indexVector.push(n);
					indexVector.push(n + 1);
					indexVector.push(n + 4);

					indexVector.push(n + 1);
					indexVector.push(n + 5);
					indexVector.push(n + 4);

					indexVector.push(n + 2);
					indexVector.push(n + 3);
					indexVector.push(n + 6);

					indexVector.push(n + 3);
					indexVector.push(n + 7);
					indexVector.push(n + 6);

				}
			}
			else
			{
				for (i = 0; i < len; i++)
				{

					n = i * 2;
					indexVector.push(n);
					indexVector.push(n + 1);
					indexVector.push(n + 2);

					indexVector.push(n + 1);
					indexVector.push(n + 3);
					indexVector.push(n + 2);


				}
			}

			targetSurface.indexBufferFr.indexVector = indexVector;
		}

		private var swordMesh:SwordLightMesh_Normal;
		public override function set targetObject3d(value:Pivot3D):void
		{
			if (targetObject3d)
			{
				targetObject3d.removeEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT, visibleChangeHander);
			}
			if (value)
			{
				value.addEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT, visibleChangeHander);
			}
			swordMesh=value as SwordLightMesh_Normal;
			super.targetObject3d = value;
		}

		private function visibleChangeHander(e:Event):void
		{
			posList.length = 0;
			rotList.length = 0;
		}

		private var _preFrame:int=-1;
		
		public override function toUpdateAnimate(forceUpdate:Boolean=false):void
		{

			var _curFrame:int=targetMesh.timerContorler.curFrame
			if (_preFrame==_curFrame)
			{
				return;
			}

			if(_preFrame>_curFrame || _curFrame==1)
			{
				posList.length = 0
				rotList.length = 0;
			}
			
			_preFrame=_curFrame;
			
			if (posList.length == 0)
			{
				resetLine1();
			}

			var worldM:Matrix3D=targetMesh.world
			var _pos:Vector3D=worldM.transformVector(_zero);
			_curRot.fromMatrix(worldM);
			_curRot.normalize();
			
			_curPos=_pos;
			rotList.unshift(_curRot.x, _curRot.y, _curRot.z, _curRot.w);
			posList.unshift(_curPos.x, _curPos.y, _curPos.z, 0);
			
			rotList.length = posList.length = _maxLen;

		}

		private function resetLine1():void
		{
			var len:int = splitBlankKeyNum + 1;
			var worldM:Matrix3D=targetMesh.world;
			_curPos=worldM.transformVector(_zero);
			_curRot.fromMatrix(worldM);
			_curRot.normalize();
			var posx:Number = _curPos.x;
			var posy:Number = _curPos.y;
			var posz:Number = _curPos.z;
			var rotx:Number = _curRot.x;
			var roty:Number = _curRot.y;
			var rotz:Number = _curRot.z;
			var rotw:Number = _curRot.w;
			for (var i:int = 0; i < len; i++)
			{
				posList.push(posx, posy, posz, 0);
				rotList.push(rotx, roty, rotz, rotw);
			}
			_totalLen=1;
		}

		public override function get type():int
		{
			return AnimateControlerType.swordLight_Normal;
		}

	}
}
