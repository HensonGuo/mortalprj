package com.gengine.modules
{
	import flash.events.EventDispatcher;
	
	[Event(name="complete",type="flash.events.Event")]
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="io_error",type="flash.events.IOErrorEvent")]
	
	public class ModuleInfo extends EventDispatcher
	{
		
		public function ModuleInfo( name:String = null,url:String = null )
		{
			this.name = name;
			this.url = url;
		}
		public var url:String;
		public var name:String;
		public var isLoaded:Boolean;
		public var isLoading:Boolean;
		public var error:Boolean;
		public var module:IModule;
	}
}