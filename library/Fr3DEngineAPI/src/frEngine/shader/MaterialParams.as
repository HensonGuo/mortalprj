package frEngine.shader
{
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.fragmentFilters.ColorTransformFilter;
	import frEngine.shader.filters.fragmentFilters.UVMaskFilter;
	import frEngine.shader.filters.fragmentFilters.UvOffsetFilter;
	import frEngine.shader.filters.fragmentFilters.UvRotateFilter;
	import frEngine.shader.filters.fragmentFilters.UvScaleFilter;
	import frEngine.shader.filters.vertexFilters.HerizonKilFilter;

	public class MaterialParams extends EventDispatcher
	{

		public var cullFace:String = Context3DTriangleFace.BACK;
		public var sourceFactor:String = Context3DBlendFactor.ONE;
		public var destFactor:String = Context3DBlendFactor.ZERO;
		public var depthWrite:Boolean = true;
		public var depthCompare:String = "lessEqual";
		private var _filterList:Array = new Array();
		private var _blendMode:int = 0;
		private var _twoSided:Boolean = false;
		//public var colorMultiplier:Vector.<Number>;
		public var colorOffset:Vector.<Number>;

		private var _alphaBaseValue:Number = 1;
		private var _colorBaseValue:Number = 0xffffff;
		private var _uvBaseValue:Point=new Point();

		private var _uvRotateBaseUse:Boolean=false;
		private var _uvRotateAnimUse:Boolean=false;
		private var _uvOffsetBaseUse:Boolean=false;
		private var _uvOffsetAnimUse:Boolean=false;
		private var _uvScaleBaseUse:Boolean=false;
		private var _uvScaleAnimUse:Boolean=false;
		private var _alphaAnimUse:Boolean=false;
		private var _colorAnimUse:Boolean=false;
		
		private var _uvMaskFilter:UVMaskFilter;
		private var _uvOffsetFilter:UvOffsetFilter;
		private var _uvRotateFilter:UvRotateFilter;
		private var _colorTransformFilter:ColorTransformFilter;
		private var _uvScaleFilter:UvScaleFilter;
		private var _herizionKillFilter:HerizonKilFilter;
		private var _uvRepeat:Boolean=true;
		public function MaterialParams()
		{
			//colorMultiplier=colorTransformFilter.colorMultiplyValue;
			colorOffset=colorTransformFilter.colorOffsetValue;
			super();
		}


		final public function set uvRepeat(value:Boolean):void
		{
			if(value==_uvRepeat)
			{
				return;
			}
			_uvRepeat=value;
			needRebuild();
		}
		final public function get uvRepeat():Boolean
		{
			return _uvRepeat;
		}
		public function setMaskRotateAngle($maskU:Number,$maskV:Number,$maskRotateAngle:Number,$textureUrl:String,$showMask:Boolean):void
		{
			var hasfilter:Boolean = this.hasFilter(FilterType.UVMask);
			
			if ($textureUrl==null || $textureUrl.length==0)
			{
				if (hasfilter)
				{
					this.removeFilteByType(FilterType.UVMask,false);
				}
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(uvMaskFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.UVMask);
					if(filter!=uvMaskFilter)
					{
						this.removeFilte(filter);
						this.addFilte(uvMaskFilter);
					}
				}
				
				uvMaskFilter.changeUVMaskValue($maskU, $maskV , $maskRotateAngle);
				
				if(uvMaskFilter.maskTexture3D)
				{
					if(uvMaskFilter.maskTexture3D.request!=$textureUrl)
					{
						Resource3dManager.instance.disposeTexture3d(uvMaskFilter.maskTexture3D);
						needRebuild();
					}
					
				}else
				{
					uvMaskFilter.maskTexture3D=Resource3dManager.instance.getTexture3d($textureUrl,Texture3D.MIP_LINEAR);
				}

				if($showMask !=uvMaskFilter.showMaskEnabled)
				{
					uvMaskFilter.showMaskEnabled=$showMask;
					needRebuild();
				}
			}
		}

		
		
		private function get uvScaleFilter():UvScaleFilter
		{
			if(!_uvScaleFilter)
			{
				_uvScaleFilter = new UvScaleFilter();
			}
			return _uvScaleFilter;
		}
		private function get colorTransformFilter():ColorTransformFilter
		{
			if(!_colorTransformFilter)
			{
				_colorTransformFilter = new ColorTransformFilter();
			}
			return _colorTransformFilter;
		}
		private function get uvRotateFilter():UvRotateFilter
		{
			if(!_uvRotateFilter)
			{
				_uvRotateFilter = new UvRotateFilter();
			}
			return _uvRotateFilter;
		}
		private function get uvMaskFilter():UVMaskFilter
		{
			if(!_uvMaskFilter)
			{
				_uvMaskFilter = new UVMaskFilter();
			}
			return _uvMaskFilter;
		}
		
		private function get herizionKillFilter():HerizonKilFilter
		{
			if(!_herizionKillFilter)
			{
				_herizionKillFilter = new HerizonKilFilter();
			}
			return _herizionKillFilter;
		}
		
		private function get uvOffsetFilter():UvOffsetFilter
		{
			if(!_uvOffsetFilter)
			{
				_uvOffsetFilter = new UvOffsetFilter();
			}
			return _uvOffsetFilter;
		}

		public function set uvScaleAnimUse(value:Boolean):void
		{
			_uvScaleAnimUse=value;
			var hasfilter:Boolean = this.hasFilter(FilterType.MaterialUvScale);
			if (!_uvScaleAnimUse)
			{
				if (hasfilter && !_uvScaleBaseUse)
				{
					this.removeFilteByType(FilterType.MaterialUvScale,false);
				}
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(uvScaleFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.MaterialUvScale);
					if(filter!=uvOffsetFilter)
					{
						this.removeFilte(filter);
						this.addFilte(uvScaleFilter);
					}
				}
			}
		}
		public function set uvScaleBase(uvScalePoint:Point):void
		{
			var hasfilter:Boolean = this.hasFilter(FilterType.MaterialUvScale);
			if (!uvScalePoint || (uvScalePoint.x==1&&uvScalePoint.y==1))
			{
				if (hasfilter && !_uvScaleAnimUse)
				{
					this.removeFilteByType(FilterType.MaterialUvScale,false);
				}
				_uvScaleBaseUse=false;
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(uvScaleFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.MaterialUvScale);
					if(filter!=uvOffsetFilter)
					{
						this.removeFilte(filter);
						this.addFilte(uvScaleFilter);
					}
				}
				uvScaleFilter.uvValue[0] = uvScalePoint.x;
				uvScaleFilter.uvValue[1] = uvScalePoint.y;
				_uvScaleBaseUse=true;
			}
		}
		
		
		public function set uvRotateAnimUse(value:Boolean):void
		{
			_uvRotateAnimUse=value;
			var hasfilter:Boolean = this.hasFilter(FilterType.UVRotateAnimation);
			if (!_uvRotateAnimUse)
			{
				if (hasfilter && !_uvRotateBaseUse)
				{
					this.removeFilteByType(FilterType.UVRotateAnimation,false);
				}
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(uvRotateFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.UVRotateAnimation);
					if(filter!=uvOffsetFilter)
					{
						this.removeFilte(filter);
						this.addFilte(uvRotateFilter);
					}
				}
			}
		}
		
		public function set uvRotateBase(angle:Number):void
		{
			var hasfilter:Boolean = this.hasFilter(FilterType.UVRotateAnimation);
			if (angle==0)
			{
				if (hasfilter && !_uvRotateAnimUse)
				{
					this.removeFilteByType(FilterType.UVRotateAnimation,false);
				}
				_uvRotateBaseUse=false;
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(uvRotateFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.UVRotateAnimation);
					if(filter!=uvOffsetFilter)
					{
						this.removeFilte(filter);
						this.addFilte(uvRotateFilter);
					}
				}
				uvRotateFilter.params[2]=angle;
				_uvRotateBaseUse=true;
			}
		}
		
		
		public function set uvOffsetAminUse(value:Boolean):void
		{
			_uvOffsetAnimUse=value;
			var hasfilter:Boolean = this.hasFilter(FilterType.MaterialUvOffset);
			if (!_uvOffsetAnimUse)
			{
				if (hasfilter && !_uvOffsetBaseUse)
				{
					this.removeFilteByType(FilterType.MaterialUvOffset,false);
				}
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(uvOffsetFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.MaterialUvOffset);
					if(filter!=uvOffsetFilter)
					{
						this.removeFilte(filter);
						this.addFilte(uvOffsetFilter);
					}
				}
			}
		}
		private var _isOpenHerizionKil:Boolean=false;
		public function get isOpenHerizionKil():Boolean
		{
			return _isOpenHerizionKil;
		}
		
		public function set isOpenHerizionKil(value:Boolean):void
		{
			if(value==_isOpenHerizionKil)
			{
				return;
			}
			_isOpenHerizionKil=value;
			var hasfilter:Boolean = this.hasFilter(FilterType.herizionKil);
			if(value)
			{
				if (!hasfilter)
				{
					this.addFilte(herizionKillFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.herizionKil);
					if(filter!=herizionKillFilter)
					{
						this.removeFilte(filter);
						this.addFilte(herizionKillFilter);
					}
				}
			}else
			{
				if (hasfilter)
				{
					this.removeFilteByType(FilterType.herizionKil,false);
				}
			}
			
		}
		public function get uvOffsetBase():Point
		{
			return _uvBaseValue;
		}
		public function set uvOffsetBase(uvOffsetPoint:Point):void
		{
			_uvBaseValue=uvOffsetPoint.clone();
			var hasfilter:Boolean = this.hasFilter(FilterType.MaterialUvOffset);
			if (_uvBaseValue.x==0 && _uvBaseValue.y==0)
			{
				if (hasfilter && !_uvOffsetAnimUse)
				{
					this.removeFilteByType(FilterType.MaterialUvOffset,false);
				}
				_uvOffsetBaseUse=false;
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(uvOffsetFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.MaterialUvOffset);
					if(filter!=uvOffsetFilter)
					{
						this.removeFilte(filter);
						this.addFilte(uvOffsetFilter);
					}
				}
				uvOffsetFilter.uvOffsetValue[0] = _uvBaseValue.x;
				uvOffsetFilter.uvOffsetValue[1] = _uvBaseValue.y;
				_uvOffsetBaseUse=true;
			}
			this.dispatchEvent(new Event(Engine3dEventName.UVOFFSET_CHANGE));
		}

		
		public function set colorAnimUse(value:Boolean):void
		{
			_colorAnimUse=value;
			var hasfilter:Boolean=this.hasFilter(FilterType.Fragment_ColorTransform);
			if (!_colorAnimUse)
			{
				if (hasfilter && _alphaBaseValue==1 && !_alphaAnimUse)
				{
					this.removeFilteByType(FilterType.Fragment_ColorTransform,false);
				}
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(colorTransformFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.Fragment_ColorTransform);
					if(filter!=colorTransformFilter)
					{
						this.removeFilte(filter);
						this.addFilte(colorTransformFilter);
					}
				}
			}
		}
		
		public function set alphaAnimUse(value:Boolean):void
		{
			_alphaAnimUse=value;
			var hasfilter:Boolean=this.hasFilter(FilterType.Fragment_ColorTransform);
			if (!_alphaAnimUse)
			{
				if (hasfilter && _alphaBaseValue==1 && !_colorAnimUse)
				{
					this.removeFilteByType(FilterType.Fragment_ColorTransform,false);
				}
			}
			else
			{
				if (!hasfilter)
				{
					this.addFilte(colorTransformFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.Fragment_ColorTransform);
					if(filter!=colorTransformFilter)
					{
						this.removeFilte(filter);
						this.addFilte(colorTransformFilter);
					}
				}
			}
		}
		
		public function set colorBase(value:uint):void
		{
			_colorBaseValue=value;
			colorOffset[0]=(value>>16 & 0xff)/255;
			colorOffset[1]=(value>>8 & 0xff)/255;
			colorOffset[2]=(value & 0xff)/255;
			var removeFilter:Boolean=(value==0xffffff);
			changeColorFilter(removeFilter);
		}
		
		public function get colorBase():uint
		{
			return _colorBaseValue;
		}
		
		public function set alphaBase(value:Number):void
		{
			colorOffset[3] = value;
			
			/*if(value==_alphaBaseValue)
			{
				return;
			}*/
			_alphaBaseValue = value;
			var removeFilter:Boolean=(value==1);
			changeColorFilter(removeFilter);
			this.dispatchEvent(new Event(Engine3dEventName.ALPHA_CHANGE));
		}

		
		private function changeColorFilter(toRemove:Boolean):void
		{
			var hasfilter:Boolean=this.hasFilter(FilterType.Fragment_ColorTransform);
			if(toRemove)
			{
				if(hasfilter && !_colorAnimUse && !_alphaAnimUse && _colorBaseValue==0xffffff)
				{
					this.removeFilteByType(FilterType.Fragment_ColorTransform);
				}
				
			}else
			{
				if(!hasfilter)
				{
					this.addFilte(colorTransformFilter);
				}else
				{
					var filter:FilterBase=this.getFilterByTypeId(FilterType.Fragment_ColorTransform);
					if(filter!=colorTransformFilter)
					{
						this.removeFilte(filter);
						this.addFilte(colorTransformFilter);
					}
				}
				//colorTransformFilter.changeColor(this.colorMultiplier,this.colorOffset);
				colorTransformFilter.changeColor(this.colorOffset);
			}
		}
		public function get alphaBase():Number
		{
			return _alphaBaseValue;
		}

		public function set filterList(value:Array):void
		{
			if (_filterList == value)
			{
				return;
			}
			_filterList = value;
			needRebuild();
		}

		public function get filterList():Array
		{
			return _filterList;
		}


		public function addFilte(filter:FilterBase , forceToAdd:Boolean = false):void
		{
			if (!filter)
			{
				return;
			}
			var _hasfilter:Boolean = hasFilter(filter.type);
			var toAdd:Boolean = false;
			if (forceToAdd)
			{
				if (_hasfilter)
				{
					this.removeFilte(filter);
				}
				toAdd = true;
			}
			else
			{
				if (!_hasfilter)
				{
					toAdd = true;
				}
			}
			if (toAdd)
			{
				_filterList.push(filter);
				needRebuild();
			}


		}

		public function removeFilteByType(typeid:int,isDispose:Boolean = true):void
		{
			var filter:FilterBase = this.getFilterByTypeId(typeid);
			if (filter)
			{
				removeFilte(filter,isDispose);
			}
		}

		public function removeFilte(filter:FilterBase,isDispose:Boolean = true):void
		{
			if (!filter)
			{
				return;
			}
			if (hasFilter(filter.type))
			{
				var index:int = _filterList.indexOf(filter);
				_filterList.splice(index , 1);
				if(isDispose)
				{
					filter.dispose();
				}
				needRebuild();
			}

		}

		public function getFilterByTypeId(filterType:int):FilterBase
		{
			var i:int;
			var len:int = _filterList.length;
			for (i = 0 ; i < len ; i++)
			{
				var filter:FilterBase = _filterList[i];
				if (filter.type == filterType)
				{
					return filter;
				}
			}
			return null
		}

		public function hasFilter(filterType:int):Boolean
		{
			var filter:FilterBase = getFilterByTypeId(filterType);
			return (filter != null);
		}

		public function needRebuild():void
		{
			this.dispatchEvent(new Event(Engine3dEventName.FILTER_CHANGE));
		}
		

		public function get twoSided():Boolean
		{
			return ((this.cullFace == Context3DTriangleFace.NONE));
		}

		public function cloneFrom(targetMaterialParams:MaterialParams):void
		{
			this.setBlendMode(targetMaterialParams.blendMode);
			this.depthWrite = targetMaterialParams.depthWrite;
			this.cullFace = targetMaterialParams.cullFace;
			this.alphaBase=targetMaterialParams.alphaBase;
			this.alphaAnimUse=targetMaterialParams._alphaAnimUse;
			this.colorAnimUse=targetMaterialParams._colorAnimUse;
			this._uvOffsetBaseUse=targetMaterialParams._uvOffsetBaseUse
			this.uvOffsetAminUse=targetMaterialParams._uvOffsetAnimUse;
			this._uvRotateBaseUse=targetMaterialParams._uvRotateBaseUse;
			this.uvRotateAnimUse=targetMaterialParams._uvRotateAnimUse;
			this._uvScaleBaseUse=targetMaterialParams._uvScaleBaseUse
			this.uvScaleAnimUse=targetMaterialParams._uvScaleAnimUse;
			this.uvRepeat=targetMaterialParams.uvRepeat;
			this.isOpenHerizionKil=targetMaterialParams.isOpenHerizionKil;
			this._filterList=targetMaterialParams._filterList.concat();
		}

		public function set twoSided(_arg1:Boolean):void
		{
			if (this._twoSided == _arg1)
			{
				return;
			}
			_twoSided = _arg1;
			if (_arg1)
			{
				this.cullFace = Context3DTriangleFace.NONE;
			}
			else
			{
				this.cullFace = Context3DTriangleFace.BACK;
			}
		}

		public function get blendMode():int
		{
			return (this._blendMode);
		}

		public function dispose():void
		{
			for each (var p:FilterBase in _filterList)
			{
				p.dispose();
			}
			_filterList = new Array();
			if(_uvMaskFilter)
			{
				_uvMaskFilter.dispose();
				_uvMaskFilter=null;
			}
			if(_uvOffsetFilter)
			{
				_uvOffsetFilter.dispose();
				_uvOffsetFilter=null;
			}
			if(_uvScaleFilter)
			{
				_uvScaleFilter.dispose();
				_uvScaleFilter=null;
			}
			if(_uvRotateFilter)
			{
				_uvRotateFilter.dispose();
				_uvRotateFilter=null;
			}
			if(_colorTransformFilter)
			{
				_colorTransformFilter.dispose();
				_colorTransformFilter=null;
			}
		}

		public function setBlendMode(_arg1:int):void
		{

			this._blendMode = _arg1;
			switch (this._blendMode)
			{
				case Material3D.BLEND_NONE:
					sourceFactor = Context3DBlendFactor.ONE;
					destFactor = Context3DBlendFactor.ZERO;
					return;
				case Material3D.BLEND_ADDITIVE:
					this.sourceFactor = Context3DBlendFactor.ONE;
					this.destFactor = Context3DBlendFactor.ONE;
					return;
				case Material3D.BLEND_LIGHT:
					this.sourceFactor = Context3DBlendFactor.SOURCE_COLOR;
					this.destFactor = Context3DBlendFactor.ONE;
					return;
				case Material3D.BLEND_ALPHA0:
					this.sourceFactor = Context3DBlendFactor.ONE;
					this.destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					return;	
				case Material3D.BLEND_ALPHA1:
					this.sourceFactor = Context3DBlendFactor.DESTINATION_ALPHA;
					this.destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					return;
				case Material3D.BLEND_ALPHA2:
					this.sourceFactor = Context3DBlendFactor.DESTINATION_ALPHA;
					this.destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					return;
				case Material3D.BLEND_COLOR:
					sourceFactor = Context3DBlendFactor.SOURCE_COLOR;
					destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					return;
				case Material3D.BLEND_SCREEN:
					this.sourceFactor = Context3DBlendFactor.ONE;
					this.destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					return;
				case Material3D.BLEND_OVERLAYER:
					this.sourceFactor = Context3DBlendFactor.DESTINATION_COLOR;
					this.destFactor = Context3DBlendFactor.ONE;
					return;
				case Material3D.BLEND_FOG:
					sourceFactor = Context3DBlendFactor.DESTINATION_COLOR;
					destFactor = Context3DBlendFactor.ZERO;
					break;

			}
		}
	}
}
