package mortal.game.scene3D.player.item
{
	import com.mui.controls.GTextFiled;
	
	import flash.text.TextFieldAutoSize;
	
	import baseEngine.system.Device3D;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3D;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3DFactory;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.scene3D.player.entity.Game2DPlayer;
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 传送阵  一个特效加一个名字
	 * 
	 */
	public class BasePlayer extends Game2DPlayer
	{
		private var _effectPlayer:EffectPlayer;
		
		private var _textField:GTextFiled;
		private var _text3D:Text3D;
		
		public function BasePlayer()
		{
			super();
		}
		
		protected function initPlayer(url:String):void
		{
			if(!_effectPlayer)
			{
				_effectPlayer = EffectPlayerPool.instance.getEffectPlayer(url);
				_effectPlayer.play(true);
				this.addChild(_effectPlayer);
			}
		}
		
		protected function setTitle(value:String):void
		{

			if(!_textField)
			{
				_textField = UIFactory.textField("",0,0,-1,-1,null,GlobalStyle.textFormatItemWhite);
				_textField.autoSize = TextFieldAutoSize.LEFT;
				_textField.htmlText = value;
				
				_text3D = Text3DFactory.instance.createtext3D(_textField);
				
			}
			else
			{
				_textField.htmlText = value;
				Text3DFactory.instance.updateText3D(_text3D,_textField);

			}

			this.addChild(_text3D);
			layOut();
		}
		
		protected function layOut():void
		{
			_text3D.x = -_text3D.textWidth/1.7;
			_text3D.y = 150;
		}
		
		public function set url( value:String ):void
		{
			initPlayer(value);
		}
		
		
		override public function dispose(isReuse:Boolean=true):void
		{
			if(_effectPlayer)
			{
				_effectPlayer.dispose(isReuse);
			}
			_effectPlayer = null;
			if(_text3D)
			{
				Text3DFactory.instance.disposeText3D(_text3D);
				_text3D = null;
			}
			if(_textField)
			{
				_textField.dispose();
				_textField = null;
			}
			super.dispose(isReuse);
		}
	}
}
