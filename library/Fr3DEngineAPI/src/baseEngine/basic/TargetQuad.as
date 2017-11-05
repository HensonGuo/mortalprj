package baseEngine.basic
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.primitives.FrQuad;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.fragmentFilters.JXmohuFilter;
	import frEngine.shader.filters.fragmentFilters.TextureFilter;
	import frEngine.shader.filters.fragmentFilters.UvOffsetFilter;
	import frEngine.shader.filters.fragmentFilters.UvScaleFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;

	public class TargetQuad
	{
		private var _textureScale:Number=1;
		public var layerQuad:FrQuad;
		public var texture3d:Texture3D;
		public var material:ShaderBase;
		private static const vf:TransformFilter=new TransformFilter();

		private var uvScaleFilter:UvScaleFilter = new UvScaleFilter();
		private var uvOffsetFilter:UvOffsetFilter = new UvOffsetFilter(0,0);
		private var jxMohuFilter:JXmohuFilter=new JXmohuFilter();
		
		public var clipRect:Rectangle=new Rectangle(0,0,Scene3D.textureWidth,Scene3D.textureHeight); 
		public function TargetQuad(create:Boolean,_id:String,blendtype:int)
		{
			if(create)
			{
				init(_id,blendtype);
			}
			

		}
		public function set textureScale(value:Number):void
		{
			_textureScale=value;
			changeSize();
		}
		public function get textureScale():Number
		{
			return _textureScale;
		}
		public function init(_id:String,blendtype:int):void
		{
			texture3d=new Texture3D(new Point(Scene3D.textureWidth,Scene3D.textureHeight),0,0);
			material=new ShaderBase(_id,vf,new TextureFilter(texture3d),null);
			layerQuad=new FrQuad(_id,0,0,Scene3D.textureWidth,Scene3D.textureHeight,true,null,null);
			layerQuad.setMateiralBlendMode(blendtype);
			layerQuad.materialPrams.depthWrite=false;
			layerQuad.materialPrams.addFilte(uvScaleFilter);
			layerQuad.materialPrams.addFilte(uvOffsetFilter);
			layerQuad.materialPrams.addFilte(jxMohuFilter);
			layerQuad.setMaterial(material,Texture3D.MIP_NONE,material.name);
			if(Device3D.scene)
			{
				resize(Device3D.scene.viewPort);
			}
			setTimeout(checkToUpload,500);
		}
		
		private function checkToUpload():void
		{
			if(texture3d.texture==null && Device3D.scene)
			{
				texture3d.upload(Device3D.scene,true);
			}
			
			if(!material.hasPrepared(null,FrQuad.surf) || texture3d.texture==null)
			{
				setTimeout(checkToUpload,500);
			}
		}

		public function resize(viewPort:Rectangle):void
		{
			if(viewPort && layerQuad)
			{
				layerQuad.sceneRect=viewPort;
				changeSize();
			}
			
			
		}
		private function changeSize():void
		{
			var textureScaleW:Number,textureScaleH:Number,textureOffsetX:Number,textureOffsetY:Number;
			
			var viewPort:Rectangle=layerQuad.sceneRect;
			var targetw:int=viewPort.width/_textureScale;
			var targeth:int=viewPort.height/_textureScale;
			
			uvScaleFilter.uvValue[0] = textureScaleW=targetw/Scene3D.textureWidth;
			uvScaleFilter.uvValue[1] = textureScaleH=targeth/Scene3D.textureHeight;
			uvOffsetFilter.uvOffsetValue[0]=textureOffsetX=(1-textureScaleW)*0.5;
			uvOffsetFilter.uvOffsetValue[1]=textureOffsetY=(1-textureScaleH)*0.5;

			clipRect.width=targetw;
			clipRect.height=targeth;
			clipRect.x=textureOffsetX*Scene3D.textureWidth;
			clipRect.y=textureOffsetY*Scene3D.textureHeight;
			
			
		}
		public function render(renderLayerList:RenderList):uint
		{
			var layers:Vector.<Layer3DSort>=renderLayerList.layers;
			var len:int=layers.length;
			var num:int=0;
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
						list[j].draw(false);
						num++;
					}
				}
			}
			return num;
			
		}
		
	}
}