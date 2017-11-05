


//flare.system.ILibraryExternalItem

package baseEngine.system
{
    import flash.events.IEventDispatcher;

    public interface ILibraryExternalItem extends ILibraryItem, IEventDispatcher 
    {

        function get bytesTotal():uint;
        function get bytesLoaded():uint;
        function get loaded():Boolean;
		function set useMaterial(value:Boolean):void;
        function load():void;
        function close():void;

    }
}//package flare.system

