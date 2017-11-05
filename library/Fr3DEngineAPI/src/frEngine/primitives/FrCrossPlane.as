package frEngine.primitives
{
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	
	public class FrCrossPlane extends Mesh3D 
	{

		private var _w:Number;
		private var _h:Number;
		private var _axis:String;

		public function FrCrossPlane(_arg1:String,$renderList:RenderList, $w:Number=10, $h:Number=10, $axis:String = "y",$material:Material3D=null)
		{
			
			
			super(_arg1,true,$renderList);
			_axis=$axis;
			var _surface:FrSurface3D
			if(!$material)
			{
				$material=new ShaderBase("FrCrossPlane",new TransformFilter(),new ColorFilter(0.3,0.3,0.3,1),this.materialPrams);
			}
			this._w = $w;
			this._h = $h;
			
			this.setMateiralBlendMode(Material3D.BLEND_LIGHT);
			this.materialPrams.depthWrite=false;
			this.materialPrams.twoSided=true;
			this.setLayer(Layer3DManager.AlphaLayer0);
			
			_surface= new FrSurface3D("crossPlane");
			this.setSurface(0,_surface);
			_surface.addVertexData(FilterName_ID.POSITION_ID,3,false,null);
			_surface.addVertexData(FilterName_ID.UV_ID,2,false,null);
			_surface.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector = getVertexVector();
			_surface.indexVector = getIndexVector();

			_surface.updateBoundings();

			setMaterial($material,Texture3D.MIP_NONE,$material.name);
			
		}

		
		private function getVertexVector():Vector.<Number>
		{
			var vector:Vector.<Number>=new Vector.<Number>();
			var w2:Number=_w/2;
			var h2:Number=_h/2;
			if(_axis=="y")
			{
				vector.push(w2,h2,0,1,1);
				vector.push(w2,-h2,0,0,1);
				vector.push(-w2,-h2,0,0,0);
				vector.push(-w2,h2,0,1,0);
				
				vector.push(0,h2,w2,1,1);
				vector.push(0,h2,-w2,1,0);
				vector.push(0,-h2,-w2,0,0);
				vector.push(0,-h2,w2,0,1);
			}
			else if(_axis=="z")
			{
				vector.push(w2,0,h2,1,1);
				vector.push(w2,0,-h2,0,1);
				vector.push(-w2,0,-h2,0,0);
				vector.push(-w2,0,h2,1,0);
				
				vector.push(0,w2,h2,1,1);
				vector.push(0,-w2,h2,1,0);
				vector.push(0,-w2,-h2,0,0);
				vector.push(0,w2,-h2,0,1);
			}else
			{
				vector.push(h2,w2,0,1,1);
				vector.push(-h2,w2,0,0,1);
				vector.push(-h2,-w2,0,0,0);
				vector.push(h2,-w2,0,1,0);
				
				vector.push(h2,0,w2,1,1);
				vector.push(h2,0,-w2,1,0);
				vector.push(-h2,0,-w2,0,0);
				vector.push(-h2,0,w2,0,1);
			}
			
			return vector;
		}
		private function getIndexVector():Vector.<uint>
		{
			var vector:Vector.<uint>=new Vector.<uint>();
			for(var i:int=0;i<2;i++)
			{
				var offset:int=i*4;
				vector.push(offset,offset+1,offset+2);
				vector.push(offset+2,offset+3,offset);
			}
			return vector;
		}

		public function get height():Number
		{
			return (this._h);
		}
		public function get width():Number
		{
			return this._w;
		}

		
	}
}

