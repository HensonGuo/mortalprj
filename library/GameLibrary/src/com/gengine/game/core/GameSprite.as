package com.gengine.game.core
{
	import com.gengine.core.IDispose;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class GameSprite extends Sprite implements IDispose
	{
		
		public var isDispose:Boolean = false;
		
		public var isHoverTest:Boolean = false;
		
		
		public function GameSprite()
		{
			super();
			this.mouseEnabled = false;
			this.mouseChildren = false;
			this.tabChildren = false;
		}
		
		public function removeToStage( stageSprite:DisplayObjectContainer = null,isRemove:Boolean = false ):Boolean
		{
			if( this.parent )
			{
				this.parent.removeChild(this);
				return true;
			}
			return false;
		}
		
		public function addToStage( stageSprite:DisplayObjectContainer ):Boolean
		{
			if( this.parent == null )
			{
				stageSprite.addChild(this);
				return true;
			}
			return false;
		}
		
		public var index:int;
		
		public function dispose( isReuse:Boolean = true ):void
		{
			removeToStage();
		}
		
		public function hoverTest():Boolean
		{
			return false;
		}
		
		public function onMouseOver():void
		{
			
		}
		
		public function onMouseOut():void
		{
			
		}
		
		public function traceLog(value:String):void
		{
			
		}
	}
}