


//deng.fzip.FZipLibrary

package deng.fzip
{
    import flash.events.EventDispatcher;
    import flash.display.Loader;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.display.Bitmap;
    import flash.events.*;

    [Event(name="complete", type="flash.events.Event")]
    public class FZipLibrary extends EventDispatcher 
    {

        private static const FORMAT_BITMAPDATA:uint = (1 << 0);
        private static const FORMAT_DISPLAYOBJECT:uint = (1 << 1);

        private var pendingFiles:Array;
        private var pendingZips:Array;
        private var currentState:uint = 0;
        private var currentFilename:String;
        private var currentZip:FZip;
        private var currentLoader:Loader;
        private var bitmapDataFormat:RegExp;
        private var displayObjectFormat:RegExp;
        private var bitmapDataList:Object;
        private var displayObjectList:Object;

        public function FZipLibrary()
        {
            this.pendingFiles = [];
            this.pendingZips = [];
            this.bitmapDataFormat = /[]/;
            this.displayObjectFormat = /[]/;
            this.bitmapDataList = {};
            this.displayObjectList = {};
            super();
        }
        public function addZip(zip:FZip):void
        {
            this.pendingZips.unshift(zip);
            this.processNext();
        }
        public function formatAsBitmapData(ext:String):void
        {
            this.bitmapDataFormat = this.addExtension(this.bitmapDataFormat, ext);
        }
        public function formatAsDisplayObject(ext:String):void
        {
            this.displayObjectFormat = this.addExtension(this.displayObjectFormat, ext);
        }
        private function addExtension(original:RegExp, ext:String):RegExp
        {
            return (new RegExp(((ext.replace(/[^A-Za-z0-9]/, "\\$&") + "$|") + original.source)));
        }
        public function getBitmapData(filename:String):BitmapData
        {
            if ((!(this.bitmapDataList[filename]) is BitmapData))
            {
                throw (new Error((('File "' + filename) + '" was not found as a BitmapData')));
            };
            return ((this.bitmapDataList[filename] as BitmapData));
        }
        public function getDisplayObject(filename:String):DisplayObject
        {
            if (!(this.displayObjectList.hasOwnProperty(filename)))
            {
                throw (new ReferenceError((('File "' + filename) + '" was not found as a DisplayObject')));
            };
            return ((this.displayObjectList[filename] as DisplayObject));
        }
        public function getDefinition(filename:String, definition:String):Object
        {
            if (!(this.displayObjectList.hasOwnProperty(filename)))
            {
                throw (new ReferenceError((('File "' + filename) + '" was not found as a DisplayObject, ')));
            };
            var disp:DisplayObject = (this.displayObjectList[filename] as DisplayObject);
            return (disp.loaderInfo.applicationDomain.getDefinition(definition));
            throw (new ReferenceError('Definition "' + definition + '" in file "' + filename));
            return (null); //dead code
        }
        private function processNext(evt:Event=null):void
        {
            var nextFile:FZipFile;
            var content:ByteArray;
            var i:uint;
            while (this.currentState === 0)
            {
                if (this.pendingFiles.length > 0)
                {
                    nextFile = this.pendingFiles.pop();
                    if (this.bitmapDataFormat.test(nextFile.filename))
                    {
                        this.currentState = (this.currentState | FORMAT_BITMAPDATA);
                    };
                    if (this.displayObjectFormat.test(nextFile.filename))
                    {
                        this.currentState = (this.currentState | FORMAT_DISPLAYOBJECT);
                    };
                    if ((this.currentState & (FORMAT_BITMAPDATA | FORMAT_DISPLAYOBJECT)) !== 0)
                    {
                        this.currentFilename = nextFile.filename;
                        this.currentLoader = new Loader();
                        this.currentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loaderCompleteHandler);
                        this.currentLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loaderCompleteHandler);
                        content = nextFile.content;
                        content.position = 0;
                        this.currentLoader.loadBytes(content);
                        break;
                    };
                }
                else
                {
                    if (this.currentZip == null)
                    {
                        if (this.pendingZips.length > 0)
                        {
                            this.currentZip = this.pendingZips.pop();
                            i = this.currentZip.getFileCount();
                            while (i > 0)
                            {
                                this.pendingFiles.push(this.currentZip.getFileAt(--i));
                            };
                            if (this.currentZip.active)
                            {
                                this.currentZip.addEventListener(Event.COMPLETE, this.zipCompleteHandler);
                                this.currentZip.addEventListener(FZipEvent.FILE_LOADED, this.fileCompleteHandler);
                                this.currentZip.addEventListener(FZipErrorEvent.PARSE_ERROR, this.zipCompleteHandler);
                                break;
                            };
                            this.currentZip = null;
                        }
                        else
                        {
                            dispatchEvent(new Event(Event.COMPLETE));
                            break;
                        };
                    }
                    else
                    {
                        break;
                    };
                };
            };
        }
        private function loaderCompleteHandler(evt:Event):void
        {
            var bitmapData:BitmapData;
            var width:uint;
            var height:uint;
            var bitmapData2:BitmapData;
            if ((this.currentState & FORMAT_BITMAPDATA) === FORMAT_BITMAPDATA)
            {
                if ((((this.currentLoader.content is Bitmap)) && (((this.currentLoader.content as Bitmap).bitmapData is BitmapData))))
                {
                    bitmapData = (this.currentLoader.content as Bitmap).bitmapData;
                    this.bitmapDataList[this.currentFilename] = bitmapData.clone();
                }
                else
                {
                    if ((this.currentLoader.content is DisplayObject))
                    {
                        width = uint(this.currentLoader.content.width);
                        height = uint(this.currentLoader.content.height);
                        if (((width) && (height)))
                        {
                            bitmapData2 = new BitmapData(width, height, true, 0);
                            bitmapData2.draw(this.currentLoader);
                            this.bitmapDataList[this.currentFilename] = bitmapData2;
                        }
                        else
                        {
                            trace((('File "' + this.currentFilename) + '" could not be converted to BitmapData'));
                        };
                    }
                    else
                    {
                        trace((('File "' + this.currentFilename) + '" could not be converted to BitmapData'));
                    };
                };
            };
            if ((this.currentState & FORMAT_DISPLAYOBJECT) === FORMAT_DISPLAYOBJECT)
            {
                if ((this.currentLoader.content is DisplayObject))
                {
                    this.displayObjectList[this.currentFilename] = this.currentLoader.content;
                }
                else
                {
                    this.currentLoader.unload();
                    trace((('File "' + this.currentFilename) + '" could not be loaded as a DisplayObject'));
                };
            }
            else
            {
                this.currentLoader.unload();
            };
            this.currentLoader = null;
            this.currentFilename = "";
            this.currentState = (this.currentState & ~((FORMAT_BITMAPDATA | FORMAT_DISPLAYOBJECT)));
            this.processNext();
        }
        private function fileCompleteHandler(evt:FZipEvent):void
        {
            this.pendingFiles.unshift(evt.file);
            this.processNext();
        }
        private function zipCompleteHandler(evt:Event):void
        {
            this.currentZip.removeEventListener(Event.COMPLETE, this.zipCompleteHandler);
            this.currentZip.removeEventListener(FZipEvent.FILE_LOADED, this.fileCompleteHandler);
            this.currentZip.removeEventListener(FZipErrorEvent.PARSE_ERROR, this.zipCompleteHandler);
            this.currentZip = null;
            this.processNext();
        }

    }
}//package deng.fzip

