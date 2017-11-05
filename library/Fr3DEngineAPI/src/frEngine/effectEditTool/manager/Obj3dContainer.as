package frEngine.effectEditTool.manager
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.RenderList;
	import baseEngine.basic.Scene3D;
	import baseEngine.core.IDrawable;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Texture3D;
	import baseEngine.modifiers.PlayMode;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.visible.VisibleControler;
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.effectEditTool.parser.ParserLayerObject;
	import frEngine.effectEditTool.temple.ETempleType;
	import frEngine.effectEditTool.temple.EmptyTemple;
	import frEngine.effectEditTool.temple.ITemple;
	import frEngine.effectEditTool.temple.TempleFight;
	import frEngine.effectEditTool.temple.TempleRole;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	
	public class Obj3dContainer extends Pivot3D
	{
		
		public var id:int;
		
		private var _idToObject3dMap:Dictionary=new Dictionary(false);
		
		private var _object3dToIdMap:Dictionary=new Dictionary(false);
		
		private static const _containerMap:Dictionary=new Dictionary(false);
		
		public static var sceneObjectsList:Dictionary=new Dictionary(false);
		
		private var _addToRenderList:Boolean;
		 
		private var _temple:ITemple;
		
		private var _templeName:String="-1";
		
		private var _isPlaying:Boolean=true;
		
		private var _animationMode:int=PlayMode.ANIMATION_STOP_MODE;
		
		public var maxKeyFrame:int;
		
		private var _renderList:RenderList;
		
		public function Obj3dContainer(_arg1:String, $id:int,addToRenderList:Boolean=true)
		{
			super(_arg1);
			_addToRenderList=addToRenderList;
			id=$id;
			this.timerContorler = TimeControler.createTimerInstance();
		}

		
		public function get renderList():RenderList
		{
			return _renderList;
		}
		public function set renderList(value:RenderList):void
		{
			if(_renderList==value)
			{
				return;
			}
			_renderList=value;
			for each(var obj:Mesh3D in _idToObject3dMap)
			{
				obj.renderList=_renderList;
			}
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		public function setData(params:Object,showHang:Boolean,setTempleName:Boolean,$renderList:RenderList):void
		{
			disposeAllChildren();
			
			if(!params)
			{
				return;
			}
			
			maxKeyFrame=params.maxKeyFrame;
			
			if(setTempleName)
			{
				setTempleByName(params.templeName);
			}
			

			var layers:Array = params.layers;
			
			var len:int = layers.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var layerObj:Object = layers[i];
				ParserLayerObject.instance.parserParentLayer(this,layerObj.parentLayer,showHang,$renderList);
			}
			for (i = 0; i < len; i++)
			{
				layerObj = layers[i];
				ParserLayerObject.instance.parserChildrenLayer(this,layerObj.parentLayer.uid,layerObj.childLayers);
			}
			
			for (i = 0; i < len; i++)
			{
				var parentLayer:Object = layers[i].parentLayer;
				ParserLayerObject.instance.parserLayerHang(this,parentLayer.uid,parentLayer.hangObjId,parentLayer.hangBoneName);

			}
			
			_temple && _temple.parsersParams(params.templeParams);
			
		}
		public function setTempleByName(templeName:String):void
		{
			if(_templeName==templeName)
			{
				return;
			}
			_templeName=templeName;
			var targetTemple:ITemple;
			switch(templeName)
			{
				case ETempleType.Role:	targetTemple=new TempleRole(this);		break;
				case ETempleType.Fight:	targetTemple=new TempleFight(this);		break;
				default:				targetTemple=new EmptyTemple();		break;
			}
			_temple=targetTemple;
		}
		
		public function get templeName():String
		{
			return _templeName;
		}
		public function get temple():ITemple
		{
			if(!_temple)
			{
				_temple=new EmptyTemple();
			}
			return _temple;
		}
		public function registerObject(uid:String,object3d:Mesh3D):void
		{
			if(_idToObject3dMap[uid]!=null)
			{
				throw new Error(uid+"已注册！");
				return;
			}
			_idToObject3dMap[uid]=object3d;
			_object3dToIdMap[object3d]=uid;
			_containerMap[object3d]=this;
			object3d.name=uid;
			if(_addToRenderList)
			{
				sceneObjectsList[object3d]=object3d;
			}
			object3d.timerContorler=this.timerContorler;
			
			
		}

		public function unRgisterObjectByID(uid:String):void
		{
			var object3d:Mesh3D=_idToObject3dMap[uid]
			delete _idToObject3dMap[uid];
			delete _object3dToIdMap[object3d];
			delete _containerMap[object3d];
			delete sceneObjectsList[object3d]
			
		}
		public function unRgisterObjectByObj3d(object3d:Mesh3D):void
		{
			var uid:String=_object3dToIdMap[object3d];
			delete _idToObject3dMap[uid];
			delete _object3dToIdMap[object3d];
			delete sceneObjectsList[object3d]
		}
		public static function getContainerByObject3d(object3d:Pivot3D):Obj3dContainer
		{
			return _containerMap[object3d];
		}
		public function getObject3dByID(uid:String):Pivot3D
		{
			if(uid=="root")
			{
				return this;	
			}else
			{
				return _idToObject3dMap[uid];
			}
			
		}
		public function getIdByObject3d(object3d:Pivot3D):String
		{
			if(!object3d)
			{
				return "null";
			}
			return _object3dToIdMap[object3d];
		}
		public function changeChildrenHang(from:Pivot3D,to:Pivot3D):void
		{
			var childList:Vector.<Pivot3D>=from.children;
			if(!childList)
			{
				return;
			}
			while(childList.length>0)
			{
				var _child:Pivot3D=childList[0];
				if(_child.curHangControler)
				{
					var boneName:String=_child.curHangControler.getMeshHangBoneName(_child);
					_child.curHangControler.removeHang(_child);
					var _mc:Md5SkinAnimateControler=to.getAnimateControlerInstance(AnimateControlerType.Md5SkinAnimateControler) as Md5SkinAnimateControler
					if(_mc)
					{
						_mc.attachObjectToBone(boneName,_child);
					}else
					{
						_child.parent=to;
					}
				}else
				{
					_child.parent=to;
				}
				
			}
			
		}
		
		public function disposeChild(child:Mesh3D):void
		{
			var scene:Scene3D=Device3D.scene
			
			var arr:Array=new Array();
			getMeshesInObject(arr,child);
			var len:int=arr.length;
			
			for(var i:int=0;i<len;i++)
			{
				var _child:Mesh3D=arr[i];
				scene.removeSelectObject(_child,false);
				if(_object3dToIdMap[_child]!=null)
				{
					_child.dispose();
					this.unRgisterObjectByObj3d(_child);
				}else
				{
					_child.parent=scene;
					if(_child.curHangControler)
					{
						_child.curHangControler.removeHang(_child);
					}
					
				}
				
				
			}
			
		}
		private function getMeshesInObject(arr:Array, obj:Pivot3D):void
		{
			if (obj.children == null)
			{
				return;
			}
			var len:int=obj.children.length
			if (len > 0)
			{
				for (var i:int=0; i < len; i++)
				{
					getMeshesInObject(arr, obj.children[i]);
				}
			}
			if (obj is Mesh3D)
			{
				arr.push(obj);
			}
		}
		public function disposeAllChildren():void
		{
			var objects:Array = this.getAllObject3d();
			var len:int = objects.length;
			for (var i:int = 0; i < len; i++)
			{
				var obj3d:Pivot3D = objects[i];
				this.disposeChild(Mesh3D(obj3d));
			}
			this.timerContorler.gotoFrame(0,0);
		}
		public function getAllObject3d():Array
		{
			var arr:Array=new Array();
			for each(var p:Pivot3D in _idToObject3dMap)
			{
				arr.push(p);
			}
			return arr;	
		}
		public function addChildByArray(children:Vector.<Pivot3D>):void
		{
			var cloneChildren:Vector.<Pivot3D>=children.concat();
			var len:int=cloneChildren.length;
			for(var i:int=0;i<len;i++)
			{
				var obj:Pivot3D=cloneChildren[i];
				if(obj.curHangControler)
				{
					obj.curHangControler.removeHang(obj);
				}
				obj.curHangControler=null;
				this.addChild(obj);
			}
		}
		public function switchObjects(from:Mesh3D,to:Mesh3D,replaceMaterialParams:Boolean):void
		{
			var objId:String=getIdByObject3d(from);
			var _framentFilter:FragmentFilter;
			var _controlers:Dictionary;
			var _visibleControler:VisibleControler;
			var _parent:Pivot3D;
			var _hang:Md5SkinAnimateControler;
			var _boneName:String;
			var _transform:Matrix3D=new Matrix3D();
			
			replaceMaterialParams && to.materialPrams.cloneFrom(from.materialPrams);
			var material:ShaderBase=from.getMaterialByName(null) as ShaderBase;
			_framentFilter=material.fragmentFilter;
			_controlers=from.animateControlerList;
			_visibleControler=from.visibleControler;
			_parent=from.parent;
			_hang=from.curHangControler;
			if(_hang)
			{
				_boneName=_hang.getMeshHangBoneName(from);
			}
			_transform.copyFrom(from.transform);
			
			if(from.offsetTransform)
			{
				to.offsetTransform=from.offsetTransform.clone()
			}
			
			to.setLayer(from.layer);
			
			from.clearAllControlers(false);
			material.setFragmentFilter(null);
			changeChildrenHang(from,to);

			this.unRgisterObjectByObj3d(from);
			from.dispose(true);
			
			to.copyToControlers(_controlers,_visibleControler);
			
			this.registerObject(objId , to);
			
			if(_parent)
			{
				_parent.addChild(to);
			}else
			{
				this.addChild(to);
			}

			to.setTransform(_transform,true);

			
			
			if(_framentFilter)
			{
				var mipType:int=(to is Md5Mesh ? Texture3D.MIP_LINEAR : Texture3D.MIP_NONE)
				to.setMaterial(_framentFilter,mipType,"framentFilter");
			}
			
			if(_hang)
			{
				_hang.attachObjectToBone(_boneName,to);
			}
		}
		
		public override function update():void
		{
			
			if (_isPlaying)
			{
				if (this._animationMode == 1)
				{
					if(this.timerContorler.totalframe>this.timerContorler.duringFrame)
					{
						playEndHander();
					}
					
				}
				super.update();
			}
			
			
		}
		
		protected function playEndHander():void
		{
			this.dispatchEvent(new Event(Engine3dEventName.PLAYEND));
		}
		/**
		 *
		 * @param isRepeat
		 * @param playTime
		 * @playTime是以秒为单位 
		 */		
		public function play(isRepeat:Boolean):void
		{
			var arr:Array = this.getAllObject3d();
			var playMode:int = isRepeat ? PlayMode.ANIMATION_LOOP_MODE : PlayMode.ANIMATION_STOP_MODE;
			this._animationMode = playMode;
			_isPlaying = true;
			this.timerContorler.active();
			this.timerContorler.gotoFrame(0,0);
			this.temple.checkAndPlay();
		}
		
		public function stop():void
		{
			_isPlaying = false;
			this.timerContorler.unActive();
		}
		
		public function reset():void
		{
			_isPlaying = true;
			_animationMode = PlayMode.ANIMATION_STOP_MODE;
		}
		
		public override function dispose(isReuse:Boolean=true):void
		{
			this.timerContorler.unActive();
			
			if(!isReuse)
			{
				if(temple)
				{
					temple.dispose();
					_temple=null;
				}
				this.disposeAllChildren();
				TimeControler.disposeTimer(this.timerContorler);
			}
			
			super.dispose(isReuse);
			
		}
		
	}
}


