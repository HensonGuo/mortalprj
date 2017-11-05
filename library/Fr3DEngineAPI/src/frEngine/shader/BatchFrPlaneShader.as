package frEngine.shader
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Surface3D;
	import baseEngine.system.Device3D;
	
	import frEngine.primitives.BatchDrawFrPlane;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	import frEngine.shader.filters.vertexFilters.BatchPlaneVertexFilter;
	
	public class BatchFrPlaneShader extends ShaderBase
	{
		private var const120:Vector.<Number>=new Vector.<Number>(120*4);
		public var  objectsNum:int=0;
		private var uvInfoByName:Dictionary;
		public function BatchFrPlaneShader($name:String,$fragmentFilter:FragmentFilter,$uvInfoByName:Dictionary,$materialParams:MaterialParams)
		{
			super($name, new BatchPlaneVertexFilter(), $fragmentFilter,$materialParams);
			uvInfoByName=$uvInfoByName;
			this.isBatchMaterial=true; 
		}

		public override function drawLeftNums(pivot:Pivot3D,surf:Surface3D):void
		{
			if(objectsNum>0)
			{
				//super.draw(pivot,surf,null,0,objectsNum*2);
				objectsNum=0;
			}
		}
		public override function draw(pivot:Pivot3D, surf:Surface3D,depthCompare:String ,cullFace:String,depthWrite:Boolean,sourceFactor:String,destFactor:String, firstIndex:int=0, count:int=-1):void
		{
			
			pushObject(BatchDrawFrPlane(pivot));
			if(objectsNum>=20)
			{
				super.draw(pivot,surf,depthCompare,cullFace,depthWrite,sourceFactor,destFactor,firstIndex,count);
				objectsNum=0;
			}
			
		}
		private  function pushObject(frplane:BatchDrawFrPlane):void
		{  
			var materialName:String//=frplane.materialName;
			var v:Vector3D=uvInfoByName[materialName];
			if(!v)
			{
				return;
			}
			var m:Matrix3D=Device3D.worldViewProj; 
			var startN:int=objectsNum*6*4;
			m.copyRawDataTo(const120,startN,true);
			const120[startN+16]=frplane.width;
			const120[startN+17]=frplane.height;
			const120[startN+19]=frplane.materialPrams.alphaBase;
			const120[startN+20]=v.x;
			const120[startN+21]=v.y;
			const120[startN+22]=v.z;
			const120[startN+23]=v.w;
			objectsNum++;

		}
		protected override function buildBytes():Boolean
		{
			var hasbuilded:Boolean=super.buildBytes();
			if(hasbuilded)
			{
				this.getParam("{const120}",true).value=const120;
			}
			return hasbuilded;
		}
	}
}