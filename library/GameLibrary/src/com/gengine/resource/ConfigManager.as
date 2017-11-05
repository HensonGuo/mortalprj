package com.gengine.resource
{
	import com.gengine.debug.Log;
	import com.gengine.resource.loader.DataLoader;
	import com.gengine.utils.JsonMergerConst;
	
	import flash.errors.IOError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="error",type="flash.events.ErrorEvent")]
	
	public class ConfigManager extends EventDispatcher
	{
		private static var _instance:ConfigManager;
		
		private var _isLoaded:Boolean = false;
		
		private var _configDic:Dictionary;
		
		public function ConfigManager()
		{
			if( _instance != null )
			{
				throw new Error("ConfigManager 单例");
			}
			_isLoaded = false;
		}
		
		public static function get instance():ConfigManager
		{
			if( _instance == null )
			{
				_instance = new ConfigManager();
			}
			return _instance;
		}
		
		public function load( url:String ):void
		{
			var dataLoader:DataLoader = new DataLoader();
			dataLoader.addEventListener(Event.COMPLETE,onLoadCompleteHandler);
			dataLoader.addEventListener(ProgressEvent.PROGRESS,onLoadProgressHandler);
			dataLoader.addEventListener(ErrorEvent.ERROR,onErrorHandler);
			dataLoader.load(url,null);
		}
		
		private function onLoadCompleteHandler( event:Event ):void
		{
			try
			{
				var memory:int = System.totalMemory;
				_isLoaded = true;
				var loader:DataLoader = event.target as DataLoader;
				var byteArray:ByteArray = loader.bytesData;
				byteArray.position = 0;
				var tim:Number = getTimer();
				byteArray.uncompress();
				tim = getTimer();
				_configDic = byteArray.readObject() as Dictionary;
				dispatchEvent(event);
				Log.system("系统总内存:",System.totalMemory,"解压data内存增加:",System.totalMemory - memory);
			}
			catch(e:Error)
			{
				_isLoaded = false;
				_configDic = null;
				dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
			}
		}
		
		private function onLoadProgressHandler( event:ProgressEvent ):void
		{
			dispatchEvent(event);
		}
		
		private function onErrorHandler( event:ErrorEvent ):void
		{
			_isLoaded = false;
			dispatchEvent(event);
		}
		
		public function getObjectByFileName(fileName:String,isDeleteByte:Boolean = true):Object
		{
			if( hasFile( fileName ) )
			{
				var bytearry:ByteArray = _configDic[fileName].content as ByteArray; 
				bytearry.position = 0;
				var obj:Object = bytearry.readObject().root;
				if(isDeleteByte)
				{
					delete _configDic[fileName];
				}
				return obj;
			}
			return null;
		}
		
		public function getStringByFileName(fileName:String):String
		{
			if( hasFile( fileName ) )
			{
				return _configDic[fileName].content;
			}
			return null;
		}
		
		public function getJSONByFileName(fileName:String,isDeleteByte:Boolean = true):Object
		{
			if( hasFile( fileName ) )
			{
				var bytearry:ByteArray =_configDic[fileName].content as ByteArray; 
				bytearry.position = 0;
				var jsonObj:Object = bytearry.readObject(); 
				jsonObj = JsonMergerConst.instance.revertAttributes(fileName,jsonObj); 
				if(isDeleteByte)
				{
					delete _configDic[fileName];
				}
				return jsonObj;
			}
			return null;
		}
		
		public function hasFile( fileName:String ):Boolean
		{
			if( _isLoaded == false ) return false;
			return _configDic[fileName] != null;
		}
		
		public function getByteArrayByFileName(fileName:String,isDeleteByte:Boolean = true):ByteArray
		{
			if( hasFile( fileName ) )
			{
				var byteArray:ByteArray = _configDic[fileName].content as ByteArray;
				delete _configDic[fileName];
				return byteArray;
			}
			return null;
		}
		
	}
}