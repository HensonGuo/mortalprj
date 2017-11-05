package com.mui.utils
{
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.gengine.utils.pools.construct;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	import com.mui.core.IFrUIContainer;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.IToolTipItem;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.effects.EffectManager;

	public class UICompomentPool
	{
		private static var pools:Dictionary = new Dictionary();
		private static var dicObj:Dictionary = new Dictionary(true);
		
		//给外部处理
		private static var _clientDisposeFun:Function;
		
		public static function get clientDisposeFun():Function
		{
			return _clientDisposeFun;
		}
		
		public static function set clientDisposeFun(value:Function):void
		{
			_clientDisposeFun = value;
		}
		
		private static function getPool( type:Class ):Array
		{
			return type in pools ? pools[type] : pools[type] = new Array();
		}
		
		public function UICompomentPool()
		{
		}
		
		/**
		 * 返回组件 
		 * @param type
		 * @param args
		 * @return 
		 * 
		 */
		public static function getUICompoment(type:Class,...parameters):*
		{
			var pool:Array = getPool( type );
			if( pool.length > 0 )
			{
				var obj:Object = pool.pop();
				if(obj is IFrUIContainer)
				{
					(obj as IFrUIContainer).createDisposedChildren();
				}
//				delete dicObj[obj];
				return obj;
			}
			else
			{
				return construct( type, parameters );
			}
		}
		
		/**
		 * 释放组件 
		 * @param object
		 * @param pushPool 是否放进池
		 * @param clsType
		 * @return 
		 * 
		 */
		public static function disposeUICompoment(object:DisplayObject,pushPool:Boolean=true,clsType:Class=null):Boolean
		{
			if(_clientDisposeFun != null)
			{
				_clientDisposeFun.call(null,object);
			}
			if(!object)
			{
				if(Global.isDebugModle)
				{
					throw Error("disposeUIComponent  is  null");
				}
				return false;
			}
//			if(object is DisplayObject)
//			{
				if((object as DisplayObject).parent)
				{
					(object as DisplayObject).parent.removeChild(object as DisplayObject);
				}
				
//				if(object is InteractiveObject)
//				{
//					(object as InteractiveObject).mouseEnabled = true;
//				}
//				if(object is Sprite)
//				{
//					(object as Sprite).mouseChildren = true;
//				}
				if(object is UIComponent)
				{
					(object as UIComponent).clearStyle("textFormat");
					(object as UIComponent).clearStyle("disabledTextFormat");
				}
				
				object.x = 0;
				object.y = 0;
				object["visible"] = true;
				object["alpha"] = 1;
				object["scaleX"] = 1;
				object["scaleY"] = 1;
				object["rotation"] = 0;
				object["filters"] = [];
				
				if(object.hasOwnProperty("enabled"))
				{
					object["enabled"] = true;
				}
				
				if(object is Sprite)
				{
					(object as Sprite).graphics.clear();
				}
//			}
			if(object is IToolTipItem)
			{
				(object as IToolTipItem).toolTipData = null;
			}
			if(pushPool)
			{
				disposeObject(object,clsType);
			}
			return true;
		}
		
		public static function disposeObject( object:*, type:Class = null ):void
		{
			if( !type )
			{
				var typeName:String = getQualifiedClassName( object );
				type = getDefinitionByName( typeName ) as Class;
			}
			var pool:Array = getPool( type );
			pool.push( object );
//			dicObj[object] = 1;
		}
		
		/**
		 * 清理池子里面的对象 
		 * 
		 */		
		public static function clearPool():void
		{
//			pools = new Dictionary();
		}
		
		/**
		 * 获取池子里面对象的大小 
		 * 
		 */
		public static function getSize():int
		{
			var length:int = 0;
			for each(var key:* in dicObj)
			{
				length ++;
			}
			return length;
		}
	}
}