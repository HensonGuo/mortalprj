package frEngine.loaders.resource
{
	
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ResourceInfo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Texture3DUtils;
	
	import frEngine.Engine3dEventName;
	import frEngine.effectEditTool.manager.Obj3dContainer;
	import frEngine.shader.Program3dRegisterInstance;

	public class Resource3dManager extends EventDispatcher
	{
		private var tex3dList:Dictionary=new Dictionary(false);
		private var tex3dRList:Dictionary=new Dictionary(false);

		private var loadRList:Dictionary=new Dictionary(false);
		
		public static const instance:Resource3dManager=new Resource3dManager();
		
		private var _timer:SecTimer;

		private var _programeById:Dictionary=new Dictionary(false);
		private var _hasRegisterProgram3DMap:Dictionary=new Dictionary(false);
		public function Resource3dManager()
		{
			super();
			_timer = new SecTimer(1*60);
			_timer.addListener(TimerType.ENTERFRAME,checkToDispose);
			_timer.start();
		}
		
		public function updateFileInfo(fileName:String):void
		{
			var info:ResourceInfo = ResourceManager.getInfoByName(fileName);
			if(info)
			{
				info.dispose();
				info.clearCacheBytes();
			}
		}
		public function updateTexture(textureName:String,mipType:int):void
		{
			updateFileInfo(textureName);
			var _hastexture:Texture3D=Resource3dManager.instance.hasTexture3d(textureName,mipType);
			if(_hastexture)
			{
				_hastexture.request=textureName;
				_hastexture.upload(Device3D.scene,true);
			}
		}
		public function getProgram3DInstance(_id:String,repeat:Boolean):Program3dRegisterInstance
		{
			var pro:Program3dRegisterInstance;
			var _id:String=repeat?_id+1:_id+0;
			var proList:Array=_programeById[_id];
			if(proList && proList.length>0)
			{
				pro=proList.shift();
				return pro;
			}else
			{
				pro=_hasRegisterProgram3DMap[_id];
				if(pro)
				{
					var _new:Program3dRegisterInstance=new Program3dRegisterInstance(pro.programeId);
					_new.cloneFrom(pro);
					return _new;
				}else
				{
					throw new Error("请先注册program3D:"+_id);
					return null;
				}
			}
			
			
		}
		public function hasRegisterProgram3D(_id:String,repeat:Boolean):Boolean
		{
			_id=repeat?_id+1:_id+0;
			return (_hasRegisterProgram3DMap[_id]!=null);
		}
		public function registerPrograme(pro:Program3dRegisterInstance,repeat:Boolean):void
		{
			var _id:String=pro.programeId;
			_id=repeat?_id+1:_id+0;
			_hasRegisterProgram3DMap[_id]=pro;
		}
		public function pushPrograme3DtoPool(pro:Program3dRegisterInstance,repeat:Boolean):void
		{
			var _id:String=pro.programeId;
			_id=repeat?_id+1:_id+0;
			var proList:Array=_programeById[_id];
			if(!proList)
			{
				proList=_programeById[_id]=new Array();
			}
			proList.push(pro);
			
			
		}

		private function checkToDispose(timer:SecTimer):void
		{
			var arr:Array=new Array();
			for(var objId:String in tex3dRList)
			{
				if(tex3dRList[objId]<1)
				{
					arr.push(objId);
				}
			}
			for each(objId in arr)
			{
				impDisposeTexture3d(objId);
			}
			
			arr.length=0;
			
			for(var url:String in loadRList)
			{
				if(loadRList[url]<1)
				{
					arr.push(url);
					
				}
			}
			for each(url in arr)
			{
				impDisposeLoadInfo(url);
			}

			this.dispatchEvent(new Event(Engine3dEventName.CHECK_TO_DISPOSE));
		}
		
		private function impDisposeLoadInfo(url:String):void
		{
			var info:ResourceInfo = ResourceManager.getInfoByName(url);
			if(info)
			{
				info.dispose();
				delete loadRList[url];
			}
		}
		
		
		
		
		private function impDisposeTexture3d(_id:String):void
		{
			var _texture3d:Texture3D=tex3dList[_id];
			if(_texture3d.request is String)
			{
				var info:ResourceInfo = ResourceManager.getInfoByName(String(_texture3d.request));
				if(info)
				{
					info.dispose();
				}
			}
			
			delete tex3dList[_id];
			delete tex3dRList[_id];
			_texture3d.disposeImp();
			
		}
		
		public function load(url:String,loadedFun:Function,loadPriority:int):void
		{
			LoaderManager.instance.load(url,loadedFun,loadPriority);
			if(!loadRList[url])
			{
				loadRList[url]=0;
			}
			loadRList[url]++;
		}
		
		public function unLoad(url:String,loadedFun:Function=null):void
		{
			if(loadedFun!=null)
			{
				LoaderManager.instance.removeResourceEvent(url,loadedFun);
			}
			if(loadRList[url]!=null)
			{
				loadRList[url]--;
			}
			
		}
		
		public function hasTexture3d(request:*,mipTye:int):Texture3D
		{
			var _id:String=Texture3DUtils.getTexureId(request,mipTye);
			return tex3dList[_id];
		}
		
		
		public function getTexture3d(request:*,mipType:int):Texture3D
		{
			var _id:String=Texture3DUtils.getTexureId(request,mipType);
			var _texture3d:Texture3D=tex3dList[_id]
			if(!_texture3d)
			{
				_texture3d=new Texture3D(request,mipType);
				tex3dList[_id]=_texture3d
				tex3dRList[_id]=0;
			}
			tex3dRList[_id]++;
			return _texture3d;
		}
		
		public function getEffectByUrl(url:String):Obj3dContainer
		{
			return null;
		}
		public function disposeTexture3d(texture3d:Texture3D,impDispose:Boolean=false):void
		{
			var _id:String=Texture3DUtils.getTexureId(texture3d.request,texture3d.mipMode);
			if(tex3dList[_id])
			{
				tex3dRList[_id]--;
				if(impDispose && tex3dRList[_id]<1)
				{
					impDisposeTexture3d(_id);
				}
			}else
			{
				texture3d.disposeImp();
			}
		}
		
	}
}
