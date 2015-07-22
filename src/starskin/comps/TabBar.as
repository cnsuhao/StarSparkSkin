//------------------------------------------------------------------------------
//
// ...
// classname: TabBar
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-10
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import flash.events.Event;

	import mx.core.IVisualElement;
	import mx.core.mx_internal;

	import spark.components.ButtonBarButton;
	import spark.components.supportClasses.ButtonBarBase;

	import starskin.events.TabCloseEvent;

	use namespace mx_internal;

	//----------------------------------------
	//  Styles
	//----------------------------------------

	[Style( name = "borderColor", type = "uint", format = "Color", inherit = "no" )]

	/**
	 * TabBar 容器的左边距。
	 * @default 0
	 */
	[Style( name = "paddingLeft", type = "Number", inherit = "no" )]

	/**
	 * TabBar 容器的右边距。
	 * @default 0
	 */
	[Style( name = "paddingRight", type = "Number", inherit = "no" )]

	/**
	 * TabBar 容器的顶边距。
	 * @default 0
	 */
	[Style( name = "paddingTop", type = "Number", inherit = "no" )]

	/**
	 * TabBar 容器的底边距。
	 * @default 0
	 */
	[Style( name = "paddingBottom", type = "Number", inherit = "no" )]
	
	/**
	 * 选项卡按钮的标签或图标的左边距。
	 * @default 0
	 */
	[Style( name = "tabPaddingLeft", type = "Number", inherit = "no" )]
	
	/**
	 * 选项卡按钮的标签或图标的右边距。
	 * @default 0
	 */
	[Style( name = "tabPaddingRight", type = "Number", inherit = "no" )]
	
	/**
	 * 选项卡按钮的标签或图标的顶边距。
	 * @default 0
	 */
	[Style( name = "tabPaddingTop", type = "Number", inherit = "no" )]
	
	/**
	 * 选项卡按钮的标签或图标的底边距。
	 * @default 0
	 */
	[Style( name = "tabPaddingBottom", type = "Number", inherit = "no" )]

	/**
	 * 选项卡导航项目之间的距离。
	 * @default -1
	 */
	[Style( name = "gap", type = "Number", format = "Length", inherit = "no" )]

	/**
	 * 每个选项卡导航项目的高度（以像素为单位）。当此属性为 undefined 时，每个选项卡的高度由应用于容器的字体样式确定。
	 * 如果设置了此属性，则指定的值将覆盖此计算值。
	 */
	[Style( name = "tabHeight", type = "Number", format = "Length", inherit = "no" )]

	/**
	 * 选项卡导航项目的宽度（以像素为单位）。如果尚未定义，则根据标签文本计算默认的选项卡宽度。
	 */
	[Style( name = "tabWidth", type = "Number", format = "Length", inherit = "no" )]

	/**
	 * 每个选项卡项目的左上和右上角的圆角程度。
	 * @default 2
	 */
	[Style( name = "cornerRadius", type = "Number", format = "Length", inherit = "no", theme = "spark" )]

	//--------------------------------------
	//  Events
	//--------------------------------------

	/**
	 * 当点击Tab按钮上的关闭按钮时派发此通知
	 */
	[Event( name = "TabCloseEvent_Close", type = "starskin.events.TabCloseEvent" )]

	//--------------------------------------
	//  Other metadata
	//--------------------------------------

	[AccessibilityClass( implementation = "spark.accessibility.TabBarAccImpl" )]

	/**
	 * Because this component does not define a skin for the mobile theme, Adobe
	 * recommends that you not use it in a mobile application. Alternatively, you
	 * can define your own mobile skin for the component. For more information,
	 * see <a href="http://help.adobe.com/en_US/flex/mobileapps/WS19f279b149e7481c698e85712b3011fe73-8000.html">Basics of mobile skinning</a>.
	 */
	[DiscouragedForProfile( "mobileDevice" )]

	[DefaultProperty( "dataProvider" )]

	public class TabBar extends ButtonBarBase
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  Placeholder for mixin by TabBarAccImpl.
		 */
		mx_internal static var createAccessibilityImplementation:Function;

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * 构造函数
		 */
		public function TabBar()
		{
			super();

			requireSelection = true;
			mouseFocusEnabled = false;
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		override public function updateRenderer( renderer:IVisualElement, itemIndex:int, data:Object ):void
		{
			super.updateRenderer( renderer, itemIndex, data );
			renderer.addEventListener( TabCloseEvent.CLOSE, buttonCloseClickHandler );
		}

		override protected function initializeAccessibility():void
		{
			if( TabBar.createAccessibilityImplementation != null )
				TabBar.createAccessibilityImplementation( this );
		}

		protected function getIndexByButton( button:ButtonBarButton ):int
		{
			const n:int = dataGroup.numElements;

			for( var i:int = 0; i < n; i++ )
			{
				var renderer:ButtonBarButton = dataGroup.getElementAt( i ) as ButtonBarButton;

				if( renderer && renderer === button )
				{
					return i;
				}
			}

			return -1;
		}

		//--------------------------------------------------------------------------
		//
		//	Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * 移除指定位置的 TabButton 选项
		 * @param index
		 */
		public function removeTabAt( index:int ):void
		{
			if( index < 0 || index >= dataProvider.length )
				return;

			dataProvider.removeItemAt( index );
			itemRemoved( index );
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		private function buttonCloseClickHandler( event:Event ):void
		{
			if( hasEventListener( TabCloseEvent.CLOSE ))
			{
				var index:int = getIndexByButton( event.target as ButtonBarButton );
				dispatchEvent( new TabCloseEvent( TabCloseEvent.CLOSE, index ));
			}
		}
	}
}
