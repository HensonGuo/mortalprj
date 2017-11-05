/**
 * @date 2013-10-17 下午10:02:42
 * @author chenriji
 */
package frEngine.animateControler.uvControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;
	import frEngine.animateControler.keyframe.NodeAnimateKey;
	import frEngine.math.MathConsts;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FcParam;

	public class UVRotateController extends MeshAnimateBase
	{
		public var params:Vector.<Number>=Vector.<Number>([0.5,0.5,0,1]);
		public function UVRotateController()
		{
			super();
		}
		
		public override function get type():int
		{
			return AnimateControlerType.UVRotateAnimationController;
		}
		
		protected override function setMaterialHander(e:Event):void
		{
			super.setMaterialHander(e);
			
			targetMesh.materialPrams.uvRotateAnimUse=true;
			
			reBuilderHander(null);

			normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
		}
		private function reBuilderHander(e:Event):void
		{
			var register:FcParam=normalMaterial.getParam("{UVrotate}", false);
			if(register)
			{
				register.value=params;
			}
			
		}
		
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			if(params == null)
			{
				return 0;
			}
			return params[2]; // 旋转角度
		}
		
		
		protected override function setTargetProperty(value:*):void
		{
			params[2] = value; // 旋转角度
		}
		
		public override function parserKeyFrames(keyFrames:Object):void
		{
			
			var len:int = keyFrames.length;
			var _toRadio:Number=MathConsts.DEGREES_TO_RADIANS;
			var keyframe:NodeAnimateKey;
			for (var i:int = 0; i < len; i++)
			{
				var obj:Object = keyFrames[i];
				var islineTween:Boolean=obj.isLineTween==null?true:obj.isLineTween;
				var bezier:BezierVo=new BezierVo(obj.LX,obj.LY,obj.RX,obj.RY,islineTween);
				var attribute:Object = obj.attributes;
				var value:Number;
				if(attribute is Array)
				{
					value=attribute[0].value
				}else
				{
					value=Number(attribute);
				}
				isNaN(value) && (value=0); 
				keyframe = new NodeAnimateKey(obj.index, value*_toRadio, bezier);
				_keyframes.push(keyframe);
			}
			_keyframes.sortOn("frame", Array.NUMERIC);
			
			this.setPlayLable(this.defaultLable);
			
			this.defaultLable.change(0, _keyframes[len-1].frame);
			
			_cache.length = 0;
		}
		public override function editKeyFrame(track:Object, keyIndex:int, attribute:String, value:*,bezierVo:BezierVo):Object
		{
			return super.editKeyFrame(track,keyIndex,attribute,value*MathConsts.DEGREES_TO_RADIANS,bezierVo);
			
		}
		public override function dispose():void
		{
			normalMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
			var filter:FilterBase = targetMesh.materialPrams.getFilterByTypeId(FilterType.UVRotateAnimation);
			targetMesh.materialPrams.uvRotateAnimUse=false;

			super.dispose();
		}
	}
}