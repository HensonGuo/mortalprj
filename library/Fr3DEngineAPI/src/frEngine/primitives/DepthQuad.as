package frEngine.primitives
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import __AS3__.vec.Vector;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.fragmentFilters.TextureFilter;
	import frEngine.shader.filters.fragmentFilters.UvOffsetFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	import frEngine.shader.registType.FcParam;
	
	public class DepthQuad extends Mesh3D 
	{
		private var _width:Number;
		private var _height:Number;
		private var _surf:FrSurface3D;
		
		public var bmpSize:int;
		private var scalex:Number;
		private var scaley:Number;
		private var centerOffsetX:Number;
		private var centerOffsetY:Number;
		private const depthTextureSizeW:int=512;
		private const depthTextureSizeH:int=256;
		private var _depthTexture:Texture3D;
		private var _material:ShaderBase;
		private var _offsetValue:Vector.<Number>;
		
		public function DepthQuad($bmpSize:int,$renderList:RenderList)
		{
			super("",true,$renderList);
			bmpSize=$bmpSize;
			
			centerOffsetX=(depthTextureSizeW-bmpSize)/depthTextureSizeW*0.5;
			centerOffsetY=(depthTextureSizeH-bmpSize)/depthTextureSizeH*0.5;
			this._surf = new FrSurface3D("quad");
			this._surf.addVertexData(FilterName_ID.POSITION_ID,3,false,null);
			this._surf.addVertexData(FilterName_ID.UV_ID,2,false,null);

			var vertexVector:Vector.<Number>=this._surf.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector;
			vertexVector.push(-1, 1, 0, 0, 0);
			vertexVector.push(1, 1, 0, 1, 0);
			vertexVector.push(-1, -1, 0, 0, 1);
			vertexVector.push(1, -1, 0, 1, 1);
			
			this._surf.indexVector = new Vector.<uint>();
			this._surf.indexVector.push(0, 1, 2, 3, 2, 1);

			this.addSurface(this._surf);
			
			this.setTo( depthTextureSizeW, depthTextureSizeH);

			_material=new ShaderBase("depthQuad",new TransformFilter(0),new TextureFilter(depthTexture),this.materialPrams);
			this.materialPrams.addFilte(new UvOffsetFilter());
			this.materialPrams.uvRepeat=false;
			this.setMaterial(_material,Texture3D.MIP_NONE,_material.name);
			this.setMateiralBlendMode(0);
			materialPrams.twoSided=false;
			materialPrams.depthWrite=true;
		}
		protected override function setShaderBase(materaial:ShaderBase):void
		{
			
			TransformFilter(materaial.vertexFilter).OpType=ECalculateOpType.WorldViewProj;
			super.setShaderBase(materaial);
			
		}
		public  function get depthTexture():Texture3D
		{
			if(!_depthTexture)
			{
				_depthTexture=new Texture3D(new Point(depthTextureSizeW,depthTextureSizeH),Texture3D.MIP_LINEAR);
				_depthTexture.mipMode=Texture3D.MIP_NONE;
			}
			if(!_depthTexture.scene && Device3D.scene)
			{
				_depthTexture.upload(Device3D.scene,false);
			}
			return _depthTexture;
		}
		public function setTo(_arg3:Number, _arg4:Number):void
		{
			this._width = _arg3;
			this._height = _arg4;
		}
		public function drawDepth(offsetx:Number,offsety:Number):void
		{
			
			if (!scene)
			{
				upload(Device3D.scene);
			};
			if (!visible)
			{
				return;
			};
			var _rect:Rectangle = scene.viewPort;
			if( this._width/_rect.width!=scalex || this._height/_rect.height!=scaley)
			{
				
				scalex = (this._width / _rect.width);
				scaley = (this._height / _rect.height);

				/*scalex = 1  - scalex;
				scaley = 1  - scaley;*/
				
				transform.identity();
				transform.appendScale(scalex, scaley, 1);
				transform.appendTranslation( scalex-1 , 1 - scaley, 0);
			}
			
			Device3D.worldViewProj.copyFrom(transform);
			
			var toReBuiderProgram:Boolean=_material.toReBuiderProgram;
			
			var hasPrepared:Boolean=_material.hasPrepared(this,this._surf)
				
			if(!_offsetValue || toReBuiderProgram)
			{
				var fc:FcParam=_material.getParam("{UVoffset}",false);
				_offsetValue=fc.value;
				
			}
			
			if(!hasPrepared)
			{
				return;
			}
			
			
			_offsetValue[0]=offsetx+centerOffsetX;
			_offsetValue[1]=offsety+centerOffsetY;
			
			_material.draw(this, this._surf,materialPrams.depthCompare,materialPrams.cullFace,materialPrams.depthWrite,materialPrams.sourceFactor,materialPrams.destFactor);	
			
		}
		
	}
}

