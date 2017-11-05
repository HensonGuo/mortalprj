package mortal.common.preloader
{
	
	import com.gengine.debug.Log;
	import com.mui.events.LibraryEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="embedComplete", type="com.mui.events.LibraryEvent")]
	[Event(name="loadComplete", type="com.mui.events.LibraryEvent")]
	[Event(name="error",type="flash.events.ErrorEvent")]
	
	public class PreloaderRes extends EventDispatcher
	{
				
		
		private var _runtimeLoaders				: Array;
		
		private var _runtimeCompletes			: Array;
		private var _runtimeComplete			: Boolean;
		
		private var _name						: String;
		
		private var _bytesLoaded				: Number = 0;
		private var _bytesTotal					: Number = 0;
		
		private var _LoaderContext:LoaderContext = new LoaderContext()
		
			
		public function PreloaderRes( name:String )
		{
			super();
			
			_name = name;
			initialize();
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		public function get complete():Boolean
		{
			return  _runtimeComplete;
		}
		
		public function get runtimeComplete():Boolean
		{
			return _runtimeComplete;
		}
		
		public function loadSWF( url:String ):void
		{
			var loader:Loader = new Loader();	
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress, false, 0, true );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete, false, 0, true );
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler,false, 0, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onIOErrorHandler,false, 0, true);
			loader.load( new URLRequest( url ) );
			_runtimeLoaders.push( loader );
			_runtimeCompletes.push( false );
		}
		
		public function loadSWFS( urls:Array ):void
		{
			_runtimeComplete = false;
			
			var num:int = urls.length;
			for( var i:int = 0; i < num; i++ )
			{
				loadSWF( urls[ i ] as String );
			}
		}
		
		public function reset():void
		{
			destroy();
			initialize();
		}
		
		public function destroy():void
		{
			var loader:Loader;
			var numLoaders:int
			var i:int;
			
			numLoaders = _runtimeLoaders.length;
			for( i = 0; i < numLoaders; i++ )
			{
				loader = Loader( _runtimeLoaders[ i ] );
				if( !_runtimeCompletes[ i ] )
				{
					loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
					loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
					loader.close();
				}
				else
				{
					loader.unload();
				}
			}
			
			_runtimeLoaders 		= null;
			_runtimeCompletes 		= null;
			
			_name					= null;
			
			_bytesLoaded			= undefined;
			_bytesTotal				= undefined;
		}
		
		private function initialize():void
		{
			_runtimeLoaders = new Array();
			_runtimeCompletes = new Array();
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}
		
		private function onLoaderProgress( event:ProgressEvent ):void
		{
			checkLoadersProgress();
		}
		
		private function onLoaderComplete( event:Event ):void
		{
			var loader:Loader = Loader( event.target.loader );
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
			
			var numLoaders:int = _runtimeLoaders.length;
			for( var i:int = 0; i < numLoaders; i++ )
			{
				if( loader == Loader( _runtimeLoaders[ i ] ) )
				{
					_runtimeCompletes[ i ] = true;
					break;
				}
			}
			
			checkLoadersProgress( true );
		}
		
		private function onIOErrorHandler( event:ErrorEvent ):void
		{
			Log.system( "library:"+event.text );
			dispatchEvent(new ErrorEvent( ErrorEvent.ERROR,false,false,event.text ));
		}
		
		private function checkLoadersProgress( complete:Boolean = false ):void
		{
			var bytesTotal:Number = 0;
			var bytesLoaded:Number = 0;
			var loader:Loader;
			
			var complete:Boolean = true;
			var numLoaders:int = _runtimeLoaders.length;
			for( var i:int = 0; i < numLoaders; i++ )
			{
				loader = Loader( _runtimeLoaders[ i ] );
				bytesTotal += loader.contentLoaderInfo.bytesTotal;
				bytesLoaded += loader.contentLoaderInfo.bytesLoaded;
				
				if( !_runtimeCompletes[ i ] ) complete = false;
			}			
			
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			
			if( complete )
			{
				_runtimeComplete = true;
				dispatchEvent( new LibraryEvent( LibraryEvent.LOAD_COMPLETE, false, false ) );
			}
			else
			{
				dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal ) );
			}
		}

	}
}