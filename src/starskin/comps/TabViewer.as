//------------------------------------------------------------------------------
//
// ...
// classname: TabViewer
// author: 喵大斯( blog.csdn.net/aosnowasp )
// created: 2015-7-12
// copyright (c) 2013 喵大斯( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import flash.display.DisplayObject;

	import mx.containers.ViewStack;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;

	import spark.components.NavigatorContent;
	import spark.components.SkinnableContainer;

	use namespace mx_internal;

	//----------------------------------------
	//  Styles
	//----------------------------------------
	
	/**
	 * TabBar 的皮肤样式类
	 */	
	[Style( name = "tabSkinClass", type = "Class" )]

	/** Tab 选项按钮的圆角程度  **/
	[Style( name = "cornerRadius", type = "Number", format = "Length", inherit = "no" )]

	/** 是否显示 Tab 背景  **/
	[Style( name = "tabBackgroundVisible", type = "Boolean", format = "Boolean", enumeration = "true,false", inherit = "no" )]
	
	/**
	 * TabBar 容器的对齐方式
	 * @default "left"
	 */	
	[Style( name = "tabAlign", type = "String", enumeration = "left,center,right", inherit = "no" )]
	
	/**
	 * TabBar 选项卡按钮之间相距的距离
	 * @default -1
	 */	
	[Style( name = "tabGap", type = "Number", format = "Length", inherit = "no" )]
	
	/**
	 * 强制统一所有选项卡按钮的宽度
	 */	
	[Style( name = "tabWidth", type = "Number", format = "Length", inherit = "no" )]
	
	/**
	 * 强制统一所有选项卡按钮的高度度
	 */	
	[Style( name = "tabHeight", type = "Number", format = "Length", inherit = "no" )]
	
	/**
	 * TabBar 容器的偏移量
	 * <p>该偏移量的计算，受到 tabAlign 对齐方式的影响</p>
	 */	
	[Style( name = "tabOffset", type = "Number", format = "Length", inherit = "no" )]
	
	/**
	 * TabViewer 的边框颜色
	 */	
	[Style( name = "borderColor", type = "uint", format = "Color", inherit = "no" )]
	
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

	public class TabViewer extends SkinnableContainer
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		private static const MIN_TAB_WIDTH:Number = 30;

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function TabViewer()
		{
			super();

			tabEnabled = false;
			tabFocusEnabled = false;
			hasFocusableChildren = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  tabBar
		//----------------------------------

		[SkinPart( required = "true" )]
		public var tabBar:TabBar;

		//----------------------------------------
		//  viewStack
		//----------------------------------------

		[SkinPart( required = "true" )]
		public var viewStack:ViewStack;

		//----------------------------------
		//  tabBarHeight
		//----------------------------------

		private function get tabBarHeight():Number
		{
			var tabHeight:Number = getStyle( "tabHeight" );

			if( isNaN( tabHeight ))
				tabHeight = tabBar.getExplicitOrMeasuredHeight();

			return tabHeight;
		}

		//----------------------------------
		//  mxmlContent
		//----------------------------------

		private var mxmlContentChanged:Boolean = false;
		private var _mxmlContent:Array;

		override public function set mxmlContent( value:Array ):void
		{
			if( createChildrenCalled )
			{
				setMXMLContent( value );
			}
			else
			{
				mxmlContentChanged = true;
				_mxmlContent = value;
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods: UIComponent
		//
		//--------------------------------------------------------------------------

		private var createChildrenCalled:Boolean = false;

		override protected function commitProperties():void
		{
			super.commitProperties();

			if( tabBar && viewStack && tabBar.dataProvider != viewStack )
			{
				tabBar.dataProvider = viewStack;
			}
		}

		override protected function createChildren():void
		{
			super.createChildren();

			createChildrenCalled = true;

			if( mxmlContentChanged )
			{
				mxmlContentChanged = false;
				setMXMLContent( _mxmlContent );
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
		}

		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );

			if( instance == viewStack )
			{
				tabBar.dataProvider = null;
				viewStack.removeAll();
			}
		}

		/**
		 * 追加  NavigatorContent 项目
		 */
		override public function addElement( element:IVisualElement ):IVisualElement
		{
			var index:int = viewStack.numElements;

			if( element.parent == viewStack )
				index = viewStack.numElements - 1;

			return addElementAt( element, index );
		}

		/**
		 * 追加  NavigatorContent 项目到指定索引位置
		 */
		override public function addElementAt( element:IVisualElement, index:int ):IVisualElement
		{
			if( !( element is NavigatorContent ))
				throw new ArgumentError( "参数错误，element 必须是 NavigatorContent 类型或其子集。" );

			if( viewStack )
			{
				viewStack.addItemAt( element, index );
			}

			return element;
		}

		/**
		 * 删除指定的 NavigatorContent 项目
		 */
		override public function removeElement( element:IVisualElement ):IVisualElement
		{
			if( !( element is NavigatorContent ))
				throw new ArgumentError( "参数错误，element 必须是 NavigatorContent 类型或其子集。" );

			return removeElementAt( viewStack.getItemIndex( element ));
		}

		/**
		 * 删除指定索引的  NavigatorContent 项目
		 */
		override public function removeElementAt( index:int ):IVisualElement
		{
			return viewStack.removeItemAt( index ) as IVisualElement;
		}

		/**
		 * 从 TabViewer 中删除所有 NavigatorContent 项目
		 */
		override public function removeAllElements():void
		{
			viewStack.removeAll();
		}

		private function setMXMLContent( value:Array ):void
		{
			if( !viewStack )
				return;

			var i:int;

			removeAllElements();

			_mxmlContent = ( value ) ? value.concat() : null; // defensive copy

			if( _mxmlContent != null )
			{
				var n:int = _mxmlContent.length;

				for( i = 0; i < n; i++ )
				{
					var elt:IVisualElement = _mxmlContent[ i ];
					addElement( elt );
				}
				viewStack.invalidateProperties();
			}

			if( tabBar )
				tabBar.invalidateProperties();
		}

	}
}
