//------------------------------------------------------------------------------
//
// ...
// classname: GridHtmlItemRenderer
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-23
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.itemRenderers
{
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;

	import flashx.textLayout.formats.VerticalAlign;

	import mx.core.mx_internal;

	import spark.core.IDisplayText;

	import starskin.namespaces.dx_internal;

	use namespace dx_internal;
	use namespace mx_internal;

	public class GridHtmlItemRenderer extends GridHtmlItemRendererBase implements IDisplayText
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function GridHtmlItemRenderer()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  text
		//----------------------------------------

		public function get text():String
		{
			return label;
		}

		public function set text( value:String ):void
		{
			label = value;
		}

		//----------------------------------------
		//  isTruncated
		//----------------------------------------

		public function get isTruncated():Boolean
		{
			return false;
		}

		//----------------------------------------
		//  condenseWhite
		//----------------------------------------

		private var _condenseWhite:Boolean = false;
		private var condenseWhiteChanged:Boolean = false;

		/**
		 * 一个布尔值，指定是否删除具有 HTML 文本的文本字段中的额外空白（空格、换行符等等）。
		 * 默认值为 false。condenseWhite 属性只影响使用 htmlText 属性（而非 text 属性）设置的文本。
		 * 如果使用 text 属性设置文本，则忽略 condenseWhite。 <p/>
		 * 如果 condenseWhite 设置为 true，请使用标准 HTML 命令（如 <BR> 和 <P>），将换行符放在文本字段中。<p/>
		 * 在设置 htmlText 属性之前设置 condenseWhite 属性。
		 */
		public function get condenseWhite():Boolean
		{
			return _condenseWhite;
		}

		public function set condenseWhite( value:Boolean ):void
		{
			if( value == _condenseWhite )
				return;

			_condenseWhite = value;
			condenseWhiteChanged = true;
			labelChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();

			dispatchChangeEvent( "condenseWhiteChanged" );
		}

		//----------------------------------------
		//  enabled
		//----------------------------------------

		override public function set enabled( value:Boolean ):void
		{
			if( super.enabled == value )
				return;

			super.enabled = value;

			if( enabled )
			{
				if( _selectable != pendingSelectable )
					selectableChanged = true;

				_selectable = pendingSelectable;
			}
			else
			{
				if( _selectable )
					selectableChanged = true;

				pendingSelectable = _selectable;
				_selectable = false;
			}
			invalidateProperties();
		}

		//----------------------------------------
		//  selectable
		//----------------------------------------

		private var pendingSelectable:Boolean = false;
		private var _selectable:Boolean = false;
		private var selectableChanged:Boolean;

		/**
		 * 指定是否可以选择文本。允许选择文本将使您能够从控件中复制文本。
		 */
		public function get selectable():Boolean
		{
			if( enabled )
				return _selectable;
			return pendingSelectable;
		}

		public function set selectable( value:Boolean ):void
		{
			if( value == selectable )
				return;

			if( enabled )
			{
				_selectable = value;
				selectableChanged = true;
				invalidateProperties();
			}
			else
			{
				pendingSelectable = value;
			}
		}

		//--------------------------------------------------------------------------
		//
		//	Text Style properties
		//
		//--------------------------------------------------------------------------

		dx_internal var defaultStyleChanged:Boolean = true;

		//----------------------------------------
		//  color
		//----------------------------------------

		private var _textColor:uint = 0x000000;

		/**
		 * 文本组件的文本颜色值
		 * @return
		 */
		public function get color():uint
		{
			return _textColor;
		}

		public function set color( value:uint ):void
		{
			if( _textColor == value )
				return;

			_textColor = value;
			defaultStyleChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  fontFamily
		//----------------------------------------

		private var _fontFamily:String = "Microsoft Yahei";

		/**
		 * 字体名称 。默认值：Microsoft Yahei
		 */
		public function get fontFamily():String
		{
			return _fontFamily;
		}

		public function set fontFamily( value:String ):void
		{
			if( _fontFamily == value )
				return;

			_fontFamily = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  embedFonts
		//----------------------------------------

		private var _embedFonts:Boolean;

		public function get embedFonts():Boolean
		{
			return _embedFonts;
		}

		public function set embedFonts( value:Boolean ):void
		{
			if( _embedFonts == value )
				return;

			_embedFonts = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  fontSize
		//----------------------------------------

		private var _fontSize:uint = 12;

		/**
		 * 字号大小,默认值12 。
		 */
		public function get fontSize():uint
		{
			return _fontSize;
		}

		public function set fontSize( value:uint ):void
		{
			if( _fontSize == value )
				return;
			_fontSize = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  bold
		//----------------------------------------

		private var _bold:Boolean = false;

		/**
		 * 是否为粗体,默认false。
		 */
		public function get bold():Boolean
		{
			return _bold;
		}

		public function set bold( value:Boolean ):void
		{
			if( _bold == value )
				return;

			_bold = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  italic
		//----------------------------------------

		private var _italic:Boolean = false;

		/**
		 * 是否为斜体,默认false。
		 */
		public function get italic():Boolean
		{
			return _italic;
		}

		public function set italic( value:Boolean ):void
		{
			if( _italic == value )
				return;

			_italic = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  underline
		//----------------------------------------

		private var _underline:Boolean = false;

		/**
		 * 是否有下划线,默认false。
		 */
		public function get underline():Boolean
		{
			return _underline;
		}

		public function set underline( value:Boolean ):void
		{
			if( _underline == value )
				return;

			_underline = value;
			defaultStyleChanged = true;
			invalidateProperties();
		}

		//----------------------------------------
		//  textAlign
		//----------------------------------------

		private var _textAlign:String = TextFormatAlign.LEFT;

		/**
		 * 文字的水平对齐方式 ,请使用TextFormatAlign中定义的常量。
		 * 默认值：TextFormatAlign.LEFT。
		 */
		public function get textAlign():String
		{
			return _textAlign;
		}

		public function set textAlign( value:String ):void
		{
			if( _textAlign == value )
				return;

			_textAlign = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  verticalAlign
		//----------------------------------------

		private var _verticalAlign:String = VerticalAlign.TOP;

		/**
		 * 垂直对齐方式
		 * <p>支持对齐格式如下：
		 * <ul>
		 * 		<li>VerticalAlign.TOP</li>
		 * 		<li>VerticalAlign.BOTTOM</li>
		 * 		<li>VerticalAlign.MIDDLE</li>
		 * 		<li>VerticalAlign.JUSTIFY(两端对齐)</li>
		 * </ul>
		 * </p>
		 * 默认值：VerticalAlign.TOP。
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign( value:String ):void
		{
			if( _verticalAlign == value )
				return;

			_verticalAlign = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  leading
		//----------------------------------------

		private var _leading:int = 2;

		/**
		 * 行距,默认值为2。
		 */
		public function get leading():int
		{
			return _leading;
		}

		public function set leading( value:int ):void
		{
			if( _leading == value )
				return;

			_leading = value;
			labelDisplay.leading = _leading;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  letterSpacing
		//----------------------------------------

		private var _letterSpacing:Number = NaN;

		/**
		 * 字符间距,默认值为NaN。
		 */
		public function get letterSpacing():Number
		{
			return _letterSpacing;
		}

		public function set letterSpacing( value:Number ):void
		{
			if( _letterSpacing == value )
				return;

			_letterSpacing = value;
			defaultStyleChanged = true;

			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  maxDisplayedLines
		//----------------------------------------

		private var _maxDisplayedLines:int = 0;

		/**
		 * 最大显示行数，0或负值代表不限制。
		 */
		public function get maxDisplayedLines():int
		{
			return _maxDisplayedLines;
		}

		public function set maxDisplayedLines( value:int ):void
		{
			if( _maxDisplayedLines == value )
				return;

			_maxDisplayedLines = value;

			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  textFormat
		//----------------------------------------

		dx_internal var _textFormat:TextFormat;

		/**
		 * 应用到所有文字的默认文字格式设置信息对象
		 */
		protected function get defaultTextFormat():TextFormat
		{
			if( defaultStyleChanged )
			{
				_textFormat = getDefaultTextFormat();

				// 当设置了verticalAlign为VerticalAlign.JUSTIFY 时将忽略行高，而自动按组件高度调整行间距
				if( _verticalAlign == VerticalAlign.JUSTIFY )
					_textFormat.leading = 0;

				defaultStyleChanged = false;
			}
			return _textFormat;
		}

		/**
		 * 由于设置了默认文本格式后，是延迟一帧才集中应用的，若需要立即应用文本样式，可以手动调用此方法。
		 */
		dx_internal function applyTextFormatNow():void
		{
			if( defaultStyleChanged )
			{
				labelDisplay.$setTextFormat( defaultTextFormat );
				labelDisplay.defaultTextFormat = defaultTextFormat;
			}
		}

		/**
		 * 获取文字的默认格式设置信息对象。
		 */
		public function getDefaultTextFormat():TextFormat
		{
			var textFormat:TextFormat = new TextFormat( _fontFamily, _fontSize, _textColor, _bold, _italic, _underline, "", "", _textAlign, 0, 0, 0, _leading );

			if( !isNaN( letterSpacing ))
			{
				textFormat.kerning = true;
				textFormat.letterSpacing = letterSpacing;
			}
			else
			{
				textFormat.kerning = false;
				textFormat.letterSpacing = null;
			}
			return textFormat;
		}

		//--------------------------------------------------------------------------
		//
		//	Padding Style properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  padding
		//----------------------------------------

		private var _padding:Number = 0;

		/**
		 * 四个边缘的共同内边距。若单独设置了任一边缘的内边距，则该边缘的内边距以单独设置的值为准。
		 * 此属性主要用于快速设置多个边缘的相同内边距。默认值：0。
		 */
		public function get padding():Number
		{
			return _padding;
		}

		public function set padding( value:Number ):void
		{
			if( _padding == value )
				return;
			_padding = value;
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  paddingLeft
		//----------------------------------------

		private var _paddingLeft:Number = NaN;

		/**
		 * 文字距离左边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft( value:Number ):void
		{
			if( _paddingLeft == value )
				return;

			_paddingLeft = value;
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  paddingRight
		//----------------------------------------

		private var _paddingRight:Number = NaN;

		/**
		 * 文字距离右边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}

		public function set paddingRight( value:Number ):void
		{
			if( _paddingRight == value )
				return;

			_paddingRight = value;
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  paddingTop
		//----------------------------------------

		private var _paddingTop:Number = NaN;

		/**
		 * 文字距离顶部边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}

		public function set paddingTop( value:Number ):void
		{
			if( _paddingTop == value )
				return;

			_paddingTop = value;
			invalidateSize();
			invalidateDisplayList();
		}

		//----------------------------------------
		//  paddingBottom
		//----------------------------------------

		private var _paddingBottom:Number = NaN;

		/**
		 * 文字距离底部边缘的空白像素,若为NaN将使用padding的值，默认值：NaN。
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}

		public function set paddingBottom( value:Number ):void
		{
			if( _paddingBottom == value )
				return;

			_paddingBottom = value;
			invalidateSize();
			invalidateDisplayList();
		}

		//--------------------------------------------------------------------------
		//
		//	Range style methods
		//
		//--------------------------------------------------------------------------

		/**
		 * 记录不同范围的格式信息
		 */
		private var rangeFormatDic:Dictionary;

		/**
		 * 范围格式信息发送改变标志
		 */
		private var rangeFormatChanged:Boolean = false;

		/**
		 * 应用范围格式信息
		 */
		private function applyRangeFormat( expLeading:Object = null ):void
		{
			rangeFormatChanged = false;

			if( !rangeFormatDic || !labelChanged || labelDisplay == null )
				return;

			var useLeading:Boolean = Boolean( expLeading != null );

			for( var beginIndex:* in rangeFormatDic )
			{
				var endDic:Dictionary = rangeFormatDic[ beginIndex ] as Dictionary;

				if( endDic )
				{
					for( var index:* in endDic )
					{
						if( !endDic[ index ])
							continue;
						var oldLeading:Object;

						if( useLeading )
						{
							oldLeading = ( endDic[ index ] as TextFormat ).leading;
							( endDic[ index ] as TextFormat ).leading = expLeading;
						}
						var endIndex:int = index;

						if( endIndex > labelDisplay.text.length )
							endIndex = labelDisplay.text.length;

						try
						{
							labelDisplay.$setTextFormat( endDic[ index ], beginIndex, endIndex );
						}
						catch( e:Error )
						{
						}

						if( useLeading )
						{
							( endDic[ index ] as TextFormat ).leading = oldLeading;
						}
					}
				}
			}
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override protected function commitProperties():void
		{
			if( condenseWhiteChanged )
			{
				labelDisplay.condenseWhite = _condenseWhite;
				condenseWhiteChanged = false;
			}

			if( selectableChanged )
			{
				labelDisplay.selectable = _selectable;
				selectableChanged = false;
			}

			if( defaultStyleChanged )
			{
				labelDisplay.$setTextFormat( defaultTextFormat );
				labelDisplay.defaultTextFormat = defaultTextFormat;
				labelDisplay.embedFonts = embedFonts;
			}

			super.commitProperties();

			var needSetDefaultFormat:Boolean = defaultStyleChanged || labelChanged;
			rangeFormatChanged = needSetDefaultFormat || rangeFormatChanged;

			super.commitProperties();

			if( rangeFormatChanged )
			{
				if( !needSetDefaultFormat ) //如果样式发生改变，父级会执行样式刷新的过程。这里就不用重复了。
					labelDisplay.$setTextFormat( defaultTextFormat );
				applyRangeFormat();
				rangeFormatChanged = false;
			}
		}

		override protected function measure():void
		{
			//先提交属性，防止样式发生改变导致的测量不准确问题。
			if( invalidatePropertiesFlag )
				validateProperties();

			super.measure();

			var padding:Number = isNaN( _padding ) ? 0 : _padding;
			var paddingL:Number = isNaN( _paddingLeft ) ? padding : _paddingLeft;
			var paddingR:Number = isNaN( _paddingRight ) ? padding : _paddingRight;
			var paddingT:Number = isNaN( _paddingTop ) ? padding : _paddingTop;
			var paddingB:Number = isNaN( _paddingBottom ) ? padding : _paddingBottom;

			measuredWidth = paddingL - paddingR;

			if( _maxDisplayedLines > 0 && labelDisplay.numLines > _maxDisplayedLines )
			{
				var lineM:TextLineMetrics = labelDisplay.getLineMetrics( 0 );
				measuredHeight = lineM.height * _maxDisplayedLines - lineM.leading + 4;
			}

			measuredWidth += paddingL + paddingR;
			measuredHeight += paddingT + paddingB;
		}

		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );

			var padding:Number = isNaN( _padding ) ? 0 : _padding;
			var paddingL:Number = isNaN( _paddingLeft ) ? padding : _paddingLeft;
			var paddingR:Number = isNaN( _paddingRight ) ? padding : _paddingRight;
			var paddingT:Number = isNaN( _paddingTop ) ? padding : _paddingTop;
			var paddingB:Number = isNaN( _paddingBottom ) ? padding : _paddingBottom;

			labelDisplay.x = paddingL;
			labelDisplay.y = paddingT;

			//防止在父级validateDisplayList()阶段改变的text属性值，
			//接下来直接调用自身的updateDisplayList()而没有经过measu(),使用的测量尺寸是上一次的错误值。
			if( invalidateSizeFlag )
				validateSize();

			if( !labelDisplay.visible ) //解决初始化时文本闪烁问题
				labelDisplay.visible = true;

			labelDisplay.scrollH = 0;
			labelDisplay.scrollV = 1;

			labelDisplay.$width = unscaledWidth - paddingL - paddingR;
			var unscaledTextHeight:Number = unscaledHeight - paddingT - paddingB;
			labelDisplay.$height = unscaledTextHeight;

			if( _maxDisplayedLines == 1 )
				labelDisplay.wordWrap = false;
			else if( Math.floor( width ) < Math.floor( measuredWidth ))
				labelDisplay.wordWrap = true;

			if( _maxDisplayedLines > 0 && labelDisplay.numLines > _maxDisplayedLines )
			{
				var lineM:TextLineMetrics = labelDisplay.getLineMetrics( 0 );
				var h:Number = lineM.height * _maxDisplayedLines - lineM.leading + 4;
				labelDisplay.$height = Math.min( unscaledTextHeight, h );
			}

			if( _verticalAlign == VerticalAlign.JUSTIFY )
			{
				labelDisplay.$setTextFormat( defaultTextFormat );
				applyRangeFormat( 0 );
			}

			if( labelDisplay.textHeight >= unscaledTextHeight )
				return;

			if( _verticalAlign == VerticalAlign.JUSTIFY )
			{
				if( labelDisplay.numLines > 1 )
				{
					labelDisplay.$height = unscaledTextHeight;
					var extHeight:Number = Math.max( 0, unscaledTextHeight - 4 - labelDisplay.textHeight );
					defaultTextFormat.leading = Math.floor( extHeight / ( labelDisplay.numLines - 1 ));
					labelDisplay.$setTextFormat( defaultTextFormat );
					applyRangeFormat( defaultTextFormat.leading );
					defaultTextFormat.leading = 0;
				}
			}
			else
			{
				var valign:Number = 0;

				if( _verticalAlign == VerticalAlign.MIDDLE )
					valign = 0.5;
				else if( _verticalAlign == VerticalAlign.BOTTOM )
					valign = 1;

				labelDisplay.y += Math.floor(( unscaledTextHeight - labelDisplay.textHeight ) * valign );
				labelDisplay.$height = unscaledTextHeight - labelDisplay.y;
			}
		}

		override protected function createTextField():void
		{
			super.createTextField();

			labelDisplay.addEventListener( "textChanged", textField_textModifiedHandler );
			labelDisplay.addEventListener( "widthChanged", textField_textModifiedHandler );
			labelDisplay.addEventListener( "heightChanged", textField_textModifiedHandler );
			labelDisplay.addEventListener( "textFormatChanged", textField_textModifiedHandler );
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		/**
		 * 文字内容发生改变
		 */
		dx_internal function textField_textModifiedHandler( event:Event ):void
		{
			labelChanged = true;
			invalidateSize();
			invalidateDisplayList();
		}
	}
}
