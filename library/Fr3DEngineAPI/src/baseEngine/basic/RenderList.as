package baseEngine.basic
{
	import flash.utils.Dictionary;
	
	import baseEngine.core.Mesh3D;

	public class RenderList
	{
		public var layMap:Dictionary=new Dictionary(false);
		public var layers:Vector.<Layer3DSort>=new Vector.<Layer3DSort>();
		public function RenderList()
		{
			super();
		}
		
		public function clear():void
		{
			for each(var layersort:Layer3DSort in layMap)
			{
				layersort.list.length=0;
			}
			layers.length=0;
			layMap=new Dictionary(false);
		}
		public function insertIntoList(_target3d:Mesh3D):void
		{
			
			
				//_target3d.targetQuad=noneQuad;
				var layerId:int=_target3d.layer
				var targetLayer:Layer3DSort=layMap[layerId];
				if(targetLayer==null)
				{
					layMap[layerId] = targetLayer = new Layer3DSort(layerId);
					var targetIndex:int=RenderList.fastGetIndexByLayerId(layers,layerId);
					layers.splice(targetIndex,0,targetLayer);
				}
				if(targetLayer.list.indexOf(_target3d)==-1)
				{
					targetLayer.list.push(_target3d);
					targetLayer.isActive=true;
				}
				
			
			
			/*if (mouseClision)
			{
			this._interactive.addCollisionWith(_target3d, false);
			this.updateMouseEvents();
			}*/
			
		}
		
		private static  function fastGetIndexByLayerId(targetList:Vector.<Layer3DSort>,targetValue:int):int
		{
			var _end:int = targetList.length;
			var _start:int=0;
			var _cur:int=0;
			while (_start < _end)
			{
				_cur = ((_start + _end) >>> 1);
				var layerId:int=targetList[_cur].layerId
				if (layerId == targetValue)
				{
					break;
				}
				if ((targetValue > layerId))
				{
					_start = ++_cur;
				}
				else
				{
					_end = _cur;
				}
				
			}
			return _end;
		}
		
		public function removeFromList(target3d:Mesh3D):void
		{
			
			var _targetSort:Layer3DSort=layMap[target3d.layer];
			
			if(!_targetSort)
			{
				return;
			}
			var index:int=_targetSort.list.indexOf(target3d);
			if(index!=-1)
			{
				_targetSort.list.splice(index,1);
			}
			/*if (delMouseCollision)
			{
			this._interactive.removeCollisionWith(target3d, false);
			}*/
			
		}
	}
	
}