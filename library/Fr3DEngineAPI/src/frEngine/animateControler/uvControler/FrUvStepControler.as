package frEngine.animateControler.uvControler
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.visible.VisibleControler;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.fragmentFilters.UVstepFilter;
	import frEngine.shader.registType.FcParam;

	public class FrUvStepControler extends MeshAnimateBase
	{
		
		private var _playSpeed:int=1;
		private var _u:Number=1;
		private var _v:Number=1;
		protected var uvValue:Vector.<Number>=new Vector.<Number>(4,true);

		private var _totoalNum:int=1
		private var _playMode:int=0;
		private var playOffsetFrame:int=0;
		public function FrUvStepControler()
		{
			uvValue[0]=1;
			uvValue[1]=1;
		}
		public function init(uvStepPoint:Point,playSpeed:int,playMode:int=0):void
		{
			_playSpeed=playSpeed;
			_u=uvStepPoint.y;
			_v=uvStepPoint.x;
			_totoalNum=_u*_v;
			_playMode=playMode;
			uvValue[0]=1/_u;
			uvValue[1]=1/_v;
		}
		public override function get type():int
		{
			return AnimateControlerType.UvStepControler;
		}
		private function visibleChangeHander(e:Event):void
		{
			if(targetMesh.visible)
			{
				var _visible:VisibleControler=targetMesh.getAnimateControlerInstance(AnimateControlerType.VisibleContoler) as VisibleControler
				playOffsetFrame=-_visible.getStartVisibleFrame();
			}
			
		}
		public override function set targetObject3d(value:Pivot3D):void
		{
			if(targetObject3d)
			{
				targetObject3d.removeEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT,visibleChangeHander);
			}
			if(value)
			{
				value.addEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT,visibleChangeHander);
			}
			
			super.targetObject3d=value;
		}
		public override function toUpdateAnimate(forceUpdate:Boolean=false):void
		{
		
			var curTime:int=targetMesh.timerContorler.curFrame+playOffsetFrame;
			var curIdnex:int=int(curTime/_playSpeed);
			if(this._playMode==1)
			{
				curIdnex=curIdnex%_totoalNum;
			}else
			{
				curIdnex=curIdnex>=_totoalNum?_totoalNum-1:curIdnex;
			}
			
			var targetU:Number=int(curIdnex%_u)/_u;
			var targetV:Number=int(curIdnex/_u)/_v;
			uvValue[2]=targetU;
			uvValue[3]=targetV;

		}

		protected override function setMaterialHander(e:Event):void
		{
			super.setMaterialHander(e);
			if(targetMesh.materialPrams.hasFilter(FilterType.NodeUVstepFilter)==false)
			{
				targetMesh.materialPrams.addFilte(new UVstepFilter(_u,_v));
			}else
			{
				reBuilderHander(null);
			}
			
			normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
		}
		private function reBuilderHander(e:Event):void
		{
			var register:FcParam=normalMaterial.getParam("{UVstepOffsetPoint}",false);
			if(register)
			{
				register.value=uvValue;
			}
			
		}
		public override function dispose():void
		{
			normalMaterial && normalMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
			targetMesh.materialPrams.removeFilteByType(FilterType.NodeUVstepFilter);
			
			super.dispose();
		}
	}
}

