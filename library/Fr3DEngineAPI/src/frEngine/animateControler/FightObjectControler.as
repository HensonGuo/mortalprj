package frEngine.animateControler
{
	import flash.geom.Vector3D;
	
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.effectEditTool.parser.def.ELineType;
	import frEngine.effectEditTool.temple.FightParams;
	import frEngine.math.FrMathUtil;
	
	public class FightObjectControler extends Modifier
	{
		
		private var _tempVect:Vector3D=new Vector3D();
		private var _const1:Number=180/Math.PI;

		private var _endPos:Vector3D=new Vector3D();
		private var _startPos:Vector3D=new Vector3D();
		private var _midPos:Vector3D;
		
		private var isLinear:Boolean;
		
		public var playDringFrame:int;
		private var curPos:Vector3D;
		private var _minDistance:Number;
		public function FightObjectControler()
		{
			
		}
		public override function get type():int
		{
			return AnimateControlerType.FightObject;
		}

		public function resetMultyEmmiter($fightParams:FightParams,$hasPassFrame:int,$minDistance:Number):void
		{
			
			_startPos=$fightParams.startPos;

			_endPos=$fightParams.fightEndPos;

			isLinear=$fightParams.lineType==ELineType.linear;
			
			!isLinear && (_midPos=$fightParams.curveMidPos);
			
			$minDistance>=0 && (_minDistance=$minDistance)
				
			if($hasPassFrame>-1)
			{
				curPos=_endPos.subtract(_startPos);
				var len:Number=curPos.normalize();
				playDringFrame=len/$fightParams.fightSpeed;
				
				curPos.scaleBy(len*$hasPassFrame/playDringFrame);
				curPos=curPos.add(_startPos);
				targetObject3d.setPosition(curPos.x,curPos.y,curPos.z,false);
				targetObject3d.timerContorler.gotoFrame($hasPassFrame,$hasPassFrame);
			}
		}
		public override function toUpdateAnimate(forceUpdate:Boolean=false):void
		{
			if( !curPos )
			{
				return;
			}

			this.currentFrame = targetObject3d.timerContorler.curFrame-2;

			if(!forceUpdate && !changeFrame)
			{
				return;
			}

			if(this.currentFrame<0)
			{
				targetObject3d.setPosition(_startPos.x,_startPos.y,_startPos.z,false);
			}
			else if(this.currentFrame<=playDringFrame)
			{
				if(isLinear)
				{
					var d1:Vector3D;
					d1=_endPos.subtract(_startPos);
					var moveSpeed:Number=d1.length*this.currentFrame/playDringFrame;
					d1.normalize();
					d1.scaleBy(moveSpeed);
					curPos=_startPos.add(d1);
					targetObject3d.setPosition(curPos.x,curPos.y,curPos.z,true);
					
				}else
				{
					var rate:Number=this.currentFrame/playDringFrame;
					FrMathUtil.pointOnCubicBezier2(_startPos,_midPos,_endPos,rate,curPos);
					targetObject3d.setPosition(curPos.x,curPos.y,curPos.z,false);
				}
			}
		}
	}
}

