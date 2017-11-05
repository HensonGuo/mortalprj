package frEngine.effectEditTool.temple
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.effectEditTool.manager.Obj3dContainer;
	import frEngine.loaders.away3dMd5.JointPose;

	public class TempleFight implements ITemple
	{
		
		private var _container:Obj3dContainer;
		private var _fighter:Md5Mesh;
		private var _fighted:Md5Mesh; 
		private var _weapon:Mesh3D;
		private var _fightSpeed:int;
		private static var _zeroVector3d:Vector3D = new Vector3D();
		private static var _globlePos:Vector3D = new Vector3D();
		private var _onHitDispose:Boolean;
		private var _playDringTime:Number;
		private var _callBack:Function;
		private var _fightList:Vector.<FightParams>;
		private var _hangList:Array;
		private var hasCalculateEndPosMap:Dictionary = new Dictionary(false);
		private var hasCalculateStartPosMap:Dictionary = new Dictionary(false);
		private var fightOnAction:String;
		private var fightOnFrame:int;
		private var _isOnPlaying:Boolean;

		public function TempleFight($container:Obj3dContainer)
		{
			_container = $container;
		}

		public function setFightParams(fighter:Md5Mesh, fighted:Md5Mesh, weapon:Mesh3D, onHitDispose:Boolean, callBack:Function = null):void
		{
			_fighter = fighter;
			_fighted = fighted;
			_weapon = weapon;
			_onHitDispose = onHitDispose;
			_callBack = callBack;
			if (_fighted && _fighter)
			{
				_fighter.addChild(_container);

			}
			//checkAndPlay();

		}

		private function updateEndPosHander(e:Event):void
		{
			var len:int = _fightList.length;
			hasCalculateEndPosMap = new Dictionary(false);
			for (var i:int = 0; i < len; i++)
			{
				var obj:FightParams = _fightList[i];
				var targetObjec3d:Pivot3D = _container.getObject3dByID(obj.uid);
				obj.endPos = getPos(obj.endTargetLabel, obj.endBoneName, hasCalculateEndPosMap,obj.endOffsetPos);
				if (obj.startPos)
				{
					targetObjec3d.setTempleParams(ETempleType.Fight, -1, -1, obj);
				}

			}
		}

		public function parsersParams(params:*):void
		{

			if (!params || !params.fightList)
			{
				return;
			}

			fightOnAction = params.fightOnAction;

			fightOnFrame = params.fightOnframe;

			var fightList:Array = params.fightList;

			_fightList = new Vector.<FightParams>();

			_hangList = params.hangList;

			var len:int = fightList.length;

			var scene:Scene3D = Device3D.scene;
			for (var i:int = 0; i < len; i++)
			{
				var obj:FightParams = new FightParams(fightList[i]);
				_fightList.push(obj);
				var targetObjec3d:Pivot3D = _container.getObject3dByID(obj.uid);
				targetObjec3d.timerContorler = TimeControler.createTimerInstance(null, _container.timerContorler);
				targetObjec3d.isHide = true;
				targetObjec3d.parent = scene;
			}

			checkAndPlay();

		}

		public function unHangAll():void
		{
			_callBack = null;
			_fighted && _fighted.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT, updateEndPosHander);
			_fighter && _fighter.targetMd5Controler.removeFrameScript(fightOnAction, fightOnFrame,startFightHander); 
			removeAllHangObj();
		}

		public function setTempleParams(params:*):void
		{
 
			setFightParams(params[0], params[1], params[2], params[3]);

		}


		public function set isOnPlaying(value:Boolean):void
		{
			_isOnPlaying=value;
		}
		public function checkAndPlay():void
		{

			if (!_fighter || !_fighted || !_fightList || _isOnPlaying)
			{
				return;
			}

			_fighter.targetMd5Controler.addFrameScript(fightOnAction, fightOnFrame, startFightHander);

			if (_fighter.targetMd5Controler.currentFrame >= fightOnFrame)
			{
				startFightHander();
			}

		}


		private function startFightHander():void
		{
			if (_fighter && _fighter.targetMd5Controler.currentFrame < fightOnFrame || _isOnPlaying)
			{
				return;
			}
			isOnPlaying = true;
			checkFightList();
			checkHangList();
		}

		private function checkFightList():void
		{
			var curFrame:int = _fighter.targetMd5Controler.currentFrame;
			var hasPassFrame:int = (curFrame - fightOnFrame);

			var _resultPlayFrame:Number = 1000000;

			_fighted.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT, updateEndPosHander);

			var len:int = _fightList.length;


			hasCalculateStartPosMap = new Dictionary(false);
			hasCalculateEndPosMap = new Dictionary(false);

			var scene:Scene3D = Device3D.scene;

			for (var i:int = 0; i < len; i++)
			{
				var obj:FightParams = _fightList[i];
				var targetObjec3d:Pivot3D = _container.getObject3dByID(obj.uid);
				obj.startPos = getPos(obj.startTargetLabel, obj.startBoneName, hasCalculateStartPosMap,obj.startOffsetPos);
				obj.endPos = getPos(obj.endTargetLabel, obj.endBoneName, hasCalculateEndPosMap,obj.endOffsetPos);

				targetObjec3d.setTempleParams(ETempleType.Fight, hasPassFrame, 20 * _fighted.scaleX, obj);

				targetObjec3d.timerContorler.gotoFrame(0, 0);

				targetObjec3d.isHide = false;

				targetObjec3d.parent = scene;

				var playDringFrame:int = obj.endPos.subtract(obj.startPos).length / obj.speed;

				var resultPlayFrame:int = playDringFrame - hasPassFrame;

				if (resultPlayFrame < _resultPlayFrame)
				{
					_resultPlayFrame = resultPlayFrame;
				}
			}


			if (_resultPlayFrame == 1000000)
			{
				return;
			}
			if (_resultPlayFrame > 0 && len > 0)
			{
				setTimeout(hasHitHander, _resultPlayFrame / Device3D.animateSpeedFrame * 1000);
			}
			else
			{
				hasHitHander();
			}
		}

		private function checkHangList():void
		{
			if (!_hangList)
			{
				return;
			}
			for each (var obj:Object in _hangList)
			{
				var uid:String = obj.uid;
				var boneName:String = obj.boneName
				var obj3d:Pivot3D = _container.getObject3dByID(obj.uid);
				var targetHang:Mesh3D;
				if (obj.hangName == ETempeItemName.WeaponName)
				{
					targetHang = _weapon
				}
				else if (obj.hangName == ETempeItemName.FighterName)
				{
					targetHang = _fighter
				}
				else
				{
					targetHang = _fighted;
				}
				if (obj3d && obj3d.parent != targetHang)
				{

					if (boneName)
					{
						var skin:Md5SkinAnimateControler = targetHang.getAnimateControlerInstance(AnimateControlerType.Md5SkinAnimateControler) as Md5SkinAnimateControler
						skin && skin.attachObjectToBone(boneName, obj3d);
					}
					else
					{
						if (obj3d.curHangControler)
						{
							obj3d.curHangControler.removeHang(obj3d);
							obj3d.curHangControler = null;
						}
						targetHang.addChild(obj3d);
						obj3d.identityOffsetTransform();
					}
				}

			}
		}

		private function removeAllHangObj():void
		{
			var obj:Object;

			if (_fightList)
			{
				for each (obj in _fightList)
				{
					var targetObjec3d:Pivot3D = _container.getObject3dByID(obj.uid);
					targetObjec3d.parent = null;
				}
				//_fightList = new Vector.<FightParams>();
			}
			if (_hangList)
			{
				for each (obj in _hangList)
				{
					var uid:String = obj.uid;
					var boneName:String = obj.boneName
					var obj3d:Pivot3D = _container.getObject3dByID(obj.uid);
					if (obj3d.curHangControler)
					{
						obj3d.curHangControler.removeHang(obj3d);
						obj3d.curHangControler = null;
					}
					if (obj3d.parent)
					{
						obj3d.parent = null;
					}
				}
				//_hangList=new Array();
			}

		}

		private function hasHitHander():void
		{
			if (_onHitDispose)
			{
				setTimeout(delayToDispose, 200);
			}
			if (_callBack != null)
			{
				_callBack.call();
				_callBack = null;
			}
			isOnPlaying = false;
		}

		private function delayToDispose():void
		{
			_container.dispose(true);
		}



		private function getPos(targetLabel:String, boneName:String, cacheMap:Dictionary,$offsetPos:Vector3D):Vector3D
		{
			var flag:String=targetLabel + boneName;
			if($offsetPos)
			{
				flag+=$offsetPos.toString();
			}
			var resultPoint3d:Vector3D = cacheMap[flag];
			if (resultPoint3d)
			{
				return resultPoint3d;
			}

			var targetMd5:Md5Mesh;
			if (targetLabel == ETempeItemName.FighterName)
			{
				targetMd5 = _fighter;
			}
			else
			{
				targetMd5 = _fighted;
			}


			if (boneName)
			{
				try
				{
					var joint:JointPose = targetMd5.targetMd5Controler.skeletoAnimator.getBoneGlobleJointByName(boneName);
					if($offsetPos)
					{
						resultPoint3d = targetMd5.world.transformVector(joint.translation.add($offsetPos));
					}else
					{
						resultPoint3d = targetMd5.world.transformVector(joint.translation);
					}
					
					
				}
				catch (e:Error)
				{
					boneName=null;
				}
			}
			
			if(!boneName)
			{
				if($offsetPos)
				{
					_globlePos=targetMd5.world.transformVector($offsetPos)
				}else
				{ 
					_globlePos=new Vector3D()
					targetMd5.world.copyColumnTo(3,_globlePos );
				}
				resultPoint3d = _globlePos;
			}

			cacheMap[flag] = resultPoint3d;

			return resultPoint3d;
		}

		public function dispose():void
		{
			unHangAll();
			_container = null;
			_fighter = null;
			_fighted = null;
			_hangList = null;
			_fightList = null;
			isOnPlaying = false;
		}
	}
}
