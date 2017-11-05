package frEngine.effectEditTool.temple
{
	import flash.utils.Dictionary;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.effectEditTool.manager.Obj3dContainer;

	public class TempleRole implements ITemple
	{
		private var _targetMesh:Md5Mesh
		private var registHangList:Dictionary=new Dictionary(false);
		private var needToReHang:Dictionary=new Dictionary(false);
		private var _container:Obj3dContainer;
		private var fightOnAction:String;
		private var fightOnFrame:int;
		private var _callBack:Function;
		public function TempleRole($container:Obj3dContainer)
		{
			_container=$container;
		}
		public function parsersParams(params:*):void
		{
			removeAllHangObj();
			
			var arr:Array=params.hangList;
			if(!arr)
			{
				arr=new Array();
			}
			fightOnAction=params.fightOnAction;
			fightOnFrame=params.fightOnframe
			var len:int=arr.length;
			for(var i:int=0;i<len;i++)
			{
				var obj:Object=arr[i];
				var uid:String=obj.uid;
				var targetObjec3d:Pivot3D=_container.getObject3dByID( obj.uid);
				if(targetObjec3d)
				{
					registHangList[targetObjec3d]=obj.boneName;
					needToReHang[targetObjec3d]=true;
				}
				
			}
			checkAndPlay();
			
		}
		public function setTempleParams(params:*):void
		{
			setRoleParams(params[0],params[1]);
		}
		public function setRoleParams(md5mesh:Md5Mesh,callBack:Function):void
		{
			_targetMesh=md5mesh;
			_callBack=callBack;
			checkAndPlay();
		}
		public function unHangAll():void
		{
			if(!_targetMesh)
			{
				return;
			}
			_targetMesh.targetMd5Controler.removeFrameScript(fightOnAction, fightOnFrame , startFightHander);
			removeAllHangObj();
			_targetMesh=null;
		}
		private function removeAllHangObj():void
		{
			for(var p:* in registHangList)
			{
				var obj3d:Pivot3D=p;
				if(obj3d.curHangControler)
				{
					obj3d.curHangControler.removeHang(obj3d);
					obj3d.curHangControler=null;
				}
				if(obj3d.parent)
				{
					obj3d.parent=null;
				}
				needToReHang[obj3d]=true;
			}
			registHangList=new Dictionary(false);
		}
		
		private function startFightHander():void
		{
			if(_container.timerContorler.curFrame<fightOnFrame)
			{
				return;
			}
			
			if (_callBack != null)
			{
				_callBack.call();
				_callBack = null;
			}
			_targetMesh.targetMd5Controler.removeFrameScript(fightOnAction, fightOnFrame , startFightHander);
		}

		public function checkAndPlay():void
		{
			if(!_targetMesh)
			{
				return;
			}
			
			if(!_container.parent)
			{
				_targetMesh.addChild(_container);
			}
			
			
			if(_callBack != null)
			{
				_targetMesh.targetMd5Controler.addFrameScript(fightOnAction, fightOnFrame, startFightHander);
				if(_container.timerContorler.curFrame>fightOnFrame)
				{
					startFightHander();
				}
			}
			
			
			

			for(var p:* in registHangList)
			{
				var obj3d:Pivot3D=p;
				if(obj3d.parent!=_targetMesh || needToReHang[obj3d])
				{
					var boneName:String=registHangList[obj3d];
					if(boneName)
					{
						var skin:Md5SkinAnimateControler = _targetMesh.getAnimateControlerInstance(AnimateControlerType.Md5SkinAnimateControler) as Md5SkinAnimateControler
						skin && skin.attachObjectToBone(boneName, obj3d);
					}else
					{
						if(obj3d.curHangControler)
						{
							obj3d.curHangControler.removeHang(obj3d);
							obj3d.curHangControler=null;
						}
						_targetMesh.addChild(obj3d);
						obj3d.identityOffsetTransform();
					}
					needToReHang[obj3d]=false;
				}
				
			}
		}
		public function dispose():void
		{
			unHangAll();
			_container = null;
			_callBack=null;
			_targetMesh=null;
			registHangList=null;
		}
	}
}