//------------------------------------------------------------------------------
//
// ...
// classname: HtmlTextBase
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-29
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;

	import mx.core.UIComponent;
	import mx.core.mx_internal;

	import starskin.namespaces.dx_internal;

	use namespace dx_internal;
	use namespace mx_internal;

	/**
	 * 实现高效支持 HTML 内容的文本标签
	 * <p>
	 * <b>实现该组件的目的在于：</b>
	 * <ol>
	 * <li>支持高效的 HTML 文本内容展示。</li>
	 * <li>支持文本内容的选定。</li>
	 * </ol>
	 * </p>
	 * @author AoSnow
	 */
	public class HtmlTextBase extends UIComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function HtmlTextBase()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  labelDisplay
		//----------------------------------------

		private var _labelDisplay:UITextField = null;

		public function get labelDisplay():UITextField
		{
			return _labelDisplay;
		}

		//----------------------------------------
		//  label
		//----------------------------------------

		private var _label:String = "";
		protected var labelChanged:Boolean;

		[Bindable( "labelChanged" )]

		public function get label():String
		{
			return _label;
		}

		public function set label( value:String ):void
		{
			if( _label == value )
				return;

			_label = value;
			labelChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			dispatchChangeEvent( "labelChanged" );
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		protected function dispatchChangeEvent( type:String ):void
		{
			if( hasEventListener( type ))
				dispatchEvent( new Event( type ));
		}

		protected function getTextFieldAutoSize():String
		{
			return TextFieldAutoSize.LEFT;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------

		override protected function createChildren():void
		{
			super.createChildren();

			if( !labelDisplay )
			{
				checkTextField();
			}
		}

		/**
		 * 检查是否创建了textField对象，没有就创建一个。
		 */
		private function checkTextField():void
		{
			if( !labelDisplay )
			{
				createTextField();

				labelDisplay.htmlText = label;
				invalidateProperties();
			}
		}

		/**
		 * 创建文本显示对象
		 */
		protected function createTextField():void
		{
			_labelDisplay = new UITextField();
			labelDisplay.selectable = true;

			labelDisplay.wordWrap = labelDisplay.multiline = true;
			labelDisplay.autoSize = getTextFieldAutoSize();

			labelDisplay.antiAliasType = AntiAliasType.ADVANCED;
			labelDisplay.mouseWheelEnabled = false;

			addChild( labelDisplay );
		}

		override protected function commitProperties():void
		{
			super.commitProperties();

			if( labelChanged )
			{
				labelDisplay.$htmlText = _label;
			}
		}

		override protected function measure():void
		{
			super.measure();

			labelDisplay.autoSize = getTextFieldAutoSize();

			if( isNaN( explicitWidth ))
			{
				labelDisplay.wordWrap = labelDisplay.multiline = false;

				measuredWidth = Math.min( labelDisplay.textWidth, isNaN( explicitMaxWidth ) ? DEFAULT_MAX_WIDTH : explicitMaxWidth );
				measuredHeight = Math.min( labelDisplay.textHeight, isNaN( explicitMaxHeight ) ? DEFAULT_MAX_HEIGHT : explicitMaxHeight );
			}
			else
			{
				labelDisplay.wordWrap = labelDisplay.multiline = true;

				measuredWidth = Math.max( width, isNaN( explicitWidth ) ? 0 : explicitWidth, explicitMinWidth );
				measuredHeight = Math.max( height, isNaN( explicitHeight ) ? 0 : explicitHeight, explicitMinHeight );
			}
		}

		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );

			labelDisplay.x = 0;
			labelDisplay.y = 0;
			labelDisplay.$width = unscaledWidth;
			labelDisplay.$height = unscaledHeight;
		}

	}
}
