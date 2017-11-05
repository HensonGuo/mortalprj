package frEngine.effectEditTool.manager
{
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	public class ContainerManager
	{
		public static const instance:ContainerManager=new ContainerManager();
		private var _idToContainerMap:Dictionary=new Dictionary(false);
		private var _containerToIdMap:Dictionary=new Dictionary(false);

		private static var _id:uint=0;
		public function ContainerManager()
		{
			super();
			
		}
		
		public function get idToContainerMap():Dictionary
		{
			return _idToContainerMap;
		}
		public function createContainer():Obj3dContainer
		{
			var container:Obj3dContainer=new Obj3dContainer("container"+_id,_id);
			_id++;
			registerContainer(container);
			Device3D.scene.addChild(container);
			return container;
		}
		public function registerContainer(container:Obj3dContainer):void
		{
			_idToContainerMap[container.id]=container
			_containerToIdMap[container]=container.id;
		}
		public function removeContainerById(id:uint):void
		{
			var container:Obj3dContainer=_idToContainerMap[id];
			delete _idToContainerMap[id];
			delete _containerToIdMap[container];
			if(container.parent)
			{
				container.parent.removeChild(container);
			}
		}
		public function removeContainer(container:Pivot3D):void
		{
			var _id:uint= _containerToIdMap[container];
			delete _idToContainerMap[_id];
			delete _containerToIdMap[container];
			if(container.parent)
			{
				container.parent.removeChild(container);
			}
		}

		public function getContainerByID(id:uint):Obj3dContainer
		{
			return _idToContainerMap[id];
		}
		public function getIdByContainer(container:Pivot3D):uint
		{
			return _containerToIdMap[container]?_containerToIdMap[container]:0;
		}
	}
}