package mortal.game.manager.msgTip
{
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.Game;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.info.GMapInfo;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	
	public class MsgSceneInfoImpl extends Sprite
	{
		private var _sceneInfoCache:Dictionary = new Dictionary();
		private var _bmp:Bitmap = new Bitmap();
		
		private var _titleTxt:TextField;
		private var _desTxts:Dictionary = new Dictionary();
		private var _infoTxtFormat:TextFormat = new GTextFormat(FontUtil.lishuName,20,0xffffff,false);
		
		private var _inTween:TweenMax;
		private var _outTween:TweenMax;
		private var _timerKey:uint;
		
		public function MsgSceneInfoImpl()
		{
			super();
			
			_infoTxtFormat.leading = 0;
			_infoTxtFormat.align = TextFormatAlign.LEFT;
			
			mouseEnabled = false;
			mouseChildren = false;
			
			_bmp.x = 270;
			_bmp.y = 150;
		}
		
		/**
		 * 显示场景描述信息 
		 * @param sceneName
		 * @param list
		 * 
		 */
		public function showMsg(sceneName:String,msgs:Array):void
		{
			hideMsg();
			
			if(!_sceneInfoCache[sceneName])
			{
				createSceneCache(sceneName,msgs);
			}
			_bmp.bitmapData = _sceneInfoCache[sceneName];
			_bmp.alpha = 0;
			LayerManager.highestLayer.addChild(_bmp);
			stageReseze();
			_inTween = TweenMax.to(_bmp,3,{alpha:1,onComplete:onInEnd});
			//			onInEnd();
		}
		
		private function createSceneCache(sceneName:String,msgs:Array):void
		{
			if(!_titleTxt)
			{
				_titleTxt = createTitleTxt();
				addChild(_titleTxt);
			}
			_titleTxt.text = sceneName;
			
			var index:int;
			var length:int = msgs.length;
			var msg:String;
			var infoTxt:TextField;
			
			while(index < length)
			{
				msg = msgs[index];
				infoTxt = _desTxts[index];
				if(!infoTxt)
				{
					infoTxt = createInfoTxt(index);
					_desTxts[index] = infoTxt;
				}
				infoTxt.text = msg;
				addChild(infoTxt);
				index++;
			}
			alpha = 1;
			filters = [FilterConst.nameGlowFilter,FilterConst.sceneDesFilter];
			
			var bmpd:BitmapData = new BitmapData(width,height,true,0);
			bmpd.draw(this);
			
			_sceneInfoCache[sceneName] = bmpd;
		}
		
		private function createInfoTxt(index:int):TextField
		{
			var infoTxt:TextField;
			infoTxt = new  TextField();
			infoTxt.defaultTextFormat = _infoTxtFormat;
			infoTxt.width = 28;
			infoTxt.autoSize = TextFieldAutoSize.LEFT;
			infoTxt.multiline = true;
			infoTxt.wordWrap = true;
			infoTxt.mouseEnabled = false;
			infoTxt.x = 35 + index * infoTxt.width;
			infoTxt.y = 30;
			return infoTxt;
		}
		
		private function createTitleTxt():TextField
		{
			var titleTxt:TextField = new TextField();
			var tf:TextFormat = new GTextFormat(FontUtil.lishuName,25,0xffffff,false);
			tf.leading = 0;
			tf.align = TextFormatAlign.LEFT;
			titleTxt.defaultTextFormat = tf;
			titleTxt.width = 32;
			titleTxt.autoSize = TextFieldAutoSize.LEFT;
			titleTxt.multiline = true;
			titleTxt.wordWrap = true;
			titleTxt.mouseEnabled = false;
			return titleTxt;
		}
		
		/**
		 * 淡入完成 
		 * 
		 */
		private function onInEnd():void
		{
			_timerKey = setTimeout(onTimeOut,3000);
		}
		
		/**
		 * 停留时间到 
		 * 
		 */
		private function onTimeOut():void
		{
			_outTween = TweenMax.to(_bmp,3,{alpha:0,onComplete:onOutEnd});
			//			onOutEnd();
		}
		
		/**
		 * 淡出完成 
		 * 
		 */
		private function onOutEnd():void
		{
			hideMsg();
			
			//			var mapInfo:GMapInfo = GameMapConfig.instance.getMapInfo(MapFileUtil.mapID);
			//			showMsg(mapInfo.name,mapInfo.getDesList());
		}
		
		/**
		 * 隐藏信息 
		 * 
		 */
		public function hideMsg():void
		{
			clearTimeout(_timerKey);
			
			if(_inTween && _inTween.active)
			{
				_inTween.kill();
			}
			
			if(_outTween && _outTween.active)
			{
				_outTween.kill();
			}
			
			if(_bmp && _bmp.parent != null)
			{
				_bmp.parent.removeChild(_bmp);
			}
			
			if(_titleTxt)
			{
				_titleTxt.text = "";
			}
			
			var index:int = 1;
			var infoTxt:TextField;
			while(index < numChildren)
			{
				infoTxt = removeChildAt(index) as TextField;
				infoTxt.text = "";
			}
		}
		
		/**
		 * 场景改变大小 
		 * 
		 */
		public function stageReseze():void
		{
		}
		
		override public function get width():Number
		{
			return 32 + (numChildren - 1) * 30;
		}
		
		override public function get height():Number
		{
			return 500;
		}
	}
}