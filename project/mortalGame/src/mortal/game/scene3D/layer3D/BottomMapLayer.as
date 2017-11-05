package mortal.game.scene3D.layer3D
{
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ImageInfo;
	
	import flash.display3D.Context3D;
	import flash.geom.Point;
	
	import baseEngine.basic.Layer3DSort;
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.OrthographicCamera3D;
	import frEngine.primitives.FrQuad;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.fragmentFilters.TextureFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;

	public class BottomMapLayer extends SLayer3D
	{
		public static const instance:BottomMapLayer=new BottomMapLayer();
		private var _texture:Texture3D;
		private var material:ShaderBase;
		private var layerQuad:FrQuad;
		private var _renderList:RenderList;
		private var _gameCameraCopy:OrthographicCamera3D;
		public function BottomMapLayer()
		{
			super("");
			
			_renderList=new RenderList();
			
			_gameCameraCopy = new OrthographicCamera3D("gameCameraCopy");
			_gameCameraCopy.parent = Device3D.scene;
			
			_gameCameraCopy.x = 0
			_gameCameraCopy.y = 0;
			_gameCameraCopy.z = -1000;
			
			_gameCameraCopy.zoom=1;
			_gameCameraCopy.updateProjectionMatrix();
		}
		
		public function setMapWH(w:int,h:int):void
		{
			_gameCameraCopy.zoom=1;
			_gameCameraCopy.updateProjectionMatrix();
			
		}
		public function init():void
		{
			
			
			var mapImgInfo:ImageInfo=new ImageInfo();
			mapImgInfo.name = "100101_0_0_2.jpg";
			mapImgInfo.type = ".jpg";
			mapImgInfo.path=mapImgInfo.loaclPath = "otherRes/bgMaps/100101/100101_0_0_2.jpg"
			ResourceManager.addResource(mapImgInfo);
			
			_texture=new Texture3D(new Point(1024,1024),0,0);
			_texture.upload(Device3D.scene,false);
			material=new ShaderBase("bgTextureMaterial",new TransformFilter(),new TextureFilter(new Texture3D("100101_0_0_2.jpg",0)),null);
			layerQuad=new BottomQuad("bgTextureMaterial",0,0,1024,1024,false,null,null);
			layerQuad.setMateiralBlendMode(Material3D.BLEND_NONE);
			layerQuad.materialPrams.depthWrite=false;
			layerQuad.setMaterial(material,Texture3D.MIP_NONE,material.name);
			layerQuad.renderList=this._renderList;
			layerQuad.setLayer(Layer3DManager.backGroudImgLayer,false);
			this.addChild(layerQuad);
			
			var _effectPlayer:EffectPlayer = EffectPlayerPool.instance.getEffectPlayer("baoshi-cheng",this._renderList);
			_effectPlayer.play(true);
			_effectPlayer.x=0;
			_effectPlayer.y=200;
			this.addChild(_effectPlayer);
		}
		public function get texture():Texture3D
		{
			if(!_texture)
			{
				init();
			}
			return _texture;
		}

		
		public override function draw(_drawChildren:Boolean=true, _material:ShaderBase=null):void
		{
			
			Device3D.setViewProj(_gameCameraCopy.viewProjection); //屏幕坐标系
			var context:Context3D=this.scene.context;
			context.setRenderToTexture(texture.texture, true, this.scene.antialias);
			context.clear(0, 0, 0, 0);
			var layers:Vector.<Layer3DSort>=this._renderList.layers;
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
						var _mesh:Mesh3D=list[j];
						_mesh.draw(false);
					}
				}
			}
		}
		public function resize():void
		{
			
		}
	}
}