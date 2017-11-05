package frEngine.core.mesh
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.loaders.away3dMd5.SkeletonAnimator;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.loaders.resource.info.Md5MeshInfo;
	import frEngine.loaders.resource.info.MeshInfo;
	import frEngine.loaders.resource.info.SkeletonInfo;
	import frEngine.render.IRender;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.TransformFilter;

	public class Md5Mesh extends Mesh3D
	{
		private var _vertexMaxBoneNum:int = -1;
		private var _md5Controler:Md5SkinAnimateControler;

		private var _defaultPlayLable:String;
		protected var _animUrl:String;
		protected var _meshUrl:String;
		private var _skeletonInfo:SkeletonInfo;
		private var _meshInfo:Md5MeshInfo;
		public function Md5Mesh(meshName:String, $meshUrl:String, useColorAnimate:Boolean, $renderList:RenderList)
		{
			super(meshName, useColorAnimate, $renderList);
			this.setMateiralBlendMode(Material3D.BLEND_NONE);
			this.setLayer(Layer3DManager.modelLayer0, false);
			if($meshUrl)
			{
				meshUrl = $meshUrl;
			}
		}

		public function get md5MeshInfo():Md5MeshInfo
		{
			return _meshInfo;
		}
		public function clear():void
		{
			if (targetMd5Controler)
			{
				targetMd5Controler.clear();
			}
			
			targetMd5Controler.removeAllFrameScript();
			targetMd5Controler.labels = new Dictionary(false);
			Resource3dManager.instance.unLoad(_animUrl, loadAnimateComplete);
			Resource3dManager.instance.unLoad(_meshUrl, loadMeshComplete);
			_skeletonInfo = null;
			_meshInfo = null;
			_md5Controler = null;
			_meshUrl = null;
			_animUrl = null;
			_vertexMaxBoneNum=-1;
			disposeSurfaces();
		}
		public function get targetMd5Controler():Md5SkinAnimateControler
		{
			if(!_md5Controler)
			{
				_md5Controler = this.getAnimateControlerInstance(AnimateControlerType.Md5SkinAnimateControler) as Md5SkinAnimateControler;
			}
			return _md5Controler;
		}

		public function get meshUrl():String
		{
			return _meshUrl;
		}
		public function set meshUrl(value:String):void
		{
			if(_meshUrl==value)
			{
				return;
			}

			
			if(_meshUrl && _meshUrl != value)
			{
				Resource3dManager.instance.unLoad(_meshUrl, loadMeshComplete);
			}
			_meshUrl = value;
			if(value)
			{
				_meshInfo=null;
				Resource3dManager.instance.load(value, loadMeshComplete, loadPriority);
			}
		}

		private function loadMeshComplete(info:Md5MeshInfo):void
		{

			vertexMaxBoneNum = info.skeleton.maxJointCount;
			addSurface(info.surface3d);

			if(material == null)
			{
				setMaterial(info.materialName, Texture3D.MIP_NONE,info.materialName);
			}
			_meshInfo=info;;
			targetMd5Controler.initComplete(info.skeleton.splitSurfaceInfo);
			checkAnimateControlerComplete();

			this.dispatchEvent(new Event(Engine3dEventName.PARSEFINISH));

		}

		public function set vertexMaxBoneNum(value:int):void
		{
			_vertexMaxBoneNum = value;
			if(this.material)
			{
				if(TransformFilter(material.vertexFilter).skinNum != _vertexMaxBoneNum)
				{
					TransformFilter(material.vertexFilter).skinNum = _vertexMaxBoneNum;
					material.toReBuiderProgram = true;
				}
			}
		}

		public override function getAnimateControlerInstance(animateControlerType:int, instane:Modifier = null):Modifier
		{
			var modifier:Modifier = super.getAnimateControlerInstance(animateControlerType, instane);
			if(modifier == null)
			{
				switch(animateControlerType)
				{
					case AnimateControlerType.Md5SkinAnimateControler:
						modifier = instane ? instane : new Md5SkinAnimateControler();
						break;
				}
				if(modifier)
				{
					_animateControlerList[animateControlerType] = modifier;
					modifier.targetObject3d = this;
					if(modifier is IRender)
					{
						this.render = IRender(modifier);
					}
				}
			}
			return modifier;

		}

		public function initAnimate(url:String,playLable:String = null):void
		{
			_defaultPlayLable = playLable;
			
			if(_animUrl==url)
			{
				return;
			}

			if(_animUrl && _animUrl != url)
			{
				Resource3dManager.instance.unLoad(_animUrl, loadAnimateComplete);
			}
			
			_animUrl = url;
			_skeletonInfo=null;
			targetMd5Controler.labels=new Dictionary(false);
			
			if(_animUrl)
			{
				Resource3dManager.instance.load(_animUrl, loadAnimateComplete, loadPriority);
			}

			
		}

		public function get animUrl():String
		{
			return _animUrl;
		}
		public function loadAnimateComplete(info:SkeletonInfo):void
		{
			_skeletonInfo=info;
			if(info.proceedParsed)
			{
				checkAnimateControlerComplete();
			}else
			{
				info.addProceedParsedCallBack(checkAnimateControlerComplete);
			}
			
			
		}
		
		public override function update():void
		{
			if(_skeletonInfo && !_skeletonInfo.proceedParsed)
			{
				_skeletonInfo.proceedParsing();
			}
			super.update();
		}
		public override function dispose(isReuse:Boolean = true):void
		{
			super.dispose(isReuse);
			clear();
		}

		private function checkAnimateControlerComplete():void
		{
			if(_skeletonInfo && _skeletonInfo.proceedParsed && _meshInfo)
			{
				var animator:SkeletonAnimator = new SkeletonAnimator(_skeletonInfo.animationSet, _meshInfo.skeleton);
				targetMd5Controler.addAnimateTracks(animator, _defaultPlayLable);
				this.dispatchEvent(new Event(Engine3dEventName.InitComplete));
			}
		}

		protected override function setShaderBase(materaial:ShaderBase):void
		{
			if(materaial)
			{
				var _skinBoneNum:int = _vertexMaxBoneNum > 0 ? _vertexMaxBoneNum : 0;
				if(materaial.vertexFilterType != FilterType.Transform)
				{
					materaial.setVertexFilter(new TransformFilter(_skinBoneNum));
				}
				else
				{
					TransformFilter(materaial.vertexFilter).skinNum = _skinBoneNum;
				}

			}

			super.setShaderBase(materaial);
		}

	}
}
