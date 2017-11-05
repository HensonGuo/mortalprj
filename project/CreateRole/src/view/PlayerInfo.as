package view
{
	import core.Effect;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	public class PlayerInfo extends Sprite
	{
		//private var Male:Class;
		//private var Female:Class;
		private var _spriteArray:Array;
		
		private var _vheight:Number = 20;
		private var _maxlen:int = 6;
		
		public function PlayerInfo()
		{
			//Male =  new Male(); //LoaderRole.instance.loader.getAssetClass("Male");
			//Female = //LoaderRole.instance.loader.getAssetClass("Female");
			_spriteArray = [];
		}
		
		public function addInfo( camp:int, sex:int, name:String ):void
		{
			var mc:MovieClip = createSprite( camp, sex, name );
			/* var mc1:MovieClip = _spriteArray[_spriteArray.length-1] as MovieClip;
			if( mc1 )
			{
				mc.y = mc1.y+_vheight;
			} */
			pushMovieClip(mc);
			updatedisplaylist();
		}
		/* <ITEM ID="1" VALUE="#88D644" />	<!--天道-->
		<ITEM ID="2" VALUE="#60CAE9" />	<!--九幽-->
		<ITEM ID="3" VALUE="#EC7CCE" /><!--星宫--> */
		private var _infoColor:Object = {1:"#29caff",2:"#90f636",3:"#f340e4"};
		
		private function createSprite(  camp:int, sex:int, name:String ):MovieClip
		{
			var sp:MovieClip;
			if( sex == 0 ) //男
			{
				sp = new Male;
			}
			else if(sex == 1)//女
			{
				sp = new Female;	
			}
			var infoTxt:TextField = sp.getChildByName("info") as TextField;
			infoTxt.filters = [Effect.glowFilter]
			infoTxt.htmlText = "<font color='"+ _infoColor[camp] +"'>"+name+"</font> 开始了修仙之旅";
			infoTxt.width = 500;
			infoTxt.selectable = false;
			return sp;
		}
		/**
		 * 添加到队列 
		 * @param mc
		 * 
		 */		
		private function pushMovieClip( mc:MovieClip ):void
		{
			_spriteArray.push(mc);
			this.addChild(mc);
		}
		/**
		 * 删除队列的最后一项 
		 * @return 
		 * 
		 */		
		private function shiftMovieClip():MovieClip
		{
			return _spriteArray.shift() as MovieClip;	
		}
		
		private function removeMovieClip( mc:MovieClip ):void
		{
			var index:int = _spriteArray.indexOf(mc);
			if( index == -1 ) return;
			_spriteArray.splice(index,1);
			if(mc.parent)
			{
				mc.parent.removeChild(mc);
			}
		}
		/**
		 * 更新显示队列列表 
		 * 
		 */		
		private function updatedisplaylist():void
		{
			var mc:MovieClip;
			while( _spriteArray.length > _maxlen )
			{
				mc = _spriteArray.shift();
				if(mc.parent)
				{
					mc.parent.removeChild(mc);
				}
			}
			var len:int = _spriteArray.length;
			for( var i:int = 0 ;i < len; i++)
			{
				mc = _spriteArray[i] as MovieClip;

				/* if(mc.y + _vheight <= 0)
				{
					removeMovieClip(mc);
					len = _spriteArray.length;
					mc = null;
					i--;
					continue;
				} */
				
				if( len>3 && i<3 )
				{
					mc.alpha = (i+1)*.3;
					mc.filters = [new GlowFilter(0,0,0,0,0)];
				}
				else
				{
					mc.filters = [];
					mc.alpha = 1;
				}
				
				mc.y = i*_vheight;
			}
		}
	}
}