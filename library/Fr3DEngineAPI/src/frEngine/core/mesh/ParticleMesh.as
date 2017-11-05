package frEngine.core.mesh
{

	import flash.events.Event;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.particleControler.LineRoadControler;
	import frEngine.animateControler.particleControler.ParticleAnimateControler;
	import frEngine.animateControler.particleControler.ParticleParams;
	import frEngine.effectEditTool.temple.ETempleType;
	import frEngine.effectEditTool.temple.FightParams;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.loaders.resource.info.ParticleInfo;
	import frEngine.render.IRender;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.vertexFilters.ParticleVertexFilter;
	import frEngine.util.HelpUtils;
	
	public class ParticleMesh extends Mesh3D
	{
		
		private var _vertexFilter:ParticleVertexFilter;
		private var _particleParams:ParticleParams;
		private var _particleUrl:String;
		private var _useOuterParams:Boolean;
		private var _useRotation:Boolean;
		private var _useScale:Boolean;
		public function ParticleMesh($name:String,$particleUrl:String,$renderList:RenderList=null,useOuterParams:Boolean=false)
		{
			super($name,false,$renderList);
			_useOuterParams=useOuterParams;
			_vertexFilter=new ParticleVertexFilter();
			this.materialPrams.depthWrite=false;
			this.materialPrams.twoSided=false;
			this.setMateiralBlendMode(Material3D.BLEND_LIGHT);
			this.setLayer(Layer3DManager.particleLayer);
			if($particleUrl)
			{
				particleUrl=$particleUrl;
			}
			
		}

		public function set useRotation(value:Boolean):void
		{
			_useRotation=value;
			if(_particleParams)
			{
				_particleParams.useRotation=value;
			}
		}

		public function set useScale(value:Boolean):void
		{
			_useScale=value;
			if(_particleParams)
			{
				_particleParams.useScale=value;
			}
		}
		
		public override function setTempleParams(type:String,hasPassFrame:int,minDistance:Number,params:*):void
		{
			var controler:ParticleAnimateControler=this.getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
			switch(type)
			{
				case ETempleType.Fight:
					var fightParams:FightParams=FightParams(params);
					controler.resetMultyEmmiter(fightParams.startPos,fightParams.endPos,fightParams.speed,hasPassFrame,minDistance);
					break;
			}

		}
		public function set particleUrl(value:String):void
		{
			if(_particleUrl && _particleUrl!=value)
			{
				Resource3dManager.instance.unLoad(_particleUrl,parseHasLoadedBytes);
			}
			_particleUrl=value;
			if(value)
			{
				Resource3dManager.instance.load(value,parseHasLoadedBytes,loadPriority);
				this.priority=HelpUtils.getSortIdByName(value);
			}
			
		}
		
		private function parseHasLoadedBytes(info:ParticleInfo):void
		{
			particleParams=info.particleParams;
			this.dispatchEvent(new Event(Engine3dEventName.PARSEFINISH));
		}
		public override function dispose(isReuse:Boolean=true):void
		{
			if(_particleUrl)
			{
				Resource3dManager.instance.unLoad(_particleUrl,parseHasLoadedBytes);
				_particleUrl=null;
			}
			if(_particleParams)
			{
				_particleParams.removeEventListener(Engine3dEventName.InitComplete,particleInitComplete);
			}
			super.dispose(isReuse);
		}
		public function get particleParams():ParticleParams
		{
			return _particleParams;
		}
		public function set particleParams($particleParams:ParticleParams):void
		{
			if(_particleParams)
			{
				_particleParams.removeEventListener(Engine3dEventName.InitComplete,particleInitComplete);
			}
			
			_particleParams=$particleParams;
			_particleParams.useRotation=_useRotation;
			_particleParams.useScale=_useScale;
			
			var controler:ParticleAnimateControler=this.getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
			controler.particleParams=$particleParams;
			_vertexFilter.particleParams=$particleParams;
			
			if(!_useOuterParams)
			{
				this.materialPrams.twoSided=_particleParams.doubleFace;
				this.setMateiralBlendMode(_particleParams.blendType);
			}
			
			if(_particleParams.hasBuildSurface)
			{
				addSurface(_particleParams.targetSurface);
			}else
			{
				_particleParams.addEventListener(Engine3dEventName.InitComplete,particleInitComplete);
			}
			
		}

		private function particleInitComplete(e:Event):void
		{
			_particleParams.removeEventListener(Engine3dEventName.InitComplete,particleInitComplete);
			addSurface(_particleParams.targetSurface);
		}
		public override function removeAnimateControler(animateControlerType:int):void
		{
			super.removeAnimateControler(animateControlerType);
			if(animateControlerType==AnimateControlerType.LineRoadControler && this.hasControler(AnimateControlerType.ParticleAnimateControler))
			{
				var particleControler:ParticleAnimateControler=getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
				particleControler.lineRoadControler=null;
			}
		}
		public override function getAnimateControlerInstance(animateControlerType:int,instane:Modifier=null):Modifier
		{
			var  modifier:Modifier=super.getAnimateControlerInstance(animateControlerType,instane);
			if(modifier==null)
			{ 
				switch(animateControlerType)
				{ 
					case AnimateControlerType.ParticleAnimateControler:		
						modifier=instane ? instane : new ParticleAnimateControler();	
						break;	
					
				}
				if(modifier)
				{
					_animateControlerList[animateControlerType]=modifier;
					modifier.targetObject3d=this;
					if(modifier is IRender)
					{
						this.render=IRender(modifier);
					}
				}
				
			}
			
			if(animateControlerType==AnimateControlerType.LineRoadControler)
			{
				var particleControler:ParticleAnimateControler=getAnimateControlerInstance(AnimateControlerType.ParticleAnimateControler) as ParticleAnimateControler;
				particleControler.lineRoadControler=LineRoadControler(modifier);
			}
			
			return modifier;
		}

		protected override function setShaderBase(materaial:ShaderBase):void
		{
			if(materaial)
			{
				materaial.setVertexFilter(_vertexFilter);
			}
			super.setShaderBase(materaial);
		}
		/*public override function draw(_drawChildren:Boolean=true, _material:ShaderBase=null):void
		{
			return;
			super.draw(_drawChildren,_material);
		}*/

	}
}

