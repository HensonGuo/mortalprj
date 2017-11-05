/**
 * @heartspeak
 * 2014-4-10 
 */   	

package mortal.game.scene3D.player.head
{
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class TalkSprite extends GSprite
	{
		public var bitMapBg:ScaleBitmap;
		
		protected var _textColor:uint = 0xFFFFFF;
		
		protected var _talkSprite:TextRecord;
		
		protected var _text:String = "";
		
		private var _faceAuthortiy:int = 1;
		
		public function TalkSprite()
		{
			super();
		}
		
		public function get faceAuthortiy():int
		{
			return _faceAuthortiy;
		}
		
		public function set faceAuthortiy(value:int):void
		{
			_faceAuthortiy = value;
		}
		
		public function set text( value:String ):void
		{
			_text = value;
			Global.instance.callLater(updateText);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			this.mouseChildren = false;
			this.mouseEnabled = false;
			bitMapBg = UIFactory.bg(0, 0, 150, 10,this,ImagesConst.SceneTalkSelfBg);
			
			_talkSprite = ObjectPool.getObject(TextRecord);
			_talkSprite.init(140,20);
			_talkSprite.defaultColor = _textColor;
			_talkSprite.x = -20;
			_talkSprite.y = -bitMapBg.height;
			this.addChild(_talkSprite);
		}
		
		protected function updateText():void
		{
			_talkSprite.faceAuthortiy = _faceAuthortiy;
			_talkSprite.content = _text;
			_talkSprite.draw();
			
			var h:Number = _talkSprite.height;
			if( h < 10 )
			{
				h = 10;
			}
			h = h + 15;
			bitMapBg.width = 150;
			bitMapBg.height = h;
			bitMapBg.y = -h ;
			bitMapBg.x = -25;
			_talkSprite.y = -h;
		}
		
		override public function dispose(isReuse:Boolean = true):void
		{
			super.dispose(isReuse);
			if(bitMapBg)
			{
				bitMapBg.dispose(isReuse);
				bitMapBg = null;
			}
			if(_talkSprite)
			{
				_talkSprite.dispose(isReuse);
				_talkSprite = null;
			}
			UICompomentPool.disposeUICompoment(this);
		}
	}
}