package baseEngine.basic
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	
	import baseEngine.core.Mesh3D;
	
	import frEngine.core.mesh.Md5Mesh;
	

	public class SceneDepthQuad extends TargetQuad
	{
		
		public function SceneDepthQuad(create:Boolean,_id:String, blendtype:int)
		{
			super(create, _id, blendtype);
		}
		
		public function renderShadow(context:Context3D,renderLayerList:RenderList):void
		{
			var layers:Vector.<Layer3DSort>=renderLayerList.layers;
			context.setStencilReferenceValue( 0 );
			context.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.EQUAL, Context3DStencilAction.INCREMENT_SATURATE ); 
			var len:int=layers.length;
			for(var i:int=0;i<len;i++)
			{
				var layersort:Layer3DSort=layers[i];

				if(layersort.isActive)
				{
					layersort.sort();
				}
				var list:Vector.<Mesh3D>=layersort.list;
				var len2:int=list.length;
				if(len2>0)
				{
					for(var j:int=0;j<len2;j++)
					{
						var mesh:Mesh3D=list[j];
						if(mesh is Md5Mesh)
						{
							Md5Mesh(mesh).targetMd5Controler.drawShadow(mesh);
						}
						
					}
				}
			}
			context.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.ALWAYS, Context3DStencilAction.KEEP );
		}
		
	}
}