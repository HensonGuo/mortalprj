package frEngine.animateControler.skilEffect
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.colorControler.ColorKeyFrame;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;
	import frEngine.core.SwordLightSurface;
	import frEngine.core.mesh.SwordLightMesh_Bone;
	import frEngine.shader.filters.fragmentFilters.SwordLightFragmentFilter_Bone;
	import frEngine.shader.registType.FcParam;

	public class SwordLightControler_Bone extends MeshAnimateBase
	{
		public var useTwoLine:Boolean = false;
		private var swordVertexFilter:SwordLightFragmentFilter_Bone;
		private var showLineNum:int = 3;
		private var showLineNumBase:Number = 3;
		public var splitNum:int=8;
		private var swordMesh:SwordLightMesh_Bone;
		private var swordSurface:SwordLightSurface;
		public var length1:int=0;
		public var offsetY:int=100;
		private var uvOffset:Vector.<Number>=Vector.<Number>([0,1,0,0]);
		public function SwordLightControler_Bone()
		{
			super();
			swordVertexFilter = new SwordLightFragmentFilter_Bone();
		}

		
		public function initData($length1:int, $length2:int, $angle:Number, $showLineNumBase:int,$offsetY:int,$splitNum:int):void
		{
			useTwoLine = false// $length2 > 1 ? true : false;
			length1=$length1;
			offsetY=$offsetY;
			splitNum=$splitNum;
			if(splitNum<1)
			{
				splitNum=1;
			}
			/*if (useTwoLine)
			{
				var xx:Number = Math.sin($angle) * $length2 / 2;
				var yy:Number = Math.cos($angle) * $length2 / 2;
				start2 = new Vector3D(xx, yy, 0);
				end2 = new Vector3D(-xx, -yy, 0);
			}*/

			showLineNum=showLineNumBase = $showLineNumBase;

			swordMesh.reInitPlaySwordLight();
			
			changeBaseValue(null,showLineNumBase);
			
		}
		

		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return showLineNumBase;
		}

		protected override function setTargetProperty(value:*):void
		{
			showLineNum = int(value);
		}

		
		public override function editKeyFrame(track:Object, keyIndex:int, attribute:String, value:*,bezierVo:BezierVo):Object
		{
			var obj:Object=super.editKeyFrame(track,keyIndex,attribute,value,bezierVo);
			showLineNum=value+showLineNumBase;
			updateData();
			return obj;
		}
		protected override function setSurfaceHander(e:Event):void
		{
			super.setSurfaceHander(e);
			swordSurface=targetSurface as SwordLightSurface;
		}
		protected override function setMaterialHander(e:Event):void
		{
			super.setMaterialHander(e);
			normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER, getRegsiterHander);
			if (normalMaterial)
			{
				normalMaterial.materialParams.addFilte(swordVertexFilter);
			}
			
		}

		private function getRegsiterHander(e:Event):void
		{
			var register:FcParam=normalMaterial.getParam("{swordUVOffset}", false);
			if(register)
			{
				register.value=uvOffset;
			}
			
		}

		
		public override function set targetObject3d(value:Pivot3D):void
		{
			swordMesh=value as SwordLightMesh_Bone;
			super.targetObject3d = value;
		}
		
		public override function toUpdateAnimate(forceUpdate:Boolean=false):void
		{
			
			super.toUpdateAnimate(forceUpdate);
			if (!swordMesh.toUpdate)
			{
				return;
			}
			swordMesh.toUpdate=false;
			updateData();
		}
		
		private function updateData():void
		{
			if(!swordMesh.curHangControler || !swordSurface)
			{
				return;
			}
			var frame:int=swordMesh.curHangControler.currentFrame;
			var len:int=swordMesh.curHangControler.cuPlayLable.length
			
			frame=(frame+len-1)%len;
			
			var triangleNum:int=showLineNum*splitNum*2;
			var startN:int=frame*splitNum*6-triangleNum*3;
			if(startN<0)
			{
				triangleNum+=startN/3;
				startN=0;
			}
			
			uvOffset[0]=(startN)/6/swordSurface.totalNumLine;
			uvOffset[1]=swordSurface.totalTriangle/triangleNum;
			
			swordSurface.firstIndex=startN;
			swordSurface.numTriangles=triangleNum;
		}

		public override function get type():int
		{
			return AnimateControlerType.swordLight_Bone;
		}
		
		public override function dispose():void
		{
			swordMesh=null;
			swordSurface=null;
			super.dispose();
		}
	}
}
