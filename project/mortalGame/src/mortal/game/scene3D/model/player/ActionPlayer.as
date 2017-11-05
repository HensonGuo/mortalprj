package mortal.game.scene3D.model.player
{
	import baseEngine.basic.RenderList;
	import baseEngine.core.Label3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.PlayMode;
	import baseEngine.system.Device3D;
	
	import com.gengine.utils.pools.ObjectPool;
	
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.effectEditTool.parser.ParserLayerObject;
	
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	import mortal.game.scene3D.player.entity.IGame2D;
	import mortal.game.scene3D.player.entity.IHang;

	public class ActionPlayer extends Md5Mesh implements IGame2D, IHang
	{
		private var _y2d:Number = 0;
		private var _x2d:Number = 0;
		private var _direction:Number = 0;
		private var _hangBoneName:String;
		private var _selectEnabled:Boolean = false;
		private var _currentActionName:String;
		private var _textTure:String;
		
		public function ActionPlayer($loadPriority:int = 2)
		{
			super("", null, false, null);
			this.loadPriority = $loadPriority;
		}

		public function set scaleValue(value:Number):void
		{
			this.scaleX = value;
			this.scaleY = value;
			this.scaleZ = value;
		}
		
		public function set selectEnabled(value:Boolean):void
		{
			if(value)
			{
				Scene3DUtil.addMesh(this);
			}
			else
			{
				Scene3DUtil.removeMesh(this);
			}
			_selectEnabled = value;
		}

		public function get selectEnabled():Boolean
		{
			return _selectEnabled;
		}

		public function openKillAlpha(value:Boolean,killAlpha:Number = 0.5):void
		{
			killAlpha=0.05;
			if(value)
			{
				this.setMateiralBlendMode(Material3D.BLEND_ALPHA0);
			}else
			{
				this.setMateiralBlendMode(Material3D.BLEND_NONE);
			}
			
			ParserLayerObject.instance.parserAlphaKil(this.materialPrams,value,killAlpha);
		}
		/**
		 * 动作播放完毕 
		 * @param callBack
		 * 
		 */	
		public function addFrameComplete(action:String,callBack:Function):void
		{
			targetMd5Controler.addFrameScript(action,getActionFrameLen(action) - 1,callBack);
		}
		
		/**
		 * 移除播放完毕事件 
		 * @param action
		 * @param callBack
		 * 
		 */		
 		public function removeFrameComplete(action:String,callBack:Function):void
		{
			targetMd5Controler.removeFrameScript(action,getActionFrameLen(action) - 1,callBack);
		}
		
		public function addFrameScript(action:String,frameIndex:int, callback:Function):void
		{
			targetMd5Controler.addFrameScript(action,frameIndex,callback);
		}
		
		public function removeAllFrameScript():void
		{
			targetMd5Controler.removeAllFrameScript();
		}
		
		public function removeFrameScript(action:String,frameIndex:int, callback:Function):void
		{
			targetMd5Controler.removeFrameScript(action,frameIndex,callback);
		}
		
		public function hasAction(actionName:String):Boolean
		{
			var lable:Label3D=targetMd5Controler.labels[actionName];
			return lable != null;
		}
		
		public function getActionFrameLen(actionName:String):int
		{
			var lable:Label3D=targetMd5Controler.labels[actionName];
			if(lable)
			{
				return lable.length;
			}else
			{
				return -1;
			}
		}
		
		public function get actionName():String
		{
			return targetMd5Controler.curPlayTrackName;
		}
		
		public function get currentFrame():int
		{
			return targetMd5Controler.currentFrame;
		}
		
		public function set currentFrame(value:int):void
		{
			targetMd5Controler.currentFrame = value;
		}
		
		public override function dispose(isReuse:Boolean = true):void
		{
			super.dispose(isReuse);
			stop();
			_y2d = 0;
			_x2d = 0;
			_direction = 0;
			_hangBoneName = null;
			_textTure = null;
			selectEnabled = false;
			scaleValue = 1;
			if(isReuse)
			{
				ObjectPool.disposeObject(this, ActionPlayer);
			}
		}

		
		public function get hangBody():Pivot3D
		{
			return this;
		}

		public function hang(obj:IHang):void
		{
			targetMd5Controler.attachObjectToBone(obj.hangBoneName, obj.hangBody);
		}

		public function hasBone(name:String):Boolean
		{
			return targetMd5Controler.getJointIndexFromName(name) >= 0;
		}
		
		public function unHang(obj:IHang):void
		{
			targetMd5Controler.removeHang(obj.hangBody);
		}

		public function get hangBoneName():String
		{
			return _hangBoneName;
		}

		public function set hangBoneName(value:String):void
		{
			_hangBoneName = value;
		}


		public function set x2d(value:Number):void
		{
			_x2d = value;
			x = Scene3DUtil.change2Dto3DX(value);
		}

		public function get x2d():Number
		{
			return _x2d;
		}

		public function set y2d(value:Number):void
		{
			_y2d = value;
			z = Scene3DUtil.change2Dto3DY(value);
		}

		public function get y2d():Number
		{
			return _y2d;
		}

//		public function load(playerId:String):void
//		{
//			this.meshUrl = GameScene3dConfig.instance.getMeshUrlById(playerId);
//			this.initAnimate(GameScene3dConfig.instance.getBoneUrlById(playerId))
//			this.setMaterial(GameScene3dConfig.instance.getTextureUrlById(playerId),Texture3D.MIP_NONE)
//		}

		public function load(mesh:String, bone:String, textTure:String,$renderList:RenderList=null):void
		{
			if($renderList==null)
			{
				$renderList=Device3D.scene.renderLayerList;
			}
			this.renderList=$renderList;
			
			this.clear();
			if(this._meshUrl != mesh)
			{
				this.meshUrl = mesh;
			}
			if(this._animUrl != bone)
			{
				this.initAnimate(bone);
			}
			if(this._textTure != textTure)
			{
				//通过后缀判断是否开透贴
				var tempTexture:String = textTure.toLocaleLowerCase();
				if(tempTexture.indexOf(".png") > 0)
				{
					openKillAlpha(true);
				}
				else
				{
					openKillAlpha(false);
				}
				_textTure = textTure;
				this.setMaterial(textTure, Texture3D.MIP_NONE,textTure);
			}

		}

		public function set direction(value:Number):void
		{
			_direction = value;
			this.setRotation(0, Scene3DUtil.change2Dto3DRotation(_direction), 0);
		}

		public function get direction():Number
		{
			return _direction;
		}

		public function changeAction(action:String):void
		{
			if(targetMd5Controler.curPlayTrackName != action)
			{
				targetMd5Controler.setPlayLable(action);
			}
		}
		
		/**
		 * 获取某个动作的攻击帧 
		 * @param action
		 * @return 
		 * 
		 */		
		public function getAttackFrame(action:String):uint
		{
			var label3D:Label3D = targetMd5Controler.getLabel(action);
			if(!label3D)
			{
				return 0;
			}
			else
			{
				return label3D.fightOnFrame;
			}
		}
		
		public function gotoFrame(frame:int):void
		{

			if(targetMd5Controler.isPlaying)
			{
				targetMd5Controler.gotoAndPlay(frame);
			}else
			{
				targetMd5Controler.gotoAndStop(frame);
			}
		}

		public function play(playMode:int=PlayMode.ANIMATION_LOOP_MODE):void
		{
			
			if(!targetMd5Controler.isPlaying)
			{
				targetMd5Controler.play();
			}
			targetMd5Controler.animationMode=playMode;
			this.timerContorler.active();
		}

		public function stop():void
		{
			if(targetMd5Controler.isPlaying)
			{
				targetMd5Controler.stop();
				
			}
			this.timerContorler.unActive();
		}

	}
}
