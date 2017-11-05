package mortal.game.scene3D.model.player
{
	import com.gengine.utils.pools.ObjectPool;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.mesh.NormalMesh3D;
	
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	import mortal.game.scene3D.player.entity.IGame2D;
	import mortal.game.scene3D.player.entity.IHang;

	public class WeaponPlayer extends NormalMesh3D implements IGame2D, IHang
	{
		private var _y2d:Number = 0;
		private var _x2d:Number = 0;
		private var _hangBoneName:String;
		private var _direction:Number = 0;
		private var _selectEnabled:Boolean = false;
		protected var _textTure:String;

		public function WeaponPlayer()
		{
			super(null, null, false, null);
		}

		public function set selectEnabled(value:Boolean):void
		{
			if (value)
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

		public override function dispose(isReuse:Boolean = true):void
		{
			super.dispose(isReuse);
			_x2d = 0;
			_y2d = 0;
			_hangBoneName = null;
			_direction = 0;
			_textTure = null;
			selectEnabled = false;
			if (isReuse)
			{
				ObjectPool.disposeObject(this, WeaponPlayer);
			}
		}

		public function load(mesh:String, textTure:String,$renderList:RenderList=null):void
		{
			if($renderList==null)
			{
				$renderList=Device3D.scene.renderLayerList;
			}
			
			renderList=$renderList;
			
			if(this._meshUrl != mesh)
			{
				this.meshUrl = mesh;
			}
			if(this._textTure != textTure)
			{
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

		public function get hangBody():Pivot3D
		{
			return this;
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
		

	}
}
