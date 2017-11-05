package frEngine.animateControler.transformControler
{

	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.NodeAnimateKey;
	import frEngine.math.FrMathUtil;

	public class ScaleXYZControler extends Modifier
	{

		public function ScaleXYZControler()
		{
			super();
		}

		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return new Vector3D(obj.scaleX, obj.scaleY, obj.scaleZ);
		}

		public override function get type():int
		{
			return AnimateControlerType.ScaleXYZ;
		}

		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.setScale(value.x, value.y, value.z);
		}

		protected override function calculateFrameValue(tframe:int):void
		{
			var index:int = getTimeIndex(tframe, _keyframes);
			var m1:NodeAnimateKey = _keyframes[index];
			var p1:Number = m1.value;
			var resultValue:Vector3D;
			if (m1.frame == tframe || index == _keyframes.length - 1)
			{
				resultValue = new Vector3D(p1+_baseValue.x, p1+_baseValue.y, p1+_baseValue.z);
				_cache[tframe] = resultValue;
				resultValue.x == 0 && (resultValue.x = 0.0001);
				resultValue.y == 0 && (resultValue.y = 0.0001);
				resultValue.z == 0 && (resultValue.z = 0.0001);
			}
			else
			{
				var m2:NodeAnimateKey = _keyframes[index + 1];
				var p2:Number = m2.value;
				var startFrame:int = m1.frame;
				var endFrame:int = m2.frame;
				var useLine:Boolean=(m1.bezierVo.isLineTween || m2.bezierVo.isLineTween)
				var calframe:int = tframe + 2 + int(Math.random() * 30);
				calframe > endFrame && (calframe = endFrame);
				var offset:Number,i:int;
				if(useLine)
				{
					var startValue:Number=m1.value;
					var scaleValue:Number=(m2.value-startValue)/(endFrame-startFrame);
					for (i = tframe; i < calframe; i++)
					{
						if (!_cache[i])
						{
							offset = startValue+(i-startFrame)*scaleValue;
							resultValue = new Vector3D(offset+_baseValue.x, offset+_baseValue.y, offset+_baseValue.z);
							_cache[i] = resultValue;
							resultValue.x == 0 && (resultValue.x = 0.0001);
							resultValue.y == 0 && (resultValue.y = 0.0001);
							resultValue.z == 0 && (resultValue.z = 0.0001);
						}
					}
				}else
				{
					FrMathUtil.getBezierData(startFrame, endFrame, startFrame + m1.bezierVo.RX, endFrame + m2.bezierVo.LX, vectorX);
					FrMathUtil.getBezierData(m1.value, m2.value, m1.value + m1.bezierVo.RY, m2.value + m2.bezierVo.LY, vectorY);
					for (i = tframe; i < calframe; i++)
					{
						if (!_cache[i])
						{
							offset = FrMathUtil.getBezierTimeAndValue(i, vectorX,vectorY);
							resultValue = new Vector3D(offset+_baseValue.x, offset+_baseValue.y, offset+_baseValue.z);
							_cache[i] = resultValue;
							resultValue.x == 0 && (resultValue.x = 0.0001);
							resultValue.y == 0 && (resultValue.y = 0.0001);
							resultValue.z == 0 && (resultValue.z = 0.0001);
						}
					}
				}
				
			}
		}
	}
}

